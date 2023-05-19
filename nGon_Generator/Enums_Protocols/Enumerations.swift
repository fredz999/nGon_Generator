//
//  Enumerations.swift
//  nGon_Generator
//
//  Created by Jon on 15/05/2023.
//

import Foundation

enum E_Building_Section_Type{
    case baseSection
    case midSection
    case roofSection
}

enum E_H_Vertex_Type {
    case topFaceVertex
    case topFaceEdgeVertex
    case bottomFaceVertex
    case bottomFaceEdgeVertex
}

enum E_NGon_Slant_Type : String {
    case roof_PointDown = "PointDown"
    case roof_PointUp = "PointUp"
    case roof_TwoVUpTwoVDown = "2Up2Down"
    case roof_Flat = "Flat"
}

enum E_Section_Type {
    case roof_Section
    case mid_Section
    case base_Section
}
