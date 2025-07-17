

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
  exerciseId: z.string(),
  name: z.string(),
  imageUrl: z.string().optional(),
  equipments: z.array(z.string()),
  bodyParts: z.array(z.string()),
  exerciseType: z.string(),
  targetMuscles: z.array(z.string()),
  secondaryMuscles: z.array(z.string()).optional(),
  videoUrl: z.string().optional(),
  keywords: z.array(z.string()).optional(),
  overview: z.string().optional(),
  instructions: z.array(z.string()).optional(),
  exerciseTips: z.array(z.string()).optional(),
  variations: z.array(z.string()).optional(),
  relatedExerciseIds: z.array(z.string()).optional()
});

export const ExerciseQueryResultSchema = z.object({
  exerciseId: z.string(),
  name: z.string(),
  imageUrl: z.string().optional()
})

export type Exercise = z.infer<typeof ExerciseSchema>;
export type ExerciseApi = z.infer<typeof ExerciseApiSchema>;
export type ExerciseQueryResult = z.infer<typeof ExerciseQueryResultSchema>;