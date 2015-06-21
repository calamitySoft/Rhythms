//
//  Metronome.swift
//  Rhythms
//
//  Created by Logan Moseley on 6/20/15.
//  Copyright (c) 2015 CalamitySoft. All rights reserved.
//

import Foundation

protocol MetronomeBeatListener {
    func beat()
}

class Metronome {
    var config: MetronomeConfiguration
    var paused = true
    var beatListeners = [MetronomeBeatListener]()
    
    init(config: MetronomeConfiguration) {
        self.config = config
    }
}
