import Foundation
import Combine

// MARK: - データストレージマネージャー
class GameSessionStore: ObservableObject {
    @Published var sessions: [GameSession] = []
    
    private let saveKey = "savedGameSessions"
    
    init() {
        loadSessions()
    }
    
    func loadSessions() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([GameSession].self, from: data) {
                sessions = decoded
            }
        }
    }
    
    func saveSessions() {
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    func addOrUpdate(_ session: GameSession) {
        if let index = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[index] = session
        } else {
            sessions.append(session)
        }
        saveSessions()
    }
    
    func delete(_ session: GameSession) {
        sessions.removeAll(where: { $0.id == session.id })
        saveSessions()
    }
}
