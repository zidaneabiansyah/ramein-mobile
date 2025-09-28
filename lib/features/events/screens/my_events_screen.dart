import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/event_provider.dart';
import '../../../core/models/registration_model.dart';
import '../../../shared/widgets/ramein_button.dart';
import 'event_detail_screen.dart';
import 'attendance_screen.dart';

/// My Events Screen untuk aplikasi Ramein
/// Menampilkan event yang sudah didaftar oleh user
class MyEventsScreen extends ConsumerStatefulWidget {
  const MyEventsScreen({super.key});

  @override
  ConsumerState<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends ConsumerState<MyEventsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  String _selectedFilter = 'Semua';
  final List<String> _filterOptions = ['Semua', 'Akan Datang', 'Sudah Selesai', 'Sudah Hadir'];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400), // Reduced from 800ms
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final eventState = ref.watch(eventProvider);

    // Get user registrations
    final userRegistrations = eventState.events
        .map((event) => _getUserRegistration(event.id, authState.user?.id ?? ''))
        .where((reg) => reg != null)
        .cast<RegistrationModel>()
        .toList();

    // Filter registrations based on selected filter
    final filteredRegistrations = _filterRegistrations(userRegistrations, eventState.events);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      // App Bar
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.white,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withValues(alpha: 0.2),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
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
                                  '${userRegistrations.length} kegiatan terdaftar',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Filter Chips
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.md,
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filterOptions.length,
                      itemBuilder: (context, index) {
                        final filter = _filterOptions[index];
                        final isSelected = _selectedFilter == filter;
                        
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: FilterChip(
                            label: Text(
                              filter,
                              style: AppTypography.labelMedium.copyWith(
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                            backgroundColor: AppColors.surface,
                            selectedColor: AppColors.primary,
                            checkmarkColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : AppColors.borderLight,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Events List
              Expanded(
                child: eventState.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : filteredRegistrations.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: () async {
                              await ref.read(eventProvider.notifier).refreshEvents();
                            },
                            color: AppColors.primary,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.screenPadding,
                              ),
                              itemCount: filteredRegistrations.length,
                              itemBuilder: (context, index) {
                                final registration = filteredRegistrations[index];
                                final event = eventState.events
                                    .firstWhere((e) => e.id == registration.eventId);
                                
                                return FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: SlideTransition(
                                    position: _slideAnimation,
                                    child: _buildEventCard(event, registration, index),
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

  Widget _buildEmptyState() {
    return Center(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              ),
              child: Icon(
                _selectedFilter == 'Semua' 
                    ? Icons.event_busy_rounded
                    : _selectedFilter == 'Akan Datang'
                        ? Icons.schedule_rounded
                        : _selectedFilter == 'Sudah Selesai'
                            ? Icons.history_rounded
                            : Icons.check_circle_rounded,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              _getEmptyStateTitle(),
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _getEmptyStateMessage(),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            RameinButton(
              text: 'Jelajahi Kegiatan',
              onPressed: () => Navigator.of(context).pop(),
              variant: RameinButtonVariant.outline,
              icon: Icons.explore_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(dynamic event, RegistrationModel registration, int index) {
    final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');
    final now = DateTime.now();
    final eventDate = event.eventDate;
    final isEventPassed = eventDate.isBefore(now);
    final canAttend = eventDate.isAtSameMomentAs(now) || eventDate.isBefore(now);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Card(
        elevation: AppSpacing.cardElevation,
        shadowColor: AppColors.shadowLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EventDetailScreen(eventId: event.id),
            ),
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with status
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.title,
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _buildStatusChip(registration.status, isEventPassed),
                  ],
                ),
                
                const SizedBox(height: AppSpacing.md),
                
                // Event details
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: AppSpacing.iconSm,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      dateFormat.format(event.eventDate),
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Icon(
                      Icons.access_time_rounded,
                      size: AppSpacing.iconSm,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      event.eventTime,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSpacing.sm),
                
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: AppSpacing.iconSm,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        event.location,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSpacing.md),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: RameinButton(
                        text: 'Lihat Detail',
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EventDetailScreen(eventId: event.id),
                          ),
                        ),
                        variant: RameinButtonVariant.outline,
                        size: RameinButtonSize.small,
                        icon: Icons.visibility_rounded,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    if (canAttend && registration.status == RegistrationStatus.approved)
                      Expanded(
                        child: RameinButton(
                          text: 'Daftar Hadir',
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AttendanceScreen(
                                eventId: event.id,
                                eventTitle: event.title,
                                token: registration.token,
                              ),
                            ),
                          ),
                          variant: RameinButtonVariant.primary,
                          size: RameinButtonSize.small,
                          icon: Icons.check_circle_rounded,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(RegistrationStatus status, bool isEventPassed) {
    Color backgroundColor;
    Color textColor;
    String text;
    IconData icon;

    switch (status) {
      case RegistrationStatus.pending:
        backgroundColor = AppColors.warning.withValues(alpha: 0.1);
        textColor = AppColors.warning;
        text = 'Pending';
        icon = Icons.schedule_rounded;
        break;
      case RegistrationStatus.approved:
        if (isEventPassed) {
          backgroundColor = AppColors.success.withValues(alpha: 0.1);
          textColor = AppColors.success;
          text = 'Selesai';
          icon = Icons.check_circle_rounded;
        } else {
          backgroundColor = AppColors.primary.withValues(alpha: 0.1);
          textColor = AppColors.primary;
          text = 'Terdaftar';
          icon = Icons.event_available_rounded;
        }
        break;
      case RegistrationStatus.cancelled:
        backgroundColor = AppColors.error.withValues(alpha: 0.1);
        textColor = AppColors.error;
        text = 'Dibatalkan';
        icon = Icons.cancel_rounded;
        break;
      case RegistrationStatus.rejected:
        backgroundColor = AppColors.error.withValues(alpha: 0.1);
        textColor = AppColors.error;
        text = 'Ditolak';
        icon = Icons.block_rounded;
        break;
      case RegistrationStatus.attended:
        backgroundColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        text = 'Hadir';
        icon = Icons.check_circle_rounded;
        break;
      case RegistrationStatus.notAttended:
        backgroundColor = AppColors.warning.withValues(alpha: 0.1);
        textColor = AppColors.warning;
        text = 'Tidak Hadir';
        icon = Icons.cancel_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: textColor,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            text,
            style: AppTypography.labelSmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getEmptyStateTitle() {
    switch (_selectedFilter) {
      case 'Semua':
        return 'Belum ada kegiatan';
      case 'Akan Datang':
        return 'Tidak ada kegiatan mendatang';
      case 'Sudah Selesai':
        return 'Belum ada kegiatan selesai';
      case 'Sudah Hadir':
        return 'Belum ada kehadiran';
      default:
        return 'Belum ada kegiatan';
    }
  }

  String _getEmptyStateMessage() {
    switch (_selectedFilter) {
      case 'Semua':
        return 'Anda belum mendaftar untuk kegiatan apapun. Jelajahi kegiatan menarik dan daftar sekarang!';
      case 'Akan Datang':
        return 'Tidak ada kegiatan mendatang yang sudah Anda daftari.';
      case 'Sudah Selesai':
        return 'Belum ada kegiatan yang sudah selesai diikuti.';
      case 'Sudah Hadir':
        return 'Anda belum menghadiri kegiatan apapun. Daftar dan hadiri kegiatan untuk mendapatkan sertifikat!';
      default:
        return 'Jelajahi kegiatan menarik dan daftar sekarang!';
    }
  }

  List<RegistrationModel> _filterRegistrations(
    List<RegistrationModel> registrations,
    List<dynamic> events,
  ) {
    final now = DateTime.now();
    
    return registrations.where((registration) {
      final event = events.firstWhere((e) => e.id == registration.eventId);
      final eventDate = event.eventDate;
      
      switch (_selectedFilter) {
        case 'Semua':
          return true;
        case 'Akan Datang':
          return eventDate.isAfter(now);
        case 'Sudah Selesai':
          return eventDate.isBefore(now);
        case 'Sudah Hadir':
          return registration.status == RegistrationStatus.approved && 
                eventDate.isBefore(now);
        default:
          return true;
      }
    }).toList();
  }

  RegistrationModel? _getUserRegistration(String eventId, String userId) {
    // This is a mock implementation
    // In real app, this would come from the registration provider
    return null; // TODO: Implement proper registration retrieval
  }
}