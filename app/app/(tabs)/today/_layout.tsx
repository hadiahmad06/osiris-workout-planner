import { Stack } from 'expo-router';
import Colors from '@/constants/Colors';
import { useColorScheme, TextInput, View, Text, TouchableWithoutFeedback, Keyboard, Pressable } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { useEffect, useState } from 'react';
import { useWorkout } from '@/contexts/WorkoutContext';
import { useRouter } from 'expo-router';
import { insertWorkout } from '@/repositories/workouts/Workout';

function CustomHeader() {
  const router = useRouter();
  const [title, setTitle] = useState('');
  const [elapsed, setElapsed] = useState('...');
  const { workout, pushWorkout } = useWorkout();


  const now = new Date();
  const tintColor = '#fff';

  useEffect(() => {
    const startTime = workout?.date
      ? new Date(workout.date).getTime()
      : Date.now();

    // Set immediately
    const updateElapsed = () => {
      const now = Date.now();
      const diff = Math.floor((now - startTime) / 1000);
      const minutes = Math.floor(diff / 60);
      const seconds = diff % 60;
      setElapsed(`${minutes}:${seconds.toString().padStart(2, '0')}`);
    };

    updateElapsed(); // call immediately

    const interval = setInterval(updateElapsed, 1000);
    return () => clearInterval(interval);
  }, []);

  return (
    <SafeAreaView edges={['top']}>
      <View style={{ height: 72, paddingHorizontal: 16, flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
        <Pressable onPress={router.back}>
          <Ionicons name="chevron-back" size={24} color={tintColor} />
        </Pressable>
        <View style={{ flex: 1, marginHorizontal: 12 }}>
          <TextInput
            value={title}
            onChangeText={setTitle}
            placeholder="Edit Title"
            placeholderTextColor="#aaa"
            maxLength={24}
            style={{
              color: tintColor,
              fontSize: 20,
              fontWeight: '600',
              paddingVertical: 4,
              minWidth: 120,
              textAlign: 'center',
            }}
          />
          <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: 4 }}>
            <Ionicons name="time-outline" size={14} color={tintColor} />
            <Text style={{ color: tintColor, fontSize: 14 }}>{elapsed}</Text>
          </View>
        </View>
        <Pressable onPress={() => {pushWorkout(); router.back()}}>
          <Ionicons name="checkmark" size={24} color={tintColor} />
        </Pressable>
      </View>
    </SafeAreaView>
  );
}

export default function HomeLayout() {
  const colorScheme = useColorScheme();
  return (
    <TouchableWithoutFeedback onPress={Keyboard.dismiss} accessible={false}>
      <View style={{ flex: 1 }}>
        <Stack
          screenOptions={{
            header: () => <CustomHeader />,
            headerShown: true,
          }}
        >
          <Stack.Screen name="index" options={{ headerShown: false }} />
        </Stack>
      </View>
    </TouchableWithoutFeedback>
  );
}
