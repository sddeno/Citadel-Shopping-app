//
//  CrashView.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 08/06/23.
//

import SwiftUI
import FirebaseCrashlytics

@MainActor
final class CrashManager {
    
    static var shared = CrashManager()
    private init(){}
    
    func setUserId(userId: String){
        Crashlytics.crashlytics().setUserID(userId)
    }
    
    func setValue(value:String, key: String){
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
    }
    
    func setIsPremiumValue(isPremium: Bool){
        setValue(value: isPremium.description.lowercased(), key: "user_is_premium")
    }
    
    func addLog(message: String){
        print(message)
    }
}

struct CrashView: View {
    var body: some View {
        ZStack{
            Color.gray.opacity(0.5).ignoresSafeArea()
            
            VStack(spacing: 40){
                Button("Click em 1 "){
                    CrashManager.shared.addLog(message: "button_1_clicked")
                    let myString: String? = nil
                    let string2 = myString!
                }
                
                Button("Click em 2 "){
                    CrashManager.shared.addLog(message: "button_2_clicked")
                    fatalError("This was a fatal crash.")
                }
                Button("Click me 3"){
                    CrashManager.shared.addLog(message: "button_3_clicked")
                    let array: [String] = []
                    let item = array[0]
                }
            }
        }
        .onAppear(){
            CrashManager.shared.setUserId(userId: "ABC123")
            CrashManager.shared.setValue(value: "TRUE", key: "user_is_premium")
            CrashManager.shared.addLog(message: "crash_view_appeared")
        }
    }
}

struct CrashView_Previews: PreviewProvider {
    static var previews: some View {
        CrashView()
    }
}
