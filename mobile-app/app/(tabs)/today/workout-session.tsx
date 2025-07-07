import Colors from '@/constants/Colors';
import { useWorkout } from '@/contexts/WorkoutContext';
import { EnrichedExerciseSession } from '@/contexts/WorkoutProvider';
import { ExerciseSession } from '@/utils/schema/ExerciseSession';
import React, { useEffect, useRef, useState } from 'react';
import { View, TextInput, Text, StyleSheet, useColorScheme, Dimensions, TouchableWithoutFeedback, KeyboardAvoidingView, Platform, Keyboard } from 'react-native';
import Carousel from 'react-native-reanimated-carousel';
import { Ionicons } from '@expo/vector-icons';
import { MotiView } from 'moti';

type ExerciseSlide = EnrichedExerciseSession | 'plus';

export default function WorkoutSession() {
  const { workout, exercises, addExercise, removeExercise} = useWorkout();
  const colorScheme = useColorScheme();
  const { width, height } = Dimensions.get('window');

  const slides: ExerciseSlide[] = [...exercises, 'plus'];
  const inputRef = useRef<TextInput>(null);
  const [isSearchFocused, setIsSearchFocused] = useState(false);

  const [keyboardVisible, setKeyboardVisible] = useState(false);

  useEffect(() => {
    const showEvent = Platform.OS === 'ios' ? 'keyboardWillShow' : 'keyboardDidShow';
    const hideEvent = Platform.OS === 'ios' ? 'keyboardWillHide' : 'keyboardDidHide';

    const showSubscription = Keyboard.addListener(showEvent, () => setKeyboardVisible(true));
    const hideSubscription = Keyboard.addListener(hideEvent, () => setKeyboardVisible(false));

    return () => {
      showSubscription.remove();
      hideSubscription.remove();
    };
  }, []);

  return (
    // <KeyboardAvoidingView
    //   style={{ flex: 1 }}
    //   behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    //   keyboardVerticalOffset={Platform.OS === 'ios' ? 80 : 0} // tweak as needed depending on nav/header
    // >
    <View style={{ ...styles.container, backgroundColor: Colors[colorScheme ?? 'dark'].background }}>
      <MotiView
        from={{height: height * 0.7}}
        animate={{
          height: keyboardVisible ? height * 0.4 : height * 0.7,
        }}
        transition={{ type: 'timing', duration: 400 }}
      >
        <Carousel
          loop
          width={width}
          // height={200}
          autoPlay={false}
          data={slides}
          scrollAnimationDuration={500}
          mode="parallax"
          modeConfig={{
            parallaxScrollingScale: 0.85,
            parallaxScrollingOffset: 80,
            parallaxAdjacentItemScale: 0.75,
          }}
          renderItem={({ item }) => {
            if (item === 'plus') {
              return (
                <MotiView
                  // animate={{
                  //   height: keyboardVisible ? height * 0.3 : height * 0.7,
                  // }}
                  transition={{ type: 'spring', duration: 400 }}
                  style={[styles.cardBase, { backgroundColor: '#666' }]}
                >
                  <Text style={styles.recommendationLabel}>Recommended</Text>
                  <View style={styles.recommendedList}>
                    <Text style={styles.recommendedPill}>Cable Row</Text>
                    <Text style={styles.recommendedPill}>Incline DB Press</Text>
                    <Text style={styles.recommendedPill}>RDL</Text>
                  </View>
                  <View style={styles.spacer} />
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
                        style={styles.searchHintText}
                      />
                    </MotiView>
                  </TouchableWithoutFeedback>
                </MotiView>
              );
            }

            return (
              <MotiView
                // from={{maxHeight: height}}
                // animate={{
                //   maxHeight: keyboardVisible ? height * 0.3 : height * 0.7,
                // }}
                transition={{ type: 'spring', duration: 400 }}
                style={[styles.cardBase, { backgroundColor: '#444' }]}
              >
                <Text style={styles.text}>Title: {item.info?.name}</Text>
                <Text style={styles.subtext}>Type: {item.info?.exerciseType}</Text>
                <Text style={styles.subtext}>Muscles: {item.info?.targetMuscles?.join(', ')}</Text>
                <Text style={styles.subtext}>Equipment: {item.info?.equipments?.join(', ')}</Text>
              </MotiView>
            );
          }}
        />
      </MotiView>
    </View>
    // </KeyboardAvoidingView>
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
  recommendationLabel: {
    fontSize: 18,
    color: '#ccc',
    alignSelf: 'flex-start',
    marginBottom: 8,
  },
  recommendedList: {
    flexDirection: 'row',
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