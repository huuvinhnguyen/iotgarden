//
//  Routers.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 12/22/19.
//


import ReSwiftRouter

let mainViewRoute: RouteElementIdentifier = "Main"
let itemDetailRoute: RouteElementIdentifier = "ItemDetail"
let itemNameRoute: RouteElementIdentifier = "ItemName"

class RootRoutable: Routable {
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    
    
    func pushRouteSegment(
        _ routeElementIdentifier: RouteElementIdentifier,
        animated: Bool,
        completionHandler: @escaping RoutingCompletionHandler) -> Routable
    {
        
        self.window.rootViewController = R.storyboard.itemListViewController.instantiateInitialViewController()
        completionHandler()
        
        return ItemListRoutable(self.window.rootViewController!)
    }
    
    func popRouteSegment(
        _ routeElementIdentifier: RouteElementIdentifier,
        animated: Bool,
        completionHandler: @escaping RoutingCompletionHandler)
    {
        // TODO: this should technically never be called -> bug in router
        completionHandler()
    }
    
}


class ItemListRoutable: Routable {
    
    private let viewController: UIViewController
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func changeRouteSegment(
        _ from: RouteElementIdentifier,
        to: RouteElementIdentifier,
        animated: Bool,
        completionHandler: @escaping RoutingCompletionHandler) -> Routable {
        
        if from == itemNameRoute && to == itemDetailRoute {
            viewController.dismiss(animated: true) {}
            
            let vc = R.storyboard.itemDetail.itemDetailViewController()!
            (self.viewController as! UINavigationController).pushViewController(
                vc,
                animated: false
            )
            completionHandler()
            return ItemDetailRoutable(viewController)
        }
        
        fatalError("Cannot handle this route change!")

    }
    
    func pushRouteSegment(
        _ routeElementIdentifier: RouteElementIdentifier,
        animated: Bool,
        completionHandler: @escaping RoutingCompletionHandler) -> Routable
    {
        if routeElementIdentifier == itemDetailRoute {
            let vc = R.storyboard.itemDetail.itemDetailViewController()!
            (self.viewController as! UINavigationController).pushViewController(
                vc,
                animated: animated
            )
            completionHandler()
            
            return ItemDetailRoutable(viewController)
        }
        
        if routeElementIdentifier == itemNameRoute {
            
            let vc = R.storyboard.itemList.instantiateInitialViewController()!
            viewController.modalPresentationStyle = .fullScreen
            viewController.present(vc, animated: true, completion: nil)

            completionHandler()
            
            return ItemNameRoutable(viewController)
        }
        
        fatalError("Cannot handle this route change!")
        
    }
    
    public func popRouteSegment(
        _ routeElementIdentifier: RouteElementIdentifier,
        animated: Bool,
        completionHandler: @escaping RoutingCompletionHandler) {
        
        if routeElementIdentifier == itemDetailRoute {
            (self.viewController as! UINavigationController).popViewController(animated: true)
            completionHandler()

        }
        
        if routeElementIdentifier == itemNameRoute {
            viewController.dismiss(animated: true) {
                completionHandler()
            }
        }

    }
}

class ItemDetailRoutable: Routable {
    
    
    private let viewController: UIViewController
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func pushRouteSegment(
        _ routeElementIdentifier: RouteElementIdentifier,
        animated: Bool,
        completionHandler: @escaping RoutingCompletionHandler) -> Routable
    {
        
        if routeElementIdentifier == itemNameRoute {
            
            let vc = R.storyboard.itemList.instantiateInitialViewController()!
            viewController.modalPresentationStyle = .fullScreen
            viewController.present(vc, animated: true, completion: nil)

            
            
            completionHandler()
            
            return ItemDetailRoutable(self.viewController)
        }
        
        fatalError("Cannot handle this route change!")
        
    }
    
    func popRouteSegment(
        _ routeElementIdentifier: RouteElementIdentifier,
        animated: Bool,
        completionHandler: @escaping RoutingCompletionHandler)
    {
        if routeElementIdentifier == itemNameRoute {
            
            viewController.dismiss(animated: true, completion: {
                completionHandler()
                
            })
        }
    }
}

class ItemNameRoutable: Routable {
    
    private let viewController: UIViewController
    
    func changeRouteSegment(
        _ from: RouteElementIdentifier,
        to: RouteElementIdentifier,
        animated: Bool,
        completionHandler: @escaping RoutingCompletionHandler) -> Routable {
        
        fatalError("Cannot handle this route change!")
        
    }
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func popRouteSegment(
        _ routeElementIdentifier: RouteElementIdentifier,
        animated: Bool,
        completionHandler: @escaping RoutingCompletionHandler)
    {
        
       
        
        completionHandler()
    }
    
    func pushRouteSegment(
        _ routeElementIdentifier: RouteElementIdentifier,
        animated: Bool,
        completionHandler: @escaping RoutingCompletionHandler) -> Routable
    {
        
        
        
        fatalError("Cannot handle this route change!")
        
    }
    
}
