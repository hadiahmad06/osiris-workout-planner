


# Vectra

Vectra is a monorepo for a full-stack hypertrophy-focused workout tracking ecosystem. It includes a mobile app, a backend API, and a data scraper.

---

## 📦 Monorepo Structure

```
vectra/
├── app/       # React Native mobile app for users to log workouts and visualize progress
├── api/       # Golang backend API that connects to Supabase and manages exercise metadata
├── scraper/   # (WIP) Scraper to populate the exercise database from external sources like exrx.net
```

---

## ✅ What’s Done So Far

### 🧠 Project Setup
- Initialized monorepo named `vectra`
- Cleaned out subrepos and nested Git state
- Renamed API to `api/`, mobile app to `app/`, and scraper to `scraper/`

### 🔧 Backend API (`/api`)
- Created in Go
- Connected to Supabase
- Health check route (`/health`) working
- Defined full `ExerciseApi` struct to match Zod schema on frontend
- Ready for additional routes and DB integration

### 📱 Mobile App (`/app`)
- Placeholder structure for React Native project

### 🔍 Scraper (`/scraper`)
- Planning to scrape [exrx.net/Lists/Directory](https://exrx.net/Lists/Directory)
- Will output structured exercise data for ingestion into DB

---

## 🛣️ Next Steps
- Build out actual API endpoints (CRUD for exercises)
- Implement Supabase logic for storing relevance/user data
- Build scraper and seed the database
- Build core UI in mobile app for viewing/logging exercises

---

## ⚙️ Tech Stack

- Go (API)
- Supabase (DB/auth)
- React Native (Mobile)
- Possibly Python or Go (Scraper)

---

## 🧪 Local Dev

To start API:

```bash
cd api
go run main.go
```

To run scraper (once built):

```bash
cd scraper
# run python or go script
```

Mobile app and deployment coming soon.