import { CompleteWorkoutSession, WorkoutSession } from '@/utils/schema/WorkoutSession';
import React, { createContext, useContext, useState, useEffect } from 'react';


type HistoryContextType = {
  workouts: CompleteWorkoutSession[];
  fetchWorkouts: () => Promise<void>;
  getWorkoutsInRange: (startDate: Date, endDate?: Date) => Promise<CompleteWorkoutSession[]>;
};

export const HistoryContext = createContext<HistoryContextType | undefined>(undefined);

export const useHistory = (): HistoryContextType => {
  const context = useContext(HistoryContext);
  if (!context) throw new Error('useHistory must be used within a HistoryProvider');
  return context;
};