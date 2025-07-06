

import { z } from 'zod';

export const ExerciseSessionSchema = z.object({
  id: z.string().uuid(),
  workout_id: z.string().uuid(),
  exercise_id: z.string().uuid(),
  order: z.number().min(1),
  notes: z.string().optional(),
//   created_at: z.string().datetime(),
//   updated_at: z.string().datetime(),
});

export type ExerciseSession = z.infer<typeof ExerciseSessionSchema>;