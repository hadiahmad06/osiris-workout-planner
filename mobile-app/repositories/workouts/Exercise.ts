import { Exercise, ExerciseApi } from '@/utils/schema/Exercise';
import { openDatabaseSync, SQLiteDatabase } from 'expo-sqlite'


const db = openDatabaseSync('main.db');

import { DefaultExercises } from '@/utils/_data/DefaultExercises';

// async function initExercisesTable() {
//   await db.execAsync(`
//     CREATE TABLE IF NOT EXISTS exercises (
//       exerciseId TEXT PRIMARY KEY NOT NULL,
//       name TEXT NOT NULL,
//       equipments TEXT NOT NULL,
//       bodyParts TEXT NOT NULL,
//       exerciseType TEXT NOT NULL,
//       targetMuscles TEXT NOT NULL,
//       secondaryMuscles TEXT,
//       relatedExerciseIds TEXT
//     );
//   `);

//   const stmt = await db.prepareAsync('SELECT COUNT(*) as count FROM exercises');
//   const result = await stmt.executeAsync();
//   const row = await result.getFirstAsync() as { count: number };
//   const count = row?.count ?? 0;
//   await stmt.finalizeAsync();

//   if (count === 0) {
//     const insertStmt = await db.prepareAsync(`
//       INSERT INTO exercises (
//         exerciseId,
//         name,
//         equipments,
//         bodyParts,
//         exerciseType,
//         targetMuscles,
//         secondaryMuscles,
//         relatedExerciseIds
//       ) VALUES (
//         $exerciseId,
//         $name,
//         $equipments,
//         $bodyParts,
//         $exerciseType,
//         $targetMuscles,
//         $secondaryMuscles,
//         $relatedExerciseIds
//       )
//     `);

//     for (const ex of DefaultExercises) {
//       await insertStmt.executeAsync({
//         $exerciseId: ex.exerciseId,
//         $name: ex.name,
//         $equipments: JSON.stringify(ex.equipments),
//         $bodyParts: JSON.stringify(ex.bodyParts),
//         $exerciseType: ex.exerciseType,
//         $targetMuscles: JSON.stringify(ex.targetMuscles),
//         $secondaryMuscles: ex.secondaryMuscles ? JSON.stringify(ex.secondaryMuscles) : null,
//         $relatedExerciseIds: ex.relatedExerciseIds ? JSON.stringify(ex.relatedExerciseIds) : null,
//       });
//     }

//     await insertStmt.finalizeAsync();
//   }
// }

// initExercisesTable();


export async function enrichExercise(exercise_id: string): Promise<ExerciseApi | null> {
  return DefaultExercises.find(ex => ex.exerciseId === exercise_id) ?? null;
}

// export async function enrichExercise(exercise_id: string): Promise<ExerciseApi | null> {
//   const stmt = await db.prepareAsync('SELECT name, targeted_muscles FROM exercises WHERE id = $id');
//   const result = await stmt.executeAsync({ $id: exercise_id });
//   const row = await result.getFirstAsync();
//   await stmt.finalizeAsync();

//   if (!row) return null;
//   return row as ExerciseApi;
// }