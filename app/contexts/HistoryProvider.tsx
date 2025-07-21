import { WorkoutSession } from "@/utils/schema/WorkoutSession";
import { useEffect, useState } from "react";
import { HistoryContext } from "./HistoryContext";
import { getRecentWorkouts } from "@/repositories/workouts/Workout";


export const HistoryProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [workouts, setWorkouts] = useState<WorkoutSession[]>([]);

  const fetchWorkouts = async () => {
    // TODO: fetch from SQLite
    setWorkouts( await getRecentWorkouts() );
  };

  const getWorkoutByDate = (date: string) => workouts.find(w => w.date === date);

  const getWorkoutsInRange = (startDate: string, endDate: string) =>
    workouts.filter(w => w.date >= startDate && w.date <= endDate);

  useEffect(() => {
    fetchWorkouts();
  }, []);

  return (
    <HistoryContext.Provider value={{ 
        workouts, 
        fetchWorkouts, 
        getWorkoutByDate, 
        getWorkoutsInRange 
    }}>
      {children}
    </HistoryContext.Provider>
  );
};