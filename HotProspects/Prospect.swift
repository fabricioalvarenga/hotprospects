//
//  Prospect.swift
//  HotProspects
//
//  Created by FABRICIO ALVARENGA on 15/10/22.
//

import Foundation

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
    var date = Date()
}

enum SortPeople {
    case date, name
}

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    
    let saveKey = "SavedData"
    let savePath = FileManager.documentsDirectory.appending(path: "PropectPath")
    var currentSort = SortPeople.date
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            people = try JSONDecoder().decode([Prospect].self, from: data)
            return
        } catch {
            people = []
        }
        
        // no saved data!
        people = []
        
        //        if let data = UserDefaults.standard.data(forKey: saveKey) {
        //            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
        //                people = decoded
        //                return
        //            }
        //        }
    }
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(people)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unabled to save data.")
        }
        //        if let encoded = try? JSONEncoder().encode(people) {
        //            UserDefaults.standard.set(encoded, forKey: saveKey)
        //        }
    }
    
    func sortPeople(by: SortPeople) {
        switch by {
        case .date:
            people = people.sorted { $0.date < $1.date }
        case .name:
            people = people.sorted { $0.name < $1.name }
        }
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}
