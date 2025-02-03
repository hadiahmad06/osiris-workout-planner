//
//  WorkoutPlan.swift
//  Osiris - Workout Planner
//
//  Created by Hadi Ahmad on 12/18/24.
//

import Dispatch

enum FunctionResult {
    case success
    case failure
}

class Plan: Identifiable, Codable {
//    private static var nextID: Int = 0
//    private static let idQueue = DispatchQueue(label: "com.myApp.objectIDQueue")
    var id: String
    var publicName: String
    var name: String
    var symbol: String?
    var exercises: [String]

    init (id: String, publicName: String, name: String, symbol: String? = nil) {
        self.id = id
        self.publicName = publicName
        self.name = name
        self.symbol = symbol
        self.exercises = []
    }
    
    func addExercise(id: String, index: Int) -> FunctionResult {
        if index < 0 || index > exercises.count { return .failure }
        if exercises.contains(where: { $0 == id }) { return .failure }
            
        exercises.insert(id, at: index)
        return .success
    }
    
    func moveExercise(start fromIdx: Int, end toIdx: Int) -> FunctionResult {
        if fromIdx < 0 || fromIdx >= exercises.count || toIdx < 0 || toIdx >= exercises.count { return .failure }
        if fromIdx == toIdx { return .success }
        
        let exercise = exercises.remove(at: fromIdx)
        exercises.insert(exercise, at: toIdx)
        return .success
    }
}


