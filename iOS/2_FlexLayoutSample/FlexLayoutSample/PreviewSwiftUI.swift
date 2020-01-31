//
//  PreviewSwiftUI.swift
//  FlexLayoutSample
//
//  Created by lian on 2020/01/31.
//  Copyright © 2020 lian. All rights reserved.
//

#if canImport(SwiftUI) && DEBUG

// From. https://nshipster.co.kr/swiftui-previews/
import SwiftUI

// From. https://developer.apple.com/documentation/swiftui/securefield/3289399-previewdevice
let deviceNames: [String] = [
    "iPhone SE",
    "iPhone 8",
    "iPhone Xs",
    "iPhone Xs Max",
]

// Dark Mode
// From. https://www.hackingwithswift.com/quick-start/swiftui/how-to-preview-your-layout-in-light-and-dark-mode

struct PreviewSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        ForEach (deviceNames, id: \.self) { deviceName in
            UIViewPreview {
                let testView = TestView()
                testView.backgroundColor = UIColor.black
                return testView
            }
            .environment(\.colorScheme, .dark)
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
        }
    }
}
#endif
