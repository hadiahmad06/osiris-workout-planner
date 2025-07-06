import { StyleSheet } from 'react-native';

import { FontAwesome } from '@expo/vector-icons';

import { Text, View } from '@/components/Themed';

export default function TabOneScreen() {
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
      <View style={styles.contentBox}>
        <Text style={styles.contentText}>Start Today's Workout!</Text>
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
  contentBox: {
    backgroundColor: '#333',
    flex: 1,
    borderRadius: 16,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
  },
  contentText: {
    color: '#fff',
    fontSize: 18,
  },
});
