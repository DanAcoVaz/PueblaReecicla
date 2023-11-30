//
//  AppDelegate.swift
//  PueblaReecicla
//
//  Created by Administrador on 31/10/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import GoogleSignIn
import GoogleSignInSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Thread.sleep(forTimeInterval: 1)
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        GIDSignIn.sharedInstance.restorePreviousSignIn{ user, error in
              if error != nil || user == nil {
                if let presentingViewController = self.window?.rootViewController {
                  GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController){ user, error in
                      if error != nil {
                      print("Error Google SignIn Auth (Code in App Delegate)")
                      return
                    }
                    
                    if let user = user {
                      NotificationCenter.default.post(name: NSNotification.Name("SignInGoogle"), object: user)
                    } else {
                      NotificationCenter.default.post(name: NSNotification.Name("SignInGoogle"), object: nil)
                    }
                    
                  }
                }
                
              }
            }
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

