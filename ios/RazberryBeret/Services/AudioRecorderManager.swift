import Foundation
import AVFoundation

class AudioRecorderManager: ObservableObject {
    private var audioRecorder: AVAudioRecorder?
    private var recordingSession: AVAudioSession?
    
    init() {
        setupAudioSession()
    }
    
    // MARK: - Audio Session Setup
    
    private func setupAudioSession() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession?.setCategory(.playAndRecord, mode: .default)
            try recordingSession?.setActive(true)
        } catch {
            print("Failed to set up recording session: \(error)")
        }
    }
    
    // MARK: - Recording
    
    func startRecording() async throws -> Void {
        // Request microphone permission
        let hasPermission = await requestMicrophonePermission()
        
        guard hasPermission else {
            throw AudioRecorderError.microphonePermissionDenied
        }
        
        // Generate unique filename
        let filename = "recording_\(Date().timeIntervalSince1970).m4a"
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        
        // Configure recording settings
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
        } catch {
            throw AudioRecorderError.recordingFailed(error.localizedDescription)
        }
    }
    
    func stopRecording() async throws -> URL {
        guard let recorder = audioRecorder else {
            throw AudioRecorderError.noActiveRecording
        }
        
        recorder.stop()
        
        guard let url = recorder.url else {
            throw AudioRecorderError.noRecordingURL
        }
        
        // Verify file exists and has content
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: url.path) else {
            throw AudioRecorderError.recordingFileNotFound
        }
        
        do {
            let attributes = try fileManager.attributesOfItem(atPath: url.path)
            let fileSize = attributes[.size] as? Int64 ?? 0
            
            guard fileSize > 0 else {
                throw AudioRecorderError.emptyRecording
            }
        } catch {
            throw AudioRecorderError.recordingFileError(error.localizedDescription)
        }
        
        return url
    }
    
    // MARK: - Permissions
    
    private func requestMicrophonePermission() async -> Bool {
        return await withCheckedContinuation { continuation in
            recordingSession?.requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // MARK: - Cleanup
    
    func cleanupOldRecordings() {
        let fileManager = FileManager.default
        let documentsURL = getDocumentsDirectory()
        
        do {
            let files = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: [.creationDateKey], options: [])
            let recordings = files.filter { $0.pathExtension == "m4a" && $0.lastPathComponent.starts(with: "recording_") }
            
            // Keep only the most recent 10 recordings
            let sortedRecordings = recordings.sorted { url1, url2 in
                let date1 = (try? url1.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? Date.distantPast
                let date2 = (try? url2.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? Date.distantPast
                return date1 > date2
            }
            
            let recordingsToDelete = sortedRecordings.dropFirst(10)
            
            for recording in recordingsToDelete {
                try fileManager.removeItem(at: recording)
            }
        } catch {
            print("Failed to cleanup old recordings: \(error)")
        }
    }
}

// MARK: - AVAudioRecorderDelegate

extension AudioRecorderManager: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            print("Recording finished unsuccessfully")
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio recording encode error: \(error)")
        }
    }
}

// MARK: - Errors

enum AudioRecorderError: LocalizedError {
    case microphonePermissionDenied
    case recordingFailed(String)
    case noActiveRecording
    case noRecordingURL
    case recordingFileNotFound
    case emptyRecording
    case recordingFileError(String)
    
    var errorDescription: String? {
        switch self {
        case .microphonePermissionDenied:
            return "Microphone permission is required to record your voice sessions."
        case .recordingFailed(let message):
            return "Recording failed: \(message)"
        case .noActiveRecording:
            return "No active recording to stop."
        case .noRecordingURL:
            return "Failed to get recording file URL."
        case .recordingFileNotFound:
            return "Recording file not found after recording stopped."
        case .emptyRecording:
            return "Recording is empty. Please try recording again."
        case .recordingFileError(let message):
            return "Recording file error: \(message)"
        }
    }
}
