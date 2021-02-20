//
//  HTTPClient.swift
//  SWPediaKit
//
//  Created by Emilio Pavia on 17/02/21.
//

import Foundation
import RxSwift

import os.log

public class HTTPClient {
    
    public let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    public func send<T: APIRequest>(_ request: T) -> Observable<T.Response> {
        let urlRequest: URLRequest
        do {
            urlRequest = try request.build()
        } catch {
            return .error(error)
        }
        
        return response(for: urlRequest)
            .map { $0.data }
            .map { try request.decoder.decode(T.Response.self, from: $0) }
            .do(onError: {
                os_log(.error, log: OSLog.net, "%{public}s (%{public}s)", $0.localizedDescription, String(describing: $0))
            })
    }
}

private extension HTTPClient {
    func response(for request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)> {
        let cache = session.configuration.urlCache
        
        return Observable.create { observer in

            let task = self.session.dataTask(with: request) { data, response, error in
                guard error == nil, let httpResponse = response as? HTTPURLResponse else {
                    // (e.g. offline)
                    if let cachedResponse = cache?.cachedResponse(for: request),
                       let httpResponse = cachedResponse.response as? HTTPURLResponse,
                       httpResponse.isSuccess {
                        observer.on(.next((httpResponse, cachedResponse.data)))
                        observer.on(.completed)
                        return
                    }
                    
                    observer.onError(APIError.networkError(error as NSError?))
                    return
                }
                
                guard httpResponse.isSuccess else {
                    observer.onError(APIError.httpError(httpResponse.statusCode, data))
                    return
                }
                
                guard let data = data else {
                    observer.onError(APIError.badResponse)
                    return
                }
                
                cache?.storeCachedResponse(CachedURLResponse(response: httpResponse, data: data),
                                           for: request)
                
                observer.on(.next((httpResponse, data)))
                observer.on(.completed)
            }
            
            os_log(.debug, log: OSLog.net, "%s %s", request.httpMethod ?? "", String(reflecting: request))
            task.resume()

            return Disposables.create(with: task.cancel)
        }
    }
}
