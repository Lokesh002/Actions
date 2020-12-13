import 'dart:io';
import 'package:workmanager/workmanager.dart';

import 'package:flutter/services.dart';
import 'package:sensors/sensors.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shake/shake.dart';
import 'package:flashlight/flashlight.dart';
import 'package:camera/camera.dart';

class ActionShow extends StatefulWidget {
  @override
  _ActionShowState createState() => _ActionShowState();
}

class _ActionShowState extends State<ActionShow> {
  List<double> _accelerometerValues;
  List<double> _userAccelerometerValues;
  List<double> _gyroscopeValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  @override
  void dispose() {
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  GyroscopeEvent gyroscopeEvent;
  bool pressed = false;
  bool torchOn = false;
  ShakeDetector detector;
  CameraController camController;
  @override
  void initState() {
    super.initState();

    //    detector = ShakeDetector.waitForStart(
//        shakeThresholdGravity: 5.0,
//        shakeSlopTimeMS: 1000,
//        onPhoneShake: () {
//          if (torchOn) {
//            Flashlight.lightOff();
//            print('torch OFF');
//            torchOn = false;
//          } else {
//            Flashlight.lightOn();
//            print('torch ON');
//            torchOn = true;
//          }
//        });

    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double>[
          event.x.abs(),
          event.y.abs(),
          event.z.abs()
        ];
      });
    }));
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[
          event.x.abs(),
          event.y.abs(),
          event.z.abs()
        ];
      });
    }));
    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _userAccelerometerValues = <double>[
          event.x.abs(),
          event.y.abs(),
          event.z.abs()
        ];
      });
    }));
  }

  StreamSubscription streamSubscription;
  void doSomething() async {
    streamSubscription =
        userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      double x = event.x;
      double y = event.y;
      double z = event.z;

      if (x > 7.0 && z > 9.0 && y < 3.0 && !torchOn) {
        Flashlight.lightOn();
        Future.delayed(Duration(seconds: 1), () {
          torchOn = true;
        });
      } else if (x > 7.0 && z > 9.0 && y < 3.0 && torchOn) {
        Flashlight.lightOff();
        Future.delayed(Duration(seconds: 1), () {
          torchOn = false;
        });
      }

//      else if (x > 9.0 && z < 2.0 && y > 4.0 && !torchOn) {
//        Flashlight.lightOn();
//        Future.delayed(Duration(seconds: 1), () {
//          torchOn = true;
//        });
//      } else if (x > 7.0 && z > 9.0 && y < 3.0 && torchOn) {
//        Flashlight.lightOff();
//        Future.delayed(Duration(seconds: 1), () {
//          torchOn = true;
//        });
//      }11
    });
  }

  void doNothing() {
    if (streamSubscription != null) {
      streamSubscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        ?.toList();

    final List<String> gyroscope =
        _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Actions Show'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Text(
              'acc: $accelerometer',
              style: TextStyle(fontSize: 30),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              'gyro: $gyroscope',
              style: TextStyle(fontSize: 30),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              'useracc: $userAccelerometer',
              style: TextStyle(fontSize: 30),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: FlatButton(
                onPressed: () async {
                  setState(() {
                    if (pressed) {
                      doNothing();
                      pressed = false;
                    } else {
                      doSomething();
                      pressed = true;
                    }
                  });
                },
                child: text(pressed)),
          ),
        ],
      ),
    );
  }

  Text text(bool pressed) {
    Text x;

    if (!pressed) {
      x = Text('Start');
    } else {
      x = Text('Stop');
    }

    return x;
  }
}
