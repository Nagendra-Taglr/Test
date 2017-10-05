//
//  firstViewController.swift
//  TestApp
//
//  Created by Omkar Todkar on 10/4/17.
//  Copyright © 2017 Nagendra. All rights reserved.
//

import UIKit
import MobileCoreServices
class firstViewController: UIViewController {

    @IBOutlet weak var firstTableView: UITableView!
    @IBOutlet weak var secondTableview: UITableView!
    var firstArr:[String] = []
    var secondArr:[String] = []
    var identifier = "Cell"
    var imageView: UIImageView!
    let size = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstTableView.delegate = self
        self.firstTableView.dataSource = self
        self.firstTableView.dragDelegate = self
        self.firstTableView.dropDelegate = self
        self.secondTableview.delegate = self
        self.secondTableview.dataSource = self
        self.secondTableview.dragDelegate = self
        self.secondTableview.dropDelegate = self
        
        self.firstTableView.dragInteractionEnabled = true
        self.secondTableview.dragInteractionEnabled = true
        
        firstArr = ["Sunday","Monday","Tuesday","Wednesday"]
        secondArr = ["Thursday","Friday","Saturday"]
        self.firstTableView.register(UITableViewCell.self, forCellReuseIdentifier: self.identifier)
        self.secondTableview.register(UITableViewCell.self, forCellReuseIdentifier: self.identifier)
        
        imageView = UIImageView(frame: CGRect(x: 100, y: 100, width: size, height: size))
        view.addSubview(imageView)
        
        // render a red circle at the same size, and use it in the image view
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        imageView.image = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: size, height: size)
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.fillEllipse(in: rectangle)
        }
        // Do any additional setup after loading the view.
    }

}

extension firstViewController : UITableViewDelegate,UITableViewDataSource,UITableViewDragDelegate,UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        if tableView == self.firstTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath)
            cell?.textLabel?.text = firstArr[indexPath.row]
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath)
            cell?.textLabel?.text = secondArr[indexPath.row]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == self.firstTableView ? firstArr.count : secondArr.count
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let string = tableView == self.firstTableView ? self.firstArr[indexPath.row] : self.secondArr[indexPath.row]
        guard let data = string.data(using: .utf8) else { return []}
        let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: kUTTypePlainText as String)
        return [UIDragItem(itemProvider: itemProvider)]
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath : IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        coordinator.session.loadObjects(ofClass: NSString.self) { (items) in
            guard let strings = items as? [String] else { return }
            var indexPaths = [IndexPath]()
            
            for (index,string) in strings.enumerated() {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                if tableView == self.firstTableView {
                    self.firstArr.insert(string, at: indexPath.row)
                } else {
                    self.secondArr.insert(string, at: indexPath.row)
                }
                indexPaths.append(indexPath)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
}

extension firstViewController : UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        guard let image = imageView.image else { return [] }
        let provider = NSItemProvider(object: image)
        let item = UIDragItem(itemProvider: provider)
        return [item]
    }
}
