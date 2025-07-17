package models

type ExerciseApi struct {
	ExerciseID         string   `json:"exerciseId"`
	Name               string   `json:"name"`
	// ImageURL           *string  `json:"imageUrl,omitempty"`
	Equipments         []string `json:"equipments"`
	BodyParts          []string `json:"bodyParts"`
	ExerciseType       string   `json:"exerciseType"`
	TargetMuscles      []string `json:"targetMuscles"`
	SecondaryMuscles   []string `json:"secondaryMuscles,omitempty"`
	// VideoURL           *string  `json:"videoUrl,omitempty"`
	Keywords           []string `json:"keywords,omitempty"`
	Overview           *string  `json:"overview,omitempty"`
	Instructions       []string `json:"instructions,omitempty"`
	ExerciseTips       []string `json:"exerciseTips,omitempty"`
	Variations         []string `json:"variations,omitempty"`
	RelatedExerciseIDs []string `json:"relatedExerciseIds,omitempty"`
}