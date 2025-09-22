//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2025/9/22.
//

import UIKit
import WWMLWhisper

// MARK: - ViewController
final class ViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBAction func loadModel(_ sender: UIBarButtonItem) {
        
        Task {
            await WWMLWhisper.shared.loadModel(WWMLWhisper.ModelType.Tiny.default, useGPU: false) { progess in
                print(progess)
            } completion: { result in
                switch result {
                case .failure(let error): DispatchQueue.main.async { self.messageLabel.text = "\(error)" }
                case .success(let url): DispatchQueue.main.async { self.messageLabel.text = "\(url)" }
                }
            }
        }
    }
    
    @IBAction func whiper(_ sender: UIBarButtonItem) {
        
        guard let waveURL = Bundle.main.url(forResource: "jfk", withExtension: "wav"),
              let data = try? Data(contentsOf: waveURL)
        else {
            return
        }
        
        Task {
            
            await WWMLWhisper.shared.transcribe(wave: (data, ._16bits)) { result in
                
                switch result {
                case .failure(let error): messageLabel.text = "\(error)"
                case .success(let isSuccess): if !isSuccess { return }
                    
                    Task {
                        let _result_ = await WWMLWhisper.shared.transcription()
                        
                        switch _result_ {
                        case .failure(let error): messageLabel.text = "\(error)"
                        case .success(let message): messageLabel.text = message
                        }
                    }
                }
            }
        }
    }
}
