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

class WorkoutPlan: Identifiable {
    private static var nextID: Int = 0
    private static let idQueue = DispatchQueue(label: "com.myApp.objectIDQueue")
    var id: Int
    
    var text: String
    var symbol: Bool
    var exercises: [Exercise]

    init (text: String, s: Bool = false) {
        self.text = text
        self.symbol = s
        exercises = []
        self.id = WorkoutPlan.idQueue.sync {
            let currentID = WorkoutPlan.nextID
            WorkoutPlan.nextID += 1
            return currentID
        }
    }
    
    func addExercise(exercise: Exercise, index: Int) -> FunctionResult {
            // Check if the index is valid
            if index < 0 || index > exercises.count {
                return .failure
            }
            
            // Check if the exercise is already in the workout plan
            if exercises.contains(where: { $0.id == exercise.id }) {
                return .failure
            }
            
            // Insert the exercise at the specified index and shift the others
            exercises.insert(exercise, at: index)
            return .success
        }
}



enum Muscle: Equatable {
    enum Biceps: Equatable {       case shorthead, longhead, brachialis    }
    enum Triceps: Equatable {      case lateralhead, longhead, medialhead  }
    enum Chest: Equatable {        case upper, middle, lower, inner, outer }
    enum Deltoids: Equatable {     case anteriordeltoid, posteriordeltoid, lateraldeltoid  }
    enum Back: Equatable {         case latissimus, rhomboids, teresmajor, infraspinatus   }
    enum Quadriceps: Equatable {   case rectusfemoris, vastuslateralis, vastusmedialis, vastusintermedius  }
    enum Hamstrings: Equatable {   case semitendinosus, semimembranosus, bicepsfemoris     }
    enum Glutes: Equatable {       case gluteusmaximus, gluteusmedius, gluteusminimus, tensorfascialata    }
    enum Calves: Equatable {       case gastrocnemius, soleus  }
    enum Forearms: Equatable {     case brachioradialis, flexors, extensors    }
    enum Traps: Equatable {        case upper, middle, lower   }
    enum Abs: Equatable {          case rectusabdominis, obliques, transverseabdominis }
    case biceps(Biceps)
    case triceps(Triceps)
    case chest(Chest)
    case deltoids(Deltoids)
    case back(Back)
    case quadriceps(Quadriceps)
    case hamstrings(Hamstrings)
    case glutes(Glutes)
    case calves(Calves)
    case forearms(Forearms)
    case traps(Traps)
    case abs(Abs)
    
    static func ==(lhs: Muscle, rhs: Muscle) -> Bool {
        switch (lhs, rhs) {
        case (.biceps(let left), .biceps(let right)):
            return left == right
        case (.triceps(let left), .triceps(let right)):
            return left == right
        case (.chest(let left), .chest(let right)):
            return left == right
        case (.deltoids(let left), .deltoids(let right)):
            return left == right
        case (.back(let left), .back(let right)):
            return left == right
        case (.quadriceps(let left), .quadriceps(let right)):
            return left == right
        case (.hamstrings(let left), .hamstrings(let right)):
            return left == right
        case (.glutes(let left), .glutes(let right)):
            return left == right
        case (.calves(let left), .calves(let right)):
            return left == right
        case (.forearms(let left), .forearms(let right)):
            return left == right
        case (.traps(let left), .traps(let right)):
            return left == right
        case (.abs(let left), .abs(let right)):
            return left == right
        default:
            return false
        }
    }
}

enum MovementType {
    case isometric, eccentric, negative, regular
}
enum Angle {
    case regular, incline, decline
}
enum Laterality {
    case bilateral, unilateral, both
}
enum Focus {
    case stretch, strengthen, warmup, cooldown
}
enum Equipment {
    enum Resistance {
        case cable, machine(Machine), dumbbell, barbell, ezbar, banded, kettlebell, calisthenic
        enum Machine {
            // Upper Body Machines
            case pecFly
            case rearDeltFly
            case chestPress
            case shoulderPress
            case latPulldown
            case seatedRow
            case bicepCurl
            case tricepPushdown
            case preacherCurl
            case hackSquat
            case legExtension
            case legCurl
            case calfRaise
            case legPress
            case adductor
            case abductor
            case cableCrossover
            case cableRow
            case inclinePress
            case declinePress
            case cablePullover
            case seatedChestPress
            case cableTricepExtension
            case machineCrunch
            case seatedLegPress
            case pecDeck
            case smithMachine
            case gluteKickback
            case machinePullOver
            case reverseFly
            
