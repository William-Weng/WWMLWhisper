//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2025/9/22.
//

import UIKit
import AVFoundation
import WWMLWhisper

// MARK: - ViewController
final class ViewController: UIViewController {
    
    private var audioPlayer: AVAudioPlayer?
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBAction func loadModel(_ sender: UIBarButtonItem) {
        
        Task {
            
            for try await result in await WWMLWhisper.shared.loadModel(.tiny(.default)) {
                switch result {
                case .error(let error): self.messageLabel.text = "\(error)"
                case .progress(let progress): print(progress)
                case .finished(let url): self.messageLabel.text = "\(url)"
                }
            }
        }
    }
    
    @IBAction func playSound() {
        
        guard let url = Bundle.main.url(forResource: "jfk", withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            
        } catch let error {
            messageLabel.text = "\(error)"
        }
    }
    
    @IBAction func whiper(_ sender: UIBarButtonItem) {
        
        guard let waveURL = Bundle.main.url(forResource: "jfk", withExtension: "wav"),
              let data = try? Data(contentsOf: waveURL)
        else {
            return
        }
        
        Task {
            do {
                try await WWMLWhisper.shared.transcribe(wave: (data, ._16bits))
                let message = try await WWMLWhisper.shared.transcription().get()
                messageLabel.text = message
            } catch {
                messageLabel.text = "\(error)"
            }
        }
    }
}
