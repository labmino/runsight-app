import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/device_pairing_controller.dart';
import '../run/setup_run_page.dart';

class PairingCodePage extends StatefulWidget {
  const PairingCodePage({super.key});

  @override
  State<PairingCodePage> createState() => _PairingCodePageState();
}

class _PairingCodePageState extends State<PairingCodePage> {
  Timer? _pollingTimer;
  int _remainingSeconds = 300; // 5 minutes
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startPairingStatusPolling();
    _startCountdown();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
          _onCodeExpired();
        }
      });
    });
  }

  void _startPairingStatusPolling() {
    final controller = Provider.of<DevicePairingController>(
      context,
      listen: false,
    );

    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (controller.currentSession != null) {
        final status = await controller.checkPairingStatus(
          controller.currentSession!.id,
        );

        if (status != null) {
          if (status.paired && status.device != null) {
            // Device berhasil paired!
            timer.cancel();
            _countdownTimer?.cancel();

            if (mounted) {
              _showSuccessAndNavigate();
            }
          } else if (status.expired) {
            // Kode expired
            timer.cancel();
            _countdownTimer?.cancel();

            if (mounted) {
              _onCodeExpired();
            }
          }
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _showSuccessAndNavigate() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Device connected successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate ke setup run page setelah delay singkat
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SetupRunPage()),
        );
      }
    });
  }

  void _onCodeExpired() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pairing code expired. Please try again.'),
        backgroundColor: Colors.red,
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Color(0xff1b1f3b)),
        child: SafeArea(
          child: Consumer<DevicePairingController>(
            builder: (context, controller, child) {
              if (controller.currentSession == null &&
                  !controller.pairingSuccessful) {
                return _buildError("No pairing session found");
              }

              // If pairing successful but session is null, show success state
              if (controller.currentSession == null &&
                  controller.pairingSuccessful) {
                return _buildSuccessState();
              }

              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            _buildDeviceIcon(),
                            const SizedBox(height: 24),
                            _buildInstructions(),
                            const SizedBox(height: 24),
                            _buildPairingCode(
                              controller.currentSession?.code ?? '',
                            ),
                            const SizedBox(height: 24),
                            _buildCountdown(),
                            const SizedBox(height: 32),
                            _buildWaitingIndicator(),
                            const SizedBox(height: 32),
                            _buildCancelButton(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            _pollingTimer?.cancel();
            _countdownTimer?.cancel();
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Text(
            'Connect Device',
            style: TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceIcon() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0x193abeff),
        borderRadius: BorderRadius.circular(32),
      ),
      child: const Icon(Icons.watch, size: 32, color: Color(0xff3abeff)),
    );
  }

  Widget _buildInstructions() {
    return Column(
      children: [
        const Text(
          'Pairing Code Generated!',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const Text(
          'Enter this code on your smartwatch to connect:',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xff888b94),
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPairingCode(String code) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0x193abeff),
        border: Border.all(color: const Color(0xff3abeff), width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        code,
        style: const TextStyle(
          fontSize: 32,
          color: Color(0xff3abeff),
          fontWeight: FontWeight.bold,
          letterSpacing: 6,
        ),
      ),
    );
  }

  Widget _buildCountdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x193abeff),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Expires in: ${_formatTime(_remainingSeconds)}',
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xff3abeff),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildWaitingIndicator() {
    return Column(
      children: [
        const SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff3abeff)),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Waiting for device connection...',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Make sure your device is powered on',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xff888b94),
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildCancelButton() {
    return GestureDetector(
      onTap: () {
        _pollingTimer?.cancel();
        _countdownTimer?.cancel();

        final controller = Provider.of<DevicePairingController>(
          context,
          listen: false,
        );
        if (controller.currentSession != null) {
          controller.cancelPairing(controller.currentSession!.id);
        }

        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: const Color(0xff888b94), width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'Cancel Pairing',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xff888b94),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 64),
          const SizedBox(height: 16),
          const Text(
            'Device Connected Successfully!',
            style: TextStyle(fontSize: 18, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Redirecting to setup...',
            style: TextStyle(fontSize: 14, color: Color(0xff888b94)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff3abeff)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 18, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}
