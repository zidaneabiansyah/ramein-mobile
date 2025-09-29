import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../events/screens/attendance_screen.dart';

/// QR Scanner Screen untuk scan QR code event
class QRScannerScreen extends ConsumerStatefulWidget {
  const QRScannerScreen({super.key});

  @override
  ConsumerState<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends ConsumerState<QRScannerScreen>
    with TickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  MobileScannerController? controller;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  bool _isScanning = true;
  String? _lastScannedCode;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    controller = MobileScannerController();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (!_isScanning) return;
    
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null && barcode.rawValue != _lastScannedCode) {
        _lastScannedCode = barcode.rawValue;
        _handleQRCode(barcode.rawValue!);
        break;
      }
    }
  }

  void _handleQRCode(String code) {
    setState(() {
      _isScanning = false;
    });

    // Parse QR code untuk mendapatkan informasi event
    try {
      // Format QR code: event_id|event_title|token
      final parts = code.split('|');
      if (parts.length >= 3) {
        final eventId = parts[0];
        final eventTitle = parts[1];
        final token = parts[2];

        // Navigate ke attendance screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AttendanceScreen(
              eventId: eventId,
              eventTitle: eventTitle,
              token: token,
            ),
          ),
        ).then((_) {
          // Resume scanning setelah kembali
          setState(() {
            _isScanning = true;
            _lastScannedCode = null;
          });
        });
      } else {
        _showErrorDialog('QR Code tidak valid');
      }
    } catch (e) {
      _showErrorDialog('Gagal memproses QR Code');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isScanning = true;
                _lastScannedCode = null;
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // QR Scanner View
          MobileScanner(
            key: qrKey,
            controller: controller,
            onDetect: _onDetect,
          ),

          // Scanner Overlay
          _buildScannerOverlay(),

          // Top App Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            'Scan QR Code Event',
                            style: AppTypography.headlineSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () {
                            controller?.toggleTorch();
                          },
                          icon: const Icon(
                            Icons.flash_on,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom Instructions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.qr_code_scanner,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  'Arahkan kamera ke QR Code event',
                                  style: AppTypography.bodyLarge.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  'QR Code akan otomatis terdeteksi untuk check-in event',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildActionButton(
                                icon: Icons.photo_library,
                                label: 'Galeri',
                                onTap: () {
                                  // TODO: Implement gallery picker
                                },
                              ),
                              _buildActionButton(
                                icon: Icons.history,
                                label: 'Riwayat',
                                onTap: () {
                                  // TODO: Navigate to history
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Corner indicators
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.primary, width: 5),
                    left: BorderSide(color: AppColors.primary, width: 5),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.primary, width: 5),
                    right: BorderSide(color: AppColors.primary, width: 5),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.primary, width: 5),
                    left: BorderSide(color: AppColors.primary, width: 5),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.primary, width: 5),
                    right: BorderSide(color: AppColors.primary, width: 5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
