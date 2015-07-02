//
//  ViewController.swift
//  Promises
//
//  Created by Dalton Claybrook on 7/1/15.
//  Copyright © 2015 Claybrook Software, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Promise { _ in
            
            print("1")
//            throw PromiseError.Error
            return nil
        }.then { obj in
            
            print("2")
            
            let promise = DeferredPromise()
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW as dispatch_time_t, Int64(5.0) * Int64(NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                
                promise.resolve("fart")
//                promise.reject(PromiseError.Error)
            })
            
            return promise
        }.then { obj in
            
            print("3")
            return nil
        }.catchError { err in
            
            print("error")
        }.done {
            
            print("done")
        }
    }
}

