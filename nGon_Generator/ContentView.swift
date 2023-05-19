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
    @State var rotationIndex : Int = 0
    @State var currentSides : Int = 0
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
                                lclBaseSection.rot_Forward_Backward(isNegative: false)
                            }
                        }
                        ZStack{
                            Rectangle().frame(width:50,height:30).foregroundColor(Color(red: 0, green: 0.6, blue: 0))
                            Text("r_fwd").foregroundColor(.white)
                        }.onTapGesture {
                            if let lclBaseSection = mainSceneStore.building_Collection.building_Array[0].baseSection{
                                lclBaseSection.rot_Forward_Backward(isNegative: true)
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
                                    //lclCentrePointNgon.numSides -= 1
                                    if lclCentrePointNgon.numSides - 1 >= 3{
                                        lclCentrePointNgon.numSides -= 1
                                    }
                                }
                                lclBaseSection.update_Geometry()
                            }
                        }
                        
                        
                        ZStack{
                            Rectangle().frame(width:50,height:30).foregroundColor(Color(red: 0, green: 0, blue: 0.6))
                            Text("+R").foregroundColor(.white)
                        }.onTapGesture {
                            if let lclBaseSection = mainSceneStore.building_Collection.building_Array[0].baseSection {
                                if let lclCentrePointNgon = lclBaseSection.geometryGenerator.centrePointFace_Ngon {
                                    if lclCentrePointNgon.rotationIndex+1 <= lclCentrePointNgon.numSides{
                                        lclCentrePointNgon.rotationIndex+=1
                                    }
                                }
                                lclBaseSection.update_Geometry()
                            }
                        }
                        
                        ZStack{
                            Rectangle().frame(width:50,height:30).foregroundColor(Color(red: 0, green: 0, blue: 0.6))
                            Text("-R").foregroundColor(.white)
                        }.onTapGesture {
                            if let lclBaseSection = mainSceneStore.building_Collection.building_Array[0].baseSection {
                                if let lclCentrePointNgon = lclBaseSection.geometryGenerator.centrePointFace_Ngon {
                                    if lclCentrePointNgon.rotationIndex-1 >= 0{
                                        lclCentrePointNgon.rotationIndex-=1
                                    }
                                }
                                lclBaseSection.update_Geometry()
                            }
                        }
                        

                    }
                    
                    //if buildingStore.baseSection?.currentSides % 2 == 0{}
//                    if let lclBase = mainSceneStore.building_Collection.building_Array[0].baseSection {
//                        if let lclRoofNgonGenerator = mainSceneStore.building_Collection.building_Array[0].roof_NGon_Generator {
//                            Slant_Buttons(buildingStore: mainSceneStore.building_Collection.building_Array[0], base_Section_Store: lclBase, roof_NGon_Generator: lclRoofNgonGenerator)
//                        }
//                    }
                }
            }
        }
    }
}

//struct Slant_Buttons : View {
//    @ObservedObject var buildingStore : Building
//    @ObservedObject var base_Section_Store : Building_Section
//    @ObservedObject var roof_NGon_Generator : Ngon_Generator
//    var body: some View {
//        return HStack{
////            if base_Section_Store.currentSides % 2 == 0{
////                ZStack{
////                    Rectangle().frame(width:90,height:30).foregroundColor(Color(red: 0.6, green: 0, blue: 0))
////                    Text("2Up2Down").foregroundColor(.white)
////                }.onTapGesture {
////
////                }
////            }
//            else if base_Section_Store.currentSides % 2 != 0{
////                ZStack{
////                    Rectangle().frame(width:90,height:30).foregroundColor(Color(red: 0.6, green: 0, blue: 0))
////                    Text("pointUp").foregroundColor(.white)
////                }.onTapGesture {
////                    roof_NGon_Generator.roofSlantSetting = .roof_PointUp
////                    //roof_NGon_Generator.gen_Geometry_From_Centrepoint_Ngon(sides: baseSec.currentSides, topPoint_Y: 0.5, bottomPoint_Y: -0.5, rotationIndex: baseSec.rotationIndex)
////                }
//                ZStack{
//                    Rectangle().frame(width:90,height:30).foregroundColor(Color(red: 0.6, green: 0, blue: 0))
//                    Text("pointDown").foregroundColor(.white)
//                }.onTapGesture {
//
//                    //roof_NGon_Generator.roofSlantSetting = .roof_PointDown
//                    if let lclCentrePointNgon = roof_NGon_Generator.centrePointFace_Ngon {
//                        lclCentrePointNgon.roofSlantType = .roof_PointDown
//                    }
//                    base_Section_Store.updateGeometry()
//                    //baseSec.inter
//                }
//            }
////            ZStack{
////                Rectangle().frame(width:90,height:30).foregroundColor(Color(red: 0.6, green: 0, blue: 0))
////                Text("flat").foregroundColor(.white)
////            }.onTapGesture {
////                roof_NGon_Generator.roofSlantSetting = .roof_Flat
////                //roof_NGon_Generator.gen_Geometry_From_Centrepoint_Ngon(sides: baseSec.currentSides, topPoint_Y: 0.5, bottomPoint_Y: -0.5, rotationIndex: baseSec.rotationIndex)
////            }
////
////            Text(roof_NGon_Generator.roofSlantSetting.rawValue).foregroundColor(.white)
//
//
//        }
//    }
//}
