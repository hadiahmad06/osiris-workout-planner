import { StyleSheet, Text, TouchableWithoutFeedback, TouchableOpacity } from "react-native";
import { View } from "../Themed"
import { KeyboardStickyView } from "react-native-keyboard-controller";
import { MotiView } from "moti";
import { useRef, useState } from "react";
import { TextInput } from "react-native-gesture-handler";
import { Ionicons } from "@expo/vector-icons";
import { getExercisesBySearch } from "@/repositories/workouts/Exercise";
import { useWorkout } from "@/contexts/WorkoutContext";

export default function AddExerciseCard() {
  const { addExercise } = useWorkout();

  const [isSearchFocused, setIsSearchFocused] = useState(false);
  const [query, setQuery] = useState('');
  const inputRef = useRef<TextInput>(null);
  const [results, setResults] = useState<{id: string, label: string}[] | null>(null);

  const debounceTimeout = useRef<ReturnType<typeof setTimeout> | null>(null);

  const handleSearch = (text: string) => {
    setQuery(text);
    if (debounceTimeout.current) {
      clearTimeout(debounceTimeout.current);
    }

    debounceTimeout.current = setTimeout(async () => {
      console.log('QUERY: ', text);
      setResults(await getExercisesBySearch(text));
    }, 300);
  };

  return (
    <View
      style={[styles.cardBase, { backgroundColor: '#666' }]}
    >
      <MotiView
        style={{ width: '100%' }}
        key={query ? 'Results' : 'Recommendation'}
        from={{ opacity: 0, translateY: -10 }}
        animate={{ opacity: 1, translateY: 0 }}
        exit={{ opacity: 0, translateY: 10 }}
        transition={{ type: 'timing', duration: 350 }}
      >
        <Text style={styles.topLabel}>
          {query ? 'Results' : 'Recommended Exercises'}
        </Text>
        {(query) ? (
          <View style={styles.resultsList}>
            {results ? (
              <>
                {results.map((val, i) => (
                  <TouchableOpacity key={i} onPress={() => addExercise(val.id)}>
                    <Text style={styles.resultsPill}>{val.label}</Text>
                  </TouchableOpacity>
                ))}
              </>
            ) : (
              <>
                {Array(16).fill(null).map((_, i) => (
                  <MotiView
                    key={i}
                    from={{ backgroundColor: '#555' }}
                    animate={{ backgroundColor: '#333' }}
                    transition={{
                      type: 'timing',
                      duration: 650,
                      loop: true,
                      delay: Math.floor(i / 3) * 60,
                    }}
                    style={[
                      styles.resultsPill,
                      {
                        height: 36,
                        width: `${[20, 30, 45][(i % 3 + Math.floor(i / 3)) % 3]}%`,
                      },
                    ]}
                  />
                ))}
              </>
            )}
          </View>
        ) : (
          <>
            <View style={styles.recommendedList}>
              <Text style={styles.recommendedPill}>Cable Row</Text>
              <Text style={styles.recommendedPill}>Incline DB Press</Text>
              <Text style={styles.recommendedPill}>RDL</Text>
            </View>
          </>
        )}
      </MotiView>
      <View style={styles.spacer} />
      <KeyboardStickyView offset={{ opened: 300 }}>
        <TouchableWithoutFeedback onPress={() => inputRef.current?.focus()}>
          <MotiView 
            from={{borderRadius: 32, width: '60%'}}
            animate={{ borderRadius: isSearchFocused ? 16 : 32, width: isSearchFocused ?  '100%' : '85%'}}
            style={styles.searchBar}
            transition={{
            type: 'spring',
            duration: 600,
            }}
          >
            <MotiView 
              from={{borderRadius: 32}}
              animate={{ borderRadius: isSearchFocused ? 16 : 32}}
              style={styles.searchIconContainer}
              transition={{
                type: 'spring',
                duration: 600,
              }}
            >
              <Ionicons name="search" size={25} color="#fff" />
            </MotiView>
            <TextInput
              onFocus={() => setIsSearchFocused(true)}
              onBlur={() => setIsSearchFocused(false)}
              ref={inputRef}
              placeholder="Search for exercises!"
              placeholderTextColor="#ccc"
              value={query}
              onChangeText={handleSearch}
              style={styles.searchHintText}
            />
          </MotiView>
        </TouchableWithoutFeedback>
      </KeyboardStickyView>
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
  iconButton: {
    backgroundColor: '#888',
    borderRadius: 100,
    padding: 16,
    marginTop: 16,
  },
  topLabel: {
    fontSize: 18,
    color: '#ccc',
    alignSelf: 'flex-start',
    marginBottom: 8,
  },
  resultsList: {
    flexDirection: 'row',
    backgroundColor: '#666',
    flexWrap: 'wrap',
    gap: 8,
  },
  resultsPill: {
    backgroundColor: '#333',
    color: '#fff',
    paddingVertical: 7,
    paddingHorizontal: 14,
    borderRadius: 999,
    fontSize: 20,
  },
  recommendedList: {
    flexDirection: 'row',
    backgroundColor: '#666',
    flexWrap: 'wrap',
    gap: 8,
    marginBottom: 24,
  },
  recommendedPill: {
    backgroundColor: '#555',
    color: '#fff',
    paddingVertical: 7,
    paddingHorizontal: 14,
    borderRadius: 999,
    fontSize: 20,
  },
  searchHintText: {
    color: '#ccc',
    fontSize: 18,
    flex: 1,
    padding: 0,
  },
  spacer: {
    flex: 1,
  },
  searchBar: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#555',
    // borderRadius: 16,      // ANIMATED
    paddingVertical: 10,
    paddingHorizontal: 12,
    // width: '100%',         // ANIMATED
  },
  searchIconContainer: {
    width: 40,
    height: 40,
    // borderRadius: 16,      // ANIMATED
    backgroundColor: '#888',
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
});