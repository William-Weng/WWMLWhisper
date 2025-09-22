//
//  WhisperContext.swift
//  Example
//
//  Created by William.Weng on 2025/9/22.
//

import UIKit
import whisper
import WWNetworking

// MARK: - 語音轉文字功能
public actor WWMLWhisper {
    
    public struct ModelType {}
    
    public static let shared = WWMLWhisper()
    
    private var context: OpaquePointer?
    
    private init() {}
    
    deinit { whisper_free(context) }
}

// MARK: - 公開函式
public extension WWMLWhisper {
        
    /// 載入模型
    /// - Parameters:
    ///   - model: 使用的模型類型 (下載或讀取)
    ///   - useGPU: 是否使用GPU運算
    ///   - useFlashAttention: 是否使用高效實現注意力機制
    ///   - progress: 下載進度
    ///   - completion: 最後結果
    func loadModel(_ model: WWMLWhisper.ModelProtocol, useGPU: Bool = false, useFlashAttention: Bool = true, progress: ((WWNetworking.DownloadProgressInformation) -> Void)? = nil, completion: @escaping (Result<URL, Error>) -> Void) {
        
        guard let localModelURL = localModelURL(model),
              let localModelPath = localModelURL.path().removingPercentEncoding
        else {
            return
        }
        
        if (FileManager.default._fileExists(with: localModelURL)) {
            let isSuccess = loadModel(with: localModelPath, useGPU: useGPU, useFlashAttention: useFlashAttention)
            if !isSuccess { completion(.failure(CustomError.notLoadModel(localModelURL))) }
            completion(.success(localModelURL)); return
        }
        
        downloadModel(model) { info in
            progress?(info)
        } completion: { result in
            switch result {
            case .failure(let error): completion(.failure(error))
            case .success(_): self.loadModel(model, useGPU: useGPU, useFlashAttention: useFlashAttention, progress: progress, completion: completion)
            }
        }
    }
    
    /// 把分析的結果抄寫下來
    /// - Parameters:
    ///   - language: 分析語言
    ///   - wave: 聲音相關資訊
    ///   - result: Result<Bool, Error>
    func transcribe(with language: String = "en", wave: WWMLWhisper.WaveInformation, result: (Result<Bool, Error>) -> Void) async {
        
        guard let samples = Optional.some(wave.data._normalizeWaveFile(type: wave.type)) else { result(.failure(CustomError.samplesError)); return }
        
        await transcribe(language: language, samples: samples) { _result_ in
            switch _result_ {
            case .failure(let error): result(.failure(error))
            case .success(let isSuccess): result(.success(isSuccess))
            }
        }
    }
    
    /// 將分析的結果轉寫成文字
    /// - Returns: Result<String, Error>
    func transcription() -> Result<String, Error> {
        
        guard let context = context else { return .failure(CustomError.notContext) }
        
        var transcription = ""
        
        for index in 0..<whisper_full_n_segments(context) {
            transcription += String(cString: whisper_full_get_segment_text(context, index))
        }
        
        return .success(transcription)
    }
}

// MARK: - 小工具
private extension WWMLWhisper {
    
    /// 本地端下載的已下載Model位置
    /// - Parameter model: WWMLWhisper.ModelProtocol
    /// - Returns: URL?
    func localModelURL(_ model: WWMLWhisper.ModelProtocol) -> URL? {
        
        guard let folder = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else { return nil }
        
        let localURL = folder.appendingPathComponent(model.filename())
        return localURL
    }
    
    /// 下載模型
    /// - Parameters:
    ///   - model: 下載模型類型
    ///   - progress: 下載進度
    ///   - completion: 下載結果
    func downloadModel(_ model: WWMLWhisper.ModelProtocol, progress: ((WWNetworking.DownloadProgressInformation) -> Void)?, completion: @escaping (Result<URL, Error>) -> Void) {
        
        guard let localModelURL = localModelURL(model) else { return }
        
        _ = WWNetworking.shared.download(urlString: model.urlString(), progress: { info in
            progress?(info)
        }, completion: { downloadResult in
            switch downloadResult {
            case .failure(let error): completion(.failure(error))
            case .success(let info):
                _  = FileManager.default._moveFile(at: info.location, to: localModelURL)
                completion(.success(localModelURL))
            }
        })
    }
    
    /// 載入模型
    /// - Parameters:
    ///   - path: 路徑
    ///   - useGPU: 是否使用GPU運算
    ///   - useFlashAttention: 是否使用高效實現注意力機制
    /// - Returns: Bool
    func loadModel(with path: String, useGPU: Bool, useFlashAttention: Bool) -> Bool {
        
        var params = whisper_context_default_params()
        
        params.use_gpu = useGPU
        params.flash_attn = useFlashAttention
        
        guard let context = whisper_init_from_file_with_params(path, params) else { return false }
        
        self.context = context
        return true
    }
    
    /// 把分析的結果抄寫下來
    /// - Parameters:
    ///   - language: 分析語言
    ///   - samples: 標準化聲音取樣
    ///   - result: Result<Bool, Error>
    func transcribe(language: String = "en", samples: [Float], result: (Result<Bool, Error>) -> Void) async {

        guard let context = context else { return result(.failure(CustomError.notContext)) }
        
        let cpuCount = await UIDevice._cpuCount()
        let maxThreads = max(1, min(8, cpuCount - 2))
        
        var params = whisper_full_default_params(WHISPER_SAMPLING_GREEDY)
        
        language.withCString { en in

            params.print_realtime   = true
            params.print_progress   = false
            params.print_timestamps = true
            params.print_special    = false
            params.translate        = false
            params.language         = en
            params.n_threads        = Int32(maxThreads)
            params.offset_ms        = 0
            params.no_context       = true
            params.single_segment   = false

            whisper_reset_timings(context)
                        
            samples.withUnsafeBufferPointer { samples in
                
                if (whisper_full(context, params, samples.baseAddress, Int32(samples.count)) != 0) {
                    result(.failure(CustomError.runModelFailed))
                } else {
                    whisper_print_timings(context)
                    result(.success(true))
                }
            }
        }
    }
}
