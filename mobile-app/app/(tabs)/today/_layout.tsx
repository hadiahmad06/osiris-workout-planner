import { Stack } from 'expo-router';
import Colors from '@/constants/Colors';
import { useColorScheme, TextInput, View, Text, TouchableWithoutFeedback, Keyboard } from 'react-native';
import { useEffect, useState } from 'react';

function HeaderTitle(props: { tintColor?: string }) {
  const [title, setTitle] = useState('');

  return (
    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center', right: 12 }}>
      <TextInput
        value={title}
        onChangeText={setTitle}
        placeholder="Edit Title"
        placeholderTextColor="#aaa"
        style={{
          color: props.tintColor ?? '#fff',
          fontSize: 20,
          fontWeight: '600',
          paddingVertical: 4,
          minWidth: 120,
          textAlign: 'center',
        }}
      />
    </View>
  );
}

function Timer(props: { tintColor?: string}) {
  const [elapsed, setElapsed] = useState('');
  const startDate = new Date('2025-07-06T20:00:00Z'); // Replace as needed

  useEffect(() => {
    const interval = setInterval(() => {
      const now = new Date();
      const diff = Math.floor((now.getTime() - startDate.getTime()) / 1000);
      const minutes = Math.floor(diff / 60);
      const seconds = diff % 60;
      setElapsed(`${minutes}:${seconds.toString().padStart(2, '0')}`);
    }, 1000);
    return () => clearInterval(interval);
  }, []);
  return (
    // <View style={{ alignItems: 'flex-start', justifyContent: 'center' }}>
      <Text style={{ color: props.tintColor ?? '#fff', fontSize: 16, textAlign: 'right' }}>{elapsed}</Text>
    // </View>
  )
}

export default function HomeLayout() {
  const colorScheme = useColorScheme();
  return (
    <TouchableWithoutFeedback onPress={Keyboard.dismiss} accessible={false}>
      <View style={{ flex: 1 }}>
        <Stack
          screenOptions={{
            headerTitle: props => <HeaderTitle {...props} />,
            headerStyle: { backgroundColor: Colors[colorScheme ?? 'dark'].background },
            headerTintColor: '#fff',
            headerBackButtonDisplayMode: 'minimal',
            headerBackButtonMenuEnabled: false,
            headerShown: true,
          }}
        >
          <Stack.Screen name="index" options={{ headerShown: false }} />
        </Stack>
      </View>
    </TouchableWithoutFeedback>
  );
}
