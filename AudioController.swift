//
//  AudioController.swift
//  gameHang
//
//  Created by Hen Hershko on 11/07/2016.
//  Copyright © 2016 Hen Hershko. All rights reserved.
//

import Foundation
import AVFoundation

class AudioController {
    private var audio = [String:AVAudioPlayer]()
    
    func preloadAudioEffects(effectFileNames:[String]) {
        for effect in AudioEffectFiles {
            // get the file path URL
            let soundPath = (NSBundle.mainBundle().resourcePath! as NSString).stringByAppendingPathComponent(effect)
            let soundURL = NSURL.fileURLWithPath(soundPath)
            
            // load the file contents
            var loadError:NSError?
            let player: AVAudioPlayer!
            do {
                player = try AVAudioPlayer(contentsOfURL: soundURL)
            } catch let error as NSError {
                loadError = error
                player = nil
            }
            assert(loadError == nil, "Load sound failed")
            
            // prepare the play
            player.numberOfLoops = 0
            player.prepareToPlay()
            
            // add to the audio dictionary
            audio[effect] = player
        }
    }
    
    func playEffect(name:String) {
        if let player = audio[name] {
            if player.playing {
                player.currentTime = 0
            } else {
                player.play()
            }
        }
    }
    
}

