//
//  UIViewPreiew.swift
//  UIkit_Tutorial
//
//  Created by 이민호 on 2023/11/10.
//

import UIKit

enum DeviceType {
    case iPhoneSE2
    case iPhone8
    case iPhone15Pro
    case iPhone15ProMax
    case iPad

    func name() -> String {
        switch self {
        case .iPhoneSE2:
            return "iPhone SE"
        case .iPhone8:
            return "iPhone 8"
        case .iPhone15Pro:
            return "iPhone 15 Pro"
        case .iPhone15ProMax:
            return "iPhone 15 Pro Max"
        case .iPad:
            return "iPad (10th generation)"
        }
        
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
extension UIViewController {

    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }

    func showPreview(_ deviceType: DeviceType = .iPhone15ProMax) -> some View {
        Preview(viewController: self).previewDevice(PreviewDevice(rawValue: deviceType.name()))
    }
}
#endif
