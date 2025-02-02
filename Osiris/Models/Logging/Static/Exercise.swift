//
//  Workout.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/25/24.
//
//  Contains the class "Exercise"
//  Contains data types for the parameters commented in the class

import Dispatch

class Exercise: Identifiable, Equatable, Codable {
//    private static var nextID: Int = 0
//    private static let idQueue = DispatchQueue(label: "com.myApp.objectIDQueue")
    
    var id: String
    
    var name: String
//    var movement: MovementType                  // isometric, eccentric, regular
    var angle: Angle                            // incline, decline, etc
    var laterality: Laterality                  // unilateral, bilateral, both
    var focus: Focus                            // strengthen vs stretch
    var impact: Double                          // impact on joints represented as a double value
    var rating: Double                          // rating of how easy it is to learn as a double value
    var progressions: [Exercise]                // exercises with similar musclesTargeted, but higher rating, eg: Knee Pushups -> Pushups
    var regressions: [Exercise]                 // exercises with similar musclesTargeted, but lower rating, eg: Pushups -> Knee Pushups
    var restrictions: [Condition]               // conditions which could prevent an exercise from being perfomed, ie: Back Squat -> Torn ACL
    var similarExercises: [Exercise]            // similar exercises (Barbell Back Squat -> Dumbbell Bulgarian Split Squat)
    var tags: [String]                          // search tags
    var equipmentRequired: [Equipment]          // equipment required to perform the exercise
    var musclesTargeted: [MuscleWeightage]      // muscle heads that are targeted in said exercise
    

