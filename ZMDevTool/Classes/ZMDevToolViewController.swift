//
//  ZMDevToolViewController.swift
//  ZMDevTool
//
//  Created by Sam Chen on 11/15/23.
//

import UIKit
import CoreMotion

let ZMDTCellIdentifier = "ZMDTCellIdentifier"

struct DragonFirePosition {
    var x:Int64
    var y:Int32
}

struct DragonHomePosition {
    var y:Int32
    var x:Int64
}

@objcMembers
open class ZMDevToolViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.rowHeight = 50
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ZMDTCellIdentifier)
        return tableView
    }()
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow.withAlphaComponent(0.5)
        let fire = MemoryLayout<DragonFirePosition>.size
        let home = MemoryLayout<DragonHomePosition>.size
        print("fire = \(fire) stride = \(MemoryLayout<DragonFirePosition>.stride), home = \(home) stride = \(MemoryLayout<DragonHomePosition>.stride)")
    }
    
    
    public override var canBecomeFirstResponder: Bool {
        return true
    }
    
    public override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("Shake motion start")
        }
    }
    
    public override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("Shake motion end")
            self.view.addSubview(tableView)
            tableView.frame = CGRectMake(10, 30, CGRectGetWidth(self.view.bounds)-20, CGRectGetHeight(self.view.bounds)-100)
        }
    }
    
    // MARK: UITableViewDelegate
        
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            100
        }
        
        public func numberOfSections(in tableView: UITableView) -> Int {
            1
        }
        
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell = tableView.dequeueReusableCell(withIdentifier: ZMDTCellIdentifier, for: indexPath)
            cell.textLabel?.text = "666"
            return cell
        }
}


