//
//  Call.swift
//  HSN
//
//  Created by Prashant Panchal on 08/02/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import Foundation

enum CallState {
    case connecting
    case active
    case held
    case ended
}

enum ConnectedState {
    case pending
    case complete
}

class Call {
    
    let uuid: UUID
    let outgoing: Bool
    let handle: String
    
    var state: CallState = .ended {
        didSet {
            stateChanged?()
        }
    }
    
    var connectedState: ConnectedState = .pending {
        didSet {
            connectedStateChanged?()
        }
    }
    
    var stateChanged: (() -> Void)?
    var connectedStateChanged: (() -> Void)?
    
    init(uuid: UUID, outgoing: Bool = false, handle: String) {
        self.uuid = uuid
        self.outgoing = outgoing
        self.handle = handle
    }
    
    func start(completion: ((_ success: Bool) -> Void)?) {
        completion?(true)
        
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 3) {
            self.state = .connecting
            self.connectedState = .pending
            
            DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 1.5) {
                self.state = .active
                self.connectedState = .complete
            }
        }
    }
    
    func answer() {
        state = .active
    }
    
    func end() {
        state = .ended
    }
    
}
