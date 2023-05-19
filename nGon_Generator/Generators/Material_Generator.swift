//
//  Material_Generator.swift
//  nGon_Generator
//
//  Created by Jon on 15/05/2023.
//

import SwiftUI
import Foundation
import SceneKit
import UIKit

class Material_Generator : ObservableObject {
    func generateMaterial()->SCNMaterial{
        let nodeMaterial = SCNMaterial()
        nodeMaterial.diffuse.contents = UIColor(red: 0, green: 0.7, blue: 0.7, alpha: 1)
        return nodeMaterial
    }
}


//class Ngon_Generator : ObservableObject {
//    var centrePointedFace = CentrePointedFace()
//    func makeCustomGeometry()->SCNGeometry {
//        let vertexArray = centrePointedFace.faceVertexArray
//        let indices : [UInt16] = centrePointedFace.indexArray
//        let geometrySource = SCNGeometrySource(vertices: vertexArray)
//        let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)
//        let geometry = SCNGeometry(sources: [geometrySource], elements: [element])
//        return geometry
//    }
//
//}
