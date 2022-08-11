// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';

/// A method channel -based implementation of the SensorsPlatform interface.
class MethodChannelSensors extends SensorsPlatform {
  static const EventChannel _accelerometerEventChannel =
      EventChannel('dev.fluttercommunity.plus/sensors/accelerometer');

  static const EventChannel _userAccelerometerEventChannel =
      EventChannel('dev.fluttercommunity.plus/sensors/user_accel');

  static const EventChannel _gyroscopeEventChannel =
      EventChannel('dev.fluttercommunity.plus/sensors/gyroscope');

  static const EventChannel _magnetometerEventChannel =
      EventChannel('dev.fluttercommunity.plus/sensors/magnetometer');

  Stream<AccelerometerEvent>? _accelerometerEvents;
  Stream<GyroscopeEvent>? _gyroscopeEvents;
  Stream<UserAccelerometerEvent>? _userAccelerometerEvents;
  Stream<MagnetometerEvent>? _magnetometerEvents;

  // The desired delay between events in microseconds. (Default is 200000 microseconds)
  // int _sampleRate = 200000;

  ///Set the desired sampleRate. (Microseconds)
  ///
  ///This is only a hint to the system.
  ///Events may be received faster or slower than the specified rate.
  ///
  ///* In order to access sensor data at high sampling rates,
  ///  apps must declare the Manifest.permission.HIGH_SAMPLING_RATE_SENSORS permission in their AndroidManifest.xml file.
  ///
  /// Not sure how to make this method availbe to users of this package.
  // void setSensorSampleRate(int sampleRate) {
  //   _sampleRate = sampleRate;
  // }

  /// A broadcast stream of events from the device accelerometer.
  @override
  Stream<AccelerometerEvent> get accelerometerEvents {
    _accelerometerEvents ??= _accelerometerEventChannel
        .receiveBroadcastStream()
        .map((dynamic event) {
      final list = event.cast<double>();

      return AccelerometerEvent(list[0]!, list[1]!, list[2]!, list[3]!);
    });
    return _accelerometerEvents!;
  }

  /// A broadcast stream of events from the device gyroscope.
  @override
  Stream<GyroscopeEvent> get gyroscopeEvents {
    _gyroscopeEvents ??=
        _gyroscopeEventChannel.receiveBroadcastStream().map((dynamic event) {
      final list = event.cast<double>();
      return GyroscopeEvent(list[0]!, list[1]!, list[2]!, list[3]!);
    });
    return _gyroscopeEvents!;
  }

  /// Events from the device accelerometer with gravity removed.
  @override
  Stream<UserAccelerometerEvent> get userAccelerometerEvents {
    _userAccelerometerEvents ??= _userAccelerometerEventChannel
        .receiveBroadcastStream()
        .map((dynamic event) {
      final list = event.cast<double>();
      return UserAccelerometerEvent(list[0]!, list[1]!, list[2]!, list[3]!);
    });
    return _userAccelerometerEvents!;
  }

  /// A broadcast stream of events from the device magnetometer.
  @override
  Stream<MagnetometerEvent> get magnetometerEvents {
    _magnetometerEvents ??=
        _magnetometerEventChannel.receiveBroadcastStream().map((dynamic event) {
      final list = event.cast<double>();
      return MagnetometerEvent(list[0]!, list[1]!, list[2]!, list[3]!);
    });
    return _magnetometerEvents!;
  }
}
