import Foundation
import Combine

// TimerManager est une classe observable pour gérer un minuteur partagé dans toute l'app
class TimerManager: ObservableObject {
    static let shared = TimerManager() // Singleton pour un accès global

    @Published var timeRemaining: Int = 0 //  Temps restant en secondes
    @Published var isRunning = false      //  Indique si le timer est actif
    @Published var isPaused = false       //  Indique si le timer est en pause

    var totalDuration: Int = 0            //  Durée totale en secondes
    private var timer: Timer?             // Timer système

    // Progrès du timer (0.0 à 1.0)
    var progress: Double {
        guard totalDuration > 0 else { return 0 }
        return 1.0 - Double(timeRemaining) / Double(totalDuration)
    }

    // Démarre un nouveau timer avec heures, minutes, secondes
    func start(hours: Int, minutes: Int, seconds: Int) {
        totalDuration = (hours * 3600) + (minutes * 60) + seconds // Conversion en secondes
        guard totalDuration > 0 else { return } // Ignore si durée nulle
        timeRemaining = totalDuration
        isRunning = true
        isPaused = false
        startTimer() // Lance le timer
    }

    //  Met en pause le timer
    func pause() {
        timer?.invalidate() // Arrête le timer temporairement
        isPaused = true
    }

    //Reprend le timer après pause
    func resume() {
        isPaused = false
        startTimer()
    }

    //  Réinitialise le timer
    func reset() {
        timer?.invalidate()
        timeRemaining = 0
        isRunning = false
        isPaused = false
    }

    // Fonction privée qui gère le timer toutes les secondes
    private func startTimer() {
        timer?.invalidate() // Arrête le timer précédent s’il existe

        // Planifie un nouveau timer qui se déclenche chaque seconde
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if self.timeRemaining > 0 {
                self.timeRemaining -= 1 // Diminue le temps restant
            } else {
                self.timer?.invalidate() // Arrête le timer à 0
                self.isRunning = false
            }
        }
    }
}
