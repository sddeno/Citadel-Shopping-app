//
//  RazorPay.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 28/12/23.
//

import Foundation
import UIKit
import Razorpay

class RazorViewController: UIViewController {
    
    private var razorpay:RazorpayCheckout?
    var razorKey = "rzp_test_uHqob8OJkDcfWA"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        razorpay = RazorpayCheckout.initWithKey(razorKey, andDelegateWithData: self)
        let options: [String:Any] = [
            "key": "rzp_test_uHqob8OJkDcfWA",
            //            "order_id": "order_DBJOWzybfXXXX",
            //            "customer_id": "cust_BtQNqzmBlXXXX",
            "prefill": [
                "contact": "+918989734106",
                "email": "shubhamdeshmukh69@gmail.com"
            ],
            "image": "https://spaceplace.nasa.gov/templates/featured/sun/sunburn300.png",
            "amount": 10000,  // Amount should match the order amount
            "currency": "INR"
        ]
        
        if let rzp = self.razorpay {
            rzp.open(options)
        }else{
            print("Unable to show razorpay ::::::::::::")
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//
//        let options: [String:Any] = [
//            "key": "rzp_test_uHqob8OJkDcfWA",
//            //            "order_id": "order_DBJOWzybfXXXX",
//            //            "customer_id": "cust_BtQNqzmBlXXXX",
//            "prefill": [
//                "contact": "+918989734106",
//                "email": "shubhamdeshmukh69@gmail.com"
//            ],
//            "image": "https://spaceplace.nasa.gov/templates/featured/sun/sunburn300.png",
//            "amount": 10000,  // Amount should match the order amount
//            "currency": "INR"
//        ]
//
//        if let rzp = self.razorpay {
//            rzp.open(options)
//        }else{
//            print("Unable to show razorpay ::::::::::::")
//        }
//    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
}

extension RazorViewController: RazorpayPaymentCompletionProtocolWithData {
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
//        let alert = UIAlertController(title: "Paid", message: "Payment Success", preferredStyle: .alert)
//        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
        print("payment done with payment_id \(payment_id)")
    }
    
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
//        let alert = UIAlertController(title: "Error", message: "\(code)\n\(str)", preferredStyle: .alert)
//        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
        
        print("payment Failed with payment_id \(code) \(str)")
    }
}

