//
//  Camera_Helper.swift
//  nGon_Generator
//
//  Created by Jon on 15/05/2023.
//

import Foundation
import SwiftUI
import SceneKit
import UIKit

class Camera_Helper {
    
    var cameraNode = SCNNode()
    
    let camera = SCNCamera()
    
    var positions = [SCNVector3]()
    
    var positionNumber:Int = 0
    
    init(sceneParam:SCNScene,targetParam:SCNLookAtConstraint){
        positions.append(SCNVector3(x: 0, y: 0, z: 3))
        positions.append(SCNVector3(x: 2, y: 1, z: 5))
        positions.append(SCNVector3(x: 3, y: 1, z: 5))
        positions.append(SCNVector3(x: 4, y: 1, z: 5))
        
        cameraNode.camera = camera
        cameraNode.position = positions[0]
        cameraNode.constraints = [targetParam]
        sceneParam.rootNode.addChildNode(cameraNode)
    }
    
    func updateCamPos(){
        if positionNumber+1 < positions.count{
            positionNumber += 1
        }
        else if positionNumber+1 >= positions.count{
            positionNumber = 0
        }
        cameraNode.position = positions[positionNumber]
    }
}
