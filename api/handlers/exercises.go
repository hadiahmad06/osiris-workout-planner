package handlers

import (
	"encoding/json"
	"net/http"
)

type Exercise struct {
	ID string `json:"id"`
	Name string `json:"name"`
}

func GetExercises(w http.ResponseWriter, r *http.Request) {
	exercises := []Exercise{
		{ID: "1", Name: "Bench Press"},
		{ID: "2", Name: "Squat"},
	}

	json.NewEncoder(w).Encode(exercises)
}