import { WorkoutSession } from "@/utils/schema/WorkoutSession";
import { useEffect, useState } from "react";
import { HistoryContext } from "./HistoryContext";


export const HistoryProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [workouts, setWorkouts] = useState<WorkoutSession[]>([]);

  const fetchWorkouts = async () => {
    // TODO: fetch from SQLite
    const dummyWorkouts: WorkoutSession[] = [
      {
        id: '550e8400-e29b-41d4-a716-446655440000',
        date: '2025-07-06T10:00:00.000Z',
        duration: 3600,
        title: 'Push Day A',
        notes: 'Felt strong today, increased weight on bench press.',
        created_at: '2025-07-06T10:00:00.000Z',
        updated_at: '2025-07-06T11:00:00.000Z',
      },
    ];
    setWorkouts(dummyWorkouts);
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