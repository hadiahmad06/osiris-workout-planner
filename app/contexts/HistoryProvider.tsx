import { CompleteWorkoutSession, WorkoutSession } from "@/utils/schema/WorkoutSession";
import { useEffect, useState } from "react";
import { HistoryContext } from "./HistoryContext";
import { getRecentWorkouts, getWorkoutsInTimeRange } from "@/repositories/workouts/Workout";


export const HistoryProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [workouts, setWorkouts] = useState<CompleteWorkoutSession[]>([]);

  const fetchWorkouts = async () => {
    // TODO: fetch from SQLite
    setWorkouts( await getRecentWorkouts() );
  };

const getWorkoutsInRange = async (startDate: Date, endDate?: Date) => {
  const start = new Date(startDate);
  start.setHours(0, 0, 0, 0);
  const startTime = start.toISOString();

  const end = new Date(endDate ?? startDate);
  end.setHours(23, 59, 59, 999);
  const endTime = end.toISOString();

  return await getWorkoutsInTimeRange(startTime, endTime);
};

  useEffect(() => {
    fetchWorkouts();
  }, []);

  return (
    <HistoryContext.Provider value={{ 
        workouts, 
        fetchWorkouts, 
        getWorkoutsInRange 
    }}>
      {children}
    </HistoryContext.Provider>
  );
};