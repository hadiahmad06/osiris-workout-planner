import { useState, useEffect, useRef } from 'react';
import { StyleSheet, TouchableOpacity, View } from 'react-native';
import { MotiView } from 'moti';

import { FontAwesome } from '@expo/vector-icons';
import { useRouter } from 'expo-router';

import { Text } from '@/components/Themed';
import Toggle from '@/components/common/Toggle';
import { useWorkout } from '@/contexts/WorkoutContext';
import { useHistory } from '@/contexts/HistoryContext';

import { format, isToday } from 'date-fns';
import { CompleteWorkoutSession } from '@/utils/schema/WorkoutSession';
import { Easing } from 'react-native-reanimated';

type WorkoutDayStatus = {
  date: string;
  completed: boolean;
}

export default function TabOneScreen() {
  const { workouts, getWorkoutsInRange } = useHistory()
  const { workout, startWorkout, cancelWorkout } = useWorkout();
  const router = useRouter();

  const [selectedToggle, setSelectedToggle] = useState<'today' | 'week'>('today');
  const [selectedDateOffset, setSelectedDateOffset] = useState(new Date().getDay());
  const [startOfWeek, setStartOfWeek] = useState(() => {
    const now = new Date();
    now.setDate(now.getDate() - now.getDay());
    now.setHours(0, 0, 0, 0);
    return now;
  });

  const [weekAnimationDirection, setWeekAnimationDirection] = useState<'left' | 'right' | null>(null);

  const [loadedWorkouts, setLoadedWorkouts] = useState<CompleteWorkoutSession[] | null>(null);
  const [weekStatuses, setWeekStatuses] = useState<boolean[]>([]);
  
  const [bubbleWidth, setBubbleWidth] = useState(0);
  const [isAnimating, setIsAnimating] = useState(false);

  const selectedDate = new Date(startOfWeek);
  selectedDate.setDate(startOfWeek.getDate() + selectedDateOffset);
  
  const fetchWorkoutsInRange = async () => {
    const endOfWeek = new Date(startOfWeek);
    endOfWeek.setDate(startOfWeek.getDate() + 6);
    endOfWeek.setHours(23, 59, 59, 999);

    const res = await getWorkoutsInRange(startOfWeek, endOfWeek);
    return res;
  };

  useEffect(() => {
    fetchWorkoutsInRange().then((res) => {
      const statuses = Array.from({ length: 7 }, (_, i) => {
        const day = new Date(startOfWeek);
        day.setDate(startOfWeek.getDate() + i);
        return res.some((w) => new Date(w.date).toDateString() === day.toDateString());
      });
      setWeekStatuses(statuses);
    });
  }, [startOfWeek])

  useEffect(() => {
    setIsAnimating(true);

    const shrinkTimeout = setTimeout(() => {
      setIsAnimating(false);
    }, 200); // adjust this value as needed

    return () => clearTimeout(shrinkTimeout);
  }, [selectedDateOffset]);

  useEffect(() => {
    if (selectedToggle === 'today') {
      const startDate = new Date(selectedDate);
      getWorkoutsInRange( startDate ).then((res) => {
        setLoadedWorkouts(res);
      });
    } else {
      fetchWorkoutsInRange().then((res) => {
        setLoadedWorkouts(res);
      });
    }
  }, [startOfWeek, selectedToggle, selectedDateOffset]);

  const formattedTitle = isToday(selectedDate)
    ? 'Today'
    : format(selectedDate, 'EEEE, MMMM d');

  const totalDuration = loadedWorkouts?.reduce((acc, w) => acc + w.duration, 0) ?? 0;
  const totalSets = loadedWorkouts?.reduce((acc, w) => acc + w.setsCount, 0) ?? 0;
  const totalExercises = loadedWorkouts?.reduce((acc, w) => acc + w.exercisesCount, 0) ?? 0;

  return (
    <View style={styles.container}>
      <Text style={styles.title}>{formattedTitle}</Text>
      <View style={styles.weekNav}>
        <FontAwesome
          name="chevron-left"
          style={styles.arrow}
          onPress={() => {
            setWeekAnimationDirection('left');
            setStartOfWeek(prev => {
              const newDate = new Date(prev);
              newDate.setDate(prev.getDate() - 7);
              return newDate;
            });
          }}
        />
        <View style={styles.weekContainerWrapper}>
          <MotiView
            key={startOfWeek.toISOString()}
            from={{
              translateX: weekAnimationDirection === 'left' ? -100 : 100,
              opacity: 0,
            }}
            animate={{
              translateX: 0,
              opacity: 1,
            }}
            transition={{
              type: 'timing',
              duration: 300,
            }}
            style={styles.weekContainer}
            onDidAnimate={() => setWeekAnimationDirection(null)}
          >
            {Array.from({ length: 7 }).map((_, index) => {
              const date = new Date();
              date.setDate(date.getDate() - date.getDay() + index); // Start from Sunday
              const dayName = date.getDate().toString();

              return (
                <TouchableOpacity
                  key={index}
                  activeOpacity={0.7}
                  onPress={() => setSelectedDateOffset(index)}
                  style={[
                    styles.dateBubble,
                    weekStatuses[index] && styles.activeDateBubble,
                    { position: 'relative' },
                  ]}
                >
                  <Text
                    numberOfLines={1}
                    adjustsFontSizeToFit
                    style={[
                      styles.dateText,
                      weekStatuses[index] && styles.activeDateText,
                    ]}
                  >
                    {dayName}
                  </Text>
                </TouchableOpacity>
              );
            })}
          </MotiView>
          <View
            style={{
              position: 'absolute',
              height: 14,
              width: '100%',
              top: '100%'
            }}
            onLayout={(event) => {
              const totalWidth = event.nativeEvent.layout.width;
              const gap = 4;
              const usableWidth = totalWidth - gap * 6;
              const calcBubbleWidth = usableWidth / 7;
              setBubbleWidth(calcBubbleWidth);
            }}
          >
            <MotiView
              from={{ translateX: 0 }}
              // IF WEEK CONTAINER GAP IS CHANGED THIS WILL BREAK
              animate={{ translateX: (bubbleWidth + 4) * selectedDateOffset }}
              transition={{
                type: 'timing',
                duration: 400,
                easing: Easing.out(Easing.ease),
              }}
              style={{
                position: 'relative',
                width: bubbleWidth,
                height: 6,
                top: 6,
                alignItems: 'center',
                justifyContent: 'center',
              }}
            >
              <MotiView
                from={{ scaleX: 0.75 }}
                animate={{ scaleX: isAnimating ? 3 : 0.75 }}
                transition={{ type: 'timing', duration: 200 }}
                style={{
                  position: 'relative',
                  width: '20%',
                  height: 6,
                  borderRadius: 999,
                  backgroundColor: '#ccc',
                }}
              />
            </MotiView>
          </View>
        </View>
        <FontAwesome
          name="chevron-right"
          style={styles.arrow}
          onPress={() => {
            setWeekAnimationDirection('right');
            setStartOfWeek(prev => {
              const newDate = new Date(prev);
              newDate.setDate(prev.getDate() + 7);
              return newDate;
            });
          }}
        />
      </View>
      <View style={styles.summaryContainer}>
        <View style={styles.summaryHeader}>
          <Text style={{ fontSize: 18, fontWeight: 'bold', color: '#fff' }}>Summary</Text>
          <Toggle
            options={[
              { key: 'today', label: 'Today' },
              { key: 'week', label: 'Week', disabled: false },
            ]}
            selected={selectedToggle}
            onChange={(val) => setSelectedToggle(val as 'today' | 'week')}
            width={70}
          />
        </View>


        {loadedWorkouts && (
          <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: 12 }}>
            <Text style={{ fontSize: 14, color: '#ccc', fontWeight: 600}}>
              {totalDuration ? `${Math.floor(totalDuration / 60) > 0 ? `${Math.floor(totalDuration / 60)} hr` : ''}${totalDuration % 60 > 0 ? ` ${totalDuration % 60} min` : ''}` : '0 min'}
              {` • ${loadedWorkouts.length} Workout${loadedWorkouts.length !== 1 ? 's' : ''} • ${totalExercises} Exercise${totalExercises !== 1 ? 's' : ''} • ${totalSets} Set${totalSets !== 1 ? 's' : ''}`}
            </Text>
          </View>
        )}

        <View style={styles.summaryCard}>
          <Text style={styles.summaryLabel}>[Muscle Diagram]</Text>
        </View>

        <View style={styles.summaryHex}>
          <Text style={styles.summaryLabel}>[Hexagon Chart]</Text>
        </View>
        
        { !workout ? (
          <View style={styles.actionRow}>
            {!isToday(selectedDate) && (
              <TouchableOpacity style={styles.actionButtonSecondary}>
                <Text style={styles.actionButtonText}>
                  Log Workout {format(selectedDate, 'M/d')}
                </Text>
              </TouchableOpacity>
            )}
            <TouchableOpacity
              onPress={async () => {
                router.push('/(tabs)/today/workout-session')
                await startWorkout(undefined, ['Bench Press']);
              }}
              style={styles.actionButtonPrimary}
            >
              <Text style={styles.actionButtonText}>Start Workout</Text>
            </TouchableOpacity>
          </View>
        ) : (
          <View style={styles.actionRow}>
            <TouchableOpacity
              onPress={cancelWorkout}
              style={styles.actionButtonCancel}
            >
              <Text style={styles.actionButtonText}>Cancel Workout</Text>
            </TouchableOpacity>
            <TouchableOpacity
              onPress={() => router.push('/(tabs)/today/workout-session')}
              style={styles.actionButtonPrimary}
            >
              <Text style={styles.actionButtonText}>Resume Workout</Text>
            </TouchableOpacity>
          </View>
        )}
        
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingVertical: 50,
    paddingHorizontal: 20,
    backgroundColor: '#000',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: 'white',
    textAlign: 'center',
    marginVertical: 20,
  },
  weekNav: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginBottom: 30,
  },
  weekContainerWrapper: {
    flex: 1,
    overflow: 'visible',
    position: 'relative',
  },
  weekContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 4,
  },
  arrow: {
    alignSelf: 'center',
    paddingTop: 2,  
    color: '#fff',
    fontSize: 20,
    paddingHorizontal: 10,
  },
  dateBubble: {
    flex: 1,
    backgroundColor: '#222',
    borderRadius: 20,
    paddingVertical: 6,
    alignItems: 'center',
    justifyContent: 'center',
  },
  activeDateBubble: {
    backgroundColor: '#6a5acd',
  },
  dateText: {
    color: '#fff',
    fontSize: 16,
    textAlign: 'center',
    includeFontPadding: false,
    textAlignVertical: 'center',
  },
  activeDateText: {
    fontWeight: 'bold',
    color: '#fff',
  },
  summaryContainer: {
    flex: 1,
    gap: 16,
    paddingHorizontal: 20,
    // paddingTop: 12,
  },
  summaryHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  summaryCard: {
    backgroundColor: '#222',
    padding: 20,
    borderRadius: 12,
    alignItems: 'center',
  },
  summaryHex: {
    backgroundColor: '#1a1a1a',
    padding: 20,
    borderRadius: 12,
    alignItems: 'center',
  },
  actionRow: {
    marginTop: 'auto',
    flexDirection: 'row',
    gap: 12,
  },
  actionButtonPrimary: {
    flex: 1,
    backgroundColor: '#6a5acd',
    padding: 14,
    borderRadius: 8,
    alignItems: 'center',
  },
  actionButtonSecondary: {
    flex: 1,
    backgroundColor: '#444',
    padding: 14,
    borderRadius: 8,
    alignItems: 'center',
  },
  actionButtonCancel: {
    flex: 1,
    backgroundColor: '#dd6b6b',
    padding: 14,
    borderRadius: 8,
    alignItems: 'center',
  },
  actionButtonText: {
    color: '#fff',
    fontWeight: 'bold',
  },
  summaryLabel: {
    color: '#aaa',
  },
});