//
//  RBTree.swift
//  Testing
//
//  Created by 陈大师 on 2020/3/2.
//  Copyright © 2020 陈大师. All rights reserved.
//

import Foundation

class RBTree<T: Comparable> {
    
    enum Color: String {
        case RED, BLACK
    }
    
    //  MARK: Define Node
    class Node: CustomStringConvertible {
        
        var description: String {
            switch color {
            case .BLACK:
                return "\(String(format: "%2d", key as! Int))B"
            case .RED:
                return "\(String(format: "%2d", key as! Int))R"
            }
        }
        
        var parent, left, right: Node?
        var color = Color.RED
        var key: T
        
        init(withKey key: T) {
            self.key = key
        }
        var height: Int {
            return max(left?.height ?? 0, right?.height ?? 0) + 1
        }
        var isLeftChild: Bool {
            return self === parent?.left
        }
        var isRightChild: Bool {
            return self === parent?.right
        }
        var isLeaf: Bool {
            return left == nil && right == nil
        }
        var grandParent: Node? {
            return parent?.parent
        }
        var sibling: Node? {
            if isLeftChild {
                return parent?.right
            } else if isRightChild {
                return parent?.left
            } else {
                return nil
            }
        }
        var uncle: Node? {
            if parent?.isLeftChild ?? false {
                return grandParent?.right
            } else if parent?.isRightChild ?? false {
                return grandParent?.left
            } else {
                return nil
            }
        }
        var successor: Node? {
            if var current = right {
                while true {
                    if let child = current.left {
                        current = child
                    } else {
                        return current
                    }
                }
            } else {
                return nil
            }
        }
        
        //  MARK: Rotation
        func rotateLeft() {
            let oldRoot = self, newRoot = right
            newRoot?.left?.parent = oldRoot
            oldRoot.right = newRoot?.left
            if oldRoot.isLeftChild {
                oldRoot.parent?.left = newRoot
            } else if oldRoot.isRightChild {
                oldRoot.parent?.right = newRoot
            }
            newRoot?.parent = oldRoot.parent
            oldRoot.parent = newRoot
            newRoot?.left = oldRoot
        }
        
        func rotateRight() {
            let oldRoot = self, newRoot = left
            newRoot?.right?.parent = oldRoot
            oldRoot.left = newRoot?.right
            if oldRoot.isLeftChild {
                oldRoot.parent?.left = newRoot
            } else if oldRoot.isRightChild {
                oldRoot.parent?.right = newRoot
            }
            newRoot?.parent = oldRoot.parent
            oldRoot.parent = newRoot
            newRoot?.right = oldRoot
        }
        
        //  MARK: Insertion Repair
        func insertRepair() {
            if parent == nil {
                color = .BLACK
            } else if parent?.color == Color.BLACK {
                return
            } else if uncle?.color == Color.RED {
                parent?.color = .BLACK
                uncle?.color = .BLACK
                grandParent?.color = .RED
                grandParent?.insertRepair()
            } else {
                var n: Node? = self
                if isRightChild && parent!.isLeftChild {
                    parent?.rotateLeft()
                    n = left
                } else if isLeftChild && parent!.isRightChild {
                    parent?.rotateRight()
                    n = right
                }
                if n!.isLeftChild {
                    n?.grandParent?.rotateRight()
                } else {
                    n?.grandParent?.rotateLeft()
                }
                n?.parent?.color = .BLACK
                n?.sibling?.color = .RED
            }
        }
        
