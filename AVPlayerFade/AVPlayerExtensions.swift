//
//  AVPlayerExtensions.swift
//  AVPlayerFade
//
//  Created by Evandro Harrison Hoffmann on 21/05/2020.
//  Copyright © 2020 It's Day Off. All rights reserved.
//

import AVFoundation

extension AVPlayer {
    
    /// Fades player volume FROM any volume TO any volume
    /// - Parameters:
    ///   - from: initial volume
    ///   - to: target volume
    ///   - duration: duration in seconds for the fade
    ///   - completion: callback indicating completion
    /// - Returns: Timer?
    func fadeInVolume(from: Float, to: Float, duration: Float, completion: (() -> Void)? = nil) -> Timer? {
        
        // 1. Set Initial volume
        volume = from
        
        // 2. There's no point in continuing if target volume is the same as initial
        guard from != to else { return nil }
        
        // 3. We define the time interval the interaction will loop into (fraction of a second)
        let interval: Float = 0.1
        // 4. Set the range the volume will move
        let range = to-from
        // 5. Based on the range, the interval and duration, we calculate how big is the step we need to take in order to reach the target in the given duration
        let step = (range*interval)/duration
        
        // internal function whether the target has been reached or not
        func reachedTarget() -> Bool {
            // volume passed max/min
            guard volume >= 0, volume <= 1 else {
                volume = to
                return true
            }
            
            // checks whether the volume is going forward or backward and compare current volume to target
            if to > from {
                return volume >= to
            }
            return volume <= to
        }
        
        // 6. We create a timer that will repeat itself with the given interval
        return Timer.scheduledTimer(withTimeInterval: Double(interval), repeats: true, block: { [weak self] (timer) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                // 7. Check if we reached the target, otherwise we add the volume
                if !reachedTarget() {
                    // note that if the step is negative, meaning that the to value is lower than the from value, the volume will be decreased instead
                    self.volume += step
                } else {
                    timer.invalidate()
                    completion?()
                }
            }
        })
    }
    
    func fadeOutVolume(from: Float, to: Float, duration: Double, completion: (() -> Void)? = nil) -> Timer? {
        
        volume = from
        guard from != to else { return nil }
        
        let interval: Float = 0.1
        let range = from - to
        let step = (range*interval) / Float(duration)
        
        func reachedTarget() -> Bool {
            
            guard volume >= 0, volume <= 1 else {
                volume = from
                return true
            }
            
            if from > to {
                return volume <= to
            }
            return volume >= to
        }
        
        return Timer.scheduledTimer(withTimeInterval: Double(interval), repeats: true, block: { [weak self] (timer) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                if !reachedTarget() {
                    if let currentItem = self.currentItem {
                        let totalDuration = CMTimeGetSeconds(currentItem.duration)
                        let currentTime = CMTimeGetSeconds(currentItem.currentTime())
                        let fadeOutTime = totalDuration - duration
                        if currentTime >= fadeOutTime {
                            self.volume -= step
                        }
                    }
                } else {
                    timer.invalidate()
                    completion?()
                }
            }
        })
    }
}
