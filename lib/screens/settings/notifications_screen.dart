import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/notification_data_model.dart';
import 'package:urban_os/widgets/notification/notification_card.dart';
import 'package:urban_os/widgets/notification/notification_item.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  int _selectedFilter = 0;
  final Set<String> _readIds = {};

  List<NotificationItem> get _filteredNotifications {
    if (_selectedFilter == 0) return notifications;
    return notifications.where((n) {
      switch (_selectedFilter) {
        case 1:
          return n.severity == NotifSeverity.critical;
        case 2:
          return n.severity == NotifSeverity.warning;
        case 3:
          return n.severity == NotifSeverity.info;
        case 4:
          return n.category == 'System' || n.category == 'Automation';
        default:
          return true;
      }
    }).toList();
  }

  int get _unreadCount =>
      notifications.where((n) => !n.isRead && !_readIds.contains(n.id)).length;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _markAllRead() {
    setState(() {
      for (final n in notifications) {
        _readIds.add(n.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B14),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 130,
            pinned: true,
            backgroundColor: const Color(0xFF070B14),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (_unreadCount > 0)
                TextButton(
                  onPressed: _markAllRead,
                  child: Text(
                    'Mark all read',
                    style: TextStyle(
                      color: const Color(0xFF00D4FF).withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ),
              IconButton(
                icon: const Icon(
                  Icons.tune_rounded,
                  color: Colors.white54,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0D1B2E), Color(0xFF070B14)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Notifications',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'City-wide event feed',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        if (_unreadCount > 0)
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF3B5C).withOpacity(
                                  0.1 + _pulseController.value * 0.1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFFF3B5C).withOpacity(
                                    0.3 + _pulseController.value * 0.2,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF3B5C),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFFFF3B5C,
                                          ).withOpacity(0.6),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '$_unreadCount unread',
                                    style: const TextStyle(
                                      color: Color(0xFFFF3B5C),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Filters
          SliverToBoxAdapter(
            child: Container(
              height: 52,
              margin: const EdgeInsets.only(top: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filters.length,
                itemBuilder: (context, i) {
                  final isSelected = _selectedFilter == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF00D4FF).withOpacity(0.15)
                            : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF00D4FF).withOpacity(0.5)
                              : Colors.white.withOpacity(0.08),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          filters[i],
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xFF00D4FF)
                                : Colors.white.withOpacity(0.5),
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Notification list
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final notif = _filteredNotifications[index];
                final isRead = notif.isRead || _readIds.contains(notif.id);
                return NotifCard(
                  notif: notif,
                  isRead: isRead,
                  onTap: () => setState(() => _readIds.add(notif.id)),
                );
              }, childCount: _filteredNotifications.length),
            ),
          ),
        ],
      ),
    );
  }
}
