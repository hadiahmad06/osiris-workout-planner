

import React, { useState } from 'react';
import { View } from 'react-native';
import { LineChart } from 'react-native-chart-kit';

export default function SetsOverTimePreview() {
  const [parentWidth, setParentWidth] = useState(0);
  const [parentHeight, setParentHeight] = useState(0);

  const data = {
    labels: [],
    datasets: [
      {
        data: [22, 35, 45, 40, 54, 60],
        color: () => '#6495ED',
        strokeWidth: 2,
      },
    ],
  };

  const chartConfig = {
    backgroundGradientFrom: 'transparent',
    backgroundGradientTo: 'transparent',
    backgroundGradientFromOpacity: 0,
    backgroundGradientToOpacity: 0,
    color: () => '#6495ED',
    strokeWidth: 2,
    propsForDots: {
      r: '0',
    },
    decimalPlaces: 0,
  };

  return (
    <View 
        style={{ width: '100%', height: '100%' }} 
        onLayout={e => {
          setParentWidth(e.nativeEvent.layout.width);
          setParentHeight(e.nativeEvent.layout.height);
        }}
    >
      {parentWidth > 0 && (
        <LineChart
          data={data}
          width={parentWidth}
          height={parentHeight}
          withVerticalLabels={false}
          withHorizontalLabels={false}
          withDots={false}
          withInnerLines={false}
          fromZero={true}
          withOuterLines={false}
          chartConfig={chartConfig}
          // bezier
          style={{ 
            width: '100%', 
            height: 80, 
            alignSelf: 'stretch',
            paddingRight: 0, 
            // paddingLeft: 0,
          }}
        />
      )}
    </View>
  );
}