//
//  Buildling.swift
//  nGon_Generator
//
//  Created by Jon on 15/05/2023.
//

import SwiftUI
import Foundation
import SceneKit
import UIKit

class Building : ObservableObject,Identifiable, Equatable, Hashable {
    var id = UUID()
    public static func == (lhs: Building, rhs: Building) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    var xGridPosition : Int
    var yGridPosition : Int
    var baseSection : Building_Section?
    var baseSectionNode : SCNNode?
    var buildingNode = SCNNode()
    
    var roof_NGon_Generator : Ngon_Generator?

    init(xPos:Int,yPos:Int){
        xGridPosition = xPos
        yGridPosition = yPos
        generateSections()
    }
    
    func generateSections(){
        baseSection = Building_Section(buildingParam: self, designationParam: .baseSection)
        if let lclBaseSection = baseSection{
            roof_NGon_Generator = lclBaseSection.geometryGenerator
            buildingNode.addChildNode(lclBaseSection.externally_Visible_Node)
        }
    }
    
}
