//
//  AppDimensions.swift
//  nGon_Generator
//
//  Created by Jon on 15/05/2023.
//

import SwiftUI
import Foundation
import SceneKit
import UIKit

class AppDimensions {
    let main3dSceneWidth : CGFloat = 350
    let main3dSceneHeight : CGFloat = 350
    let main3dSceneOffset : CGSize = CGSize(width: 10, height: 20)
    let camTargetPoint = SCNVector3(x: 0, y: 0, z: 0)
    
    let maxNgonSides : Int = 20
    let minNgonSides : Int = 3
    
    let defaultBaseInitial_Y_Float : Float = 0.0
    let defaultBaseInitial_Min_Floors : Int = 1
    let defaultBaseInitial_Max_Floors : Int = 10
    let defaultBaseInitial_Start_Floors : Int = 5
    
    let initialSectionSides = 5
    
    func returnInitialSectionVals(designation:E_Building_Section_Type)->Initial_Section_Info{
        //default to base
        let retVal = Initial_Section_Info(initial_Y_Float: defaultBaseInitial_Y_Float, min_Floors: defaultBaseInitial_Min_Floors, max_Floors: defaultBaseInitial_Max_Floors, start_Floors: defaultBaseInitial_Start_Floors)
        if designation == .midSection{
            
        }
        else if designation == .roofSection{
            
        }
        return retVal
    }
    
    static let StaticAppDimensions = AppDimensions()
}

class Initial_Section_Info{
    var initial_Y_Float : Float
    var min_Floors : Int
    var max_Floors : Int
    var start_Floors : Int
    init(initial_Y_Float: Float, min_Floors: Int, max_Floors: Int, start_Floors: Int) {
        self.initial_Y_Float = initial_Y_Float
        self.min_Floors = min_Floors
        self.max_Floors = max_Floors
        self.start_Floors = start_Floors
    }
}
