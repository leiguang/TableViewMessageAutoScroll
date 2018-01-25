//
//  TableViewController.swift
//  tableview
//
//  Created by 雷广 on 2018/1/22.
//  Copyright © 2018年 leiguang. All rights reserved.
//

// (https://www.cnblogs.com/zrr-notes/p/5896824.html)
// >> 其实一般情况下调用reloadData时tableView的 contentoffset是不会变的，但是如果table里面cell的数目发生的改变，如增加了一个cell，并且无法从重用队列中找到时，talbeView会重排结构，contentoffset会清零（所以我的页面会出现快闪的问题）。并且这一过程是需要时间的，如果在上述动作尚未完成之前又去设置与table相关的动画（例如：tableView.setContentOffset(: , animated: true) 会引起冲突，从而导致重排后的tableView的布局与预期出现偏差的情况。故，解决上述问题还可将设置tableView的contentoffset的动作延后或者放到UIView的动画回调中（，因为原理上是一样的，都避开了tableView本身重排的时间。可以将animated动画设置为NO来解决问题

// (https://www.jianshu.com/p/3bdd962dbd9e)
// >> tableView-reloadData后setContentOffset无效问题解决。在tableView.reloadData()后 先执行tableView.layoutIfNeeded()，最后tableView.setContentOffset()

import UIKit

let kNavigationHeight: CGFloat = UIApplication.shared.statusBarFrame.height + 44.0
let kScreenHeight: CGFloat = UIScreen.main.bounds.height
let kRowHeight: CGFloat = 60.0

class TableViewController: UITableViewController {

    var colors: [UIColor] = []
    var cellHeights: [CGFloat] = []
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    

    @IBAction func tapAdd(_ sender: Any) {
        let color = UIColor(red: CGFloat(arc4random_uniform(200))/200.0, green: CGFloat(arc4random_uniform(200))/200.0, blue: CGFloat(arc4random_uniform(200))/200.0, alpha: 1)
        colors.append(color)
        
        let height = CGFloat(arc4random_uniform(80) + 30)
        cellHeights.append(height)

        
        // Demo1: 从顶部开始增加，有增加数据，自动滑到最下面一个
//        let indexPath = IndexPath(row: tableView.numberOfRows(inSection: 0), section: 0)
//        tableView.insertRows(at: [indexPath], with:UITableViewRowAnimation.automatic)
//        tableView.scrollToRow(at: indexPath, at:UITableViewScrollPosition.none, animated:true)
        
        // Demo2: 从底部开始增加数据
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.contentOffset = CGPoint(x: 0, y: cellHeights.dropLast().reduce(0) { $0 + $1 } - kScreenHeight)
        tableView.setContentOffset(CGPoint(x: 0, y: self.cellHeights.reduce(0) { $0 + $1 } - kScreenHeight), animated: true)
        
        
        // Demo3: 用CGAffineTransform 把tableView和cell.contentView 都翻转180°
        
    }
    
    @IBAction func tapClear(_ sender: Any) {
        colors.removeAll()
        cellHeights.removeAll()
        tableView.reloadData()
    }
    
    @IBAction func tapAuto(_ sender: Any) {
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: 0.30, repeats: true) {_ in
            self.tapAdd(UIButton())
        }
    }
    
    @IBAction func tapStop(_ sender: Any) {
        timer?.invalidate()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        cell.textLabel?.text = "\(colors.count-1)"
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }

}
