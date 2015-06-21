//
//  Metronome.swift
//  Rhythms
//
//  Created by Logan Moseley on 6/20/15.
//  Copyright (c) 2015 CalamitySoft. All rights reserved.
//

import Foundation
import QuartzCore

protocol MetronomeBeatListener {
    func beat()
}

class Metronome {
    var config: MetronomeConfiguration
    var paused = true
    var beatListeners = [MetronomeBeatListener]()
    
    /// A display link that keeps calling the `updateFrame` method on every screen refresh.
    private lazy var displayLink: CADisplayLink = CADisplayLink(target: self, selector: "tick:")
    
    
    init(config: MetronomeConfiguration) {
        self.config = config
    }
    
    // MARK: - Tick-tock
    func start() {
        self.displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        self.displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
    }
    
    func stop() {
        self.displayLink.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    }
    
    @objc func tick(displayLink: CADisplayLink) {
        print(displayLink.timestamp)
    }
}
