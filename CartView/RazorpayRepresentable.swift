//
//  RazorpayRepresentable.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 29/12/23.
//

import Foundation
import SwiftUI

struct RazorpayViewRepresentable : UIViewControllerRepresentable {

    @State var razorKey : String

    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = RazorViewController()
        controller.razorKey = self.razorKey
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
