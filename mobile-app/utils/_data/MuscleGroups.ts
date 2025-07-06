
// Hierarchical muscle group structure
// from https://exrx.net/
export const MuscleGroups = [
  {
    name: "Chest",
    id: "chest",
    submuscles: [
      { name: "Pectoralis Major - Clavicular Head", id: "pec_major_clavicular" },
      { name: "Pectoralis Major - Sternal Head", id: "pec_major_sternal" },
      { name: "Pectoralis Minor", id: "pec_minor" },
      { name: "Serratus Anterior", id: "serratus_anterior" }
    ]
  },
  {
    name: "Back",
    id: "back",
    submuscles: [
      { name: "Latissimus Dorsi", id: "lats" },
      { name: "Teres Major", id: "teres_major" },
      { name: "Teres Minor", id: "teres_minor" },
      { name: "Infraspinatus", id: "infraspinatus" },
      { name: "Supraspinatus", id: "supraspinatus" },
      { name: "Rhomboids", id: "rhomboids" },
      { name: "Erector Spinae", id: "erector_spinae" },
      { name: "Quadratus Lumborum", id: "quadratus_lumborum" },
      { name: "Levator Scapulae", id: "levator_scapulae" },
      { name: "Subscapularis", id: "subscapularis" },
      { name: "Splenius", id: "splenius" }
    ]
  },
  {
    name: "Trapezius",
    id: "trapezius",
    submuscles: [
      { name: "Trapezius - Upper Fibers", id: "trapezius_upper" },
      { name: "Trapezius - Middle Fibers", id: "trapezius_middle" },
      { name: "Trapezius - Lower Fibers", id: "trapezius_lower" }
    ]
  },
  {
    name: "Deltoid",
    id: "deltoid",
    submuscles: [
      { name: "Anterior Deltoid", id: "deltoid_anterior" },
      { name: "Lateral Deltoid", id: "deltoid_lateral" },
      { name: "Posterior Deltoid", id: "deltoid_posterior" }
    ]
  },
  {
    name: "Biceps",
    id: "biceps",
    submuscles: [
      { name: "Biceps Brachii", id: "biceps_brachii" },
      { name: "Brachialis", id: "brachialis" },
      { name: "Coracobrachialis", id: "coracobrachialis" }
    ]
  },
  {
    name: "Triceps",
    id: "triceps",
    submuscles: [
      { name: "Triceps Brachii", id: "triceps_brachii" }
    ]
  },
  {
    name: "Forearms",
    id: "forearms",
    submuscles: [
      { name: "Brachioradialis", id: "brachioradialis" },
      { name: "Wrist Extensors", id: "wrist_extensors" },
      { name: "Wrist Flexors", id: "wrist_flexors" }
    ]
  },
  {
    name: "Core",
    id: "core",
    submuscles: [
      { name: "Rectus Abdominis", id: "rectus_abdominis" },
      { name: "Transverse Abdominus", id: "transverse_abdominus" },
      { name: "Obliques", id: "obliques" }
    ]
  },
  {
    name: "Glutes",
    id: "glutes",
    submuscles: [
      { name: "Gluteus Maximus", id: "gluteus_maximus" },
      { name: "Gluteus Medius", id: "gluteus_medius" },
      { name: "Gluteus Minimus", id: "gluteus_minimus" }
    ]
  },
  {
    name: "Legs",
    id: "legs",
    submuscles: [
      { name: "Quadriceps", id: "quadriceps" },
      { name: "Hamstrings", id: "hamstrings" },
      { name: "Adductors", id: "adductors" },
      { name: "Gastrocnemius", id: "gastrocnemius" },
      { name: "Soleus", id: "soleus" },
      { name: "Gracilis", id: "gracilis" },
      { name: "Sartorius", id: "sartorius" },
      { name: "Tensor Fasciae Latae", id: "tfl" },
      { name: "Popliteus", id: "popliteus" },
      { name: "Deep Hip External Rotators", id: "deep_hip_external_rotators" },
      { name: "Pectineus", id: "pectineus" },
      { name: "Iliopsoas", id: "iliopsoas" }
    ]
  },
  {
    name: "Calves & Tibialis",
    id: "calves",
    submuscles: [
      { name: "Tibialis Anterior", id: "tibialis_anterior" }
    ]
  },
  {
    name: "Neck",
    id: "neck",
    submuscles: [
      { name: "Sternocleidomastoid", id: "sternocleidomastoid" }
    ]
  },
  {
    name: "Misc",
    id: "misc",
    submuscles: [
      // Miscellaneous or accessory muscles
      { name: "Palmaris Longus", id: "palmaris_longus" },
      { name: "Plantaris", id: "plantaris" },
      { name: "Anconeus", id: "anconeus" },
      { name: "Abductor Pollicis Longus", id: "abductor_pollicis_longus" },
      { name: "Flexor Digitorum Superficialis", id: "flexor_digitorum_superficialis" },
      { name: "Extensor Digitorum", id: "extensor_digitorum" }
    ]
  }
];