//
//  UserDefaultManager.swift
//  ibrahim_erdogan_marti_case
//
//  Created by İbrahim Erdogan on 2.04.2025.
//

import Foundation
import CoreLocation
protocol UserDefaultsManagerProtocol {
    func save(_ models: [CustomLocationModel])
    func fetchAll() -> [CustomLocationModel]
    func add(_ model: CustomLocationModel)
    func removeAll()
}
class UserDefaultsManager: UserDefaultsManagerProtocol {
    private let key = "customModels"


    init() {}

    func save(_ models: [CustomLocationModel]) {
        if let encoded = try? JSONEncoder().encode(models) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    func fetchAll() -> [CustomLocationModel] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let models = try? JSONDecoder().decode([CustomLocationModel].self, from: data) else {
            return []
        }
        return models
    }

    func add(_ model: CustomLocationModel) {
        var models = fetchAll()
        models.append(model)
        save(models)
    }

    func removeAll() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
