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
    
    /// KVO these (or whatever Swift does?)
    var isActionAllowed: Bool
    var beatRelationship: MetronomeBeatRelationship
    
    /// A display link that calls method `update:` on every screen refresh.
    private lazy var displayLink: CADisplayLink = CADisplayLink(target: self, selector: "update:")
    private var elapsedTime: CFTimeInterval = 0
    private var startTime: CFTimeInterval = 0
    private var lastFireTime: CFTimeInterval = 0
    private var secondsPerBeat: CFTimeInterval
    
    init(config: MetronomeConfiguration) {
        self.config = config
        self.secondsPerBeat = 60.0 / Double(config.bpm)
        self.isActionAllowed = false
        self.beatRelationship = MetronomeBeatRelationship.Off
    }
    
    // MARK: - Tick-tock
    func start() {
        self.displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
    }
    
    func stop() {
        self.displayLink.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    }
    
    @objc func update(displayLink: CADisplayLink) {
        let elapsedSinceLastTick = displayLink.duration * CFTimeInterval(displayLink.frameInterval)
        self.elapsedTime += elapsedSinceLastTick
        
        let beatRelationship = beatRelationshipWithElapsedTime(self.elapsedTime)
        if self.beatRelationship != beatRelationship {
            self.beatRelationship = beatRelationship
        }
        
        let isActionAllowed = isActionAllowedWithBeatRelationship(beatRelationship)
        if self.isActionAllowed != isActionAllowed {
            self.isActionAllowed = isActionAllowed
        }
        
        let priorBeatTime = beatTimePriorToElapsedTime(self.elapsedTime)
        let shouldBeat = priorBeatTime != self.lastFireTime
        if shouldBeat {
            tick(displayLink)
            self.lastFireTime = priorBeatTime
            for listener in self.beatListeners {
                listener.beat()
            }
        }
    }
    
    /// up-beat
    private func tick(displayLink: CADisplayLink) {
        print("tick \(displayLink.timestamp)")
    }
    
    // MAKR: Calculate beat
    private func beatRelationshipWithElapsedTime(elapsedTime: CFTimeInterval) -> MetronomeBeatRelationship {
        let priorBeatTime       = beatTimePriorToElapsedTime(elapsedTime)
        let subsequentBeatTime  = beatTimeSubsequentToElapsedTime(elapsedTime)
        let trailingDiff        = elapsedTime - priorBeatTime
        let leadingDiff         = subsequentBeatTime - elapsedTime
        
        let isPreciselyOnBeat    = trailingDiff == 0 || leadingDiff == 0
        let trailsWithinLeniency = trailingDiff >= 0 && trailingDiff < self.config.trailingLeniency
        let leadsWithinLeniency  = leadingDiff >= 0 && leadingDiff < self.config.leadingLeniency
        
        if isPreciselyOnBeat {
            return .On
        } else if leadsWithinLeniency {
            return .Leading
        } else if trailsWithinLeniency {
            return . Trailing
        } else {
            return .Off
        }
    }
    
    private func beatTimePriorToElapsedTime(elapsedTime: CFTimeInterval) -> CFTimeInterval {
        return (floor(elapsedTime / self.secondsPerBeat)) * self.secondsPerBeat
    }
    
    private func beatTimeSubsequentToElapsedTime(elapsedTime: CFTimeInterval) -> CFTimeInterval {
        return (ceil(elapsedTime / self.secondsPerBeat)) * self.secondsPerBeat
    }
    
    private func isActionAllowedWithElapsedTime(elapsedTime: CFTimeInterval) -> Bool {
        let beatRelationship = beatRelationshipWithElapsedTime(elapsedTime)
        return isActionAllowedWithBeatRelationship(beatRelationship)
    }
    
    private func isActionAllowedWithBeatRelationship(beatRelationship: MetronomeBeatRelationship) -> Bool {
        switch beatRelationship {
        case .Leading, .On, .Trailing:
            return true
        case .Off:
            return false
        }
    }
}
