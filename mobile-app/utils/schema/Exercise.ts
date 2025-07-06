

enum MuscleRole {
  Primary,      // Agonist: the main muscle responsible for the movement
  Secondary,    // Synergist: assists the primary muscle
  Stabilizer    // Stabilizer: supports the body during the movement
}

import { z } from 'zod';

export const ExerciseSchema = z.object({
  id: z.string().uuid(),
  name: z.string(),
  equipment_id: z.string().uuid(),
  targeted_muscles: z.array(z.object({
    muscle: z.string(),
    percentage: z.number().min(0).max(100),
    role: z.nativeEnum(MuscleRole)
  })),
  is_user_created: z.boolean(),
  created_by_user_id: z.string().uuid().optional(),
});

export type Exercise = z.infer<typeof ExerciseSchema>;