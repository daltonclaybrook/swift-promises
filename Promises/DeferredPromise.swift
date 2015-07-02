//
//  DeferredPromise.swift
//  Promises
//
//  Created by Dalton Claybrook on 7/1/15.
//  Copyright © 2015 Claybrook Software, LLC. All rights reserved.
//

typealias DeferredPromiseBlock = AnyObject? -> Void

class DeferredPromise {
    
    private var finishBlock: DeferredPromiseBlock?
    private var errorBlock: CatchBlock?
    
    init() {}
    
    func resolve(obj: AnyObject?) {
        
        if let block = finishBlock {
            block(obj)
        }
    }
    
    func reject(obj: ErrorType) {
        
        if let block = errorBlock {
            block(obj)
        }
    }
    
    func waitAndExecute(block: DeferredPromiseBlock) {
        
        finishBlock = block
    }
    
    func waitAndFail(block: CatchBlock) {
        
        errorBlock = block
    }
}
