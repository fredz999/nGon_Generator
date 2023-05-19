//
//  CentrePointFace_Ngon.swift
//  nGon_Generator
//
//  Created by Jon on 19/05/2023.
//

import SwiftUI
import Foundation
import SceneKit
import UIKit

class CentrePointFace_Ngon {
    
    var topFaceEdge_H_Vertices = [H_Vertex]()
    var bottomFaceEdge_H_Vertices = [H_Vertex]()
    var topFaceIndices = [UInt16]()
    var wallIndices = [UInt16]()
    var bottomFaceIndices = [UInt16]()
    var exposedVertices = [SCNVector3]()
    var combinedIndices = [UInt16]()
    
    //===================ALTERATION SECTION=========================
    
    var numSides : Int
    {
        didSet {
        reGenerateGeometry()
        }
    }
    
    var roofSlantType : E_NGon_Slant_Type = .roof_Flat
    {
        didSet {
        reGenerateGeometry()
        }
    }
    
    var rotationIndex:Int = 0
    {
        didSet {
        reGenerateGeometry()
        }
    }
    
    var topVector3:SCNVector3 = SCNVector3(x: 0, y: 0.5, z: 0)
    {
        didSet {
        reGenerateGeometry()
        }
    }
    
    var bottomVector3:SCNVector3 = SCNVector3(x: 0, y: -0.5, z: 0)
    {
        didSet {
        reGenerateGeometry()
        }
    }
    
    //===================/ALTERATION SECTION=========================
    
    var normals = [SCNVector3]()
    
    var radius : Float = 1.0
    var widthScale : Float = 1
    var lengthScale : Float = 1
    var height : Float = 1.0
    var topFaceYfloat : Float = 0.5
    var bottomFaceYfloat : Float = -0.5
    
    
    
    init(){
        numSides = AppDimensions.StaticAppDimensions.initialSectionSides
//        numSides = numberOfSides
//        topVector3 = topVector3Param
//        bottomVector3 = bottomVector3Param
        reGenerateGeometry()
//        reGenerateGeometry(topVector3:topVector3
//        ,bottomVector3:bottomVector3
//        ,numberOfSides:numberOfSides
//        ,rotationIndex:rotationIndex)
    }
   
    // have to regenerate this
    //func reGenerateGeometry(topVector3:SCNVector3,bottomVector3:SCNVector3,numberOfSides:Int,rotationIndex:Int){
    func reGenerateGeometry(){
        
        if topFaceEdge_H_Vertices.count > 0{topFaceEdge_H_Vertices.removeAll()}
        if bottomFaceEdge_H_Vertices.count > 0{bottomFaceEdge_H_Vertices.removeAll()}
        if topFaceIndices.count > 0{topFaceIndices.removeAll()}
        if wallIndices.count > 0{wallIndices.removeAll()}
        if bottomFaceIndices.count > 0{bottomFaceIndices.removeAll()}
        if combinedIndices.count > 0{combinedIndices.removeAll()}
        if exposedVertices.count > 0{exposedVertices.removeAll()}
        
        let topFaceVertex = H_Vertex(vector3Param: topVector3, typeParam: .topFaceVertex, placeInSpecifiedCollectionParam: 0)
        topFaceEdge_H_Vertices.append(topFaceVertex)
        generateTopFaceVertices(rotationIndex:rotationIndex)
        
        if roofSlantType != .roof_Flat{
            topFaceEdge_H_Vertices[3].vector3.y += 0.5
        }
        
        let newStarterIndex = topFaceEdge_H_Vertices.count
        let bottomFaceVertex = H_Vertex(vector3Param: bottomVector3, typeParam: .bottomFaceVertex, placeInSpecifiedCollectionParam: newStarterIndex)
        bottomFaceEdge_H_Vertices.append(bottomFaceVertex)
        generateBottomFaceVertices(rotationIndex:rotationIndex)
        
        
        for i in topFaceEdge_H_Vertices{
            exposedVertices.append(i.vector3)
        }
        for i in bottomFaceEdge_H_Vertices{
            exposedVertices.append(i.vector3)
        }
        generateTopFaceEdgeIndices()
        generateBottomFaceEdgeIndices()
        incorporateWallIndices()
        combineIndices()
        print("regen supposedly happened.............")
    }
    
//    func retrieveGeometry(geometryGettingAltered:inout SCNGeometry){
//        //if let lclCentrePoint = centrePointFace_Ngon {
//            //let vertexArray = lclCentrePoint.exposedVertices
//            //let indices : [UInt16] = lclCentrePoint.combinedIndices
//            let geometrySource = SCNGeometrySource(vertices: exposedVertices)
//            let element = SCNGeometryElement(indices: combinedIndices, primitiveType: .triangles)
//            let geom = SCNGeometry(sources: [geometrySource], elements: [element])
//            geometryGettingAltered = geom
//        print("retrieveGeometry( tried ......")
//        //}
//    }
    
