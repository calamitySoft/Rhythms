//
//  MetronomeConfiguration.swift
//  Rhythms
//
//  Created by Logan Moseley on 6/20/15.
//  Copyright (c) 2015 CalamitySoft. All rights reserved.
//

import Foundation

struct MetronomeConfiguration {
    let bpm: Int
    let leadingLeniency: NSTimeInterval
    let trailingLeniency: NSTimeInterval
    
    init(bpm: Int, leadingLeniency: NSTimeInterval = 0.2, trailingLeniency: NSTimeInterval = 0.2) {
        self.bpm = bpm
        self.leadingLeniency = leadingLeniency
        self.trailingLeniency = trailingLeniency
    }
}
