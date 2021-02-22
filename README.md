# SWPedia

## Description

SWPedia is a sample app that uses the Stars Wars API ([SWAPI](https://swapi.dev)) to explore Star Wars characters.

The app runs on the iPhone, iPad and macOS (as a Catalyst app).

It supports the following features:

- portrait and landscape orientation;
- light and dark mode;
- automatic list paging while scrolling;
- offline browsing;
- searching.

It doesn't support characters sorting (e.g. by name) because APIs don't offer this feature, and implementing it client-side along with paging would be impossible.

## Dependencies

The app has the following dependencies (handled via SwiftPM):

- `RxSwift` (to bring some reactive magic into the app);
- `Kingfisher` (for image loading through the Internet).

## Project structure

The app is organized in a workspace using two different Xcode projects:

- `SWPedia` is the main app that contains all the UI code (VCs, views, and view models);
- `SWPediaKit` is a dynamic framework that contains the model and a small networking layer.

By splitting the code this way we will be able to reuse some business logic in different targets if needed (e.g. for building a watchOS app or a home screen widget).

## App Architecture

The app (as simple as it is) follows a MVVM architecture. It's based on UIKit built just using `UICollectionView` with compositional layouts (for creating both list and grid visualizations) and diffable data sources.

All the networking is made with a tiny custom wrapper built around `URLSession` (`APIRequest` + `HTTPClient`). Requests are exposed as RxSwift observables and models are decoded using the standard Swift `Decodable` protocol.

Offline browsing was implemented using a lightweight solution based on `URLCache`. Using more complex implementations (e.g. custom filesystem storage or Core Data) wasn't worth.
