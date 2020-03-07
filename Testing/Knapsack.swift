//
//  Knapsack.swift
//  Testing
//
//  Created by 陈大师 on 2020/3/4.
//  Copyright © 2020 陈大师. All rights reserved.
//

import Foundation

class Knapsack {
    
    class Item {
        var weight, value: Int
        init(weight: Int, value: Int) {
            self.weight = weight
            self.value = value
        }
    }
    
    var capacity: Int
    var valueTable = [[Int]]()
    var choiceTable = [[Bool]]()
    var items = [Item]()
    var maxmunValue: Int {
        return valueTable.last!.last!
    }
    var choicePath: [Item] {
        var path = [Item]()
        var (i, c) = (items.count - 1, capacity)
        while i > 0 && c > 0 {
            if choiceTable[i][c] == true {
//                path.insert(items[i], at: 0)
                path.append(items[i])
                (i, c) = (i - 1, c - items[i].weight)
            } else {
                (i, c) = (i - 1, c)
            }
        }
        return path
    }
    
    init(withMaxCapacity maxCapacity: Int) {
        self.capacity = maxCapacity
        initTables()
        items.append(Item(weight: 0, value: 0))
    }
    
    func addItem(weight: Int, value: Int) {
        items.append(Item(weight: weight, value: value))
        add(i: items.count - 1)
    }
    
    func initTables() {
        valueTable.removeAll()
        choiceTable.removeAll()
        valueTable.append([Int](repeating: 0, count: capacity + 1))
        choiceTable.append([Bool](repeating: false, count: capacity + 1))
    }
    
    func freshTables() {
        initTables()
        for i in 1..<items.count {
            add(i: i)
        }
    }
    
    private func add(i: Int) {
        guard i >= 0 && i <= items.count - 1 else {
            return
        }
        choiceTable.append([Bool](repeating: false, count: capacity + 1))
        var valueList = [Int]()
        for remainingCapacity in 0...capacity {
            if items[i].weight <= remainingCapacity {
                let valueOfGet = valueTable[i - 1][remainingCapacity - items[i].weight] + items[i].value
                let valueOfPut = valueTable[i - 1][remainingCapacity]
                if valueOfGet >= valueOfPut {
                    valueList.append(valueOfGet)
                    choiceTable[i][remainingCapacity] = true
                } else {
                    valueList.append(valueOfPut)
                }
            } else {
                valueList.append(valueTable[i - 1][remainingCapacity])
            }
        }
        valueTable.append(valueList)
    }
    
    func printTable() {
        for list in valueTable {
            print("[\t", terminator: "")
            for cell in list {
                print("\(cell)\t", terminator: "")
            }
            print("]")
        }
    }

}

func printChoicePath(knapsnap: Knapsack) {
    var flag = true
    for item in knapsnap.choicePath {
        if flag {
            flag = false
        } else {
            print(terminator: " ")
        }
        print(item.value, terminator: "")
    }
}
