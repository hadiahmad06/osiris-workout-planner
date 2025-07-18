import { ExerciseApi, ExerciseApiSchema, ExerciseQueryResultSchema } from "@/utils/schema/Exercise";
import Constants from 'expo-constants';

const { RAPID_API_KEY } = Constants.expoConfig?.extra ?? {};
console.log(RAPID_API_KEY);
const url = 'https://exercisedb-api1.p.rapidapi.com/api/v1/';



// export async function getStatus() {
//   const res = await fetch(`${url}liveness`, options);
//   return res.json();
// }

// export async function getExercises() {
//   const res = await fetch(`${url}exercises`, options);
//   return res.json();
// }

// export async function getExercisesBySearch(query: string) {
//   try {
//     const res = await fetch(`${url}exercises/search?search=${encodeURIComponent(query)}`, options);
//     const data = await res.json();
//     // console.log(data);
//     console.log(data.data);
//     const parsed = ExerciseQueryResultSchema.array().parse(data.data);

//     return parsed.map(ex => ({
//       id: ex.exerciseId,
//       label: ex.name,
//     }));
//   } catch (error) {
//     console.error("Failed to fetch or parse search exercises:", error);
//     return [];
//   }
// }

// export async function getExerciseById(id: string) {
//   try {
//     const res = await fetch(`${url}exercises/${id}`, options);
//     const data = await res.json();
//     console.log(data);
//     // console.log(ExerciseApiSchema.parse(data));
//     return ExerciseApiSchema.parse(data);
//   } catch (error) {
//     console.error("Failed to fetch or parse exercise:", error);
//     return null;
//   }
// }

// export async function getEquipments() {
//   const res = await fetch(`${url}equipments`, options);
//   return res.json();
// }

// export async function getBodyparts() {
//   const res = await fetch(`${url}bodyparts`, options);
//   return res.json();
// }

// export async function getExerciseTypes() {
//   const res = await fetch(`${url}exercisetypes`, options);
//   return res.json();
// }

// export async function getMuscles() {
//   const res = await fetch(`${url}muscles`, options);
//   return res.json();
// }

// const db = openDatabaseSync('main.db');

import { DefaultExercises } from '@/utils/_data/DefaultExercises';



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