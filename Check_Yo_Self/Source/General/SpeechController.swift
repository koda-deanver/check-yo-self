//
//  SpeechController.swift
//  check-yo-self
//
//  Created by Phil on 3/15/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import AVFoundation

// MARK: - Enumeration -

/// Convenient way of switching between voices.
enum Speaker {
    case australianGirl, britishDude, robotGirl, americanGirl, britishGirl
    
    /// Voice object.
    var voice: AVSpeechSynthesisVoice? {
        switch self {
        case .australianGirl: return AVSpeechSynthesisVoice(language: "en-AU")
        case .britishDude: return AVSpeechSynthesisVoice(language: "en-GB")
        case .robotGirl: return AVSpeechSynthesisVoice(language: "en-IE")
        case .americanGirl: return AVSpeechSynthesisVoice(language: "en-US")
        case .britishGirl: return AVSpeechSynthesisVoice(language: "en-ZA")
        }
    }
}

// MARK: - Class -

/// Able to have a variety of speakers speak any string.
class SpeechController {
    
    private static let synthesizer = AVSpeechSynthesizer()
    
    // MARK: - Public Methods -
    
    ///
    /// Causes speaker to start reading the specified string.
    ///
    static func speak(_ text: String) {
        stop()
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.5
        utterance.voice = Speaker.britishGirl.voice
        synthesizer.speak(utterance)
    }
    
    ///
    /// Stops speaker dead in thier tracks.
    ///
    static func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
