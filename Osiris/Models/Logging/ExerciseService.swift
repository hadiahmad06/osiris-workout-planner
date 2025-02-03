//
//  ExerciseService.swift
//  Osiris
//
//  Created by Hadi Ahmad on 2/1/25.
//

import Foundation

class ExerciseService: ObservableObject {
    @Published var exercises: [Exercise] = [Exercise.EXAMPLE_EXERCISE]
    
    init() {
        loadExercises()
    }
    
    func loadExercises(from fileName: String = "exercises_example.json") {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            print("Error: Could not find \(fileName) in bundle.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            self.exercises = try decoder.decode([Exercise].self, from: data)
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
    
    func getExercise(byName name: String) -> Exercise {
        return exercises.first { $0.name.lowercased() == name.lowercased() } ?? Exercise.EXAMPLE_EXERCISE
    }
    
    func getExercise(byId id: String) -> Exercise {
        return exercises.first { $0.id == id } ?? Exercise.EXAMPLE_EXERCISE
    }
    
    func getExercises(byTag tag: String) -> [Exercise] {
        return exercises.filter { $0.tags.contains(tag.lowercased()) }
    }
    
    func getProgressions(of exercise: Exercise) -> [Exercise] {
        return exercise.progressions
    }
    
    func getRegressions(of exercise: Exercise) -> [Exercise] {
        return exercise.regressions
    }
    
    func getSimilarExercises(of exercise: Exercise) -> [Exercise] {
        return exercise.similarExercises
    }
}
