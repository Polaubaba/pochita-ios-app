import SwiftUI

struct ContentView: View {
    @State private var currentTime = Date()
    @State private var currentEmoji = "😀"
    @State private var selectedWord = "Random"
    @State private var timerValue: Double = 10
    @State private var isTimerRunning = false
    @State private var timerEmoji = ""
    
    let emojiDictionary: [String: String] = [
        "Heart": "🦎",
        "Joker": "🤡",
        "Fire": "🔥",
        "Star": "⭐️",
        "Sun": "☀️",
        "Moon": "🌙",
        "Ghost": "👻",
        "Robot": "🤖"
    ]
    
    let words: [String] = ["Heart", "Joker", "Fire", "Star", "Sun", "Moon", "Ghost", "Robot"]
    
    var body: some View {
        VStack {
            Text(currentTime, style: .time)
                .font(.largeTitle)
                .padding()
            
            Text(currentEmoji)
                .font(.system(size: 100))
                .padding()
                .scaleEffect(1.2)
                .animation(.easeInOut(duration: 0.5).repeatForever(), value: currentEmoji)
            
            Picker("Select a Word", selection: $selectedWord) {
                ForEach(words, id: \.self) { word in
                    Text(word)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: selectedWord) { newValue in
                currentEmoji = emojiDictionary[newValue] ?? "😀"
            }
            
            Text(timerEmoji)
                .font(.system(size: 100))
                .padding()
                .opacity(timerEmoji.isEmpty ? 0 : 1)
                .scaleEffect(timerEmoji == "💥" ? 1.5 : 1.0)
                .animation(.easeInOut(duration: 0.5), value: timerEmoji)
            
            Slider(value: $timerValue, in: 5...60, step: 5) {
                Text("Timer")
            }
            .padding()
            
            Button(action: startCountdown) {
                Text(isTimerRunning ? "Running..." : "Start Timer")
                    .padding()
                    .background(isTimerRunning ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(isTimerRunning)
        }
        .onAppear {
            startTimer()
        }
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            updateTimeAndEmoji()
        }
    }
    
    func updateTimeAndEmoji() {
        currentTime = Date()
    }
    
    func startCountdown() {
        isTimerRunning = true
        timerEmoji = "💣"
        DispatchQueue.main.asyncAfter(deadline: .now() + timerValue) {
            timerEmoji = "💥"
            isTimerRunning = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                timerEmoji = ""
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
