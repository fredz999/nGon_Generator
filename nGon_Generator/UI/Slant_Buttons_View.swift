//
//  Slant_Buttons_View.swift
//  nGon_Generator
//
//  Created by Jon on 23/05/2023.
//

import Foundation
import SwiftUI

struct Slant_Buttons_View : View {
        var mainSceneStore : Main_3d_Scene_Store
        @ObservedObject var buildingStore : Building
        @ObservedObject var base_Section_Store : Building_Section
        @ObservedObject var roof_NGon_Generator : Ngon_Generator
        @ObservedObject var centralNGon_Store : CentrePointFace_Ngon
    var body: some View {
        HStack{
            ZStack {
                Rectangle().frame(width:90,height:30).foregroundColor(Color(red: 0, green: 0, blue: 0.6))
                Text("gen_Slant").foregroundColor(.white)
            }.onTapGesture {
                if let lclBaseSection = mainSceneStore.building_Collection.building_Array[0].baseSection {
                    if let lclCentrePointNgon = lclBaseSection.geometryGenerator.centrePointFace_Ngon {
                        lclCentrePointNgon.slope_Generator.generate_Slant_Addition_Array(topFace_H_Vertices: lclCentrePointNgon.topFace_H_Vertices)
                        lclCentrePointNgon.slope_Generator.generate_Slant_Addition_Array_2(topFace_H_Vertices: lclCentrePointNgon.topFace_H_Vertices)
                    }
                }
            }
            
            ZStack {
                Rectangle().frame(width:90,height:30).foregroundColor(Color(red: 0, green: 0, blue: 0.6))
                Text("blank_Slant").foregroundColor(.white)
            }.onTapGesture {
                if let lclBaseSection = mainSceneStore.building_Collection.building_Array[0].baseSection {
                    if let lclCentrePointNgon = lclBaseSection.geometryGenerator.centrePointFace_Ngon {
                        lclCentrePointNgon.slope_Generator.blank_Slant_Addition_Array()
                    }
                }
            }
        }
            
        HStack {
            ZStack {
                Rectangle().frame(width:90,height:30).foregroundColor(Color(red: 0, green: 0, blue: 0.6))
                Text("frame =>").foregroundColor(.white)
            }.onTapGesture {
                if let lclBaseSection = mainSceneStore.building_Collection.building_Array[0].baseSection {
                    if let lclCentrePointNgon = lclBaseSection.geometryGenerator.centrePointFace_Ngon {
                        if lclCentrePointNgon.slope_Generator.slantAdditionArray.count > 0 {
                            lclCentrePointNgon.slope_Generator.frameShift(toRight: true)
                        }
                    }
                }
            }
            
            ZStack {
                Rectangle().frame(width:90,height:30).foregroundColor(Color(red: 0, green: 0, blue: 0.6))
                Text("<= frame").foregroundColor(.white)
            }.onTapGesture {
                if let lclBaseSection = mainSceneStore.building_Collection.building_Array[0].baseSection {
                    if let lclCentrePointNgon = lclBaseSection.geometryGenerator.centrePointFace_Ngon {
                        if lclCentrePointNgon.slope_Generator.slantAdditionArray.count > 0 {
                            lclCentrePointNgon.slope_Generator.frameShift(toRight: false)
                        }
                    }
                }
            }
        }

        ZStack {
            Rectangle().frame(width:90,height:30).foregroundColor(Color(red: 0, green: 0, blue: 0.6))
            Text("apply").foregroundColor(.white)
        }.onTapGesture {
            if let lclBaseSection = mainSceneStore.building_Collection.building_Array[0].baseSection {
                if let lclCentrePointNgon = lclBaseSection.geometryGenerator.centrePointFace_Ngon {
                    lclCentrePointNgon.reGenerateGeometry()
                }
                lclBaseSection.update_Geometry()
            }
        }

    }
}