            // Lower Body Machines
            case legPressMachine
            case seatedLegCurl
            case standingCalfRaise
            case gluteHamRaise
            case hipThrustMachine
            case smithSquatMachine
            case abMachine
            case multiHipMachine
            case verticalLegPress
            case legSled
            case gluteMachine
        }
    }
    case resistance(Resistance)
    case bench, pullupbar, dipbar
}

enum Condition: Equatable {
    enum Joint: Equatable {
        case arthritis
        case osteoarthritis
        case rheumatoidArthritis
        case gout
        case tendonitis
        case bursitis
        case sprain
        case strain
        case dislocation
        case frozenShoulder
        case carpalTunnelSyndrome
        case meniscusTear
        case ligamentTear
        case rotatorCuffInjury
        case hipLabralTear
        case kneePatellarTracking
        case ligamentSprain
        case shoulderInstability
        case jointEffusion
        case dislocatedKnee
        case dislocatedHip
    }

    enum MuscleCondition: Equatable {
        case muscleTear(Muscle)
        case muscleStrain(Muscle)
        case muscleCramps(Muscle)
        case muscleWeakness(Muscle)
        case muscleFatigue(Muscle)
        case muscleImbalance(Muscle)
        case myositis(Muscle)
        case fibromyalgia(Muscle)
        case polymyositis(Muscle)
        case rhabdomyolysis(Muscle)
        case sarcopenia(Muscle)
    }

    enum Back: Equatable {
        case herniatedDisc
        case sciatica
        case degenerativeDiscDisease
        case spinalStenosis
        case spondylolisthesis
        case scoliosis
        case lordosis
        case kyphosis
        case slippedDisc
        case facetJointSyndrome
    }

    enum Cardiovascular: Equatable {
        case heartDisease
        case hypertension
        case arrhythmia
        case coronaryArteryDisease
        case congestiveHeartFailure
        case stroke
        case peripheralArteryDisease
        case aorticAneurysm
        case pulmonaryHypertension
        case deepVeinThrombosis
    }

    enum Respiratory: Equatable {
        case asthma
        case chronicObstructivePulmonaryDisease
        case emphysema
        case chronicBronchitis
        case pneumonia
        case bronchiectasis
        case interstitialLungDisease
        case pulmonaryFibrosis
        case pulmonaryEdema
        case lungCancer
    }

    enum Metabolic: Equatable {
        case diabetes
        case hyperthyroidism
        case hypothyroidism
        case hypoglycemia
        case hyperglycemia
        case obesity
        case metabolicSyndrome
        case polycysticOvarianSyndrome
    }

    enum Neurological: Equatable {
        case stroke
        case multipleSclerosis
        case epilepsy
        case ParkinsonsDisease
        case cerebralPalsy
        case neuropathy
        case Alzheimer
        case HuntingtonDisease
        case BellPalsy
        case traumaticBrainInjury
        case spinalCordInjury
        case concussion
    }

    enum Immunity: Equatable {
        case lupus
        case multipleSclerosis
        case psoriasis
        case rheumatoidArthritis
        case ankylosingSpondylitis
        case celiacDisease
        case type1Diabetes
        case CrohnsDisease
        case ulcerativeColitis
        case HashimotosThyroiditis
    }

    enum Pregnancy: Equatable {
        case earlyPregnancy
        case thirdTrimester
        case highRiskPregnancy
        case pelvicPain
        case roundLigamentPain
        case preeclampsia
        case gestationalDiabetes
    }

    enum PostSurgical: Equatable {
        case kneeReplacement
        case hipReplacement
        case shoulderSurgery
        case spinalFusion
        case ACLReconstruction
        case rotatorCuffSurgery
        case carpalTunnelSurgery
        case herniaRepair
        case jointReconstruction
        case abdominalSurgery
        case bypassSurgery
        case gallbladderSurgery
        case cesareanSection
        case hysterectomy
    }

