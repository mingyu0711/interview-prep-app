import { useEffect, useRef, useState } from 'react';
import { Animated, View, Text, StyleSheet } from 'react-native';
import { Stack } from 'expo-router';
import * as SplashScreen from 'expo-splash-screen';

SplashScreen.preventAutoHideAsync();

function AnimatedSplash({ onFinish }: { onFinish: () => void }) {
  const scale = useRef(new Animated.Value(0.6)).current;
  const logoOpacity = useRef(new Animated.Value(0)).current;
  const textOpacity = useRef(new Animated.Value(0)).current;
  const fadeOut = useRef(new Animated.Value(1)).current;

  useEffect(() => {
    Animated.sequence([
      Animated.parallel([
        Animated.spring(scale, { toValue: 1, tension: 60, friction: 8, useNativeDriver: true }),
        Animated.timing(logoOpacity, { toValue: 1, duration: 500, useNativeDriver: true }),
      ]),
      Animated.timing(textOpacity, { toValue: 1, duration: 400, useNativeDriver: true }),
      Animated.delay(700),
      Animated.timing(fadeOut, { toValue: 0, duration: 500, useNativeDriver: true }),
    ]).start(() => onFinish());
  }, []);

  return (
    <Animated.View style={[StyleSheet.absoluteFill, styles.splashBg, { opacity: fadeOut }]}>
      <View style={styles.splashContent}>
        <Animated.View
          style={{ transform: [{ scale }], opacity: logoOpacity, alignItems: 'center' }}
        >
          <View style={styles.logoBox}>
            <Text style={styles.logoLetter}>P</Text>
          </View>
        </Animated.View>
        <Animated.View style={{ opacity: textOpacity, alignItems: 'center', marginTop: 20 }}>
          <Text style={styles.appName}>PrepView</Text>
          <Text style={styles.appSub}>면접 연습 도우미</Text>
        </Animated.View>
      </View>
    </Animated.View>
  );
}

export default function RootLayout() {
  const [ready, setReady] = useState(false);

  useEffect(() => {
    SplashScreen.hideAsync();
  }, []);

  return (
    <View style={{ flex: 1 }}>
      <Stack screenOptions={{ headerShown: false }} />
      {!ready && <AnimatedSplash onFinish={() => setReady(true)} />}
    </View>
  );
}

const styles = StyleSheet.create({
  splashBg: {
    backgroundColor: '#4F46E5',
  },
  splashContent: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  logoBox: {
    width: 88,
    height: 88,
    borderRadius: 24,
    backgroundColor: 'rgba(255,255,255,0.2)',
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 2,
    borderColor: 'rgba(255,255,255,0.4)',
  },
  logoLetter: {
    fontSize: 48,
    fontWeight: '700',
    color: '#FFFFFF',
    letterSpacing: -1,
  },
  appName: {
    fontSize: 28,
    fontWeight: '700',
    color: '#FFFFFF',
    letterSpacing: -0.5,
  },
  appSub: {
    fontSize: 14,
    color: 'rgba(255,255,255,0.7)',
    marginTop: 6,
    letterSpacing: 0.3,
  },
});
