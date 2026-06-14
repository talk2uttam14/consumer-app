//
//  AppTypography.swift
//  consumer-app
//
//  Created by COMVIVA on 13/06/26.
//
import SwiftUI
import UIKit

// MARK: - Font Weights

public enum FontWeight {
    case thin
    case extraLight
    case light
    case regular
    case medium
    case semiBold
    case bold
}

// MARK: - Font Constants

public enum FontConstants {

    // MARK: - Font Name Resolver
    private static func name(for weight: FontWeight) -> String {
        switch weight {
        case .thin: return "Poppins-Thin"
        case .extraLight: return "Poppins-ExtraLight"
        case .light: return "Poppins-Light"
        case .regular: return "Poppins-Regular"
        case .medium: return "Poppins-Medium"
        case .semiBold: return "Poppins-SemiBold"
        case .bold: return "Poppins-Bold"
        }
    }

    // MARK: - Safe Font Builder
    private static func font(weight: FontWeight, size: CGFloat) -> Font {
        let fontName = name(for: weight)

        if UIFont(name: fontName, size: size) != nil {
            return Font.custom(fontName, size: size)
        } else {
            return Font.system(size: size)
        }
    }

    // MARK: - TYPOGRAPHY SCALE

    // 28
    public static func size28(_ weight: FontWeight = .bold) -> Font {
        font(weight: weight, size: 28)
    }

    // 26
    public static func size26(_ weight: FontWeight = .semiBold) -> Font {
        font(weight: weight, size: 26)
    }

    // 24
    public static func size24(_ weight: FontWeight = .semiBold) -> Font {
        font(weight: weight, size: 24)
    }

    // 22
    public static func size22(_ weight: FontWeight = .semiBold) -> Font {
        font(weight: weight, size: 22)
    }

    // 20
    public static func size20(_ weight: FontWeight = .medium) -> Font {
        font(weight: weight, size: 20)
    }

    // 18
    public static func size18(_ weight: FontWeight = .regular) -> Font {
        font(weight: weight, size: 18)
    }

    // 16 (body base)
    public static func size16(_ weight: FontWeight = .regular) -> Font {
        font(weight: weight, size: 16)
    }

    // 14
    public static func size14(_ weight: FontWeight = .regular) -> Font {
        font(weight: weight, size: 14)
    }

    // 12
    public static func size12(_ weight: FontWeight = .light) -> Font {
        font(weight: weight, size: 12)
    }
}
