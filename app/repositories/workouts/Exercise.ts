import Fuse from 'fuse.js';
import { ExerciseApi, ExerciseApiSchema, ExerciseQueryResultSchema } from "@/utils/schema/Exercise";
import Constants from 'expo-constants';

const { RAPID_API_KEY } = Constants.expoConfig?.extra ?? {};
console.log(RAPID_API_KEY);
const url = 'https://exercisedb-api1.p.rapidapi.com/api/v1/';

import exercise_data from '@/utils/data/exercise_data.json';

const DefaultExercises: ExerciseApi[] = Array.isArray(exercise_data) ? exercise_data : Object.values(exercise_data);



export async function getExercisesBySearch(query: string): Promise<{ id: string, label: string }[] | null> {
  if (!query) return null;

  const fuse = new Fuse(DefaultExercises, {
    keys: ['title', 'target', 'synergists'],
    threshold: 0.4,
  });

  const results = fuse.search(query).slice(0, 15);

  return results.map(result => ({
    id: result.item.title,
    label: result.item.title,
  }));
}

export async function getExerciseById(exercise_id: string): Promise<ExerciseApi | null> {
  return DefaultExercises.find(ex => ex.title === exercise_id) ?? null;
}

// export async function enrichExercise(exercise_id: string): Promise<ExerciseApi | null> {
//   const stmt = await db.prepareAsync('SELECT name, targeted_muscles FROM exercises WHERE id = $id');
//   const result = await stmt.executeAsync({ $id: exercise_id });
//   const row = await result.getFirstAsync();
//   await stmt.finalizeAsync();

//   if (!row) return null;
//   return row as ExerciseApi;
// }