    init(id: String, name: String, angle: Angle, laterality: Laterality, focus: Focus, impact: Double, rating: Double, progressions: [Exercise] = [], regressions: [Exercise] = [], restrictions: [Condition] = [], similarExercises: [Exercise] = [], tags: [String] = [], equipmentRequired: [Equipment], musclesTargeted: [MuscleWeightage]) {
        self.id = id
        self.name = name
//        self.movement = movement
        self.angle = angle
        self.laterality = laterality
        self.focus = focus
        self.impact = impact
        self.rating = rating
        self.progressions = progressions
        self.regressions = regressions
        self.restrictions = restrictions
        self.similarExercises = similarExercises
        self.tags = tags
        self.equipmentRequired = equipmentRequired
        self.musclesTargeted = musclesTargeted
        
//        self.id = Exercise.idQueue.sync {
//            let currentID = Exercise.nextID
//            Exercise.nextID += 1
//            return currentID
//        }
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

enum Muscle: Equatable, Codable {
    enum Biceps: Equatable, Codable {       case shorthead, longhead, brachialis    }
    enum Triceps: Equatable, Codable {      case lateralhead, longhead, medialhead  }
    enum Chest: Equatable, Codable {        case upper, middle, lower, inner, outer }
    enum Deltoids: Equatable, Codable {     case anteriordeltoid, posteriordeltoid, lateraldeltoid  }
    enum Back: Equatable, Codable {         case latissimus, rhomboids, teresmajor, infraspinatus   }
    enum Quadriceps: Equatable, Codable {   case rectusfemoris, vastuslateralis, vastusmedialis, vastusintermedius  }
    enum Hamstrings: Equatable, Codable {   case semitendinosus, semimembranosus, bicepsfemoris     }
    enum Glutes: Equatable, Codable {       case gluteusmaximus, gluteusmedius, gluteusminimus, tensorfascialata    }
    enum Calves: Equatable, Codable {       case gastrocnemius, soleus  }
    enum Forearms: Equatable, Codable {     case brachioradialis, flexors, extensors    }
    enum Traps: Equatable, Codable {        case upper, middle, lower   }
    enum Abs: Equatable, Codable {          case rectusabdominis, obliques, transverseabdominis }
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
    
    static func name(muscle: Muscle) -> String {
        switch muscle {
            case .biceps(let biceps): //prints the specific muscle head
                return "Biceps (\(biceps))"
            case .triceps(let triceps):
                return "Triceps (\(triceps))"
            case .chest(let chest):
                return "Chest (\(chest))"
            case .deltoids(let deltoids):
                return "Deltoids (\(deltoids))"
            case .back(let back):
                return "Back (\(back))"
            case .quadriceps(let quadriceps):
                return "Quadriceps (\(quadriceps))"
            case .hamstrings(let hamstrings):
                return "Hamstrings (\(hamstrings))"
            case .glutes(let glutes):
                return "Glutes (\(glutes))"
            case .calves(let calves):
                return "Calves (\(calves))"
            case .forearms(let forearms):
                return "Forearms (\(forearms))"
            case .traps(let traps):
                return "Traps (\(traps))"
            case .abs(let abs):
                return "Abs (\(abs))"
        }
    }
}

enum MovementType: Codable {
    case isometric, eccentric, negative, regular
    
    static func name(movementType: MovementType) -> String {
        switch movementType {
            case .isometric:
                return "Isometric"
            case .eccentric:
                return "Eccentric"
            case .negative:
                return "Negative"
            case .regular:
                return "Regular"
        }
    }
}
enum Angle: Codable {
    case regular, incline, decline
    
    static func name(angle: Angle) -> String {
        switch angle {
            case .regular:
                return "Regular"
            case .incline:
                return "Incline"
            case .decline:
                return "Decline"
        }
    }
}
enum Laterality: Codable {
    case bilateral, unilateral, both
    
    static func name(laterality: Laterality) -> String {
        switch laterality {
            case .bilateral:
                return "Bilateral"
            case .unilateral:
                return "Unilateral"
            case .both:
                return "Both"
        }
    }
}
enum Focus: Codable {
    case stretch, strengthen, warmup, cooldown
    
    static func name(focus: Focus) -> String {
        switch focus {
            case .stretch:
                return "Stretch"
            case .strengthen:
                return "Strengthen"
            case .warmup:
                return "Warmup"
            case .cooldown:
                return "Cooldown"
        }
    }
}
enum Equipment: Codable {
    enum Resistance: Codable {
        case cable, machine(Machine), dumbbell, barbell, ezbar, banded, kettlebell, calisthenic
        enum Machine: Codable {
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
    
    static func name(equipment: Equipment) -> String {
            switch equipment {
            case .resistance(.machine(let machine)):
                return "\(machine)" // prints the specific machine name (if it's a machine)
            case .resistance(.cable):
                return "Cable"
            case .resistance(.dumbbell):
                return "Dumbbell"
            case .resistance(.barbell):
                return "Barbell"
            case .resistance(.ezbar):
                return "EZ Bar"
            case .resistance(.banded):
                return "Banded"
            case .resistance(.kettlebell):
                return "Kettlebell"
            case .resistance(.calisthenic):
                return "Calisthenic"
            case .bench:
                return "Bench"
            case .pullupbar:
                return "Pull-up Bar"
            case .dipbar:
                return "Dip Bar"
            }
        }
}

enum Condition: Equatable, Codable {
    enum Joint: Equatable, Codable {
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

    enum MuscleCondition: Equatable, Codable {
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

    enum Back: Equatable, Codable {
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

    enum Cardiovascular: Equatable, Codable {
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

    enum Respiratory: Equatable, Codable {
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

    enum Metabolic: Equatable, Codable {
        case diabetes
        case hyperthyroidism
        case hypothyroidism
        case hypoglycemia
        case hyperglycemia
        case obesity
        case metabolicSyndrome
        case polycysticOvarianSyndrome
    }

    enum Neurological: Equatable, Codable {
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

    enum Immunity: Equatable, Codable {
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

    enum Pregnancy: Equatable, Codable {
        case earlyPregnancy
        case thirdTrimester
        case highRiskPregnancy
        case pelvicPain
        case roundLigamentPain
        case preeclampsia
        case gestationalDiabetes
    }

    enum PostSurgical: Equatable, Codable {
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

    enum Other: Equatable, Codable {
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
    
    static func name(condition: Condition) -> String { // NOT COMPLETE I WILL FIX WHEN IVE REDONE MY LIST
        switch condition {
        case .joint: return "Joint"
        case .muscleCondition: return "Muscle Condition"
        case .back: return "Back"
        case .cardiovascular: return "Cardiovascular"
        default: return "unspecified"
        }
    }
}

struct MuscleWeightage: Codable {
    var type: MuscleRole
    var muscle: Muscle
    var weightage: Double
}

enum MuscleRole: Codable {
    case agonist, synergist, stabilizer
    
    static func name(muscleRole: MuscleRole) -> String {
        switch muscleRole {
        case .agonist: return "Agonist"
        case .synergist: return "Synergist"
        case .stabilizer: return "Stabilizer"
        }
    }
}
