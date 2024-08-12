import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DeviceInfoPage(),
    );
  }
}

class DeviceInfoPage extends StatefulWidget {
  const DeviceInfoPage({super.key});

  @override
  _DeviceInfoPageState createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  static const platform = MethodChannel('com.jboy.battery_kotlin/device_info');
  
  String _batteryLevel = 'Unknown';
  String _wifiSignalStrength = 'Unknown';

  Future<void> _getDeviceInfo() async {
    try {
      final result = await platform.invokeMethod('getDeviceInfo');
      setState(() {
        _batteryLevel = '${result['batteryLevel']}%';
        _wifiSignalStrength = '${result['wifiSignalStrength']} dBm';
      });
    } on PlatformException catch (e) {
      setState(() {
        _batteryLevel = "Failed to get battery level: '${e.message}'.";
        debugPrint(e.message);
        _wifiSignalStrength = "Failed to get WiFi signal strength: '${e.message}'.";
        debugPrint(e.message);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Info'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('🪫バッテリーレベル: $_batteryLevel'),
            Text('🛜Wifiレベル: $_wifiSignalStrength'),
            ElevatedButton(
              onPressed: _getDeviceInfo,
              child: const Text('Get Device Info'),
            ),
          ],
        ),
      ),
    );
  }
}