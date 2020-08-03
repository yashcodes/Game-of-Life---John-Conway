//
//  ViewController.swift
//  Game of Life
//
//  Created by Yash  on 31/07/20.
//  Copyright © 2020 Yash . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var twoDarrayOfCells : [[Cell]] = []
    
    var StopButtonPressed : Bool = false
    
    var generation : Int = 0
    
    var GenerationLabel : UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateCells()
        
        let StartButton = UIButton(frame: CGRect(x: 30, y: view.frame.size.height - 120, width: 100, height: 50))
        StartButton.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        StartButton.setTitle("Start", for: .normal)
        StartButton.addTarget(self, action: #selector(self.StartButtonClicked), for: .touchUpInside)
        StartButton.layer.cornerRadius = 15
        self.view.addSubview(StartButton)
        
        let StopButton = UIButton(frame: CGRect(x: view.frame.size.width - 130, y: view.frame.size.height - 120, width: 100, height: 50))
        StopButton.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        StopButton.setTitle("Stop", for: .normal)
        StopButton.addTarget(self, action: #selector(self.StopButtonClicked), for: .touchUpInside)
        StopButton.layer.cornerRadius = 15
        self.view.addSubview(StopButton)
        
        let ResetButton = UIButton(frame: CGRect(x: 30, y: view.frame.size.height - 60, width: 100, height: 50))
        ResetButton.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        ResetButton.setTitle("Reset", for: .normal)
        ResetButton.addTarget(self, action: #selector(self.ResetButtonClicked), for: .touchUpInside)
        ResetButton.layer.cornerRadius = 15
        self.view.addSubview(ResetButton)
        
        let ResumeButton = UIButton(frame: CGRect(x: view.frame.size.width - 130, y: view.frame.size.height - 60, width: 100, height: 50))
        ResumeButton.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        ResumeButton.setTitle("Resume", for: .normal)
        ResumeButton.addTarget(self, action: #selector(self.ResumeButtonClicked), for: .touchUpInside)
        ResumeButton.layer.cornerRadius = 15
        self.view.addSubview(ResumeButton)
        
        GenerationLabel = UILabel(frame: CGRect(x: view.frame.size.width - 285, y: view.frame.size.height - 132, width: 200, height: 80))
        GenerationLabel?.textAlignment = .center
        GenerationLabel?.text = "0"
        GenerationLabel?.font = UIFont.systemFont(ofSize: 30.0)
        self.view.addSubview(GenerationLabel!)
        
    }
    
    func populateCells(){
        var X = 0
        var Y = 30
        
        for _ in 1...32{
            var temp : [Cell] = []
            
            for _ in 1...32{
                let cell = Cell()
                
                let button = UIButton(frame: CGRect(x: X, y: Y, width: 15, height: 15))
                button.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                button.addTarget(self, action: #selector(self.MakeCellAliveOrDead), for: .touchUpInside)
                self.view.addSubview(button)
                
                cell.button = button
                temp.append(cell)
                X = X + 16
            }
            X = 0
            Y = Y + 16
            twoDarrayOfCells.append(temp)
        }
    }
    
    @objc func MakeCellAliveOrDead(sender: UIButton){
        if sender.backgroundColor == #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1) {
            sender.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }else {
            sender.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        }
        updateForNewGen()
    }
    
    
}

// Functions to Start the Cycle
extension ViewController{
    
    @objc func StartButtonClicked(sender : UIButton){
        
        sender.pulsate()
        print("Start Button Clicked")
        
        self.StopButtonPressed = false
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            
            for i in 0...31 {
                for j in 0...31 {
                    
                    let aliveNbrs : Int = self.neighbours(row: i, column: j)
                    if (self.twoDarrayOfCells[i][j].currGenAlive){
                        if (aliveNbrs < 2 || aliveNbrs > 3) {
                            self.twoDarrayOfCells[i][j].nextGenAlive = false
                        }else{
                            self.twoDarrayOfCells[i][j].nextGenAlive = true
                        }
                    }else {
                        if (aliveNbrs == 3){
                            self.twoDarrayOfCells[i][j].nextGenAlive = true
                        }
                    }
                    DispatchQueue.main.async{
                        if self.twoDarrayOfCells[i][j].nextGenAlive {
                            self.twoDarrayOfCells[i][j].button.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                        }else{
                            self.twoDarrayOfCells[i][j].button.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                        }
                    }
                    
                }
            }
            
            DispatchQueue.main.async {
                self.updateForNewGen()
            }
            if self.StopButtonPressed {
                self.StopButtonPressed = false
                Timer.invalidate()
            }
            
            self.updateGen()
        }
        
    }
    
    func updateForNewGen(){
        for cells in twoDarrayOfCells{
            for cell in cells{
                if cell.button.backgroundColor == #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1){
                    cell.currGenAlive = true
                }else{
                    cell.currGenAlive = false
                }
                cell.nextGenAlive = false
            }
        }
    }
    
    
    func updateGen(){
        generation += 1
        GenerationLabel?.text = "\(generation)"
    }
    
    func neighbours(row: Int, column: Int) -> Int {
        
        var aliveNbrs = 0
        
        if (row + 1 < 32){
            if (self.twoDarrayOfCells[row + 1][column].currGenAlive){
                aliveNbrs = aliveNbrs + 1
            }
        }
        
        if (row + 1 < 32 && column + 1 < 32){
            if (self.twoDarrayOfCells[row + 1][column + 1].currGenAlive){
                aliveNbrs = aliveNbrs + 1
            }
        }
        
        if (column + 1 < 32){
            if (self.twoDarrayOfCells[row][column + 1].currGenAlive){
                aliveNbrs = aliveNbrs + 1
            }
        }
        
        if (row - 1 > -1 && column + 1 < 32){
            if (self.twoDarrayOfCells[row - 1][column + 1].currGenAlive){
                aliveNbrs = aliveNbrs + 1
            }
        }
        
        if (row - 1 > -1 ){
            if (self.twoDarrayOfCells[row - 1][column].currGenAlive){
                aliveNbrs = aliveNbrs + 1
            }
        }
        
        if (row - 1 > -1 && column - 1 > -1){
            if (self.twoDarrayOfCells[row - 1][column - 1].currGenAlive){
                aliveNbrs = aliveNbrs + 1
            }
        }
        
        if (column - 1 > -1){
            if (self.twoDarrayOfCells[row][column - 1].currGenAlive){
                aliveNbrs = aliveNbrs + 1
            }
        }
        
        if (row + 1 < 32 && column - 1 > -1){
            if (self.twoDarrayOfCells[row + 1][column - 1].currGenAlive){
                aliveNbrs = aliveNbrs + 1
            }
        }
        
        return aliveNbrs
    }
    
}

// Functions to Stop the cycle
extension ViewController {
    
    @objc func StopButtonClicked(sender : UIButton){
        sender.pulsate()
        print("Stop Button Clicked")
        StopButtonPressed = true
    }
}

// Functions to Reset the cycle
extension ViewController {
    
    @objc func ResetButtonClicked(sender : UIButton){
        sender.pulsate()
        print("Reset Button Clicked")
        GenerationLabel?.text = "0"
        generation = 0
        StopButtonPressed = true
        for cells in twoDarrayOfCells{
            for cell in cells{
                cell.button.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                cell.nextGenAlive = false
                cell.currGenAlive = true
            }
        }
    }
}

// Function to Resume the cycle
extension ViewController {
    @objc func ResumeButtonClicked(sender : UIButton){
        sender.pulsate()
        print("Resume Button Clicked")
        StartButtonClicked(sender: sender)
    }
}
