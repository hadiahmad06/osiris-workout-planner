import { EnrichedExerciseSession } from '@/contexts/WorkoutProvider';
import { StyleSheet, Text } from 'react-native';
import { View } from '../Themed';
export default function ExerciseCard({ exercise }: { exercise: EnrichedExerciseSession }) {
  return (
    <View
      style={[styles.cardBase, { backgroundColor: '#444' }]}
    >
      <Text style={styles.text}>Title: {exercise.info?.name}</Text>
      <Text style={styles.subtext}>Type: {exercise.info?.exerciseType}</Text>
      <Text style={styles.subtext}>Muscles: {exercise.info?.targetMuscles?.join(', ')}</Text>
      <Text style={styles.subtext}>Equipment: {exercise.info?.equipments?.join(', ')}</Text>
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    width: '100%'
  },
  cardBase: {
    flex: 1,
    borderRadius: 20,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  text: {
    color: '#fff',
    fontSize: 24,
    fontWeight: 'bold',
  },
  subtext: {
    color: '#ccc',
    fontSize: 16,
    marginTop: 8,
    textAlign: 'center',
  },
});