//
//  Promise.swift
//  Promises
//
//  Created by Dalton Claybrook on 7/1/15.
//  Copyright © 2015 Claybrook Software, LLC. All rights reserved.
//

typealias PromiseBlock = AnyObject? throws -> AnyObject?
typealias DoneBlock = Void -> Void
typealias CatchBlock = ErrorType -> Void

func ==(lhs: Promise, rhs: Promise) -> Bool {
    return (ObjectIdentifier(lhs) == ObjectIdentifier(rhs))
}

enum PromiseError: ErrorType {
    case Error
}

class Promise : Hashable, Equatable {
    
    var hashValue: Int {
        get {
            return ObjectIdentifier(self).hashValue
        }
    }
    
    init(block: PromiseBlock) {
        then(block)
    }
    
    func then(block: PromiseBlock) -> Self {
        PromiseManager.sharedManager.chainBlock(block, forPromise: self)
        return self
    }
    
    func catchError(block: CatchBlock) -> Self {
        PromiseManager.sharedManager.attachErrorBlock(block, forPromise: self)
        return self
    }
    
    func done(block: DoneBlock?) {
        PromiseManager.sharedManager.executeChainForPromise(self, withDoneBlock: block)
    }
}