    func generateTopFaceVertices(rotationIndex:Int){
        let standardSeperatingAngle : Float = 360/Float(numSides)
        if numSides % 2 == 0 {
            let halfStandard = standardSeperatingAngle/2
            let totalSubtraction = (0-(90+halfStandard))+(standardSeperatingAngle*Float(rotationIndex))
            for x in 0..<numSides{
                let unadjustedAngleVal : Float = ((standardSeperatingAngle*Float(x))+totalSubtraction) * (Float.pi / 180)
                let xVal = cos(unadjustedAngleVal)
                let zVal : Float = sin(unadjustedAngleVal)
                let vec3Top = SCNVector3(x: xVal, y: topFaceYfloat, z: zVal)
                let hVecTop = H_Vertex(vector3Param: vec3Top, typeParam: .topFaceEdgeVertex, placeInSpecifiedCollectionParam: x)
                topFaceEdge_H_Vertices.append(hVecTop)
            }
        }
        else if numSides % 2 != 0 {
            let halfStandard = standardSeperatingAngle/2
            let totalSubtraction = (0-(90+halfStandard))+(standardSeperatingAngle*Float(rotationIndex))
            for x in 0..<numSides{
                let unadjustedAngleVal : Float = ((standardSeperatingAngle*Float(x))+totalSubtraction) * (Float.pi / 180)
                let xVal = cos(unadjustedAngleVal)
                let zVal : Float = sin(unadjustedAngleVal)
                let vec3Top = SCNVector3(x: xVal, y: topFaceYfloat, z: zVal)
                let hVecTop = H_Vertex(vector3Param: vec3Top, typeParam: .topFaceEdgeVertex, placeInSpecifiedCollectionParam: x)
                topFaceEdge_H_Vertices.append(hVecTop)
            }
        }
    }
    
    func generateBottomFaceVertices(rotationIndex:Int){
        let standardSeperatingAngle : Float = 360/Float(numSides)
        if numSides % 2 == 0 {
            let halfStandard = standardSeperatingAngle/2
            let totalSubtraction = (0-(90+halfStandard))+(standardSeperatingAngle*Float(rotationIndex))
            for x in 0..<numSides {
                let unadjustedAngleVal : Float = ((standardSeperatingAngle*Float(x))+totalSubtraction) * (Float.pi / 180)
                let xVal = cos(unadjustedAngleVal)
                let zVal : Float = sin(unadjustedAngleVal)
                let vec3Top = SCNVector3(x: xVal, y: bottomFaceYfloat, z: zVal)
                let hVecTop = H_Vertex(vector3Param: vec3Top, typeParam: .topFaceEdgeVertex, placeInSpecifiedCollectionParam: topFaceEdge_H_Vertices.count + x)
                bottomFaceEdge_H_Vertices.append(hVecTop)
            }
        }
        else if numSides % 2 != 0 {
            let halfStandard = standardSeperatingAngle/2
            let totalSubtraction = (0-(90+halfStandard))+(standardSeperatingAngle*Float(rotationIndex))
            for x in 0..<numSides {
                let unadjustedAngleVal : Float = ((standardSeperatingAngle*Float(x))+totalSubtraction) * (Float.pi / 180)
                let xVal = cos(unadjustedAngleVal)
                let zVal : Float = sin(unadjustedAngleVal)
                let vec3Top = SCNVector3(x: xVal, y: bottomFaceYfloat, z: zVal)
                let hVecTop = H_Vertex(vector3Param: vec3Top, typeParam: .topFaceEdgeVertex, placeInSpecifiedCollectionParam: topFaceEdge_H_Vertices.count + x)
                bottomFaceEdge_H_Vertices.append(hVecTop)
            }
        }
    }
    
    func generateTopFaceEdgeIndices(){
        for i in 1...numSides{
            if i < numSides{
                let triplet = [UInt16(i-i),UInt16(numSides-i+1),UInt16(numSides-i)]
                topFaceIndices.append(contentsOf: triplet)
            }
            else if i == numSides{
                let triplet = [UInt16(i-i),UInt16(numSides-i+1),UInt16(numSides)]
                topFaceIndices.append(contentsOf: triplet)
            }
        }
    }
    
    func generateBottomFaceEdgeIndices(){
        let startIndex = numSides+1
        for i in 1...numSides{
            if i < numSides{
                bottomFaceIndices.append(contentsOf: [UInt16(startIndex),UInt16(startIndex+i),UInt16(startIndex+i+1)])
            }
            else if i == numSides{
               bottomFaceIndices.append(contentsOf: [UInt16(startIndex),UInt16(startIndex+i),UInt16(startIndex+1)])
            }
        }
    }
    
    func incorporateWallIndices(){
        var indicesTop = [UInt16]()
        var indicesBottom = [UInt16]()
        
        for i in 1...numSides{
            indicesTop.append(UInt16(i))
            indicesBottom.append(UInt16(i+1)+UInt16(numSides))
        }

        for i in 0..<numSides{
            if i < numSides-1{
                wallIndices.append(contentsOf: [indicesTop[i],indicesTop[i+1],indicesBottom[i]])
            }
            else if i == numSides-1{
                wallIndices.append(contentsOf: [indicesTop[i],indicesTop[0],indicesBottom[i]])
            }
        }

        for i in 0..<numSides{
            if i < numSides-1{
                wallIndices.append(contentsOf:[indicesBottom[i+1],indicesBottom[i],indicesTop[i+1]])
            }
            else if i == numSides-1{
                wallIndices.append(contentsOf:[indicesBottom[0],indicesBottom[i],indicesTop[0]])
            }
        }

    }
    
    func combineIndices(){
        combinedIndices.append(contentsOf: topFaceIndices)
        combinedIndices.append(contentsOf: wallIndices)
        combinedIndices.append(contentsOf: bottomFaceIndices)
    }
    
}
