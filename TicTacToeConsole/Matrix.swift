//
//  Matrix.swift
//  TicTacToeConsole
//
//  Created by Eric Hovhannisyan on 8/30/19.
//  Copyright © 2019 Eric Hovhannisyan. All rights reserved.
//

import Foundation

typealias index = (row: Int, column: Int)

class Matrix {
    private var matrix = [String]()
    private(set) var rows: Int = 0
    private(set) var columns: Int = 0
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        matrix = [String](repeating: " ", count: rows * columns)
    }
    
    func insert(_ element: String, at i: index) {
        self[i.row, i.column] = element
    }
    
    func contains(_ element: String) -> Bool {
        return matrix.contains(element)
    }
    
    subscript(row: Int, column: Int) -> String {
        get {
            let index = row * columns + column
            return index < matrix.count ? matrix[index] : "out of range"
        }
        set {
            let index = row * columns + column
            return matrix[index] = index < matrix.count ? newValue : "out of range"
        }
    }
    
}

extension Matrix: CustomStringConvertible {
    var description: String {
        func verticalSpacingLine(row: Int) -> String {
            var value = ""
            
            for j in 0..<columns {
                value += "┃ \(self[row, j]) "
            }
            return value + "┃"
        }
        
        let firstLine = "┏━━━" + String(repeating: "┳━━━", count: columns - 1) + "┓"
        let verticalSeparatingLine = "┣━━━" + String(repeating: "╋━━━", count: columns - 1) + "┫"
        let lastLine = "┗━━━" + String(repeating: "┻━━━", count: columns - 1) + "┛"
        
        var lines = [firstLine]
        for i in 0..<rows - 1 {
            lines += [verticalSpacingLine(row: i), verticalSeparatingLine]
        }
        lines += [verticalSpacingLine(row: rows - 1), lastLine]
        
        return lines.joined(separator: "\n")
    }
}
