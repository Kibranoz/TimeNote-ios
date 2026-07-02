//
//  AudioSessionManager.swift
//  TimeNote
//
//  Created by Louis R Couture on 2026-06-28.
//

import Foundation
import Combine
import AVFAudio


class AudioSessionManager: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private var timenote:AppController
    
    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            // Use a secondary audio category so we can react to non-mixable audio
            // from other apps (for example YouTube in Split View/Stage Manager).
            try session.setCategory(.ambient, mode: .default, options: [])
            try session.setActive(true)
        } catch {
            print("Erreur fatale : Impossible de configurer la session audio : \(error)")
        }
    }
    
    init(timeNote: AppController) {
        self.timenote = timeNote
        self.setupAudioSession()
        setupObservers()
    }
    
    func setupObservers() {
        
        // 2. Pour la musique externe (Spotify, etc.)
        NotificationCenter.default.publisher(for: AVAudioSession.silenceSecondaryAudioHintNotification)
            .sink { [weak self] n in self?.handleSecondaryAudioHint(n) }
            .store(in: &cancellables)
    }
    
    private func handleSecondaryAudioHint(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionSilenceSecondaryAudioHintTypeKey] as? UInt,
              let type = AVAudioSession.SilenceSecondaryAudioHintType(rawValue: typeValue) else { return }
        
        if type == .begin {
            print("Son externe détecté -> Play")
        } else {
            print("Silence externe détecté -> Pause")
        }
    }

}
