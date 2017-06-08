//
//  ViewController.swift
//  ARtistry
//
//  Created by Chris Rittersdorf on 6/8/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, UIGestureRecognizerDelegate {
    var pressed = false
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    fileprivate func addAnchorInFrontOfCamera() {
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.5
        
        if let frame = sceneView.session.currentFrame {
            let transform = simd_mul(frame.camera.transform, translation)
            let newAnchor = ARAnchor(transform: transform)
            
            sceneView.session.add(anchor: newAnchor)
        }
    }
    
    @IBAction func viewWasTapped(_ sender: UITapGestureRecognizer) {
        print("view was tapped...")
        
        addAnchorInFrontOfCamera()
    }
    
    
    // MARK: - ARSCNViewDelegatelkjlkj
    
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if pressed {
            addAnchorInFrontOfCamera()
        }
    }
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode(geometry: buildSphere())
        
        node.position = SCNVector3(0, 0, -0.2)
        
        print("node was added....")
        return node
    }
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func buildSphere() -> SCNSphere {
        let sphere = SCNSphere(radius: 0.025)
        let material = SCNMaterial()
        
        material.diffuse.contents = UIColor.red
        material.specular.contents = UIColor(white: 0.6, alpha: 1.0)
        material.shininess = 0.3
        
        sphere.materials = [material]
        
        return sphere
    }
    
    @IBAction func longPressCallback(gr: UIGestureRecognizer) {
        print("\(gr)")
        
        switch gr.state {
        case .began:
            self.pressed = true
        case .ended:
            self.pressed = false
        case .changed:
            print("changed...")
            //no op
        default:
            self.pressed = false
        }
    }
}