//struct Exercises {
//    var list: [Exercise]
//    init() {
//        list = []
//        list.append(Exercise(
//            name: "Barbell Back Squat",
//            movement: .regular,
//            angle: .regular,
//            laterality: .bilateral,
//            focus: .strengthen,
//            impact: 8.0,
//            rating: 7.5,
//            restrictions: [
//                .joint(.kneePatellarTracking),
//                .joint(.hipLabralTear),
//                .joint(.ligamentSprain),
//                .back(.spinalStenosis),
//                .joint(.arthritis),
//                .joint(.meniscusTear),
//                .back(.herniatedDisc),
//                .back(.sciatica),
//                .muscleCondition(.muscleStrain(.quadriceps(.rectusfemoris))),
//                .muscleCondition(.muscleStrain(.quadriceps(.vastuslateralis))),
//                .muscleCondition(.muscleStrain(.quadriceps(.vastusmedialis))),
//                .muscleCondition(.muscleStrain(.quadriceps(.vastusintermedius))),
//                .muscleCondition(.muscleStrain(.hamstrings(.semitendinosus))),
//                .muscleCondition(.muscleStrain(.hamstrings(.bicepsfemoris))),
//                .muscleCondition(.muscleStrain(.glutes(.gluteusmaximus))),
//                .muscleCondition(.muscleStrain(.abs(.rectusabdominis))),
//                .muscleCondition(.muscleStrain(.traps(.middle)))
//            ],
//            equipmentRequired: [.resistance(.barbell)],
//            musclesTargeted: [
//                MuscleWeightage(type: .agonist, muscle: .quadriceps(.rectusfemoris), weightage: 0.35),
//                MuscleWeightage(type: .agonist, muscle: .quadriceps(.vastuslateralis), weightage: 0.25),
//                MuscleWeightage(type: .agonist, muscle: .quadriceps(.vastusmedialis), weightage: 0.20),
//                MuscleWeightage(type: .agonist, muscle: .quadriceps(.vastusintermedius), weightage: 0.15),
//                MuscleWeightage(type: .synergist, muscle: .hamstrings(.semitendinosus), weightage: 0.10),
//                MuscleWeightage(type: .synergist, muscle: .hamstrings(.bicepsfemoris), weightage: 0.10),
//                MuscleWeightage(type: .synergist, muscle: .glutes(.gluteusmaximus), weightage: 0.20),
//                MuscleWeightage(type: .stabilizer, muscle: .abs(.rectusabdominis), weightage: 0.10),
//                MuscleWeightage(type: .stabilizer, muscle: .traps(.middle), weightage: 0.05)
//            ]
//        ))
//        
//        // 2. Cable Lat Pulldown
//        list.append(Exercise(
//            name: "Cable Lat Pulldown",
//            movement: .regular,
//            angle: .regular,
//            laterality: .bilateral,
//            focus: .strengthen,
//            impact: 6.0,
//            rating: 8.0,
//            restrictions: [
//                .joint(.rotatorCuffInjury),
//                .joint(.shoulderInstability),
//                .joint(.frozenShoulder),
//                .back(.herniatedDisc),
//                .muscleCondition(.muscleStrain(.back(.latissimus))),
//                .muscleCondition(.muscleStrain(.back(.rhomboids))),
//                .muscleCondition(.muscleStrain(.back(.teresmajor))),
//                .muscleCondition(.muscleStrain(.biceps(.shorthead))),
//                .muscleCondition(.muscleStrain(.biceps(.longhead))),
//                .muscleCondition(.muscleStrain(.forearms(.brachioradialis))),
//                .muscleCondition(.muscleStrain(.traps(.lower)))
//            ],
//            equipmentRequired: [.resistance(.cable), .resistance(.machine(.latPulldown))],
//            musclesTargeted: [
//                MuscleWeightage(type: .agonist, muscle: .back(.latissimus), weightage: 0.40),
//                MuscleWeightage(type: .synergist, muscle: .back(.rhomboids), weightage: 0.15),
//                MuscleWeightage(type: .synergist, muscle: .back(.teresmajor), weightage: 0.15),
//                MuscleWeightage(type: .synergist, muscle: .biceps(.shorthead), weightage: 0.10),
//                MuscleWeightage(type: .synergist, muscle: .biceps(.longhead), weightage: 0.10),
//                MuscleWeightage(type: .stabilizer, muscle: .forearms(.brachioradialis), weightage: 0.05),
//                MuscleWeightage(type: .stabilizer, muscle: .traps(.lower), weightage: 0.05)
//            ]
//        ))
//        
//        // 3. Dumbbell Incline Bicep Curls
//        list.append(Exercise(
//            name: "Dumbbell Incline Bicep Curls",
//            movement: .regular,
//            angle: .incline,
//            laterality: .bilateral,
//            focus: .strengthen,
//            impact: 4.0,
//            rating: 7.0,
//            restrictions: [
//                .joint(.tendonitis),
//                .joint(.carpalTunnelSyndrome),
//                .muscleCondition(.muscleStrain(.biceps(.shorthead))),
//                .muscleCondition(.muscleStrain(.biceps(.longhead))),
//                .muscleCondition(.muscleStrain(.biceps(.brachialis))),
//                .muscleCondition(.muscleStrain(.forearms(.brachioradialis))),
//                .muscleCondition(.muscleStrain(.forearms(.flexors)))
//            ],
//            equipmentRequired: [.resistance(.dumbbell), .bench],
//            musclesTargeted: [
//                MuscleWeightage(type: .agonist, muscle: .biceps(.longhead), weightage: 0.40),
//                MuscleWeightage(type: .agonist, muscle: .biceps(.shorthead), weightage: 0.30),
//                MuscleWeightage(type: .synergist, muscle: .biceps(.brachialis), weightage: 0.15),
//                MuscleWeightage(type: .stabilizer, muscle: .forearms(.brachioradialis), weightage: 0.10),
//                MuscleWeightage(type: .stabilizer, muscle: .forearms(.flexors), weightage: 0.05)
//            ]
//        ))
//        
//        // 4. EZ-Bar Preacher Curls
//        list.append(Exercise(
//            name: "EZ-Bar Preacher Curls",
//            movement: .regular,
//            angle: .decline,
//            laterality: .bilateral,
//            focus: .strengthen,
//            impact: 5.0,
//            rating: 7.5,
//            restrictions: [
//                .joint(.tendonitis),
//                .joint(.carpalTunnelSyndrome),
//                .muscleCondition(.muscleStrain(.biceps(.shorthead))),
//                .muscleCondition(.muscleStrain(.biceps(.longhead))),
//                .muscleCondition(.muscleStrain(.biceps(.brachialis))),
//                .muscleCondition(.muscleStrain(.forearms(.brachioradialis))),
//                .muscleCondition(.muscleStrain(.forearms(.flexors)))
//            ],
//            equipmentRequired: [.resistance(.ezbar), .resistance(.machine(.preacherCurl))],
//            musclesTargeted: [
//                MuscleWeightage(type: .agonist, muscle: .biceps(.shorthead), weightage: 0.40),
//                MuscleWeightage(type: .agonist, muscle: .biceps(.longhead), weightage: 0.30),
//                MuscleWeightage(type: .synergist, muscle: .biceps(.brachialis), weightage: 0.15),
//                MuscleWeightage(type: .stabilizer, muscle: .forearms(.brachioradialis), weightage: 0.10),
//                MuscleWeightage(type: .stabilizer, muscle: .forearms(.flexors), weightage: 0.05)
//            ]
//        ))
//    }
//
//}
