//
//  Router.swift
//  Filters
//
//  Created by Tom Belov on 25/05/2019.
//  Copyright © 2019 Tom Belov. All rights reserved.
//

import UIKit

class Router {
    public var window: UIWindow?
    var viewController = ViewController()
    var presenter = Presenter()

    init(window : UIWindow) {
        self.window = window
    }
    
    public func showMain() {
        presenter.output = viewController
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
