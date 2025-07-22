import { CompleteWorkoutSession, WorkoutSession } from '@/utils/schema/WorkoutSession';
import { openDatabaseSync, SQLiteDatabase } from 'expo-sqlite'


const db = openDatabaseSync('main.db');

db.execAsync(
  // DROP TABLE IF EXISTS workouts;
  `CREATE TABLE IF NOT EXISTS workouts (
    id TEXT PRIMARY KEY NOT NULL,
    date TEXT NOT NULL,
    duration INTEGER NOT NULL,
    title TEXT,
    notes TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    setsCount INTEGER NOT NULL,
    exercisesCount INTEGER NOT NULL,
    muscleDistribution TEXT NOT NULL
  );
`);


export async function getRecentWorkouts(limit: number = 30): Promise<CompleteWorkoutSession[]> {
  const statement = await db.prepareAsync(
    'SELECT * FROM workouts ORDER BY date DESC LIMIT $limit'
  );
  try {
    const result = await statement.executeAsync({ $limit: limit });
    return await result.getAllAsync() as CompleteWorkoutSession[];
  } finally {
    await statement.finalizeAsync();
  }
}

export async function getWorkoutsInTimeRange(startTime: string, endTime: string): Promise<CompleteWorkoutSession[]> {
  try {
    const statement = await db.prepareAsync(
      'SELECT * FROM workouts WHERE date BETWEEN $startTime AND $endTime'
    );

    const result = await statement.executeAsync({
      $startTime: startTime,
      $endTime: endTime
    });
    
    return await result.getAllAsync() as CompleteWorkoutSession[];
  } catch (err) {
    console.error("Failed to get workouts by time range:", err);
    return [];
  }
}

export async function insertWorkout(workout: CompleteWorkoutSession): Promise<void> {
  let statement;
  try {
    statement = await db.prepareAsync(
      `INSERT INTO workouts (id, date, duration, title, notes, created_at, updated_at, setsCount, exercisesCount, muscleDistribution)
       VALUES ($id, $date, $duration, $title, $notes, $created_at, $updated_at, $setsCount, $exercisesCount, $muscleDistribution)`
    );
    await statement.executeAsync({
      $id: workout.id,
      $date: workout.date,
      $duration: workout.duration,
      $title: workout.title ?? null,
      $notes: workout.notes ?? null,
      $created_at: workout.created_at,
      $updated_at: workout.updated_at,
      $setsCount: workout.setsCount,
      $exercisesCount: workout.exercisesCount,
      $muscleDistribution: JSON.stringify(workout.muscleDistribution),
    });
  } catch (err) {
    console.error("Failed to insert workout:", err);
  } finally {
    if (statement) {
      await statement.finalizeAsync();
    }
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
