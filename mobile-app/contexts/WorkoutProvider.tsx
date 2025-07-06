import { ExerciseSession } from "@/utils/schema/ExerciseSession";
import { SetSession } from "@/utils/schema/SetSession";
import { WorkoutSession } from "@/utils/schema/WorkoutSession";
import { useState } from "react";
import { WorkoutContext } from "./WorkoutContext";


export const WorkoutProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [workout, setWorkout] = useState<WorkoutSession | null>(null);
  const [exercises, setExercises] = useState<ExerciseSession[]>([]);
  const [sets, setSets] = useState<Record<string, SetSession[]>>({});

  const addExercise = (exercise: ExerciseSession) => {
    setExercises(prev => [...prev, exercise]);
  };

  const updateExercise = (updated: ExerciseSession) => {
    setExercises(prev => prev.map(e => e.id === updated.id ? updated : e));
  };

  const removeExercise = (exerciseId: string) => {
    setExercises(prev => prev.filter(e => e.id !== exerciseId));
    setSets(prev => {
      const updated = { ...prev };
      delete updated[exerciseId];
      return updated;
    });
  };

  const addSet = (exerciseSessionId: string, set: SetSession) => {
    setSets(prev => ({
      ...prev,
      [exerciseSessionId]: [...(prev[exerciseSessionId] || []), set],
    }));
  };

  const updateSet = (exerciseSessionId: string, setIndex: number, updatedSet: SetSession) => {
    setSets(prev => ({
      ...prev,
      [exerciseSessionId]: prev[exerciseSessionId].map((s, i) => i === setIndex ? updatedSet : s),
    }));
  };

  const removeSet = (exerciseSessionId: string, setIndex: number) => {
    setSets(prev => ({
      ...prev,
      [exerciseSessionId]: prev[exerciseSessionId].filter((_, i) => i !== setIndex),
    }));
  };

  return (
    <WorkoutContext.Provider
      value={{
        workout,
        exercises,
        sets,
        setWorkout,
        addExercise,
        updateExercise,
        removeExercise,
        addSet,
        updateSet,
        removeSet,
      }}
    >
      {children}
    </WorkoutContext.Provider>
  );
};