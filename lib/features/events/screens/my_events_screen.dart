import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/ramein_button.dart';
import '../../../shared/widgets/ramein_input.dart';
import '../widgets/my_event_card.dart';

/// My Events Screen untuk aplikasi Ramein
/// Modern, minimalis, dan unik dengan identitas visual yang kuat
class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen>
    with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late TabController _tabController;
  
  bool _isLoading = true;
  String _searchQuery = '';

  final List<Map<String, dynamic>> _myEvents = [
    {
      'id': '1',
      'title': 'Workshop Flutter Development',
      'date': DateTime.now().add(const Duration(days: 3)),
      'time': '09:00 - 16:00',
      'location': 'Gedung Serbaguna ITB',
      'category': 'Teknologi',
      'image': 'https://via.placeholder.com/300x200',
      'status': 'registered',
      'registrationDate': DateTime.now().subtract(const Duration(days: 5)),
      'tokenNumber': 'TK001ABCDE',
      'attended': false,
      'certificateAvailable': false,
    },
    {
      'id': '2',
      'title': 'Seminar Digital Marketing',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'time': '13:00 - 17:00',
      'location': 'Hotel Grand Mercure',
      'category': 'Bisnis',
      'image': 'https://via.placeholder.com/300x200',
      'status': 'completed',
      'registrationDate': DateTime.now().subtract(const Duration(days: 15)),
      'tokenNumber': 'TK002FGHIJ',
      'attended': true,
      'attendanceDate': DateTime.now().subtract(const Duration(days: 7)),
      'certificateAvailable': true,
      'certificateNumber': 'CERT-002-2024',
    },
    {
      'id': '3',
      'title': 'Kelas Memasak Sehat',
      'date': DateTime.now().subtract(const Duration(days: 30)),
      'time': '10:00 - 14:00',
      'location': 'Cooking Studio Bandung',
      'category': 'Kesehatan',
      'image': 'https://via.placeholder.com/300x200',
      'status': 'completed',
      'registrationDate': DateTime.now().subtract(const Duration(days: 40)),
      'tokenNumber': 'TK003KLMNO',
      'attended': false,
      'certificateAvailable': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _setupAnimations();
    _loadMyEvents();
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
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
    ));

    _animationController.forward();
  }

  Future<void> _loadMyEvents() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _filteredEvents {
    List<Map<String, dynamic>> events = [];
    
    switch (_tabController.index) {
      case 0: // Semua
        events = _myEvents;
        break;
      case 1: // Terdaftar
        events = _myEvents.where((event) => event['status'] == 'registered').toList();
        break;
      case 2: // Selesai
        events = _myEvents.where((event) => event['status'] == 'completed').toList();
        break;
    }

    if (_searchQuery.isEmpty) {
      return events;
    }
    
    return events.where((event) {
      return event['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
             event['category'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
             event['location'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => context.pop(),
                            icon: const Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kegiatan Saya',
                                  style: AppTypography.headlineMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '${_myEvents.length} kegiatan terdaftar',
                                  style: AppTypography.bodyMedium.copyWith(
                                          color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.push('/certificates');
                            },
                            icon: const Icon(
                              Icons.workspace_premium_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppSpacing.lg),
                      
                      // Search Bar
                      RameinSearchInput(
                        controller: _searchController,
                        hint: 'Cari kegiatan saya...',
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Tab Bar
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  color: AppColors.surface,
                  child: TabBar(
                    controller: _tabController,
                    onTap: (index) {
                      setState(() {
                        // Trigger rebuild when tab changes
                      });
                    },
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.list_rounded, size: AppSpacing.iconSm),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Semua',
                              style: AppTypography.labelMedium,
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.app_registration_rounded, size: AppSpacing.iconSm),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Terdaftar',
                              style: AppTypography.labelMedium,
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle_rounded, size: AppSpacing.iconSm),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Selesai',
                              style: AppTypography.labelMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Statistics
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Total Kegiatan',
                            '${_myEvents.length}',
                            Icons.event_rounded,
                            AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _buildStatCard(
                            'Sudah Hadir',
                            '${_myEvents.where((e) => e['attended'] == true).length}',
                            Icons.check_circle_rounded,
                            AppColors.success,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _buildStatCard(
                            'Sertifikat',
                            '${_myEvents.where((e) => e['certificateAvailable'] == true).length}',
                            Icons.workspace_premium_rounded,
                            AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Events List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadMyEvents,
                  color: AppColors.primary,
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                      : _filteredEvents.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.screenPadding,
                              ),
                              itemCount: _filteredEvents.length,
                              itemBuilder: (context, index) {
                                final event = _filteredEvents[index];
                                return FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: SlideTransition(
                                    position: _slideAnimation,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppSpacing.md,
                                      ),
                                      child: MyEventCard(
                                        event: event,
                                        onTap: () {
                                          _showEventDetail(event);
                                        },
                                        onAttendance: event['status'] == 'registered' &&
                                            _isEventActiveToday(event['date'])
                                            ? () {
                                                context.push('/attendance');
                                              }
                                            : null,
                                        onCertificate: event['certificateAvailable'] == true
                                            ? () {
                                                context.push('/certificates');
                                              }
                                            : null,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            title,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    String title;
    String description;
    IconData icon;

    switch (_tabController.index) {
      case 1: // Terdaftar
        title = 'Belum Ada Kegiatan Terdaftar';
        description = 'Daftar kegiatan menarik dan mulai belajar hal baru';
        icon = Icons.app_registration_rounded;
        break;
      case 2: // Selesai
        title = 'Belum Ada Kegiatan Selesai';
        description = 'Kegiatan yang sudah Anda ikuti akan muncul di sini';
        icon = Icons.check_circle_rounded;
        break;
      default: // Semua
        title = _searchQuery.isEmpty ? 'Belum Ada Kegiatan' : 'Kegiatan Tidak Ditemukan';
        description = _searchQuery.isEmpty 
            ? 'Mulai jelajahi dan daftar kegiatan menarik'
            : 'Coba kata kunci yang berbeda';
        icon = _searchQuery.isEmpty ? Icons.event_rounded : Icons.search_off_rounded;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.textTertiary,
              size: AppSpacing.iconHuge,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              description,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
            if (_searchQuery.isEmpty && _tabController.index == 0) ...[
              const SizedBox(height: AppSpacing.lg),
              RameinButton(
                text: 'Jelajahi Kegiatan',
                onPressed: () {
                  context.push('/events');
                },
                variant: RameinButtonVariant.outline,
                size: RameinButtonSize.medium,
                icon: Icons.explore_rounded,
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _isEventActiveToday(DateTime eventDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDay = DateTime(eventDate.year, eventDate.month, eventDate.day);
    return today.isAtSameMomentAs(eventDay);
  }

  void _showEventDetail(Map<String, dynamic> event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildEventDetailSheet(event),
    );
  }

  Widget _buildEventDetailSheet(Map<String, dynamic> event) {
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');
    final registrationFormat = DateFormat('dd MMM yyyy HH:mm', 'id_ID');
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.radiusXl),
          topRight: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.md),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderMedium,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Icon(
                    _getStatusIcon(event['status']),
                    color: Colors.white,
                    size: AppSpacing.iconLg,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detail Kegiatan',
                        style: AppTypography.headlineSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _getStatusText(event['status']),
                        style: AppTypography.bodyMedium.copyWith(
                          color: _getStatusColor(event['status']),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Info
                  _buildDetailRow('Nama Kegiatan', event['title']),
                  _buildDetailRow('Kategori', event['category']),
                  _buildDetailRow('Tanggal & Waktu', '${dateFormat.format(event['date'])}, ${event['time']}'),
                  _buildDetailRow('Lokasi', event['location']),
                  _buildDetailRow('Tanggal Daftar', registrationFormat.format(event['registrationDate'])),
                  _buildDetailRow('Token Number', event['tokenNumber']),
                  
                  if (event['attended'] == true && event['attendanceDate'] != null)
                    _buildDetailRow('Tanggal Hadir', registrationFormat.format(event['attendanceDate'])),
                  
                  if (event['certificateAvailable'] == true && event['certificateNumber'] != null)
                    _buildDetailRow('Nomor Sertifikat', event['certificateNumber']),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Actions
                  if (event['status'] == 'registered' && _isEventActiveToday(event['date']))
                    RameinButton(
                      text: 'Absen Sekarang',
                      onPressed: () {
                        context.pop();
                        context.push('/attendance');
                      },
                      variant: RameinButtonVariant.primary,
                      size: RameinButtonSize.large,
                      isFullWidth: true,
                      icon: Icons.qr_code_scanner_rounded,
                    ),
                  
                  if (event['certificateAvailable'] == true) ...[
                    const SizedBox(height: AppSpacing.md),
                    RameinButton(
                      text: 'Lihat Sertifikat',
                      onPressed: () {
                        context.pop();
                        context.push('/certificates');
                      },
                      variant: RameinButtonVariant.outline,
                      size: RameinButtonSize.large,
                      isFullWidth: true,
                      icon: Icons.workspace_premium_rounded,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'registered':
        return Icons.app_registration_rounded;
      case 'completed':
        return Icons.check_circle_rounded;
      default:
        return Icons.event_rounded;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'registered':
        return AppColors.primary;
      case 'completed':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'registered':
        return 'Terdaftar';
      case 'completed':
        return 'Selesai';
      default:
        return 'Unknown';
    }
  }
}
