import { EnrichedExerciseSession } from '@/contexts/WorkoutProvider';
import { StyleSheet, Text, TextInput, TouchableOpacity, ScrollView } from 'react-native';
import { Pressable } from 'react-native';
import { MaterialIcons, MaterialCommunityIcons } from '@expo/vector-icons';
import { View } from '../Themed';
import { MotiView } from 'moti';
import { SetSession } from '@/utils/schema/SetSession';
import { useEffect, useRef, useState } from 'react';
import { useWorkout } from '@/contexts/WorkoutContext';

export default function ExerciseCard({ exercise }: { exercise: EnrichedExerciseSession }) {

  const { sets, addSet, updateSet, removeSet, updateExercise } = useWorkout();

  const [selected, setSelected] = useState<number>(0);
  const inputRefs = useRef<Record<string, TextInput | null>>({});

  useEffect(() => {
    const currentSets = sets[exercise.id];
    if (currentSets) {
      const keys = Object.keys(currentSets).map(Number);
      if (keys.length > 0) {
        const maxIdx = Math.max(...keys);
        setSelected(maxIdx);
      }
    }
  }, [])

  function deferSelectedUpdate(newIdx: number) {
    requestAnimationFrame(() => {
      setSelected(newIdx);
      inputRefs.current[newIdx]?.focus?.()
    });
  }

  // HANDLERS

  function handleAdd() {
    addSet(exercise.id, selected+1);
    deferSelectedUpdate(selected+1);
  }
  function handleNumericInput(text: string, idx: number, field: keyof SetSession) {
    const numeric = parseInt(text.replace(/[^0-9]/g, ''));
    const currentSets = sets[exercise.id] ?? {};
    updateSet(exercise.id, idx, {
      ...currentSets[idx],
      [field]: Number.isNaN(numeric) ? undefined : numeric
    });
  }
  function handleDelete() {
    const newSelectedIndex = removeSet(exercise.id, selected);
    if (newSelectedIndex !== undefined) {
      deferSelectedUpdate(newSelectedIndex);
    }
  }

  // COMPONENT

  const currentSets = sets[exercise.id] ?? {};

  return (
    <View style={[styles.cardBase, { backgroundColor: '#444' }]}>
      <View style={{ backgroundColor: '#444', flexDirection: 'row', alignItems: 'center', gap: 6 }}>
        <Text style={styles.text}>{exercise.info?.name}</Text>
        <MaterialIcons name="info-outline" size={24} color="#fff" />
      </View>

      <View style={styles.setHeaderRow}>
        <Text style={styles.setSetHeader}>Set #</Text>
        <Text style={styles.setHeaderSmall}>RiR</Text>
        <Text style={styles.setHeader}>Reps</Text>
        <Text style={styles.setHeader}>Weight</Text>
      </View>
      {/* <ScrollView contentContainerStyle={{ flexGrow: 1 }} keyboardShouldPersistTaps="handled"> */}
        {Object.entries(currentSets)
          .sort((a, b) => a[0].localeCompare(b[0]))
          .map(([idxStr, set]) => {
            const idx = parseInt(idxStr);
            return (
              <MotiView
                key={set.id}
                from={{ opacity: 0, translateX: -5 }}
                animate={{ opacity: 1, translateX: 5}}
                exit={{ opacity: 0, translateX: -5 }}
                style={[
                  styles.setRow,
                  { borderRadius: 10, borderLeftWidth: 4, borderLeftColor: selected === idx ? '#6a5acd' : 'transparent' }
                ]}
              >
                <Text style={styles.setLabelSmall}>{idx+1}</Text>
                <TextInput
                  onFocus={() => setSelected(idx)}
                  style={styles.setInputSmall}
                  keyboardType="numeric"
                  placeholder="RiR"
                  placeholderTextColor={'#777'}
                  value={String(currentSets[idx]?.rir ?? '')}
                  onChangeText={(text) => handleNumericInput(text, idx, 'rir')}
                />
                <TextInput
                  onFocus={() => setSelected(idx)}
                  style={styles.setInput}
                  keyboardType="numeric"
                  placeholder="1"
                  placeholderTextColor={'#777'}
                  value={String(currentSets[idx]?.reps ?? '')}
                  onChangeText={(text) => handleNumericInput(text, idx, 'reps')}
                />
                <TextInput
                  ref={(ref) => {inputRefs.current[idx] = ref}}
                  onFocus={() => setSelected(idx)}
                  style={styles.setInput}
                  keyboardType="numeric"
                  placeholder="23"
                  placeholderTextColor={'#777'}
                  value={String(currentSets[idx]?.weight ?? '')}
                  onChangeText={(text) => handleNumericInput(text, idx, 'weight')}
                />
              </MotiView>
            );
          })}
      {/* </ScrollView> */}
      <View style={{ flex: 1 }} /> {/* SPACER HERE */}
      <View style={styles.notesAndButtonsRow}>
        <View style={styles.notesStack}>
          <TextInput
            style={styles.notesBox}
            placeholder="Notes..."
            placeholderTextColor="#aaa"
            multiline
            value={exercise.notes ?? ''}
            onChangeText={(text) => updateExercise({ ...exercise, notes: text })}
          />
          <TextInput
            style={styles.setNotesBox}
            placeholder="Set Notes..."
            placeholderTextColor="#aaa"
            multiline
            value={currentSets[selected]?.notes ?? ''}
            onChangeText={(text) =>
              updateSet(exercise.id, selected, {
                ...currentSets[selected],
                notes: text,
              })
            }
          />
        </View>
        <View style={styles.buttonStack}>
          <View style={styles.buttonRow}>
            <Pressable>
              <MaterialIcons name="repeat" style={styles.iconButton} />
            </Pressable>
            <Pressable>
              <MaterialCommunityIcons name="crop-free" style={styles.iconButton} />
            </Pressable>
          </View>
          <View style={styles.buttonRow}>
            <Pressable onPress={handleDelete}>
              <MaterialIcons name="delete" style={styles.iconButton} />
            </Pressable>
            <Pressable onPress={handleAdd}>
              <MaterialIcons name="add" style={styles.iconButton} />
            </Pressable>
          </View>
        </View>
      </View>
    </View>
  );
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
  setLabelSmall: {
    color: '#fff',
    fontSize: 20,
    fontWeight: 'bold',
    width: '15%',
    textAlign: 'center',
    paddingVertical: 4,
  },
  setInput: {
    backgroundColor: '#333',
    borderRadius: 5,
    paddingVertical: 4,
    fontSize: 20,
    width: '27.5%',
    textAlign: 'center',
    color: '#fff',
  },
  setInputSmall: {
    backgroundColor: '#333',
    borderRadius: 5,
    paddingVertical: 4,
    fontSize: 18,
    width: '20%',
    textAlign: 'center',
    color: '#fff',
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
  notesStack: {
    backgroundColor: '#444',
    flex: 1,
    flexDirection: 'column',
    gap: 5,
  },
notesBox: {
    backgroundColor: '#333',
    color: '#fff',
    borderRadius: 8,
    padding: 10,
    flex: 2,
    fontSize: 16
  },
  setNotesBox: {
    backgroundColor: '#333',
    color: '#fff',
    borderRadius: 8,
    padding: 10,
    fontSize: 16,
    flex: 1
  },
  buttonStack: {
    backgroundColor: '#444',
    justifyContent: 'space-between',
    alignItems: 'center',
    gap: 4,
  },
  buttonRow: {
    backgroundColor: '#444',
    flexDirection: 'row',
    gap: 4,
  },
  iconButton: {
    fontSize: 40,
    color: '#fff',
    // backgroundColor: '#666',
    borderRadius: 8,
    padding: 2,
    justifyContent: 'center',
    alignItems: 'center',
    display: 'flex',
  }
});