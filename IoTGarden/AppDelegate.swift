//
//  AppDelegate.swift
//  IoTGarden
//
//  Created by Apple on 10/31/18.
//

import UIKit
import CoreData
import Firebase
import ReSwift
import ReSwiftRouter


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var router: Router<AppState>!
    var rootViewController: Routable!



    func application(_ application: UIApplication,   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIViewController()
        let rootRoutable = RootRoutable(window: window!)
        
        router = Router(store: appStore, rootRoutable: rootRoutable) { state in
            state.select { $0.navigationState }
        }
        
        appStore.dispatch(ReSwiftRouter.SetRouteAction([mainViewRoute]))
        
        window?.makeKeyAndVisible()

        
        FirebaseApp.configure()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "IoTGarden")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

let mainViewRoute: RouteElementIdentifier = "Main"
let itemDetailRoute: RouteElementIdentifier = "ItemDetail"

let storyboard = UIStoryboard(name: "Main", bundle: nil)



class RootRoutable: Routable {
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func setToItemListViewController() -> Routable {
        self.window.rootViewController = R.storyboard.itemListViewController.instantiateInitialViewController()
        
        return ItemListRoutable(self.window.rootViewController!)
    }
    
    
    func pushRouteSegment(
        _ routeElementIdentifier: RouteElementIdentifier,
        animated: Bool,
        completionHandler: @escaping RoutingCompletionHandler) -> Routable
    {
        return setToItemListViewController()

        
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
    
    let viewController: UIViewController
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
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
                animated: false
            )
            completionHandler()

            return ItemDetailRoutable()
        }

        fatalError("Cannot handle this route change!")

    }
}

class ItemDetailRoutable: Routable {}

