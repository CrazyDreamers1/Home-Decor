//
//  ViewController.swift
//  Home Decor
//
//  Created by MacBook Pro on 30/10/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class HomeDecorViewController: UIViewController, ARSCNViewDelegate {
    
    var shipScene:SCNScene!

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!

        shipScene = scene
        sceneView.scene = scene
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
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [.featurePoint])
        
        guard let hitFeature = results.last else {
            return
        }
        
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        let hitPosition = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        placeFurniture(position: hitPosition)
        
    }
    
    
    
    func placeFurniture(position:SCNVector3) {
        let shipNode = shipScene.rootNode.childNode(withName: "ship", recursively: true)
        shipNode?.position = position
        
        let lampScene = SCNScene(named: "art.scnassets/lamp.scn")!
        
        let lampNode = lampScene.rootNode.childNode(withName: "lamp", recursively: true)
        lampNode?.position = position

//        let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.1*Double.pi), z: 0, duration: 0.5))
//
//        shipNode?.runAction(rotate)
        
        sceneView.scene.rootNode.addChildNode(lampNode!)
        
    }
    
}
