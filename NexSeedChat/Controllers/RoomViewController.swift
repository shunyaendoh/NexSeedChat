//
//  RoomViewController.swift
//  NexSeedChat
//
//  Created by shunya endoh on 2019/12/10.
//  Copyright © 2019 shunya endoh. All rights reserved.
//

import UIKit
import Firebase
import RevealingSplashView

class RoomViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var rooms: [Room] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var documentId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showSplashView()
        tableView.delegate = self
        tableView.dataSource = self
        
        let db = Firestore.firestore()
        
        db.collection("rooms").order(by: "createdAt", descending: true).addSnapshotListener({(querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
             return
         }
            
            var results: [Room] = []
            for document in documents {
                let name = document.get("name") as! String
                let room = Room(name: name, documentId: document.documentID)
                results.append(room)
            }
            self.rooms = results
    })
    
    }
    
    func showSplashView() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        let splashView = RevealingSplashView(iconImage: UIImage(named: "SeedKun")!, iconInitialSize: CGSize(width: 600, height: 600), backgroundColor: UIColor(red: 187/255, green: 136/255, blue: 6/255, alpha: 1))
        
        splashView.animationType = .squeezeAndZoomOut
        
        self.view.addSubview(splashView)
        
        splashView.startAnimation(){
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    @IBAction func didClickButton(_ sender: UIButton) {
        guard let roomName = textField.text else {
            return
        }
        if textField.text!.isEmpty {
            return
        }
        let db = Firestore.firestore()
        db.collection("rooms").addDocument(data: ["name": roomName, "createdAt": FieldValue.serverTimestamp()]) { err in
            print(err.debugDescription)
        }
        textField.text = ""
    }
    
}

extension RoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = rooms[indexPath.row].name
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