        //  MARK: Removal Repair
        func removeRepair() {
            // step 1
            if parent == nil {
                return
            }
            // step 2
            if sibling?.color == Color.RED {
                parent?.color = .RED
                sibling?.color = .BLACK
                if isLeftChild {
                    parent?.rotateLeft()
                } else if isRightChild {
                    parent?.rotateRight()
                }
            }
            // step 3
            if parent?.color == Color.BLACK && (sibling?.color == Color.BLACK || sibling == nil) && (sibling?.left?.color == Color.BLACK || sibling?.left == nil) && (sibling?.right?.color == Color.BLACK || sibling?.right == nil) {
                sibling?.color = .RED
                parent?.removeRepair()
            } else {
                // step 4
                if parent?.color == Color.RED && (sibling?.color == Color.BLACK || sibling == nil) && (sibling?.left?.color == Color.BLACK || sibling?.left == nil) && (sibling?.right?.color == Color.BLACK || sibling?.right == nil) {
                    sibling?.color = .RED
                    parent?.color = .BLACK
                } else {
                    // step 5
                    if (sibling?.color == Color.BLACK || sibling == nil) {
                        if isLeftChild && (sibling?.right?.color == Color.BLACK || sibling?.right == nil) && sibling?.left?.color == Color.RED {
                            sibling?.color = .RED
                            sibling?.left?.color = .BLACK
                            sibling?.rotateRight()
                        } else if isRightChild && (sibling?.left?.color == Color.BLACK || sibling?.left == nil) && sibling?.right?.color == Color.RED {
                            sibling?.color = .RED
                            sibling?.right?.color = .BLACK
                            sibling?.rotateLeft()
                        }
                    }
                    // step 6
                    sibling?.color = parent!.color
                    parent?.color = .BLACK
                    if isLeftChild {
                        sibling?.right?.color = .BLACK
                        parent?.rotateLeft()
                    } else if isRightChild {
                        sibling?.left?.color = .BLACK
                        parent?.rotateRight()
                    }
                }
            }
            
        }
    }
    
    var root: Node? = nil
    var height: Int {
        return root?.height ?? 0
    }
    
    private func updateRoot(withNode node: Node?) {
        root = node
        while let newRoot = root?.parent {
            root = newRoot
        }
    }
    
    private func find(withKey key: T) -> Node? {
        var node = root
        while let current = node {
            if key < current.key {
                node = current.left
            } else if key > current.key {
                node = current.right
            } else {
                return current
            }
        }
        return nil
    }
    
    //  MARK: Insertion
    func insert(withKey key: T) {
        let newNode = Node(withKey: key)
        if var current = root {
            while true {
                if key < current.key {
                    if let child = current.left {
                        current = child
                    } else {
                        current.left = newNode
                        newNode.parent = current
                        break
                    }
                } else if key > current.key {
                    if let child = current.right {
                        current = child
                    } else {
                        current.right = newNode
                        newNode.parent = current
                        break
                    }
                } else {
                    return
                }
            }
        } else {
            root = newNode
        }
        newNode.insertRepair()
        updateRoot(withNode: newNode)
    }
    
    //  MARK: Removal
    func remove(withKey key: T) {
        if var target = find(withKey: key) {
            var nodeForRoot: Node? = target
            if !target.isLeaf, let successor = target.successor {
                target.key = successor.key
                target = successor
            }
            if target.isLeaf {
                nodeForRoot = target.parent
                if target.color == .BLACK {
                    target.removeRepair()
                }
            } else {
                let child = target.left ?? target.right
                target.key = child!.key
                if target.color == .BLACK && child?.color == Color.BLACK {
                    target.removeRepair()
                }
                target = child!
            }
            if target.isLeftChild {
                target.parent?.left = nil
            } else if target.isRightChild {
                target.parent?.right = nil
            }
            target.parent = nil
            updateRoot(withNode: nodeForRoot)
        } else {
            return
        }
    }
    
    //  MARK: Print Level Counts
    func levelPrint() {
        var queue = [(Node, Int)]()
        var count = [Int: Int]()
        if let node = root {
            queue.append((node, 0))
        }
        while !queue.isEmpty {
            let (node, level) = queue.removeFirst()
//            print(node, "  Level:", level)
            if count[level] == nil {
                count[level] = 1
            } else {
                count[level]! += 1
            }
            if let l = node.left {
                queue.append((l, level + 1))
            }
            if let r = node.right {
                queue.append((r, level + 1))
            }
        }
        for (level, time) in count.sorted(by: { $0.key < $1.key }) {
            print("level: \(String(format: "%2d", level)) \t\tcount: \(String(format: "%6d", time))")
        }
    }
    
}
