//
//  Building_Collection.swift
//  nGon_Generator
//
//  Created by Jon on 15/05/2023.
//

import SwiftUI
import Foundation
import SceneKit
import UIKit

class Building_Collection:ObservableObject{
    @Published var building_Array = [Building]()
    func generateBuilding(x:Int,y:Int){
        let building = Building(xPos: x, yPos: y)
        building_Array.append(building)
    }
}
