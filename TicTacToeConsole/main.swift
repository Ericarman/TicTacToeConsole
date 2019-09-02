//
//  main.swift
//  TicTacToeConsole
//
//  Created by Eric Hovhannisyan on 8/28/19.
//  Copyright © 2019 Eric Hovhannisyan. All rights reserved.
//

import Foundation

class Game {
    enum BoardSize: Int {
        case small = 3
        case medium = 6
        case large = 8
    }
    
    enum Turn {
        case cross
        case circle
    }
    
    enum EndGame {
        case win
        case lose
        case draw
        case undefined
    }
    
    lazy var board = Matrix(rows: size.rawValue, columns: size.rawValue)
    
    lazy var size: BoardSize = {
        print("Choose board size (small, medium, large)")
        while true {
            if let line = readLine() {
                switch line {
                case "small":
                    return .small
                case "medium":
                    return .medium
                case "large":
                    return .large
                default:
                    break
                }
            }
        }
    }()
    
    private var inputFromUser: index {
        print("Choose position to insert ", terminator: "")

        while true {
            if let line = filterLine(readLine() ?? "") {
                return line
            }
        }
    }
    
    private func filterLine(_ line: String) -> index? {
        var row = ""
        var column = ""
        var findComma = false
        
        let filteredLine = line.filter { Int(String($0)) != nil || $0 == "," }
        
        for i in filteredLine.indices {
            if filteredLine[i] == "," { findComma = true; continue }
            
            if findComma {
                column += String(filteredLine[i])
            } else {
                row += String(filteredLine[i])
            }
        }
        guard let filteredRow = Int(row), let filteredColumn = Int(column) else { return nil }
        return (filteredRow, filteredColumn)
    }
    
    private func play(turn: inout Turn) {
        print(board)
        let index = inputFromUser
        
        if board[index.row, index.column] != " " {
            print("Enter correct position")
            return
        }
        
        switch turn {
        case .cross:
            board.insert("×", at: index)
            turn = .circle
        case .circle:
            board.insert("⚬", at: index)
            turn = .cross
        }
    }
    
    private func checkBoard() -> EndGame {
        var crossRow = String(repeating: "×", count: size.rawValue)
        var circleRow = String(repeating: "⚬", count: size.rawValue)
        
        func checkRows() -> EndGame {
            for i in 0..<board.rows {
                var row = ""
                for j in 0..<board.columns {
                    row += board[i, j]
                }
                
                if row == crossRow {
                    return .win
                } else if row == circleRow {
                    return .lose
                }
            }
            return .undefined
        }
        
        func checkColumns() -> EndGame {
            for j in 0..<board.columns {
                var row = ""
                for i in 0..<board.rows {
                    row += board[i, j]
                }
                
                if row == crossRow {
                    return .win
                } else if row == circleRow {
                    return .lose
                }
            }
            return .undefined
        }
        
        func checkDiagonals() -> EndGame {
            var row = ""
            for i in 0..<board.rows {
                row += board[i, i]
            }
            
            if row == crossRow {
                return .win
            } else if row == circleRow {
                return .lose
            }
            
            row = ""
            
            for i in 0..<board.rows {
                row += board[i, board.rows - i - 1]
            }
            
            if row == crossRow {
                return .win
            } else if row == circleRow {
                return .lose
            }
            return .undefined
        }
        
        let rowCheck = checkRows()
        let columnCheck = checkColumns()
        let diogonalCheck = checkDiagonals()
        
        if rowCheck == .win || columnCheck == .win || diogonalCheck == .win {
            return .win
        } else if rowCheck == .lose || columnCheck == .lose || diogonalCheck == .lose {
            return .lose
        } else if !board.contains(" ") {
            return .draw
        }
        return .undefined
    }
    
    public func start() {
        var turn = Turn.cross
        var result = checkBoard()
        while result == .undefined {
            play(turn: &turn)
            result = checkBoard()
        }
        
        print(board)
        switch result {
        case .win:
            print("You win!")
        case .lose:
            print("You lose!")
        case .draw:
            print("Draw!")
        case .undefined:
            print("Something goes wrong!")
        }
    }
}

var game = Game()
game.start()
//print(game.board)
