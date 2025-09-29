import 'package:flutter/material.dart';

/// Model untuk Quick Action buttons seperti Gojek/Grab
class QuickActionModel {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final String? badge;
  final VoidCallback onTap;

  const QuickActionModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    this.badge,
    required this.onTap,
  });
}

/// Data untuk Quick Actions
class QuickActionData {
  static List<QuickActionModel> get quickActions => [
    QuickActionModel(
      id: 'events',
      title: 'Event',
      icon: Icons.event,
      color: const Color(0xFF1A2BFF),
      onTap: () {
        // TODO: Navigate to events
      },
    ),
    QuickActionModel(
      id: 'qr_scan',
      title: 'Scan QR',
      icon: Icons.qr_code_scanner,
      color: const Color(0xFF00ED64),
      onTap: () {
        // TODO: Navigate to QR scanner
      },
    ),
    QuickActionModel(
      id: 'history',
      title: 'Riwayat',
      icon: Icons.history,
      color: const Color(0xFFFF6B35),
      onTap: () {
        // TODO: Navigate to history
      },
    ),
    QuickActionModel(
      id: 'certificates',
      title: 'Sertifikat',
      icon: Icons.school,
      color: const Color(0xFF9C27B0),
      onTap: () {
        // TODO: Navigate to certificates
      },
    ),
    QuickActionModel(
      id: 'chatbot',
      title: 'Chatbot',
      icon: Icons.chat,
      color: const Color(0xFF2196F3),
      badge: 'NEW',
      onTap: () {
        // TODO: Navigate to chatbot
      },
    ),
    QuickActionModel(
      id: 'profile',
      title: 'Profile',
      icon: Icons.person,
      color: const Color(0xFF607D8B),
      onTap: () {
        // TODO: Navigate to profile
      },
    ),
    QuickActionModel(
      id: 'settings',
      title: 'Pengaturan',
      icon: Icons.settings,
      color: const Color(0xFF795548),
      onTap: () {
        // TODO: Navigate to settings
      },
    ),
    QuickActionModel(
      id: 'more',
      title: 'Lainnya',
      icon: Icons.more_horiz,
      color: const Color(0xFF9E9E9E),
      onTap: () {
        // TODO: Show more options
      },
    ),
  ];
}
