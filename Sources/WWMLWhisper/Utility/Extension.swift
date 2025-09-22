//
//  Extension.swift
//  Example
//
//  Created by William.Weng on 2025/9/22.
//

import UIKit

// MARK: - Data
extension Data {
    
    /// 正規化Wav聲音檔 (語音模型分析用)
    /// - Returns: [Float]
    func _normalizeWaveFile(type: WWMLWhisper.AudioBitDepthType) -> [Float] {
        switch type {
        case ._8bits: return self._normalizeWaveFileFor8bits()
        case ._16bits: return self._normalizeWaveFileFor16bits()
        case ._24bits: return self._normalizeWaveFileFor24bits()
        case ._32bits: return self._normalizeWaveFileFor32bits()
        }
    }
}

// MARK: - Data
private extension Data {
    
    /// 正規化Wav聲音檔 for 8bits (-2^7 ~ 2^7 => -1.0 ~ +1.0)
    /// - Returns: [Float]
    func _normalizeWaveFileFor8bits() -> [Float] {
        
        let bits = 8
        let bytes = bits / 8
        let headerCount = 44
        let maxValue = Int8.max

        let floats = stride(from: headerCount, to: count, by: bytes).map {
            return self[$0..<$0 + bytes].withUnsafeBytes {
                let intValue = Int8(littleEndian: $0.load(as: Int8.self))
                return Swift.max(-1.0, Swift.min(Float(intValue) / Float(maxValue), 1.0))
            }
        }
        
        return floats
    }
    
    /// 正規化Wav聲音檔 for 16bits (-2^15 ~ 2^15 => -1.0 ~ +1.0)
    /// - Returns: [Float]
    func _normalizeWaveFileFor16bits() -> [Float] {
        
        let bits = 16
        let bytes = bits / 8
        let headerCount = 44
        let maxValue = Int16.max

        let floats = stride(from: headerCount, to: count, by: bytes).map {
            return self[$0..<$0 + bytes].withUnsafeBytes {
                let intValue = Int16(littleEndian: $0.load(as: Int16.self))
                return Swift.max(-1.0, Swift.min(Float(intValue) / Float(maxValue), 1.0))
            }
        }
        
        return floats
    }

    /// 正規化Wav聲音檔 for 24bits (-2^23 ~ 2^23 => -1.0 ~ +1.0)
    /// - Returns: [Float]
    func _normalizeWaveFileFor24bits() -> [Float] {
        
        let bits = 24
        let bytes = bits / 8
        let headerCount = 44
        let maxValue = (1 << (bits - 1)) - 1

        let floats = stride(from: headerCount, to: count, by: bytes).map {
            
            return self[$0..<$0 + bytes].withUnsafeBytes {
                
                let b0 = $0[0]
                let b1 = $0[1]
                let b2 = $0[2]

                var intValue = Int32(b0) | (Int32(b1) << 8) | (Int32(b2) << 16)
                
                // 負數修正 (0b11111111_00000000_00000000_00000000)
                if (b2 & 0b1000_0000) == 0b1000_0000 { intValue |= (-1 << bits) }

                return Swift.max(-1.0, Swift.min(Float(intValue) / Float(maxValue), 1.0))
            }
        }
        
        return floats
    }
    
    /// 正規化Wav聲音檔 for 32bits (-2^31 ~ 2^31 => -1.0 ~ +1.0)
    /// - Returns: [Float]
    func _normalizeWaveFileFor32bits() -> [Float] {
        
        let bits = 32
        let bytes = bits / 8
        let headerCount = 44
        let maxValue = Int32.max

        let floats = stride(from: headerCount, to: count, by: bytes).map {
            return self[$0..<$0 + bytes].withUnsafeBytes {
                let intValue = Int32(littleEndian: $0.load(as: Int32.self))
                return Swift.max(-1.0, Swift.min(Float(intValue) / Float(maxValue), 1.0))
            }
        }
        
        return floats
    }
}

// MARK: - FileManager
extension FileManager {
    
    /// 測試該檔案是否存在 / 是否為資料夾
    /// - Parameter url: 檔案的URL路徑
    /// - Returns: Constant.FileInformation
    func _fileExists(with url: URL?) -> Bool {

        guard let url = url else { return false }
        
        var isDirectory: ObjCBool = false
        let isExists = fileExists(atPath: url.path, isDirectory: &isDirectory)
        
        return isExists
    }

    /// 移動檔案
    /// - Parameters:
    ///   - atURL: 從這裡移動 =>
    ///   - toURL: => 到這裡
    /// - Returns: Result<Bool, Error>
    func _moveFile(at atURL: URL, to toURL: URL) -> Result<Bool, Error> {
        
        do {
            try moveItem(at: atURL, to: toURL)
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
}

// MARK: - UIDevice
extension UIDevice {
    
    /// [獲取當前設備上可用的處理核心CPU數量](https://developer.apple.com/documentation/foundation/processinfo)
    /// - Returns: Int
    static func _cpuCount() async -> Int {
        await MainActor.run { return ProcessInfo.processInfo.processorCount }
    }
}
