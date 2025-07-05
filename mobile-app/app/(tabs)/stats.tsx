import { StyleSheet, Dimensions } from 'react-native';
const screenWidth = Dimensions.get('window').width;
const itemWidth = screenWidth * 0.44;

import { Text, View } from '@/components/Themed';
import GridPreview from '@/components/stats/preview/GridPreview';
import SetsOverTimePreview from '@/components/stats/preview/SetsOverTimePreview';

export default function TabTwoScreen() {
  return (
    <View style={styles.container}>
      <Text style={styles.section}>Recent Progress</Text>
      <View style={styles.gridContainer}>
        <View style={styles.gridItem}>
          <GridPreview
            title="Sets Over Time"
            caption="Last 6 Weeks"
            footerValue="60"
            footerUnit="sets last week"
          >
            <SetsOverTimePreview />
          </GridPreview>
        </View>
        {/* <View style={styles.gridItem}>
          <GridPreview
            title="Sets Over Time"
            caption="Last 6 Weeks"
            footerValue="22"
            footerUnit="sets"
          >
            <SetsOverTimePreview />
          </GridPreview>
        </View> */}
      </View>
      {/* <Text style={styles.section}>Habits</Text>
      <View style={styles.gridContainer}></View>

      <Text style={styles.section}>Body Metrics</Text>
      <View style={styles.gridContainer}></View>

      <Text style={styles.section}>Muscle Breakdown</Text>
      <View style={styles.gridContainer}></View> */}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingTop: 60,
    paddingHorizontal: 20,
    backgroundColor: '#000',
  },
  section: {
    fontSize: 18,
    fontWeight: '600',
    color: '#fff',
    marginTop: 32,
    marginBottom: 8,
  },
  gridContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
    rowGap: 12,
  },
  gridItem: {
    width: itemWidth,
    marginBottom: 12,
  },
});
