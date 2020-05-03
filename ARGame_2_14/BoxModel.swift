//
//  BoxModel.swift
//  ARGame_2_14
//
//  Created by Лаура Есаян on 03.05.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class BoxModel {
    
    private func createBox(position: SCNVector3, color: UIColor) -> SCNNode {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = color
        box.firstMaterial?.isDoubleSided = true
        let boxNode = SCNNode(geometry: box)
        boxNode.position = position

        return boxNode
    }
    
    private func generateRandomPosition() -> SCNVector3 {
        return SCNVector3(x: Float.random(in: -1...1), y: Float.random(in: -1...1), z: Float.random(in: -1...1))
    }
    
     func generateRandomColor() -> UIColor {
        let colors = [0: #colorLiteral(red: 1, green: 0.9598860748, blue: 0.4043213171, alpha: 0.9), 1: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0.9), 2: #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 0.9), 3: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 0.9), 4: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 0.9), 5: #colorLiteral(red: 0.6067150242, green: 1, blue: 0.9936729992, alpha: 0.9)]
        return colors[Int.random(in: 0...5)]!
    }
    
    func generateBoxes(boxesCount: Int) -> [SCNNode] {
        var boxes: [SCNNode] = []
        for _ in 0..<boxesCount {
            let boxPosition = generateRandomPosition()
            let boxColor = generateRandomColor()
            boxes.append(createBox(position: boxPosition, color: boxColor))
        }
        
        return boxes
    }
}
