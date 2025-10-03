//
//  Constant.swift
//  Example
//
//  Created by William.Weng on 2025/9/22.
//

import UIKit
import WWNetworking

// MARK: - typealias
public extension WWMLWhisper {
    typealias WaveInformation = (data: Data, type: WWMLWhisper.AudioBitDepthType)
}

// MARK: - Protocol
public extension WWMLWhisper {
    
    protocol ModelProtocol {
        func filename() -> String
        func urlString() -> String
    }
}

// MARK: - Error
public extension WWMLWhisper {
    
    /// 自定義錯誤
    enum CustomError: Error {
        case isUrlNull
        case isFolderNull
        case notLocalModel
        case notLoadModel(_ url: URL)
        case notContext
        case notFileExists
        case runModelFailed
        case samplesError
        case transcribeFailed
    }
}

// MARK: - enum
public extension WWMLWhisper {
    
    /// [音訊位元深度類型](https://zh.wikipedia.org/zh-tw/位元深度_(音訊))
    enum AudioBitDepthType {
        case _8bits
        case _16bits
        case _24bits
        case _32bits
    }
    
    /// 檔案下載狀態事件
    enum DownloadEvent {
        case progress(_ progress: WWNetworking.DownloadProgressInformation)
        case finished(_ url: URL)
        case error(_ error: Error)
    }
}

// MARK: - 模型列表
public extension WWMLWhisper.ModelType {
    
    /// 迷你模型
    enum Tiny: String, WWMLWhisper.ModelProtocol {
        
        case `default` = "ggml-tiny.bin"
        case q5_1 = "ggml-tiny-q5_1.bin"
        case q8_0 = "ggml-tiny-q8_0.bin"
        case en = "ggml-tiny.en.bin"
        case en_q5_1 = "ggml-tiny.en-q5_1.bin"
        case en_q8_0 = "ggml-tiny.en-q8_0.bin"
        
        /// 檔案名稱
        /// - Returns: String
        public func filename() -> String {
            return rawValue
        }
        
        /// 取得模型的下載URL
        /// - Returns: String
        public func urlString() -> String {
            let base = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main"
            return "\(base)/\(rawValue)"
        }
    }
    
    /// 基本模型
    enum Base: String, WWMLWhisper.ModelProtocol {
        
        case `default` = "ggml-base.bin"
        case q5_1 = "ggml-base-q5_1.bin"
        case q8_0 = "ggml-base-q8_0.bin"
        case en = "ggml-base.en.bin"
        case en_q5_1 = "ggml-base.en-q5_1.bin"
        case en_q8_0 = "ggml-base.en-q8_0.bin"
        
        /// 檔案名稱
        /// - Returns: String
        public func filename() -> String {
            return rawValue
        }

        /// 取得模型的下載URL
        /// - Returns: String
        public func urlString() -> String {
            let base = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main"
            return "\(base)/\(rawValue)"
        }
    }
    
    /// 小型模型
    enum Small: String, WWMLWhisper.ModelProtocol {
        
        case `default` = "ggml-small.bin"
        case q5_1 = "ggml-small-q5_1.bin"
        case q8_0 = "ggml-small-q8_0.bin"
        case en = "ggml-small.en.bin"
        case en_q5_1 = "ggml-small.en-q5_1.bin"
        case en_q8_0 = "ggml-small.en-q8_0.bin"
        
        /// 檔案名稱
        /// - Returns: String
        public func filename() -> String {
            return rawValue
        }

        /// 取得模型的下載URL
        /// - Returns: String
        public func urlString() -> String {
            let base = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main"
            return "\(base)/\(rawValue)"
        }
    }
    
    /// 中等模型
    enum Medium: String, WWMLWhisper.ModelProtocol {
        
        case `default` = "ggml-medium.bin"
        case q5_1 = "ggml-medium-q5_1.bin"
        case q8_0 = "ggml-medium-q8_0.bin"
        case en = "ggml-medium.en.bin"
        case en_q5_1 = "ggml-medium.en-q5_1.bin"
        case en_q8_0 = "ggml-medium.en-q8_0.bin"
        
        /// 檔案名稱
        /// - Returns: String
        public func filename() -> String {
            return rawValue
        }

        /// 取得模型的下載URL
        /// - Returns: String
        public func urlString() -> String {
            let base = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main"
            return "\(base)/\(rawValue)"
        }
    }
    
    /// 大型模型
    enum Large: String, WWMLWhisper.ModelProtocol {
        
        case `default` = "ggml-large.bin"
        case v2 = "ggml-large-v2.bin"
        case v2_q5_0 = "ggml-large-v2-q5_0.bin"
        case v2_q8_0 = "ggml-large-v2-q8_0.bin"
        case v3 = "ggml-large-v3.bin"
        case v3_q5_0 = "ggml-large-v3-q5_0.bin"
        case v3_turbo = "ggml-large-v3-turbo.bin"
        case v3_turbo_q5_0 = "ggml-large-v3-turbo-q5_0.bin"
        case v3_turbo_q8_0 = "ggml-large-v3-turbo-q8_0.bin"
        
        /// 檔案名稱
        /// - Returns: String
        public func filename() -> String {
            return rawValue
        }

        /// 取得模型的下載URL
        /// - Returns: String
        public func urlString() -> String {
            let base = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main"
            return "\(base)/\(rawValue)"
        }
    }
}
