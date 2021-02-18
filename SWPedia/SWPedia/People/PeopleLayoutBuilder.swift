//
//  PeopleLayoutBuilder.swift
//  SWPedia
//
//  Created by Emilio Pavia on 18/02/21.
//

import UIKit

class PeopleLayoutBuilder {
    enum Mode {
        case list
        case grid
    }
    
    class func layout(with mode: Mode) -> UICollectionViewLayout {
        switch mode {
        case .list:
            return listLayout()
        case .grid:
            return gridLayout()
        }
    }
    
    private class func listLayout() -> UICollectionViewLayout {
        UICollectionViewFlowLayout()
    }
    
    private class func gridLayout() -> UICollectionViewLayout {
        UICollectionViewFlowLayout()
    }
}
