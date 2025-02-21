import SwiftUI
import ActivityKit

struct ContentView: View {
    @State private var currentTime = Date()
    @State private var currentEmoji = "😀"
    @State private var activity: Activity<EmojiAttributes>? = nil
    
    let emojis = ["😀", "😂", "😍", "🥳", "🤔", "😎", "😡", "🥶", "😴", "🤯", "😼", "👀" , "💀" ]
    
    var body: some View {
        VStack {
            Text(currentTime, style: .time)
                .font(.largeTitle)
                .padding()
            
            Text(currentEmoji)
                .font(.system(size: 100))
                .padding()
        }
        .onAppear {
            startTimer()
        }
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            updateTimeAndEmoji()
        }
    }
    
    func updateTimeAndEmoji() {
        currentTime = Date()
        currentEmoji = emojis.randomElement() ?? "😀"
        
        Task {
            await showDynamicIslandEmoji()
        }
    }
    
    func showDynamicIslandEmoji() async {
        let attributes = EmojiAttributes()
        let contentState = EmojiAttributes.ContentState(emoji: currentEmoji)
        
        do {
            activity = try Activity.request(attributes: attributes, content: ActivityContent(state: contentState, staleDate: nil), pushType: nil)
            
            try await Task.sleep(nanoseconds: 10 * 1_000_000_000)
            await activity?.end(dismissalPolicy: .immediate)
        } catch {
            print("Failed to start Live Activity: \(error)")
        }
    }
}

struct EmojiAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var emoji: String
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
