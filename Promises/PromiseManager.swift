//
//  PromiseManager.swift
//  Promises
//
//  Created by Dalton Claybrook on 7/1/15.
//  Copyright © 2015 Claybrook Software, LLC. All rights reserved.
//

import UIKit

class PromiseManager {
    
    static let sharedManager = PromiseManager()
    private var blockChains = [Promise:Array<PromiseBlock>]()
    private var errorBlocks = [Promise:CatchBlock]()
    private var doneBlocks = [Promise:DoneBlock]()
    
    func chainBlock(block: PromiseBlock, forPromise promise: Promise) {
        
        var chain: [PromiseBlock]! = blockChains[promise]
        if (chain == nil) {
            chain = [PromiseBlock]()
        }
        chain.append(block)
        blockChains[promise] = chain
    }
    
    func attachErrorBlock(block: CatchBlock, forPromise promise: Promise) {
        
        errorBlocks[promise] = block
    }
    
    func executeChainForPromise(promise: Promise, withDoneBlock block: DoneBlock?) {
        
        guard let chain = blockChains[promise] else {
            assertionFailure("no blocks have been registered")
            return
        }
        
        if let block = block {
            doneBlocks[promise] = block
        }
        
        blockChains.removeValueForKey(promise)
        executeChain(chain, forPromise: promise, blockParam: nil)
    }
    
    private func executeChain(var chain: [PromiseBlock], forPromise promise: Promise, blockParam: AnyObject?) {
        
        var lastObj: AnyObject? = blockParam
        var finished = true
        
        while (chain.count > 0) {
            let block = chain.removeAtIndex(0)
            
            // execute synchronous blocks
            do {
                try lastObj = block(lastObj)
            } catch let err {
                self.executeError(err, forPromise: promise)
                finished = false
                break
            }
            
            // execute wait for deffered blocks if necessary
            if let deferred = lastObj as? DeferredPromise {
                
                deferred.waitAndExecute { obj in
                    self.executeChain(chain, forPromise: promise, blockParam: obj)
                }
                
                deferred.waitAndFail { err in
                    self.executeError(err, forPromise: promise)
                }
                finished = false
                break
            }
        }
        
        if finished {
            executeDoneBlockIfNecessaryForPromise(promise)
        }
    }
    
    private func executeError(error: ErrorType, forPromise promise: Promise) {
        
        if let block = errorBlocks[promise] {
            block(error)
        }
        executeDoneBlockIfNecessaryForPromise(promise)
    }
    
    private func executeDoneBlockIfNecessaryForPromise(promise: Promise) {
        
        if let block = doneBlocks[promise] {
            block()
        }
    }
}
