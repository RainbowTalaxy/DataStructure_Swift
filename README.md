#  Here is Talaxy's private Swift DataStrucure Club

update on 20/3/8 : 
## RBTree & PrintTree
An RBTree has such methods:
* init()
* insert(withKey:)
* remove(withKey:)
* contain(withKey:)

A PrintTree can print an RBTree by such code:
```swift
var tree = RBTree<Int>();
(0..<10).forEach { tree.insert(withKey: $0) }
let printer = PrintTree(tree: tree)
printer.printTree()
```

