package main

import (
	"log"
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/joho/godotenv"
	"github.com/hadiahmad06/anabolic-api/db"
	"github.com/hadiahmad06/anabolic-api/handlers"
)

func main() {
	// Load environment variables
	err := godotenv.Load()
	if err != nil {
		log.Println("No .env file found or error loading it")
	}

	// Init DB connection
	db.Init()

	// Start router
	r := chi.NewRouter()

	// Health check route
	r.Get("/health", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("API is up and running"))
	})
	r.Get("/exercises", handlers.GetExercises)

	log.Println("Starting server on :8080")
	http.ListenAndServe(":8080", r)
}