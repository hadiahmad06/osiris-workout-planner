import { ExerciseApi, ExerciseApiSchema, ExerciseQueryResultSchema } from "@/utils/schema/Exercise";
import Constants from 'expo-constants';

const { RAPID_API_KEY } = Constants.expoConfig?.extra ?? {};
console.log(RAPID_API_KEY);
const url = 'https://exercisedb-api1.p.rapidapi.com/api/v1/';

import exercise_data from '@/utils/data/exercise_data.json';

const DefaultExercises: ExerciseApi[] = Array.isArray(exercise_data) ? exercise_data : Object.values(exercise_data);



export async function getExercisesBySearch(query: string): Promise<{ id: string, label: string }[] | null> {
  if (!query) return null;

  const lowerQuery = query.toLowerCase();
  const nameMatches = DefaultExercises.filter(ex =>
    ex.title.toLowerCase().includes(lowerQuery)
  );

  const results = [...nameMatches];

  if (results.length < 10) {
    const additionalMatches = DefaultExercises.filter(ex =>
      !results.includes(ex) &&
      (
        ex.target?.some(m => m.toLowerCase().includes(lowerQuery)) ||
        ex.synergists?.some(m => m.toLowerCase().includes(lowerQuery))
      )
    );

    results.push(...additionalMatches);
  }

  return results.map(ex => ({ id: ex.title, label: ex.title }));
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