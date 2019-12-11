//
//  LoginViewController.swift
//  NexSeedChat
//
//  Created by shunya endoh on 2019/12/10.
//  Copyright © 2019 shunya endoh. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import RevealingSplashView

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        let splashView = RevealingSplashView(iconImage: UIImage(named: "SeedKun")!, iconInitialSize: CGSize(width: 600, height: 600), backgroundColor: UIColor(red: 187/255, green: 136/255, blue: 6/255, alpha: 1))
        
        splashView.animationType = .squeezeAndZoomOut
        
        self.view.addSubview(splashView)
        
        splashView.startAnimation(){
        }
    }

}

extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let err = error {
            print(err.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (result, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            
            print("signed in!")
            self.performSegue(withIdentifier: "toHome", sender: nil)
        }
    }
}
