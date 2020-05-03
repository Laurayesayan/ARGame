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
    
    private func generateRandomColor(_ colorRange: [Int: UIColor]) -> UIColor {

        return colorRange[Int.random(in: 0...5)]!
    }
    
    func generateBoxNodes(boxesCount: Int, colorRange: [Int: UIColor]) -> [SCNNode] {
        var boxes: [SCNNode] = []
        for _ in 0..<boxesCount {
            let boxPosition = generateRandomPosition()
            let boxColor = generateRandomColor(colorRange)
            boxes.append(createBox(position: boxPosition, color: boxColor))
        }
        
        return boxes
    }
}
