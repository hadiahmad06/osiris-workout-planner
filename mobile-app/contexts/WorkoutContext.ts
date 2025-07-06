import { ExerciseSessionSchema } from '@/utils/schema/ExerciseSession';
import { SetSessionSchema } from '@/utils/schema/SetSession';
import { WorkoutSessionSchema } from '@/utils/schema/WorkoutSession';
import React, { createContext, useContext, useState } from 'react';
import { z } from 'zod';

type WorkoutSession = z.infer<typeof WorkoutSessionSchema>;
type ExerciseSession = z.infer<typeof ExerciseSessionSchema>;
type SetSession = z.infer<typeof SetSessionSchema>;

type WorkoutContextType = {
  workout: WorkoutSession | null;
  exercises: ExerciseSession[];
  sets: Record<string, SetSession[]>; // key = exercise_session_id
  setWorkout: (workout: WorkoutSession | null) => void;
  addExercise: (exercise: ExerciseSession) => void;
  updateExercise: (exercise: ExerciseSession) => void;
  removeExercise: (exerciseId: string) => void;
  addSet: (exerciseSessionId: string, set: SetSession) => void;
  updateSet: (exerciseSessionId: string, setIndex: number, updatedSet: SetSession) => void;
  removeSet: (exerciseSessionId: string, setIndex: number) => void;
};

export const WorkoutContext = createContext<WorkoutContextType | undefined>(undefined);

export const useWorkout = () => {
  const context = useContext(WorkoutContext);
  if (!context) throw new Error('useWorkout must be used within a WorkoutProvider');
  return context;
};