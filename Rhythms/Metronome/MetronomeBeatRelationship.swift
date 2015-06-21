//
//  MetronomeBeatRelationship.swift
//  Rhythms
//
//  Created by Logan Moseley on 6/19/15.
//  Copyright (c) 2015 CalamitySoft. All rights reserved.
//

// Probably not actually a good idea to work with an enum in a manner not
// dependent on `switch`, but I'm trying it out.
enum MetronomeBeatRelationship {
    case Leading, On, Trailing, Off
    
    func string() -> String? {
        return MetronomeBeatRelationship.stringValues[self]
    }
    
    func actionAllowed() -> Bool {
        if let allowed = MetronomeBeatRelationship.actionAllowedValues[self] {
            return allowed
        } else {
            return false
        }
    }
    
    private static let stringValues = [
        Leading: "leading",
        On: "on",
        Trailing: "trailing",
        Off: "off"
    ]
    
    private static let actionAllowedValues = [
        Leading: true,
        On: true,
        Trailing: true,
        Off: false
    ]
}
