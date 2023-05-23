//
//  Building_Section.swift
//  nGon_Generator
//
//  Created by Jon on 15/05/2023.
//

import SwiftUI
import Foundation
import SceneKit
import UIKit

class Building_Section : ObservableObject,Identifiable, Equatable, Hashable {
    var dimensions = AppDimensions.StaticAppDimensions
    var id = UUID()
    
    public static func == (lhs: Building_Section, rhs: Building_Section) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    
    var materialGenerator = Material_Generator()
    var internally_Held_Material = SCNMaterial()
    var internally_Held_Geometry = SCNGeometry()
    let nodeMaterial = SCNMaterial()
    let externally_Visible_Node = SCNNode()
    var parentBuilding : Building
    //============= poss from designation?
    var designation : E_Building_Section_Type
    var geometryGenerator = Ngon_Generator() // this will be a protocol defn of the geometry funcs
    // use the enum simply as a decider for which designation specific attributes are composed in
    // the attribz themselves will be an interface defn whose concrete class has variations in functionality
    //including if designation = .roof then the geometry comes from the nGom generator
    // if designation = .mid_Section then the geometry comes from a different generator - giving the normal one from the previous project (skyLineSketchPad)
    // its just that those geometry functions seem to have very diffeent arg signatures because of slantType
    // maybe the slant type needs to be a variable that gets set in an external function then used in the internal sequencce of events
    // so that an interface definition from functions used by all three types can be adhered to.
    // ok the roof variant of the protocol will also contain a slant type variable that gets consulted during the
    // geometry generation along with sides top point e.t.c - it just wont be in the arg sig in fact
    // the generation func can serve as at least the main character in the protocol defn
    
    var initial_Y_Float : Float
    var min_Floors : Int
    var max_Floors : Int
    var start_Floors : Int
    //============= poss from designation?
    init(buildingParam:Building,designationParam:E_Building_Section_Type){
        parentBuilding = buildingParam
        designation = designationParam
        let sectionVals : Initial_Section_Info = dimensions.returnInitialSectionVals(designation: designationParam)
        initial_Y_Float = sectionVals.initial_Y_Float
        min_Floors = sectionVals.min_Floors
        max_Floors = sectionVals.max_Floors
        start_Floors = sectionVals.start_Floors
        nodeMaterial.diffuse.contents = UIColor(red: 0, green: 0.7, blue: 0.7, alpha: 1)
        initalise_Geometry()
    }
    
//    @Published var currentSides : Int = 3 {
//        didSet{
//            print("currentSides set to:",currentSides.description)
//            regenerate()
//        }
//    }
//
//    var rotationIndex : Int = 0{
//        didSet{
//            print("rotationIndex set to:",rotationIndex.description)
//            regenerate()
//        }
//    }
    
    var markerArray = [SCNNode]()
    

    
    func initalise_Geometry(){
        internally_Held_Material = materialGenerator.generateMaterial()
        internally_Held_Geometry = geometryGenerator.initalise_Geometry_From_Centrepoint_Ngon()
        internally_Held_Geometry.materials = [internally_Held_Material]
        externally_Visible_Node.geometry = internally_Held_Geometry
        rePlaceMarkess()
    }
    
    func update_Geometry(){
        geometryGenerator.retrieveGeometry(geometryGettingAltered: &internally_Held_Geometry)
        internally_Held_Material = materialGenerator.generateMaterial()
        internally_Held_Geometry.materials = [internally_Held_Material]
        externally_Visible_Node.geometry = internally_Held_Geometry
        rePlaceMarkess()
    }

    func rePlaceMarkess(){
        markerArray.removeAll()
        for node in externally_Visible_Node.childNodes{ node.removeFromParentNode() }
        if let lclNgon = geometryGenerator.centrePointFace_Ngon{
            for v in 0..<lclNgon.exposedVertices.count{
                requestMarker(vertex:lclNgon.exposedVertices[v], num: v)
            }
        }
        for node in markerArray{
            externally_Visible_Node.addChildNode(node)
        }
    }
    
    func requestMarker(vertex:SCNVector3,num:Int){
        let orangeMarker_Node = SCNNode()
        let orangeSphere = SCNSphere(radius: 0.05)
        let orangeMaterial = SCNMaterial()
        orangeMaterial.diffuse.contents = UIColor(red: 1, green: 0, blue: 0.5, alpha: 1)
        orangeSphere.materials = [orangeMaterial]
        orangeMarker_Node.geometry = orangeSphere
        orangeMarker_Node.position = vertex
        
        let skText = SCNText(string: num.description, extrusionDepth: 0.1)
        let textMat = SCNMaterial()
        textMat.diffuse.contents = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
        skText.materials = [textMat]
        
        let texNode = SCNNode(geometry: skText)
        texNode.scale = SCNVector3(x: 0.02, y: 0.02, z: 0.02)
        texNode.position = SCNVector3(x: 0.1, y: 0, z: 0)
        orangeMarker_Node.addChildNode(texNode)
        markerArray.append(orangeMarker_Node)
    
        
        
    }
    
    func roll_Forward_Backward(isNegative:Bool){
        if isNegative == true{externally_Visible_Node.eulerAngles.x -= 0.2}
        else if isNegative == false{externally_Visible_Node.eulerAngles.x += 0.2}
    }

}
