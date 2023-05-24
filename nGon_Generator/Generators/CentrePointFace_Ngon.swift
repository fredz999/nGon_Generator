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

class CentrePointFace_Ngon : ObservableObject {
    
    var topFace_H_Vertices = [H_Vertex]()
    var bottomFaceEdge_H_Vertices = [H_Vertex]()
    var topFaceIndices = [UInt16]()
    var wallIndices = [UInt16]()
    var bottomFaceIndices = [UInt16]()
    var exposedVertices = [SCNVector3]()
    var combinedIndices = [UInt16]()
    
    //===================ALTERATION SECTION=========================
    
    @Published var numSides : Int
    {
        didSet {
        reGenerateGeometry()
        }
    }
    
    @Published var sides_Even : Bool = true
    
    @Published var roofSlantType : E_NGon_Slant_Type = .roof_Flat
    {
        didSet {
        reGenerateGeometry()
        }
    }
    
    
    
    @Published var rotationIndex:Int = 0
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
    
    //================== SLOPE ======================================
    var slantModificationArray : [Float] = []
    var sortedZFloats = [Float](){
        didSet {
            print("sortedZFloats count: ",sortedZFloats.count)
        }
    }
    var evenCosRation:Float = 1.0
    var evenSinRation:Float = 1.0
    @Published var orientation : E_Section_Orientation = .south
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
        reGenerateGeometry()
    }
    
    func generateTopFaceGeometry(){
        if topFace_H_Vertices.count > 0{ topFace_H_Vertices.removeAll() }
        let topFaceVertex = H_Vertex(vector3Param: topVector3, typeParam: .topFaceCentreVertex, placeInSpecifiedCollectionParam: 0)
        topFace_H_Vertices.append(topFaceVertex)
        generate_Top_Face_Edge_Vertices()
    }
    
    func reGenerateGeometry(){
        if bottomFaceEdge_H_Vertices.count > 0{bottomFaceEdge_H_Vertices.removeAll()}
        
        if topFaceIndices.count > 0{topFaceIndices.removeAll()}
        if wallIndices.count > 0{wallIndices.removeAll()}
        if bottomFaceIndices.count > 0{bottomFaceIndices.removeAll()}
        if combinedIndices.count > 0{combinedIndices.removeAll()}
        if exposedVertices.count > 0{exposedVertices.removeAll()}
        
        if numSides % 2 != 0{sides_Even = false}
        else if numSides % 2 == 0{sides_Even = true}
        generateTopFaceGeometry()
        apply_Top_Face_Modifiers()
        
        let bottomCentreStartIndex = topFace_H_Vertices.count
        let bottomFaceVertex = H_Vertex(vector3Param: bottomVector3, typeParam: .bottomFaceCentreVertex, placeInSpecifiedCollectionParam: bottomCentreStartIndex)
        bottomFaceEdge_H_Vertices.append(bottomFaceVertex)
        generateBottomFaceVertices(rotationIndex:rotationIndex)

        for i in bottomFaceEdge_H_Vertices {
            exposedVertices.append(i.vector3)
        }

        generateTopFaceEdgeIndices()
        generateBottomFaceEdgeIndices()
        incorporateWallIndices()
        combineIndices()

    }
    
    func apply_Top_Face_Modifiers(){

        let applicationZone = topFace_H_Vertices.filter{$0.type == .topFaceEdgeVertex}
        if slantAdditionArray.count >= applicationZone.count &&  slantAdditionArray.count > 0{
            for i in 0..<applicationZone.count {
                applicationZone[i].vector3.y += slantAdditionArray[i]
            }
        }
        for v in topFace_H_Vertices {
            exposedVertices.append(v.vector3)
        }
    }

    var slantAdditionArray = [Float]()

    func blank_Slant_Addition_Array(){
        slantAdditionArray.removeAll()
        print("slantAdditionArray count: ",slantAdditionArray.count.description)
    }
    
    func generate_Slant_Addition_Array(){
        if slantAdditionArray.count > 0{slantAdditionArray.removeAll()}
        let edgeSection = topFace_H_Vertices.filter{$0.type != .topFaceCentreVertex}

        for i in 0..<edgeSection.count {
            let zVal : Float = edgeSection[i].vector3.z
            let multipliedZ = zVal*100
            let intMultiplied = Int(multipliedZ)

            let z_Multiplier = Float(intMultiplied)/100
            let slantAddition = 0.25*(z_Multiplier)
            slantAdditionArray.append(slantAddition)
        }
        
        var trackString = ""
        for v in slantAdditionArray{
            trackString.append(v.description+", ")
        }
        print("slantAdditionArray: ",trackString)
        
    }
    
    var currFrameShiftAMount:Int = 0
    
    func frameShift(toRight:Bool){
        
        if slantAdditionArray.count > 0 {
            let shifter = FrameShifter()
            if toRight == true {
                shifter.shiftArrayFrame(frameShift: 1, floatArray: &slantAdditionArray)
            }
            else if toRight == false {
                shifter.shiftArrayFrame(frameShift: -1, floatArray: &slantAdditionArray)
            }
            var trackString = ""
            for v in slantAdditionArray{trackString.append(v.description+", ")
            }
        }
        else if slantAdditionArray.count == 0 {
            print("slantAdditionArray was nil: ")
        }

    }
    
    func flipOrientation(newOrientation:E_Section_Orientation){
        if orientation != newOrientation{orientation = newOrientation}
    }
    
    func genSubtraction() -> Float {
        let standard_Angle : Float = 360/Float(numSides)
        let halfStandard = standard_Angle/2
        let rotationIndex_F = Float(rotationIndex)
        
        var retVal = (standard_Angle * rotationIndex_F) + (90)
        
        if orientation == .north {
        retVal = (standard_Angle * rotationIndex_F) + (270)
        }
        
        else if orientation == .east {
            retVal = (0-(90+halfStandard))+(standard_Angle*Float(rotationIndex))
        }
        
        return retVal
    }

    func generate_Top_Face_Edge_Vertices(){
    let standardSeperatingAngle : Float = 360/Float(numSides)
    if numSides % 2 == 0 {
        let halfStandard = standardSeperatingAngle/2
        let totalSubtraction = genSubtraction()
        let indexIdAddition = topFace_H_Vertices.count
        for x in 0..<numSides{
            let unadjustedAngleVal : Float = ((standardSeperatingAngle*Float(x))+totalSubtraction) * (Float.pi / 180)
            let xVal = cos(unadjustedAngleVal)*evenCosRation
            let zVal : Float = sin(unadjustedAngleVal)*evenSinRation
            let vec3Top = SCNVector3(x: xVal, y: topFaceYfloat, z: zVal)
            let hVecTop = H_Vertex(vector3Param: vec3Top, typeParam: .topFaceEdgeVertex, placeInSpecifiedCollectionParam: x+indexIdAddition)
            topFace_H_Vertices.append(hVecTop)
        }
    }
    else if numSides % 2 != 0 {
        let totalSubtraction = genSubtraction()
        let indexIdAddition = topFace_H_Vertices.count
        for x in 0..<numSides{
            let unadjustedAngleVal : Float = ((standardSeperatingAngle*Float(x))+totalSubtraction) * (Float.pi / 180)
            let xVal = cos(unadjustedAngleVal)
            let zVal : Float = sin(unadjustedAngleVal)
            let vec3Top = SCNVector3(x: xVal, y: topFaceYfloat, z: zVal)
            let hVecTop = H_Vertex(vector3Param: vec3Top, typeParam: .topFaceEdgeVertex, placeInSpecifiedCollectionParam: x+indexIdAddition)
            topFace_H_Vertices.append(hVecTop)
        }
    }
}
    
    func generateBottomFaceVertices(rotationIndex:Int){
        let standardSeperatingAngle : Float = 360/Float(numSides)
        let indexIdAddition = topFace_H_Vertices.count
        if numSides % 2 == 0 {
            let halfStandard = standardSeperatingAngle/2
            let totalSubtraction = genSubtraction()
            for x in 0..<numSides {
                let unadjustedAngleVal : Float = ((standardSeperatingAngle*Float(x))+totalSubtraction) * (Float.pi / 180)
                let xVal = cos(unadjustedAngleVal)
                let zVal : Float = sin(unadjustedAngleVal)
                let vec3Top = SCNVector3(x: xVal, y: bottomFaceYfloat, z: zVal)
                let hVecTop = H_Vertex(vector3Param: vec3Top, typeParam: .topFaceEdgeVertex, placeInSpecifiedCollectionParam: x+indexIdAddition)
                bottomFaceEdge_H_Vertices.append(hVecTop)
            }
        }
        else if numSides % 2 != 0 {
            let totalSubtraction = genSubtraction()
            let indexIdAddition = topFace_H_Vertices.count
            for x in 0..<numSides {
                let unadjustedAngleVal : Float = ((standardSeperatingAngle*Float(x))+totalSubtraction) * (Float.pi / 180)
                let xVal = cos(unadjustedAngleVal)
                let zVal : Float = sin(unadjustedAngleVal)
                let vec3Top = SCNVector3(x: xVal, y: bottomFaceYfloat, z: zVal)
                let hVecTop = H_Vertex(vector3Param: vec3Top, typeParam: .topFaceEdgeVertex, placeInSpecifiedCollectionParam: x+indexIdAddition)
                bottomFaceEdge_H_Vertices.append(hVecTop)
            }
        }
    }
    
    func generateTopFaceEdgeIndices(){
        for i in 1...numSides {
            if i < numSides {
                let triplet = [UInt16(i-i),UInt16(numSides-i+1),UInt16(numSides-i)]
                topFaceIndices.append(contentsOf: triplet)
            }
            else if i == numSides {
                let triplet = [UInt16(i-i),UInt16(numSides-i+1),UInt16(numSides)]
                topFaceIndices.append(contentsOf: triplet)
            }
        }
    }
    
    func generateBottomFaceEdgeIndices(){
        let startIndex = numSides+1
        for i in 1...numSides {
            if i < numSides {
                bottomFaceIndices.append(contentsOf: [UInt16(startIndex),UInt16(startIndex+i),UInt16(startIndex+i+1)])
            }
            else if i == numSides {
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


class Modifier{
    
    var modificationFloats = [Float]()
    
    func generateModificationArray(basePositionsArray:[H_Vertex]){
        
    }
    
    func applyModification(basePositionsArray:inout [H_Vertex],resultingVectorArray : inout [SCNVector3]){
        
    }
    
    func generate_Slant_Addition_Array_2(){
        
//        if modificationFloats.count > 0{modificationFloats.removeAll()}
//
//        let edgeSection = topFace_H_Vertices.filter{$0.type == .topFaceEdgeVertex}
//
//        var individual_Z_Floats = Set<Float>()
        
//        for i in 0..<edgeSection.count {
//            let zVal : Float = edgeSection[i].vector3.z
//            let multipliedZ = zVal*100
//            let intMultiplied = Int(multipliedZ)
//            let z_Centrigrade_Band = Float(intMultiplied)/100
//            individual_Z_Floats.insert(z_Centrigrade_Band)
//        }
        
        //sortedZFloats = individual_Z_Floats.sorted(by:{ $0 < $1 })
        
        
//        for edgeVertex in topFace_H_Vertices{
//            if edgeVertex.type == .topFaceEdgeVertex{
//                let zVal : Float = edgeVertex.vector3.z
//                let multipliedZ = zVal*100
//                let intMultiplied = Int(multipliedZ)
//                let z_Centi = Float(intMultiplied)/100
//                for j in 0..<sortedZFloats.count {
//                    if z_Centi == sortedZFloats[j] {
//                        edgeVertex.zCentigradeBand = j
//                        print("whhhhaaaaat.............")
//                    }
//                }
//            }
//        }
        
        
    }
}


class FrameShifter{
    func shiftArrayFrame(frameShift:Int,floatArray: inout [Float]){
        var returnArray = [Float]()
        if frameShift > 0{
            for i in floatArray.count-frameShift...floatArray.count-1{
                returnArray.append(floatArray[i])
             }
             for i in 0..<floatArray.count-frameShift{
                returnArray.append(floatArray[i])
             }
        }
        else if frameShift < 0{
            let startVal = floatArray[0]
            
            for i in 0..<floatArray.count{
                if i < floatArray.count-1{
                    returnArray.append(floatArray[i+1])
                }
                else if i == floatArray.count-1{
                    returnArray.append(startVal)
                }
            }
        }
        floatArray = returnArray
    }
}

//class ZBand:Identifiable,Hashable,Equatable {
//
//    var id = UUID()
//    var centigrade_Z_Index : Float
//
//    public static func == (lhs: ZBand, rhs: ZBand) -> Bool {
//        lhs.id == rhs.id
//    }
//
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//
//    init(centigradeParam:Float){
//        centigrade_Z_Index = centigradeParam
//    }
//
//}






//class FrameShiftArrayHolder {
//
//    var originalArray = [Float]()
//    var shiftedArray = [Float]()
//    var frameShift : Int = 0 {
//        didSet {
//            shiftArrayFrame()
//        }
//    }
//
//    func injectNewArray(originalArrayParam:[Float]){
//        if originalArray.count != 0{originalArray.removeAll()}
//        if shiftedArray.count != 0{shiftedArray.removeAll()}
//        originalArray = originalArrayParam
//        for i in 0..<originalArray.count{
//            shiftedArray.append(originalArray[i])
//        }
//    }
//
//    func shiftArrayFrame(){
//        if shiftedArray.count > 0{shiftedArray.removeAll()}
//        if frameShift > 0 {
//
//            //1: last one goes to the start
//            for i in originalArray.count-frameShift...originalArray.count-1{
//                shiftedArray.append(originalArray[i])
//            }
//            for i in 0..<originalArray.count-frameShift{
//                shiftedArray.append(originalArray[i])
//            }
//            //shiftedArray.append(originalArray[  originalArray.count-1])
//            //2: from 0 to last-1 gets tagged on after the new 0
////            for i in 0..<originalArray.count-1{
////                shiftedArray.append(originalArray[i])
////            }
//        }
//        else if frameShift < 0 {
//            print("less than hit")
////            for i in 0..<frameShift {
////                shiftedArray.append(originalArray[i])
////            }
////            for i in frameShift..<originalArray.count {
////                shiftedArray.append(originalArray[i])
////            }
//        }
////        else if frameShift == 0{
////            print("equal to hit")
////            for i in 0..<originalArray.count{
////                shiftedArray.append(originalArray[i])
////            }
////        }
//
//    }
//}


//for i in frameShift..<originalArray.count {
//shiftedArray.append(originalArray[i])
//}
//for i in 0..<frameShift {
//shiftedArray.append(originalArray[i])
//}
