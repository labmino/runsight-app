import 'package:flutter/material.dart';
import 'package:labmino_app/presentation/history/history_screen.dart';
import 'package:provider/provider.dart';
import '../../controller/device_pairing_controller.dart';
import '../../controller/auth_controller.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../homepage/dashboard.dart';
import '../authentication/login.dart';

class DevicePairingScreen extends StatefulWidget {
  const DevicePairingScreen({super.key});

  @override
  State<DevicePairingScreen> createState() => _DevicePairingScreenState();
}

class _DevicePairingScreenState extends State<DevicePairingScreen> {
  int _currentNavIndex = 2; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAvailableDevices();
    });
  }

  void _loadAvailableDevices() {
    final pairingController = Provider.of<DevicePairingController>(
      context,
      listen: false,
    );
    pairingController.getConnectedDevices();
  }

  void _connectDevice() {
    final pairingController = Provider.of<DevicePairingController>(
      context,
      listen: false,
    );
    pairingController.requestPairingCode();
  }

  void _onNavBarTap(int index) {
    final authController = Provider.of<AuthController>(context, listen: false);
    if (!authController.isLoggedIn || authController.currentUser == null) {
      _navigateToLogin();
      return;
    }

    setState(() {
      _currentNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HistoryScreen()),
        );
        break;
      case 2:
        break;
      case 3:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Community page coming soon!')),
        );
        break;
      case 4:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings page coming soon!')),
        );
        break;
    }
  }

  void _navigateToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: const Color(0xff1b1f3b)),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _buildHeader(),
                        const SizedBox(height: 32),
                        _buildAvailableDevicesSection(),
                        const SizedBox(height: 32),
                        _buildConnectSection(),
                        const SizedBox(height: 32),
                        _buildInstructionsSection(),
                      ],
                    ),
                  ),
                ),
              ),

              CustomBottomNavBar(
                currentIndex: _currentNavIndex,
                onTap: _onNavBarTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Connect Your Device',
                textAlign: TextAlign.center,
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 28,
                  color: const Color(0xffffffff),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(
                'Pair your smart glasses to get started',
                textAlign: TextAlign.center,
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 16,
                  color: const Color(0xff888b94),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAvailableDevicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Devices',
          style: TextStyle(
            decoration: TextDecoration.none,
            fontSize: 16,
            color: const Color(0xffffffff),
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 16),

        _buildDeviceCard(
          deviceName: 'RunSight Glasses Pro',
          deviceModel: 'Model: RSG-2024',
          isAvailable: true,
          signalStrength: 'Strong',
          iconColor: const Color(0xff3abeff),
        ),

        const SizedBox(height: 16),

        _buildDeviceCard(
          deviceName: 'RunSight Glasses Lite',
          deviceModel: 'Model: RSG-2023',
          isAvailable: false,
          signalStrength: 'Out of range',
          iconColor: const Color(0xff888b94),
        ),
      ],
    );
  }

  Widget _buildDeviceCard({
    required String deviceName,
    required String deviceModel,
    required bool isAvailable,
    required String signalStrength,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isAvailable ? const Color(0xffffffff) : const Color(0x99ffffff),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.smart_toy, size: 24, color: iconColor),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deviceName,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 16,
                      color: const Color(0xff1b1f3b),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deviceModel,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 14,
                      color: const Color(0xff888b94),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: iconColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isAvailable ? 'Ready to pair' : 'Out of range',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 12,
                          color: iconColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            Column(
              children: [
                Icon(Icons.wifi, size: 20, color: iconColor),
                const SizedBox(height: 4),
                Text(
                  signalStrength,
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 12,
                    color: const Color(0xff888b94),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectSection() {
    return Consumer<DevicePairingController>(
      builder: (context, pairingController, child) {
        return Column(
          children: [
            GestureDetector(
              onTap: pairingController.isLoading ? null : _connectDevice,
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xff3abeff),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (pairingController.isLoading) ...[
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xff1b1f3b),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Connecting...',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 16,
                          color: const Color(0xff1b1f3b),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ] else ...[
                      Text(
                        'Connect Device',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 16,
                          color: const Color(0xff1b1f3b),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Need help pairing?',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 14,
                    color: const Color(0xff888b94),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildInstructionsSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0x193abeff),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: const Color(0xff3abeff),
                ),
                const SizedBox(width: 8),
                Text(
                  'Pairing Instructions',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 14,
                    color: const Color(0xff3abeff),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '1. Turn on your RunSight glasses\n2. Hold the power button for 3 seconds\n3. Wait for the blue light to flash\n4. Tap \'Connect Device\' above',
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 12,
                color: const Color(0xff3abeff),
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
