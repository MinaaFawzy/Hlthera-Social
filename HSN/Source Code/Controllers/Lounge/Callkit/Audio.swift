//
//  Audio.swift
//  HSN
//
//  Created by Prashant Panchal on 08/02/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import Foundation
import AVFoundation
func configureAudioSession() {
    print("Configuring audio session")
let session = AVAudioSession.sharedInstance()
do {
    try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.voiceChat, options: [])
    } catch (let error) {
    print("Error while configuring audio session: \(error)")
    }
}
func startAudio() {
    print("Starting audio")
}
func stopAudio() {
    print("Stopping audio")
}
