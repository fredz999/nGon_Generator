//
//  Orientation_Buttons.swift
//  nGon_Generator
//
//  Created by Jon on 24/05/2023.
//

import Foundation
import SwiftUI

struct Orientation_Buttons : View {
    @ObservedObject var mainSceneStore : Main_3d_Scene_Store
    @ObservedObject var centralNGon_Store : CentrePointFace_Ngon
    var activeColor = Color(red: 0, green: 0.6, blue: 0)
    var inActiveColor = Color(red: 0.6, green: 0, blue: 0)
    
    var body: some View{
        return HStack{
            ZStack{
                Rectangle().frame(width:50,height:30).foregroundColor(centralNGon_Store.orientation == .north ? activeColor : inActiveColor)
                Text("P_North").foregroundColor(.white)
            }.onTapGesture {
                if let lclBaseSection = mainSceneStore.building_Collection.building_Array[0].baseSection {
                    if let lclCentrePointNgon = lclBaseSection.geometryGenerator.centrePointFace_Ngon {
                        lclCentrePointNgon.flipOrientation(newOrientation: .north)
                        lclCentrePointNgon.reGenerateGeometry()
                    }
                    lclBaseSection.update_Geometry()
                }
            }

            ZStack{
                Rectangle().frame(width:50,height:30).foregroundColor(centralNGon_Store.orientation == .south ? activeColor : inActiveColor)
                Text("P_South").foregroundColor(.white)
            }.onTapGesture {
                if let lclBaseSection = mainSceneStore.building_Collection.building_Array[0].baseSection {
                    if let lclCentrePointNgon = lclBaseSection.geometryGenerator.centrePointFace_Ngon {
                        lclCentrePointNgon.flipOrientation(newOrientation: .south)
                        lclCentrePointNgon.reGenerateGeometry()
                    }
                    lclBaseSection.update_Geometry()
                }
            }
            
            ZStack{
                Rectangle().frame(width:50,height:30).foregroundColor(centralNGon_Store.orientation == .east ? activeColor : inActiveColor)
                Text("P_East").foregroundColor(.white)
            }.onTapGesture {
                if let lclBaseSection = mainSceneStore.building_Collection.building_Array[0].baseSection {
                    if let lclCentrePointNgon = lclBaseSection.geometryGenerator.centrePointFace_Ngon {
                        lclCentrePointNgon.flipOrientation(newOrientation: .east)
                        lclCentrePointNgon.reGenerateGeometry()
                    }
                    lclBaseSection.update_Geometry()
                }
            }
            
        }
    }
}
