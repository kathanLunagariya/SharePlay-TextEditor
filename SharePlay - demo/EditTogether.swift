//
//  EditTogether.swift
//  SharePlay - demo
//
//  Created by Kathan Lunagariya on 27/10/21.
//

import Foundation
import GroupActivities

struct EditTogether:GroupActivity {
    
    var metadata: GroupActivityMetadata{
        
        var metadata = GroupActivityMetadata()
        metadata.title = NSLocalizedString("Edit Together!", comment: "title of group activity...")
        metadata.type = .generic
        return metadata
    }
    
}
