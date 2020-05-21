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
        let url = URL(string: "https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3")!
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        player.volume = 0
        player.play()
        
        // Fade player volume from 0 to 1 in 5 seconds
        fadeTimer = player.fadeVolume(from: 0, to: 1, duration: 5)
    }

}
