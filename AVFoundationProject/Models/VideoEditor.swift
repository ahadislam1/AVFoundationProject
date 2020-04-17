//
//  VideoEditor.swift
//  AVFoundationProject
//
//  Created by Ahad Islam on 4/16/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import AVFoundation

class VideoEditor {
    func addTextToVideo(fromVideoAt videoURL: URL, withText text: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let asset = AVURLAsset(url: videoURL)
        let composition = AVMutableComposition()
    }
}
