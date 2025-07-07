import { ExerciseSession } from "@/utils/schema/ExerciseSession";
import { SetSession } from "@/utils/schema/SetSession";
import { WorkoutSession } from "@/utils/schema/WorkoutSession";
import { useState } from "react";
import { WorkoutContext } from "./WorkoutContext";
import { enrichExercise } from "@/repositories/workouts/Exercise";
import { ExerciseApi } from "@/utils/schema/Exercise";


export interface EnrichedExerciseSession extends ExerciseSession {
  info: ExerciseApi | null
};


export const WorkoutProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [workout, setWorkout] = useState<WorkoutSession | null>(null);
  const [exercises, setExercises] = useState<EnrichedExerciseSession[]>([]);
  const [sets, setSets] = useState<Record<string, SetSession[]>>({});

  const startWorkout = async (title?: string, exercises: string[] = []) => {
    const now = new Date().toISOString();

    const newWorkout: WorkoutSession = {
      date: now,
      title
    };

    setWorkout(newWorkout);

    setExercises([]);

    for (let i = 0; i < exercises.length; i++) {
      const exerciseSession: ExerciseSession = {
        exercise_id: exercises[i],
        order: i,
      };
      await addExercise(exerciseSession);
      console.log(`DEBUG: added exercise: ${exercises[i]}`)
    }

    console.log('DEBUG: WORKOUTS FETCHED')
  };

  const addExercise = async (exercise: ExerciseSession) => {
    // Insert the bare exercise first
    setExercises(prev => [...prev, { ...exercise, info: null }]);

    // Then enrich it once the info is available
    const exerciseInfo = await enrichExercise(exercise.exercise_id);
    setExercises(prev =>
      prev.map(e =>
        e.exercise_id === exercise.exercise_id ? { ...e, info: exerciseInfo } : e
      )
    );
  };

  const updateExercise = (updated: ExerciseSession) => {
    setExercises(prev => prev.map(e => e.id === updated.id ? {...e, updated} : e));
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
        startWorkout,
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