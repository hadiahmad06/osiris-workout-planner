import { useState } from 'react';
import { StyleSheet, TouchableOpacity } from 'react-native';
import { MotiView } from 'moti';

import { FontAwesome } from '@expo/vector-icons';
import { useRouter } from 'expo-router';

import { Text, View } from '@/components/Themed';
import Toggle from '@/components/common/Toggle';
import { useWorkout } from '@/contexts/WorkoutContext';

export default function TabOneScreen() {
  const { workout, startWorkout } = useWorkout();
  const [selectedToggle, setSelectedToggle] = useState<'today' | 'week'>('today');
  const router = useRouter();
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Today</Text>
      <View style={styles.weekNav}>
        <FontAwesome name="chevron-left" style={styles.arrow} />
        <View style={styles.weekContainerWrapper}>
          <View style={styles.weekContainer}>
            {['26', '27', '28', '29', '30', '31', '1'].map((date, index) => (
              <View
                key={index}
                style={[
                  styles.dateBubble,
                  date === '29' && styles.activeDateBubble,
                ]}
              >
                <Text
                  numberOfLines={1}
                  adjustsFontSizeToFit
                  style={[
                    styles.dateText,
                    date === '29' && styles.activeDateText,
                  ]}
                >
                  {date}
                </Text>
              </View>
            ))}
          </View>
        </View>
        <FontAwesome name="chevron-right" style={styles.arrow} />
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

        <View style={styles.summaryCard}>
          <Text style={styles.summaryLabel}>[Muscle Diagram]</Text>
        </View>

        <View style={styles.summaryHex}>
          <Text style={styles.summaryLabel}>[Hexagon Chart]</Text>
        </View>
        
        { !workout ? (
          <View style={styles.actionRow}>
            <View style={styles.actionButtonSecondary}>
              <Text style={styles.actionButtonText}>Mark Rest Day</Text>
            </View>
            <TouchableOpacity
              onPress={async () => {
                router.push('/(tabs)/today/workout-session')
                await startWorkout(undefined, ['K6NnTv0']);
              }}
              style={styles.actionButtonPrimary}
            >
              <Text style={styles.actionButtonText}>Start Workout</Text>
            </TouchableOpacity>
          </View>
        ) : (
          <View style={styles.actionRow}>
            <View style={styles.actionButtonCancel}>
              <Text style={styles.actionButtonText}>Cancel Workout</Text>
            </View>
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
    overflow: 'hidden',
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
    paddingTop: 12,
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