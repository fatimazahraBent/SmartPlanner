import SwiftUI

struct ContentView: View {
    @State private var selectedDate = Date()

    //  Remplace les tableaux simples par les objets partagés avec UserDefaults
    @StateObject private var taskManager = TaskManager()
    @StateObject private var eventManager = EventManager()

    @State private var showAddTask = false
    @State private var showAddEvent = false
    @State private var showYearPixels = false
    @State private var showTimer = false

    var body: some View {
        VStack(spacing: 0) {
            //  Bandeau dégradé avec menu
            ZStack(alignment: .top) {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                )

                VStack(spacing: 0) {
                    HStack {
                        Spacer()

                        Menu {
                            Button {
                                showAddTask = true
                            } label: {
                                Label("Add Task", systemImage: "plus.circle")
                            }

                            Button {
                                showAddEvent = true
                            } label: {
                                Label("Add Event", systemImage: "calendar.badge.plus")
                            }

                            Button {
                                showYearPixels = true
                            } label: {
                                Label("Mood Pixels", systemImage: "square.grid.3x3.fill")
                            }

                            Button {
                                showTimer = true
                            } label: {
                                Label("Focus Timer", systemImage: "timer")
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(.trailing)
                        }
                    }

                    Text("SmartPlanner")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 0)
                }
                .padding(.top, 50)
            }
            .frame(height: 110)
            .edgesIgnoringSafeArea(.top)

            // Vue du calendrier avec les données des managers
            CustomCalendarView(
                selectedDate: $selectedDate,
                tasks: $taskManager.tasks,
                events: $eventManager.events
            )
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 3)
            )
            .padding()

            Spacer()
        }
        .background(Color(.systemGroupedBackground))

        //  Feuilles avec bindings sur les données sauvegardées
        .sheet(isPresented: $showAddTask) {
            AddTaskView(tasks: $taskManager.tasks)
        }
        .sheet(isPresented: $showAddEvent) {
            AddMonthlyEventView(events: $eventManager.events)
        }
        .sheet(isPresented: $showYearPixels) {
            YearInPixelsView()
        }
        .fullScreenCover(isPresented: $showTimer) {
            FocusTimerView()
        }
    }
}
