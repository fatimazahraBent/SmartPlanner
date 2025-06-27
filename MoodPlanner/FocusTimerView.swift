import SwiftUI

/// View to handle focus timer with plant growth visual
struct FocusTimerView: View {
    @ObservedObject var timerManager = TimerManager.shared
    @Environment(\.dismiss) var dismiss

    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0

    var body: some View {
        ZStack(alignment: .top) {
            //  Le contenu principal
            VStack(spacing: 30) {
                Color.clear.frame(height: 100) // Réserve l’espace du header

                if timerManager.isRunning || timerManager.isPaused {
                    Text(timeString)
                        .font(.system(size: 48, weight: .bold, design: .monospaced))

                    PlantGrowthView(progress: timerManager.progress)
                        .frame(height: 200)

                    HStack {
                        if timerManager.isPaused {
                            Button("Resume") {
                                timerManager.resume()
                            }
                            .buttonStyle(.borderedProminent)
                        } else if timerManager.isRunning {
                            Button("Pause") {
                                timerManager.pause()
                            }
                            .buttonStyle(.borderedProminent)
                        }

                        Button("Stop") {
                            timerManager.reset()
                            dismiss()
                        }
                        .buttonStyle(.bordered)
                    }
                } else {
                    HStack {
                        Picker("Hours", selection: $hours) {
                            ForEach(0..<24, id: \.self) { Text("\($0) h") }
                        }
                        Picker("Min", selection: $minutes) {
                            ForEach(0..<60, id: \.self) { Text("\($0) min") }
                        }
                        Picker("Sec", selection: $seconds) {
                            ForEach(0..<60, id: \.self) { Text("\($0) sec") }
                        }
                    }
                    .pickerStyle(.wheel)

                    Button("Start") {
                        timerManager.start(hours: hours, minutes: minutes, seconds: seconds)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(hours + minutes + seconds == 0)

                    Button("Close") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                }

                Spacer()
            }
            .padding()

            // Bandeau dégradé avec le titre CENTRÉ dedans
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(height: 110)
            .overlay(
                Text("Focus Timer")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 40)
                    .frame(maxWidth: .infinity)
            )
            .ignoresSafeArea(edges: .top)
        }
        .interactiveDismissDisabled(timerManager.isRunning)
    }

    /// Format time as HH:MM:SS
    var timeString: String {
        let hr = timerManager.timeRemaining / 3600
        let min = (timerManager.timeRemaining % 3600) / 60
        let sec = timerManager.timeRemaining % 60
        return String(format: "%02d:%02d:%02d", hr, min, sec)
    }
}
