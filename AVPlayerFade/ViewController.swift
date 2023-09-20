//
//  ViewController.swift
//  AVPlayerFade
//
//  Created by Evandro Harrison Hoffmann on 21/05/2020.
//  Copyright © 2020 It's Day Off. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPlayer()
    }
    
    private lazy var player: AVPlayer = .init()
    private var fadeTimer: Timer?
    
    private func setupPlayer() {
        // Setup player
        guard let url = Bundle.main.url(forResource: "sample", withExtension: "mp3") else { return }
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        player.volume = 0
        player.play()
        
        // Fade player volume from 0 to 1 in 5 seconds
        fadeTimer = player.fadeInVolume(from: 0, to: 1, duration: 5)
        // or
        // fadeTimer = player.fadeOutVolume(from: 1, to: 0, duration: 5)
    }

}
