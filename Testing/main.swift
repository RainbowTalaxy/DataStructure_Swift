
import Foundation

var tree = RBTree<Int>()
var large = 20
let list = (0..<large).shuffled()
var printer = PrintTree(tree: tree)

list.forEach {
    tree.insert(withKey: $0)
}

printer.printTree()
