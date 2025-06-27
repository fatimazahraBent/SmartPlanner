import SwiftUI

struct PixelEditorPanel: View {
    @Binding var day: PixelDayModel
    var onSave: () -> Void

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Mood")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(MoodType.allCases.filter { $0 != .none }, id: \.self) { mood in
                                Button(action: {
                                    day.mood = mood
                                }) {
                                    VStack {
                                        Text(mood.emoji)
                                            .font(.largeTitle)
                                        Text(mood.description)
                                            .font(.caption)
                                            .foregroundColor(.primary)
                                    }
                                    .padding()
                                    .background(day.mood == mood ? Color.blue.opacity(0.3) : Color.clear)
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                }

                Section(header: Text("Note")) {
                    TextEditor(text: $day.note)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Edit Mood")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave()
                        dismiss()
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
