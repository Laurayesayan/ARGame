//
//  ViewController.swift
//  ARGame_2_14
//
//  Created by Лаура Есаян on 03.05.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    private let boxModel = BoxModel()
    private let colorRange = [0: #colorLiteral(red: 1, green: 0.9598860748, blue: 0.4043213171, alpha: 0.95), 1: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0.95), 2: #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 0.95), 3: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 0.95), 4: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 0.95), 5: #colorLiteral(red: 0.6067150242, green: 1, blue: 0.9936729992, alpha: 0.95)]
    private var sphereNode: SCNNode? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        addBoxes()
        addColorPanel()
    }
    
    func addBoxes() {
        let boxNodes = boxModel.generateBoxNodes(boxesCount: 100, colorRange: colorRange)
        
        for box in boxNodes {
            sceneView.scene.rootNode.addChildNode(box)
        }
    }
    
    func addColorPanel() {
        let panel = UIView()
        let h = view.frame.height / 8
        panel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1988655822)
        
        panel.frame = CGRect(x: 0.0, y: view.frame.height - h, width: view.frame.width, height: h)
        
        let offset = panel.frame.width / 7
        let w = panel.frame.height / 2.5
        var buttonX = offset
        for i in 0..<colorRange.count {
            let button = UIButton()
            button.backgroundColor = colorRange[i]
            button.frame = CGRect(x: 0, y: 0, width: w, height: w)
            button.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            button.layer.position = CGPoint(x: buttonX, y: panel.frame.height / 2)
            button.layer.cornerRadius = button.frame.width / 2
            buttonX += offset
            button.addTarget(self, action: #selector(buttonAction(sender: )), for: .touchDown)
            
            panel.addSubview(button)
        }
    
        self.view.addSubview(panel)
    }
    
    @objc func buttonAction(sender: UIButton) {
        if sphereNode != nil {
            sphereNode?.removeFromParentNode()
            sphereNode = nil
        }
        
        if let color = sender.backgroundColor {
            createSphere(color: color)
        }
    }
    
    private func createSphere(color: UIColor) {
        let sphere = SCNSphere(radius: 0.03)
        sphere.firstMaterial?.diffuse.contents = color
        sphere.firstMaterial?.isDoubleSided = true
        
        sphereNode = SCNNode(geometry: sphere)
        sphereNode!.position = SCNVector3(0, 0, -0.2)
        sceneView.scene.rootNode.addChildNode(sphereNode!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: sceneView)
            
            if let intersectedNode = sceneView.hitTest(position, options: nil).first?.node, let sphereNode = sphereNode {
                SCNTransaction.animationDuration = 1.0
                sphereNode.position = intersectedNode.position
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    self!.handleCollision(of: sphereNode, with: intersectedNode)
                }
            }
        }
    }
    
    func handleCollision(of sphere: SCNNode, with box: SCNNode) {
        let sphereColor = sphere.geometry?.firstMaterial?.diffuse.contents as! UIColor
        let boxColor = box.geometry?.firstMaterial?.diffuse.contents as! UIColor
        
        if sphereColor == boxColor {
            sphere.removeFromParentNode()
            box.removeFromParentNode()
            sphereNode = nil
        } else {
            sphere.removeFromParentNode()
            sphereNode = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
