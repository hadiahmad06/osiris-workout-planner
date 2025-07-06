import { z } from 'zod';

export const SetSchema = z.object({
  id: z.string().uuid(),
  exercise_session_id: z.string().uuid(),
  set_number: z.number().min(1),
  weight: z.number().min(0),
  reps: z.number().min(0),
  rir: z.number().optional(),
  tempo: z.string().optional(),
  notes: z.string().optional(),
//   created_at: z.string().datetime(),
//   updated_at: z.string().datetime(),
});

export type Set = z.infer<typeof SetSchema>;
