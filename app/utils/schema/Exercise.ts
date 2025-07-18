enum MuscleRole {
  Primary,      // Agonist: the main muscle responsible for the movement
  Secondary,    // Synergist: assists the primary muscle
  Stabilizer    // Stabilizer: supports the body during the movement
}

import { z } from 'zod';

export const ExerciseSchema = z.object({
  exerciseId: z.string(),
  name: z.string(),
  equipments: z.array(z.string()),
  bodyParts: z.array(z.string()),
  exerciseType: z.string(),
  targetMuscles: z.array(z.string()),
  secondaryMuscles: z.array(z.string()).optional(),
  keywords: z.array(z.string()).optional(),
  relatedExerciseIds: z.array(z.string()).optional()
});

export const ExerciseApiSchema = z.object({
  title: z.string(),
  target: z.array(z.string()).optional(),
  synergists: z.array(z.string()).optional(),
  stabilizers: z.array(z.string()).optional(),
  similar_exercises: z.array(z.string())
});

export const ExerciseQueryResultSchema = z.object({
  title: z.string()
})

export type Exercise = z.infer<typeof ExerciseSchema>;
export type ExerciseApi = z.infer<typeof ExerciseApiSchema>;
export type ExerciseQueryResult = z.infer<typeof ExerciseQueryResultSchema>;