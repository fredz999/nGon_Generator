//
//  ContentView.swift
//  nGon_Generator
//
//  Created by Jon on 15/05/2023.
//

import SwiftUI

struct ContentView: View {
    let dimensions = AppDimensions.StaticAppDimensions
    var mainSceneStore = Main_3d_Scene_Store()
//    @State var rotationIndex : Int = 0
//    @State var currentSides : Int = 0
    var body: some View {
        return ZStack(alignment: .topLeading){
            Rectangle().foregroundColor(Color(red: 0.4, green: 0.4, blue: 0))
            VStack(alignment: .center) {
                Main_3d_Scene_View(main_3d_Scene_Store: mainSceneStore)
                .frame(width: dimensions.main3dSceneWidth , height: dimensions.main3dSceneHeight)
                .offset(dimensions.main3dSceneOffset)
                VStack(alignment: .leading) {
                    HStack{
                        
                        ZStack{
                            Rectangle().frame(width:50,height:30).foregroundColor(Color(red: 0.6, green: 0, blue: 0))
                            Text("r_bck").foregroundColor(.white)
                        }.onTapGesture {
                            if let lclBaseSection = mainSceneStore.building_Collection.building_Array[0].baseSection{
                                lclBaseSection.roll_Forward_Backward(isNegative: false)
                            }
                        }
                        
                        ZStack{
                            Rectangle().frame(width:50,height:30).foregroundColor(Color(red: 0, green: 0.6, blue: 0))
                            Text("r_fwd").foregroundColor(.white)
                        }.onTapGesture {
                            if let lclBaseSection = mainSceneStore.building_Collection.building_Array[0].baseSection{
                                lclBaseSection.roll_Forward_Backward(isNegative: true)
                            }
                        }
                        
                        ZStack{
                            Rectangle().frame(width:50,height:30).foregroundColor(Color(red: 0, green: 0.6, blue: 0.6))
                            Text("+sides").foregroundColor(.white)
                        }.onTapGesture {
                            if let lclBaseSection = mainSceneStore.building_Collection.building_Array[0].baseSection {
                                if let lclCentrePointNgon = lclBaseSection.geometryGenerator.centrePointFace_Ngon {
                                    if lclCentrePointNgon.numSides + 1 <= 12{
                                        lclCentrePointNgon.numSides += 1
                                    }
                                }
                                lclBaseSection.update_Geometry()
                            }
                        }

                        ZStack{
                            Rectangle().frame(width:50,height:30).foregroundColor(Color(red: 0, green: 0.6, blue: 0.6))
                            Text("-sides").foregroundColor(.white)
                        }.onTapGesture {
                            if let lclBaseSection = mainSceneStore.building_Collection.building_Array[0].baseSection {
                                if let lclCentrePointNgon = lclBaseSection.geometryGenerator.centrePointFace_Ngon {
                                    if lclCentrePointNgon.numSides - 1 >= 3{
                                        lclCentrePointNgon.numSides -= 1
                                    }
                                }
                                lclBaseSection.update_Geometry()
                            }
                        }
                    }
                    
                    if let lclBase = mainSceneStore.building_Collection.building_Array[0].baseSection {
                        if let lclRoofNgonGenerator = mainSceneStore.building_Collection.building_Array[0].roof_NGon_Generator {
                            if let centrFaceNgon = lclRoofNgonGenerator.centrePointFace_Ngon {
                                Slant_Buttons_View(mainSceneStore: mainSceneStore
                                , buildingStore: mainSceneStore.building_Collection.building_Array[0]
                                , base_Section_Store: lclBase
                                , roof_NGon_Generator: lclRoofNgonGenerator, centralNGon_Store: centrFaceNgon)
                            }
                        }
                    }
                    
                    if let lclBase = mainSceneStore.building_Collection.building_Array[0].baseSection {
                        if let lclRoofNgonGenerator = mainSceneStore.building_Collection.building_Array[0].roof_NGon_Generator {
                            if let centrFaceNgon = lclRoofNgonGenerator.centrePointFace_Ngon {
                                Orientation_Buttons(mainSceneStore: mainSceneStore, centralNGon_Store: centrFaceNgon)
                            }
                        }
                    }
                    
                    

                }
            }
        }
    }
}





//                        ZStack{
//                            Rectangle().frame(width:50,height:30).foregroundColor(Color(red: 0, green: 0, blue: 0.6))
//                            Text("+R").foregroundColor(.white)
//                        }.onTapGesture {
//                            if let lclBaseSection = mainSceneStore.building_Collection.building_Array[0].baseSection {
//                                if let lclCentrePointNgon = lclBaseSection.geometryGenerator.centrePointFace_Ngon {
//                                    if lclCentrePointNgon.rotationIndex+1 <= lclCentrePointNgon.numSides{
//                                        lclCentrePointNgon.rotationIndex+=1
//                                    }
//                                }
//                                lclBaseSection.update_Geometry()
//                            }
//                        }
//
//                        ZStack{
//                            Rectangle().frame(width:50,height:30).foregroundColor(Color(red: 0, green: 0, blue: 0.6))
//                            Text("-R").foregroundColor(.white)
//                        }.onTapGesture {
//                            if let lclBaseSection = mainSceneStore.building_Collection.building_Array[0].baseSection {
//                                if let lclCentrePointNgon = lclBaseSection.geometryGenerator.centrePointFace_Ngon {
//                                    if lclCentrePointNgon.rotationIndex-1 >= 0{
//                                        lclCentrePointNgon.rotationIndex-=1
//                                    }
//                                }
//                                lclBaseSection.update_Geometry()
//                            }
//                        }
