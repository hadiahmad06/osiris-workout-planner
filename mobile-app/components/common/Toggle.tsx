import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { MotiView } from 'moti';


type ToggleOption = {
  key: string;
  label: string;
  disabled?: boolean;
};

type ToggleProps = {
  options: ToggleOption[];
  selected: string;
  onChange: (val: string) => void;
  width?: number;
  backgroundColor?: string,
};

// i used a padding of 4, dont change these values without updating the width calculation
export default function Toggle({ options, selected, onChange, width = 70, backgroundColor = '#6a5acd' }: ToggleProps) {
  console.log('selected', selected, 'keys:', options.map((opt) => opt.key));
  const selectedIndex = options.findIndex((opt) => opt.key === selected);
  return (
    <View style={styles.toggleWrapper}>
      <View style={styles.toggleInner}>
        <MotiView
          animate={{ translateX: selectedIndex * (width + 4 + 2) }}
          transition={{ type: 'timing', duration: 200 }}
          style={[styles.toggleSlider, { width: width + 4+2, backgroundColor: backgroundColor }]}
        />
        {options.map((val) => (
          <TouchableOpacity key={val.key} onPress={() => onChange(val.key)}>
            <View style={[styles.toggleOption, { width }]}>
              <Text style={styles.toggleText}>{val.label}</Text>
            </View>
          </TouchableOpacity>
        ))}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  toggleWrapper: {
    // gap: 4,
    flexDirection: 'row',
    backgroundColor: 'rgba(255,255,255,0.1)',
    borderRadius: 8,
    paddingHorizontal: 4,
    paddingVertical: 2,
    position: 'relative',
    overflow: 'hidden',
  },
  toggleInner: {
    flexDirection: 'row',
    position: 'relative',
    paddingHorizontal: 4,
    gap: 4,
    paddingVertical: 2,
    backgroundColor: 'transparent',
  },
  toggleSlider: {
    flex: 1,
    position: 'absolute',
    top: 2,
    height: '100%',
    borderRadius: 6,
  },
  toggleOption: {
    backgroundColor: 'transparent',
    paddingVertical: 4,
    paddingHorizontal: 3,
    borderRadius: 6,
    alignItems: 'center',
    justifyContent: 'center',
  },
  toggleText: {
    color: '#fff',
  },
});