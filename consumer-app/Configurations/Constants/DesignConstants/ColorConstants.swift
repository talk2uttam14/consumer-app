//
//  ColorConstants.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 29/10/25.
//
/*
Use enum Because:
Cannot be instantiated
Cannot be subclassed
Clearly acts as a namespace
Struct Allowed
even though you never intend to create an instance.
*/
import SwiftUI

public enum ColorConstants {
    
    public static let primary = Color("Primary")
    public static let secondary = Color("Secondary")
    
    public static let surfacePrimary = Color("SurfacePrimary")
    public static let surfaceSecondary = Color("SurfaceSecondary")
    
    public static let backgroundPrimary = Color("BackgroundPrimary")
    public static let backgroundSecondary = Color("BackgroundSecondary")

    public static let textPrimary = Color("TextPrimary")
    public static let textSecondary = Color("TextSecondary")

    public static let success = Color("Success")
    public static let warning = Color("Warning")
    public static let error = Color("Error")
    public static let info = Color("Info")
}
