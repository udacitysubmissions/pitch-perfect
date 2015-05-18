//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Carl Ward on 5/13/15.
//  Copyright (c) 2015 Carl Ward. All rights reserved.
//

import Foundation

public class RecordedAudio: NSObject {
    var filePathUrl: NSURL
    var title: String

    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}