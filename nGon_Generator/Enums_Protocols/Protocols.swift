//
//  Protocols.swift
//  nGon_Generator
//
//  Created by Jon on 18/05/2023.
//

import Foundation
import SwiftUI
import Foundation
import SceneKit
import UIKit

protocol P_Geometry_Gen{
    func initalise_Geometry_From_Centrepoint_Ngon() -> SCNGeometry
}



protocol P_Configurable_Roof{
    var roofSlantSetting : E_NGon_Slant_Type{get set}
}
