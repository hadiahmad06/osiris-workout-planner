import { WorkoutSession } from '@/utils/schema/WorkoutSession';
import React, { createContext, useContext, useState, useEffect } from 'react';


type HistoryContextType = {
  workouts: WorkoutSession[];
  fetchWorkouts: () => Promise<void>;
  getWorkoutByDate: (date: string) => WorkoutSession | undefined;
  getWorkoutsInRange: (startDate: string, endDate: string) => WorkoutSession[];
};

export const HistoryContext = createContext<HistoryContextType | undefined>(undefined);

export const useHistory = (): HistoryContextType => {
  const context = useContext(HistoryContext);
  if (!context) throw new Error('useHistory must be used within a HistoryProvider');
  return context;
};