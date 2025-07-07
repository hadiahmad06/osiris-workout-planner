import { CompleteWorkoutSession, WorkoutSession } from '@/utils/schema/WorkoutSession';
import { openDatabaseSync, SQLiteDatabase } from 'expo-sqlite'

const db = openDatabaseSync('main.db');
// console.log(db, { depth: 2 })

export async function getRecentWorkouts(limit: number = 30): Promise<WorkoutSession[]> {
  const statement = await db.prepareAsync(
    'SELECT * FROM workouts ORDER BY date DESC LIMIT $limit'
  );
  try {
    const result = await statement.executeAsync({ $limit: limit });
    return await result.getAllAsync() as WorkoutSession[];
  } finally {
    await statement.finalizeAsync();
  }
}

export async function getWorkoutByDate(date: string): Promise<WorkoutSession | null> {
  const statement = await db.prepareAsync(
    'SELECT * FROM workouts WHERE date = $date LIMIT 1'
  );
  try {
    const result = await statement.executeAsync({ $date: date });
    const first = await result.getFirstAsync();
    return first ? first as WorkoutSession : null;
  } finally {
    await statement.finalizeAsync();
  }
}

export async function insertWorkout(workout: CompleteWorkoutSession): Promise<void> {
  const statement = await db.prepareAsync(
    `INSERT INTO workouts (id, date, duration, title, notes, created_at, updated_at)
     VALUES ($id, $date, $duration, $title, $notes, $created_at, $updated_at)`
  );
  try {
    await statement.executeAsync({
      $id: workout.id,
      $date: workout.date,
      $duration: workout.duration,
      $title: workout.title ?? null,
      $notes: workout.notes ?? null,
      $created_at: workout.created_at,
      $updated_at: workout.updated_at,
    });
  } finally {
    await statement.finalizeAsync();
  }
}

export async function deleteWorkout(id: string): Promise<void> {
  const statement = await db.prepareAsync(
    'DELETE FROM workouts WHERE id = $id'
  );
  try {
    await statement.executeAsync({ $id: id });
  } finally {
    await statement.finalizeAsync();
  }
}

export async function updateWorkout(id: string, fields: Partial<WorkoutSession>): Promise<void> {
  const keys = Object.keys(fields);
  const values = Object.values(fields);
  if (keys.length === 0) return;

  const setClause = keys.map(key => `${key} = $${key}`).join(', ');
  const statement = await db.prepareAsync(
    `UPDATE workouts SET ${setClause} WHERE id = $id`
  );
  try {
    const params = keys.reduce((acc, key, index) => {
      acc[`$${key}`] = values[index];
      return acc;
    }, {} as Record<string, any>);
    params['$id'] = id;
    await statement.executeAsync(params);
  } finally {
    await statement.finalizeAsync();
  }
}
