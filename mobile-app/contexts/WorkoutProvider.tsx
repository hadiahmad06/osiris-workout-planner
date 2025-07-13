import { ExerciseSession } from "@/utils/schema/ExerciseSession";
import { SetSession } from "@/utils/schema/SetSession";
import { WorkoutSession } from "@/utils/schema/WorkoutSession";
import { startTransition, useState } from "react";
import { WorkoutContext } from "./WorkoutContext";
import { enrichExercise } from "@/repositories/workouts/Exercise";
import { ExerciseApi } from "@/utils/schema/Exercise";
import 'react-native-get-random-values';
import { v4 as uuidv4 } from "uuid";


export interface EnrichedExerciseSession extends ExerciseSession {
  info: ExerciseApi | null
};


export const WorkoutProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [workout, setWorkout] = useState<WorkoutSession | null>(null);
  const [exercises, setExercises] = useState<EnrichedExerciseSession[]>([]);
  const [sets, setSets] = useState<Record<string, SetSession[]>>({});

  const startWorkout = async (title?: string, exercises: string[] = []) => {
    const now = new Date().toISOString();
    console.log(typeof uuidv4)
    try {
      const workoutId = uuidv4();
      console.log("Workout ID:", workoutId);
    } catch (err) {
      console.error("Failed to generate UUID:", err);
    }
    const workoutId = "1";
    const newWorkout: WorkoutSession = {
      id: workoutId,
      date: now,
      title
    };

    setWorkout(newWorkout);

    setExercises([]);

    for (let i = 0; i < exercises.length; i++) {
      const exerciseSession: ExerciseSession = {
        id: uuidv4(),
        workout_id: workoutId,
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
    addSet(exercise.id, 0);
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

  const addSet = (exerciseSessionId: string, insertAt: number) => {
    const newSet: SetSession = {
      id: uuidv4(),
      exercise_session_id: exerciseSessionId,
      notes: '',
      toRecord: true,
    };

    startTransition(() => {
      setSets(prev => {
        const existingSets = prev[exerciseSessionId] ?? [];
        const updated = [
          ...existingSets.slice(0, insertAt),
          newSet,
          ...existingSets.slice(insertAt)
        ];
        return {
          ...prev,
          [exerciseSessionId]: updated,
        };
      });
    })
  };

  const updateSet = (
    exerciseSessionId: string,
    setIndex: number,
    updatedSet: Partial<SetSession>
  ) => {
    setSets(prev => ({
      ...prev,
      [exerciseSessionId]: prev[exerciseSessionId].map((s, i) =>
        i === setIndex ? { ...s, ...updatedSet } : s
      ),
    }));
  };

  const removeSet = (
    exerciseSessionId: string,
    setIndex: number,
  ): number | undefined => {
    let newSelectedIndex: number | undefined = undefined;

    setSets(prev => {
      const currentSets = prev[exerciseSessionId];
      console.log(currentSets.length)
      if (!currentSets) return prev;

      const updatedSets = [...currentSets];

      if (updatedSets.length === 1) {
        updatedSets[0] = {
          ...updatedSets[0],
          notes: '',
          rir: undefined,
          reps: undefined,
          weight: undefined,
        };
        newSelectedIndex = 0;
        return { ...prev, [exerciseSessionId]: updatedSets };
      }

      updatedSets.splice(setIndex, 1);

      newSelectedIndex = updatedSets[setIndex] ? setIndex : (setIndex > 0 ? setIndex - 1 : 0);

      return {
        ...prev,
        [exerciseSessionId]: updatedSets,
      };
    });

    return newSelectedIndex;
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