    enum Other: Equatable {
        case fatigue
        case dizziness
        case vertigo
        case dehydration
        case anemia
        case insomnia
        case malnutrition
        case stress
        case anxiety
        case depression
        case chronicPain
        case fibromyalgia
    }
    case joint(Joint)
    case muscleCondition(MuscleCondition)
    case back(Back)
    case cardiovascular(Cardiovascular)
    case respiratory(Respiratory)
    case metabolic(Metabolic)
    case neurological(Neurological)
    case immunity(Immunity)
    case pregnancy(Pregnancy)
    case postSurgical(PostSurgical)
    case other(Other)
    
    static func ==(lhs: Condition, rhs: Condition) -> Bool {
            switch (lhs, rhs) {
            case (.joint(let left), .joint(let right)):
                return left == right
            case (.muscleCondition(let left), .muscleCondition(let right)):
                return left == right
            case (.back(let left), .back(let right)):
                return left == right
            case (.cardiovascular(let left), .cardiovascular(let right)):
                return left == right
            case (.respiratory(let left), .respiratory(let right)):
                return left == right
            case (.metabolic(let left), .metabolic(let right)):
                return left == right
            case (.neurological(let left), .neurological(let right)):
                return left == right
            case (.immunity(let left), .immunity(let right)):
                return left == right
            case (.pregnancy(let left), .pregnancy(let right)):
                return left == right
            case (.postSurgical(let left), .postSurgical(let right)):
                return left == right
            case (.other(let left), .other(let right)):
                return left == right
            default:
                return false
            }
        }
}

struct MuscleWeightage {
    var type: muscleRole
    var muscle: Muscle
    var weightage: Double
}

enum muscleRole {
    case agonist, synergist, stabilizer
}

class Exercise: Identifiable, Equatable {
    private static var nextID: Int = 0
    private static let idQueue = DispatchQueue(label: "com.myApp.objectIDQueue")
    
    var id: Int
    
    var name: String
    var movement: MovementType                  // isometric, eccentric, regular
    var angle: Angle                            // incline, decline, etc
    var laterality: Laterality                  // unilateral, bilateral, both
    var focus: Focus                            // strengthen vs stretch
    var impact: Double                          // impact on joints represented as a double value
    var rating: Double                          // rating of how easy it is to learn as a double value
    var progressions: [Exercise]                // exercises with similar musclesTargeted, but higher rating, eg: Knee Pushups -> Pushups
    var regressions: [Exercise]                 // exercises with similar musclesTargeted, but lower rating, eg: Pushups -> Knee Pushups
    var restrictions: [Condition]               // conditions which could prevent an exercise from being perfomed, ie: Back Squat -> Torn ACL
    var similarExercises: [Exercise]            // similar exercises (Barbell Back Squat -> Dumbbell Bulgarian Split Squat)
    var equipmentRequired: [Equipment]          // equipment required to perform the exercise
    var musclesTargeted: [MuscleWeightage]      // muscle heads that are targeted in said exercise
    

    init(name: String, movement: MovementType, angle: Angle, laterality: Laterality, focus: Focus, impact: Double, rating: Double, progressions: [Exercise] = [], regressions: [Exercise] = [], restrictions: [Condition] = [], similarExercises: [Exercise] = [], equipmentRequired: [Equipment], musclesTargeted: [MuscleWeightage]) {
        self.name = name
        self.movement = movement
        self.angle = angle
        self.laterality = laterality
        self.focus = focus
        self.impact = impact
        self.rating = rating
        self.progressions = progressions
        self.regressions = regressions
        self.restrictions = restrictions
        self.similarExercises = similarExercises
        self.equipmentRequired = equipmentRequired
        self.musclesTargeted = musclesTargeted
        
        self.id = Exercise.idQueue.sync {
            let currentID = Exercise.nextID
            Exercise.nextID += 1
            return currentID
        }
    }

