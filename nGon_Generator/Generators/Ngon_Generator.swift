//
//  Ngon_Generator.swift
//  nGon_Generator
//
//  Created by Jon on 15/05/2023.
//

import SwiftUI
import Foundation
import SceneKit
import UIKit

// this stuff might make for pretty good package material

class Ngon_Generator : P_Geometry_Gen, ObservableObject {
    var dimensions = AppDimensions.StaticAppDimensions
    var centrePointFace_Ngon : CentrePointFace_Ngon?
    
    func initalise_Geometry_From_Centrepoint_Ngon() -> SCNGeometry {
        var geom = SCNGeometry()
        let newCentrePointNGon = CentrePointFace_Ngon()
        centrePointFace_Ngon = newCentrePointNGon
        let vertexArray = newCentrePointNGon.exposedVertices
        let indices : [UInt16] = newCentrePointNGon.combinedIndices
        let geometrySource = SCNGeometrySource(vertices: vertexArray)
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)
        geom = SCNGeometry(sources: [geometrySource], elements: [element])
        return geom
    }
    
    func retrieveGeometry(geometryGettingAltered:inout SCNGeometry){
        if let lclCentrePoint = centrePointFace_Ngon {
            let vertexArray = lclCentrePoint.exposedVertices
            let indices : [UInt16] = lclCentrePoint.combinedIndices
            let geometrySource = SCNGeometrySource(vertices: vertexArray)
            let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)
            let geom = SCNGeometry(sources: [geometrySource], elements: [element])
            geometryGettingAltered = geom
        }
    }

}

class H_Vertex:Identifiable, Equatable, Hashable {
    var id = UUID()
    var vector3 : SCNVector3
    var type : E_H_Vertex_Type
    var placeInSpecifiedCollection : Int
    
    init(vector3Param: SCNVector3,typeParam:E_H_Vertex_Type,placeInSpecifiedCollectionParam:Int) {
        type = typeParam
        placeInSpecifiedCollection = placeInSpecifiedCollectionParam
        self.vector3 = vector3Param
    }
    
    public static func == (lhs: H_Vertex, rhs: H_Vertex) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

//class CentrePointedFace {
//
//    var faceVertexArray = [SCNVector3]()
//    var indexArray = [UInt16]()
//    init(){
//
//        faceVertexArray.append(SCNVector3(x: 0, y: 0, z: 0)) //centre 1
//        
//        faceVertexArray.append(SCNVector3(x: -1, y: 1, z: 0))
//        faceVertexArray.append(SCNVector3(x: 0, y: -1, z: 0))
//        faceVertexArray.append(SCNVector3(x: 1, y: 1, z: 0))
//        
//        faceVertexArray.append(SCNVector3(x: 0, y: 0, z: -1)) //centre 2
//        
//        faceVertexArray.append(SCNVector3(x: -1, y: 1, z: -1))
//        faceVertexArray.append(SCNVector3(x: 0, y: -1, z: -1))
//        faceVertexArray.append(SCNVector3(x: 1, y: 1, z: -1))
//        
//        //first face
//        indexArray.append(contentsOf: [0,1,2])
//        indexArray.append(contentsOf: [0,2,3])
//        indexArray.append(contentsOf: [0,3,1])
//        //first 'wall'
//        indexArray.append(contentsOf: [1,5,6])
//        indexArray.append(contentsOf: [1,6,2])
//        
//        indexArray.append(contentsOf: [2,6,7])
//        indexArray.append(contentsOf: [2,7,3])
//        
//        indexArray.append(contentsOf: [3,7,5])
//        indexArray.append(contentsOf: [3,5,1])
//        //2nd face
//        indexArray.append(contentsOf: [4,5,7])
//        indexArray.append(contentsOf: [4,6,5])
//        indexArray.append(contentsOf: [4,7,6])
//    }
//    
//    func generateWallFace(){
//        
//    }
//    
//    func centralisedNGon(sides:Int){
//    }
//    
//}
