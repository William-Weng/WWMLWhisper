# WWMLWhisper

[![Swift-5.7](https://img.shields.io/badge/Swift-5.7-orange.svg?style=flat)](https://developer.apple.com/swift/) [![iOS-16.0](https://img.shields.io/badge/iOS-16.0-pink.svg?style=flat)](https://developer.apple.com/swift/) ![](https://img.shields.io/github/v/tag/William-Weng/WWMLWhisper) [![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/) [![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

## [Introduction - 簡介](https://swiftpackageindex.com/William-Weng)
- [Speech-to-text: TTS (using whisper.cpp)](https://github.com/ggml-org/whisper.cpp)
- [語音轉文字: TTS (使用 whisper.cpp)](https://huggingface.co/ggerganov/whisper.cpp)

https://github.com/user-attachments/assets/8ccc5274-2f24-4ad5-844d-3ff278d85d51

## [Installation with Swift Package Manager](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/使用-spm-安裝第三方套件-xcode-11-新功能-2c4ffcf85b4b)
```bash
dependencies: [
    .package(url: "https://github.com/William-Weng/WWMLWhisper.git", .upToNextMajor(from: "1.1.0"))
]
```

## 可用函式
|函式|說明|
|-|-|
|loadModel(_:for:useGPU:useFlashAttention:progress:completion:)|載入模型|
|loadModel(_:for:useGPU:useFlashAttention:)|載入模型|
|transcribe(with:wave:result:)|把分析的結果抄寫下來|
|transcribe(with:wave:)|把分析的結果抄寫下來|
|transcription()|將分析的結果轉寫成文字|

## Example
```swift
import UIKit
import AVFoundation
import WWMLWhisper

final class ViewController: UIViewController {
    
    private var audioPlayer: AVAudioPlayer?
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBAction func loadModel(_ sender: UIBarButtonItem) {
        
        Task {
            
            for try await result in await WWMLWhisper.shared.loadModel(WWMLWhisper.ModelType.Tiny.default, useGPU: false) {
                switch result {
                case .progress(let progress): print(progress)
                case .finished(let url): self.messageLabel.text = "\(url)"
                case .error(let error): self.messageLabel.text = "\(error)"
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
```


