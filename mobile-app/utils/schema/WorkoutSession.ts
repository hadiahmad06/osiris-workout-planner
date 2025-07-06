import { z } from 'zod';

export const WorkoutSessionSchema = z.object({
  id: z.string().uuid(),
  date: z.string().datetime(),
  duration: z.number().int().min(0), // Duration in seconds
  title: z.string().optional(),
  notes: z.string().optional(),
  created_at: z.string().datetime(),
  updated_at: z.string().datetime(),
});

export type WorkoutSession = z.infer<typeof WorkoutSessionSchema>;