//
//  ViewController.swift
//  ar0523
//
//  Created by Akiko Sato on 2019/05/23.
//  Copyright © 2019 Akiko Sato. All rights reserved.
//

import UIKit
import ARKit

class DoodleViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }()
    
    var drawingNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(defaultConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: sceneView) else {
            return
        }
        let point3D = sceneView.unprojectPoint(SCNVector3(point.x, point.y, 0.997))
        
        let node: SCNNode
        // drawingNodeがもし、ボールを作ったら、クローンする。なければ新しく作るß
        if let drawingNode = drawingNode {
            //ボールを複製(クローン)して次々にボールを作る
            node = drawingNode.clone() //①→ ①と②がお互いに補完してく。また、.clone()がないとボールが指の動きに付いてくる
        } else {
            node = createBallLine()
            drawingNode = node //②
        }
        node.position = point3D
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    //小さいボールのNodeをたくさん書いて、returnする
    func createBallLine() -> SCNNode {
        //ボール作る→ class SCNSphere : SCNGeometry
        //radiusの数値が大きいほど線っぽくなる
        let ball = SCNSphere(radius: 0.004)
        ball.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.8431372549, green: 1, blue: 0, alpha: 0.8)
        
        //SCNGeometryにNodeを作る
        let node = SCNNode(geometry: ball)
        return node
    }
    
    func createPathLine() -> SCNNode {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0.005))
        path.addLine(to: CGPoint(x: 0.005, y: 0))
        path.addLine(to: CGPoint(x: 0, y: -0.005))
        path.addLine(to: CGPoint(x: -0.005, y: 0))
        path.close()
        
        let shape = SCNShape(path: path, extrusionDepth: 0.01)
        shape.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        shape.chamferRadius = 0.005
        
        let node = SCNNode(geometry: shape)
        return node
    }
}

extension DoodleViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }
}
