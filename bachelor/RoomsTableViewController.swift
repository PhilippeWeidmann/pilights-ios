//
//  RoomsTableViewController.swift
//  bachelor
//
//  Created by Philippe Weidmann on 22.03.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import UIKit
import CoreMotion

class RoomsTableViewController: UITableViewController {

    var rooms = [Room]()
    let motionActivityManager = CMMotionActivityManager()
    let fileManager = FileManager.default

    override func viewDidLoad() {
        super.viewDidLoad()
        /*motionActivityManager.startActivityUpdates(to: .main) { (activity) in
            print(activity)
        }*/
        if let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {

            do {
                let files = try fileManager.contentsOfDirectory(atPath: dir.relativePath)
                for file in files {
                    if file.contains(".json") {
                        rooms.append(Room(name: String(file.split(separator: ".")[0])))
                    }
                }
            }
            catch {}
        }
        
    }

    @IBAction func newRoomTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Room name", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.rooms.append(Room(name: textField!.text!.trimmingCharacters(in: .whitespacesAndNewlines)))
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: self.rooms.count - 1, section: 0)], with: .automatic)
            self.tableView.endUpdates()
        }))

        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath)


        cell.textLabel!.text = rooms[indexPath.row].name

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            let room = rooms.remove(at: indexPath.row)
            if let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                do {
                    try fileManager.removeItem(atPath: dir.relativePath+"/\(room.name).json")
                } catch {}
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            tableView.endUpdates()
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DevicesTableViewController {
            let roomName = rooms[tableView.indexPath(for: sender as! UITableViewCell)!.row].name
            destination.roomName = roomName
        }
    }
    

}