    func addTargetedMuscle(weightage: MuscleWeightage) -> FunctionResult {
        if self.musclesTargeted.contains(where: {$0.muscle == weightage.muscle} ) {
            return .failure
        }
        musclesTargeted.append(weightage)
        return .success
    }
    func addRestriction(restriction: Condition) -> FunctionResult {
        if self.restrictions.contains(where: {$0 == restriction} ) {
            return .failure
        }
        self.restrictions.append(restriction)
        return .success
    }
    func addSimilarExercise(exercise: Exercise) -> FunctionResult {
        if self.similarExercises.contains(where: {$0 == exercise} ) {
            return .failure
        }
        self.similarExercises.append(exercise)
        return .success
    }
    func addProgression(progression: Exercise) -> FunctionResult {
        if self.progressions.contains(where: {$0 == progression} ) {
            return .failure
        }
        self.progressions.append(progression)
        return .success
    }
    func addRegression(regression: Exercise) -> FunctionResult {
        if self.regressions.contains(where: {$0 == regression} ) {
            return .failure
        }
        self.regressions.append(regression)
        return .success
    }
    
    static func ==(lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Exercises {
    var list: [Exercise]
    init() {
        list = []
        list.append(Exercise(
            name: "Barbell Back Squat",
            movement: .regular,
            angle: .regular,
            laterality: .bilateral,
            focus: .strengthen,
            impact: 8.0,
            rating: 7.5,
            restrictions: [
                .joint(.kneePatellarTracking),
                .joint(.hipLabralTear),
                .joint(.ligamentSprain),
                .back(.spinalStenosis),
                .joint(.arthritis),
                .joint(.meniscusTear),
                .back(.herniatedDisc),
                .back(.sciatica),
                .muscleCondition(.muscleStrain(.quadriceps(.rectusfemoris))),
                .muscleCondition(.muscleStrain(.quadriceps(.vastuslateralis))),
                .muscleCondition(.muscleStrain(.quadriceps(.vastusmedialis))),
                .muscleCondition(.muscleStrain(.quadriceps(.vastusintermedius))),
                .muscleCondition(.muscleStrain(.hamstrings(.semitendinosus))),
                .muscleCondition(.muscleStrain(.hamstrings(.bicepsfemoris))),
                .muscleCondition(.muscleStrain(.glutes(.gluteusmaximus))),
                .muscleCondition(.muscleStrain(.abs(.rectusabdominis))),
                .muscleCondition(.muscleStrain(.traps(.middle)))
            ],
            equipmentRequired: [.resistance(.barbell)],
            musclesTargeted: [
                MuscleWeightage(type: .agonist, muscle: .quadriceps(.rectusfemoris), weightage: 0.35),
                MuscleWeightage(type: .agonist, muscle: .quadriceps(.vastuslateralis), weightage: 0.25),
                MuscleWeightage(type: .agonist, muscle: .quadriceps(.vastusmedialis), weightage: 0.20),
                MuscleWeightage(type: .agonist, muscle: .quadriceps(.vastusintermedius), weightage: 0.15),
                MuscleWeightage(type: .synergist, muscle: .hamstrings(.semitendinosus), weightage: 0.10),
                MuscleWeightage(type: .synergist, muscle: .hamstrings(.bicepsfemoris), weightage: 0.10),
                MuscleWeightage(type: .synergist, muscle: .glutes(.gluteusmaximus), weightage: 0.20),
                MuscleWeightage(type: .stabilizer, muscle: .abs(.rectusabdominis), weightage: 0.10),
                MuscleWeightage(type: .stabilizer, muscle: .traps(.middle), weightage: 0.05)
            ]
        ))
        
        // 2. Cable Lat Pulldown
        list.append(Exercise(
            name: "Cable Lat Pulldown",
            movement: .regular,
            angle: .regular,
            laterality: .bilateral,
            focus: .strengthen,
            impact: 6.0,
            rating: 8.0,
            restrictions: [
                .joint(.rotatorCuffInjury),
                .joint(.shoulderInstability),
                .joint(.frozenShoulder),
                .back(.herniatedDisc),
                .muscleCondition(.muscleStrain(.back(.latissimus))),
                .muscleCondition(.muscleStrain(.back(.rhomboids))),
                .muscleCondition(.muscleStrain(.back(.teresmajor))),
                .muscleCondition(.muscleStrain(.biceps(.shorthead))),
                .muscleCondition(.muscleStrain(.biceps(.longhead))),
                .muscleCondition(.muscleStrain(.forearms(.brachioradialis))),
                .muscleCondition(.muscleStrain(.traps(.lower)))
            ],
            equipmentRequired: [.resistance(.cable), .resistance(.machine(.latPulldown))],
            musclesTargeted: [
                MuscleWeightage(type: .agonist, muscle: .back(.latissimus), weightage: 0.40),
                MuscleWeightage(type: .synergist, muscle: .back(.rhomboids), weightage: 0.15),
                MuscleWeightage(type: .synergist, muscle: .back(.teresmajor), weightage: 0.15),
                MuscleWeightage(type: .synergist, muscle: .biceps(.shorthead), weightage: 0.10),
                MuscleWeightage(type: .synergist, muscle: .biceps(.longhead), weightage: 0.10),
                MuscleWeightage(type: .stabilizer, muscle: .forearms(.brachioradialis), weightage: 0.05),
                MuscleWeightage(type: .stabilizer, muscle: .traps(.lower), weightage: 0.05)
            ]
        ))
        
        // 3. Dumbbell Incline Bicep Curls
        list.append(Exercise(
            name: "Dumbbell Incline Bicep Curls",
            movement: .regular,
            angle: .incline,
            laterality: .bilateral,
            focus: .strengthen,
            impact: 4.0,
            rating: 7.0,
            restrictions: [
                .joint(.tendonitis),
                .joint(.carpalTunnelSyndrome),
                .muscleCondition(.muscleStrain(.biceps(.shorthead))),
                .muscleCondition(.muscleStrain(.biceps(.longhead))),
                .muscleCondition(.muscleStrain(.biceps(.brachialis))),
                .muscleCondition(.muscleStrain(.forearms(.brachioradialis))),
                .muscleCondition(.muscleStrain(.forearms(.flexors)))
            ],
            equipmentRequired: [.resistance(.dumbbell), .bench],
            musclesTargeted: [
                MuscleWeightage(type: .agonist, muscle: .biceps(.longhead), weightage: 0.40),
                MuscleWeightage(type: .agonist, muscle: .biceps(.shorthead), weightage: 0.30),
                MuscleWeightage(type: .synergist, muscle: .biceps(.brachialis), weightage: 0.15),
                MuscleWeightage(type: .stabilizer, muscle: .forearms(.brachioradialis), weightage: 0.10),
                MuscleWeightage(type: .stabilizer, muscle: .forearms(.flexors), weightage: 0.05)
            ]
        ))
        
        // 4. EZ-Bar Preacher Curls
        list.append(Exercise(
            name: "EZ-Bar Preacher Curls",
            movement: .regular,
            angle: .decline,
            laterality: .bilateral,
            focus: .strengthen,
            impact: 5.0,
            rating: 7.5,
            restrictions: [
                .joint(.tendonitis),
                .joint(.carpalTunnelSyndrome),
                .muscleCondition(.muscleStrain(.biceps(.shorthead))),
                .muscleCondition(.muscleStrain(.biceps(.longhead))),
                .muscleCondition(.muscleStrain(.biceps(.brachialis))),
                .muscleCondition(.muscleStrain(.forearms(.brachioradialis))),
                .muscleCondition(.muscleStrain(.forearms(.flexors)))
            ],
            equipmentRequired: [.resistance(.ezbar), .resistance(.machine(.preacherCurl))],
            musclesTargeted: [
                MuscleWeightage(type: .agonist, muscle: .biceps(.shorthead), weightage: 0.40),
                MuscleWeightage(type: .agonist, muscle: .biceps(.longhead), weightage: 0.30),
                MuscleWeightage(type: .synergist, muscle: .biceps(.brachialis), weightage: 0.15),
                MuscleWeightage(type: .stabilizer, muscle: .forearms(.brachioradialis), weightage: 0.10),
                MuscleWeightage(type: .stabilizer, muscle: .forearms(.flexors), weightage: 0.05)
            ]
        ))
    }

}
