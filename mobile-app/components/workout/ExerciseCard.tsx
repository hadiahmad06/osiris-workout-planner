import { EnrichedExerciseSession } from '@/contexts/WorkoutProvider';
import { StyleSheet, Text, TextInput } from 'react-native';
import { MaterialIcons, MaterialCommunityIcons } from '@expo/vector-icons';
import { View } from '../Themed';
export default function ExerciseCard({ exercise }: { exercise: EnrichedExerciseSession }) {
  return (
    <View
      style={[styles.cardBase, { backgroundColor: '#444' }]}
    >
      <View style={{ backgroundColor: '#444', flexDirection: 'row', alignItems: 'center', gap: 6 }}>
        <Text style={styles.text}>{exercise.info?.name}</Text>
        <MaterialIcons name="info-outline" size={20} color="#fff" />
      </View>

      <View style={styles.setHeaderRow}>
        <Text style={styles.setSetHeader}>Set #</Text>
        <Text style={styles.setHeaderSmall}>RiR</Text>
        <Text style={styles.setHeader}>Reps</Text>
        <Text style={styles.setHeader}>Weight</Text>
      </View>
      {[1, 2, 3].map((setNumber) => (
        <View style={styles.setRow} key={setNumber}>
          <Text style={styles.setLabelSmall}>{setNumber}</Text>
          <TextInput style={styles.setInputSmall} keyboardType="numeric" placeholder="RiR" />
          <TextInput style={styles.setInput} keyboardType="numeric" placeholder="1" />
          <TextInput style={styles.setInput} keyboardType="numeric" placeholder="23" />
        </View>
      ))}
      <View style={styles.notesAndButtonsRow}>
        <TextInput
          style={styles.notesBox}
          placeholder="Notes..."
          placeholderTextColor="#aaa"
          multiline
        />
        <View style={styles.buttonStack}>
          <MaterialIcons name="repeat" style={styles.iconButton} />
          <MaterialCommunityIcons name="crop-free" style={styles.iconButton} />
          <MaterialIcons name="add" style={styles.iconButton} />
        </View>
      </View>
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
    fontSize: 32,
    fontWeight: 'bold',
  },
  subtext: {
    color: '#ccc',
    fontSize: 18,
    marginTop: 8,
    textAlign: 'center',
  },
  setHeaderRow: {
    backgroundColor: '#444',
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 24,
    width: '100%',
    paddingHorizontal: 10,
    gap: 10,
  },
  setHeader: {
    color: '#aaa',
    fontSize: 20,
    fontWeight: 'bold',
    width: '27.5%',
    textAlign: 'center',
  },
  setSetHeader: {
    color: '#aaa',
    fontSize: 18,
    fontWeight: 'bold',
    width: '15%',
    textAlign: 'center',
  },
  setHeaderSmall: {
    color: '#aaa',
    fontSize: 18,
    fontWeight: 'bold',
    width: '20%',
    textAlign: 'center',
  },
  setRow: {
    backgroundColor: '#444',
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 8,
    width: '100%',
    paddingHorizontal: 10,
    gap: 10,
  },
  setLabel: {
    color: '#fff',
    fontSize: 18,
    fontWeight: 'bold',
    width: '25%',
    textAlign: 'center',
  },
  setLabelSmall: {
    color: '#fff',
    fontSize: 20,
    fontWeight: 'bold',
    width: '15%',
    textAlign: 'center',
  },
  setInput: {
    backgroundColor: '#333',
    color: '#fff',
    borderRadius: 5,
    paddingVertical: 4,
    fontSize: 20,
    width: '27.5%',
    textAlign: 'center',
  },
  setInputSmall: {
    backgroundColor: '#333',
    color: '#fff',
    borderRadius: 5,
    paddingVertical: 4,
    fontSize: 18,
    width: '20%',
    textAlign: 'center',
  },
  notesAndButtonsRow: {
    flexDirection: 'row',
    backgroundColor: '#444',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    width: '100%',
    marginTop: 20,
    gap: 10,
  },
  notesBox: {
    backgroundColor: '#333',
    color: '#fff',
    borderRadius: 8,
    padding: 10,
    flex: 1,
    fontSize: 16,
    height: '100%'
  },
  buttonStack: {
    backgroundColor: '#444',
    justifyContent: 'space-between',
    alignItems: 'center',
    gap: 4,
  },
  iconButton: {
    fontSize: 24,
    color: '#fff',
    // backgroundColor: '#666',
    borderRadius: 8,
    padding: 4,
    justifyContent: 'center',
    alignItems: 'center',
    display: 'flex',
  }
});