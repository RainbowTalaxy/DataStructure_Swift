//
//  PrintTree.swift
//  Testing
//
//  Created by 陈大师 on 2020/3/5.
//  Copyright © 2020 陈大师. All rights reserved.
//

import Foundation

class PrintTree {
    
    var level = 4
    
    /*
     |              [6]
     |       ________|________
     |      [7]             [5]
     |   ____|____       ____|____
     |  [5]     [6]     [3]     [4]
     | __|__   __|__   __|__   __|__
     |[1] [2] [3] [4] [8] [9] [1] [2]
     */
    
    var tree: RBTree<Int>
    var branch = [String]()
    var datas = [String]()
    
    init(tree: RBTree<Int>) {
        self.tree = tree
    }
    
    private func space(_ n: Int) -> String {
        return factory(n, char: " ")
    }
    
    private func line(_ n: Int) -> String {
        return factory(n, char: "_") + "|" + factory(n, char: "_")
    }
    
    private func factory(_ n: Int, char: Character) -> String {
        var s = ""
        for _ in 0..<n {
            s.append(char)
        }
        return s
    }
    
    private func pow2(_ n: Int) -> Int {
        var a = 1
        for _ in 0..<n {
            a *= 2
        }
        return a
    }
    
    func printTree() {
        fresh()
        for i in 0..<level - 1 {
            print(datas[i])
            print(branch[i])
        }
        print(datas.last!)
    }
    
    private func fresh() {
        level = tree.height
        if level <= 1 {
            level = 2
        }
        datas.removeAll()
        branch.removeAll()
        for i in 1..<level {
            var s = ""
            for _ in 0..<pow2(i - 1) {
                s += space(pow2(level - i) - 1)
                s += line(pow2(level - i))
                s += space(pow2(level - i))
            }
            branch.append(s)
        }
        for _ in 0..<level {
            datas.append("")
        }
        var queue = [(RBTree<Int>.Node?, Int)]()
        queue.append((tree.root, 0))
        while !queue.isEmpty {
            let (n, l) = queue.removeFirst()
            if let node = n {
                if l < level - 1 {
                    queue.append((node.left, l + 1))
                    queue.append((node.right, l + 1))
                }
            } else if l < level - 1 {
                queue.append((nil, l + 1))
                queue.append((nil, l + 1))
            }
            let s = space(pow2(level - l) - 2) + "\(n?.description ?? "   ")" + space(pow2(level - l) - 1)
            datas[l] += s
        }
    }
    
}
