//
//  Main_3d_Scene.swift
//  nGon_Generator
//
//  Created by Jon on 15/05/2023.
//

import SwiftUI
import Foundation
import SceneKit
import UIKit

struct Main_3d_Scene_View : View {
    let dimensions = AppDimensions.StaticAppDimensions
    @ObservedObject var main_3d_Scene_Store : Main_3d_Scene_Store
    var body: some View {
        if let lclCameraHelper = main_3d_Scene_Store.cameraHelper {
            SceneView(
            scene: main_3d_Scene_Store.scene,
            pointOfView: lclCameraHelper.cameraNode,
            options: []
            )
            .frame(width: dimensions.main3dSceneWidth , height: dimensions.main3dSceneHeight)
            .background(Color.black)
        }
    }
}


class Main_3d_Scene_Store:ObservableObject{
    let dimensions = AppDimensions.StaticAppDimensions
    let scene = SCNScene()
    let groundPlaneNode : SCNNode
    let camera_Target = SCNNode()
    var building_Collection = Building_Collection()
    @Published var cameraHelper : Camera_Helper?
    
    init(){
        camera_Target.position = dimensions.camTargetPoint
        let targetZero = SCNLookAtConstraint(target: camera_Target)
        cameraHelper = Camera_Helper(sceneParam: scene, targetParam: targetZero)
        
        let light = SCNLight()
        light.type = SCNLight.LightType.omni
        light.castsShadow = false
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 0, y: 6.5, z: 6)
        scene.rootNode.addChildNode(lightNode)
        
        let groundPlaneGeometry = SCNPlane(width: 14, height: 14)
        groundPlaneNode = SCNNode(geometry: groundPlaneGeometry)
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = UIColor(red: 1, green: 0.7, blue: 0, alpha: 1)
        planeMaterial.emission.contents = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        planeMaterial.isDoubleSided = true
        groundPlaneGeometry.materials = [planeMaterial]
        
        let floatVal = GLKMathDegreesToRadians(-90)
        groundPlaneNode.eulerAngles = SCNVector3(x: floatVal, y: 0, z: 0)
        groundPlaneNode.position = SCNVector3(x: 0, y: -0.01, z: 0)
        scene.background.contents = UIColor(red: 0.4, green: 0, blue: 0, alpha: 1)
        scene.rootNode.addChildNode(groundPlaneNode)

        addBuilding()
    }
    func addBuilding(){
        building_Collection.generateBuilding(x: 0, y: 0)
        //want the rendering to happen automatically but not have them overlapping like remove them before adding them all
        for childNode in scene.rootNode.childNodes {
            childNode.removeFromParentNode()
        }
        //scene.rootNode.addChildNode(groundPlaneNode)
        for building in building_Collection.building_Array{
            scene.rootNode.addChildNode(building.buildingNode)
        }
    }
 
}
