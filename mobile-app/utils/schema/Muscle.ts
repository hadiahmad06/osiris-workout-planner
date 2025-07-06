import { z } from 'zod';
// import { MuscleGroups } from '../data/MuscleGroups';

export const MuscleSchema = z.object({
  id: z.string().uuid(),
  name: z.string(),
  parent_muscle_id: z.string().uuid().optional(), // Optional for top-level muscles
  submuscles: z.array(z.object({
    id: z.string().uuid(),
    name: z.string()
  })).optional() // Optional for muscles that have submuscles
});

export type Muscle = z.infer<typeof MuscleSchema>;