import 'package:flutter/material.dart';

import '../widgets/wire.dart';
import 'admin_update_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.isAdmin,
    required this.onToggleRole,
  });

  final bool isAdmin;

  /// Demo only: tapping the avatar switches between the admin and standard
  /// Profile variants until real authentication exists.
  final VoidCallback onToggleRole;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _destinations = ['Kadıköy', 'Sabancı'];

  String _destination = _destinations.first;
  bool _notifications = true;

  void _snack(String msg) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _pickDestination() async {
    final choice = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Default destination'),
        children: [
          for (final d in _destinations)
            SimpleDialogOption(
              onPressed: () => Navigator.of(ctx).pop(d),
              child: Text(d,
                  style: TextStyle(
                      fontWeight: d == _destination
                          ? FontWeight.bold
                          : FontWeight.normal)),
            ),
        ],
      ),
    );
    if (choice != null) setState(() => _destination = choice);
  }

  void _confirmClearCache() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear cached data?'),
        content: const Text('Saved schedules and menus will be re-downloaded.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _snack('Cached data cleared');
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.isAdmin;
    final name = isAdmin ? 'Esra Yağışan' : 'Tülin Çevik';
    final email =
        isAdmin ? 'esra.yagisan@sabanciuniv.edu' : 'tulin.cevik@sabanciuniv.edu';

    return Column(
      children: [
        const WireHeader(title: 'Profile'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onToggleRole,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: kWireBorder),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(email,
                              style: const TextStyle(
                                  fontSize: 12, color: kWireMuted)),
                          if (isAdmin)
                            const Text('Role: admin',
                                style: TextStyle(
                                    fontSize: 12, color: kWireAccent)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              WireRow(
                  label: 'Default destination',
                  value: _destination,
                  onTap: _pickDestination),
              WireRow(
                label: 'Notifications',
                value: _notifications ? '[on]' : '[off]',
                chevron: false,
                onTap: () => setState(() => _notifications = !_notifications),
              ),
              if (isAdmin) ...[
                WireRow(
                    label: 'Clear cached data', onTap: _confirmClearCache),
                WireRow(
                  label: 'Admin: update data',
                  highlighted: true,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const AdminUpdateScreen()),
                  ),
                ),
              ],
              WireRow(
                label: 'About SUrvivor',
                onTap: () => showAboutDialog(
                  context: context,
                  applicationName: 'SUrvivor',
                  applicationVersion: '0.1.0',
                  children: const [
                    Text('Shuttle times & campus menus for Sabancı University. '
                        'CS310 Group 12.'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: WireButton(
            label: 'Log out',
            onPressed: () =>
                _snack('Authentication will be added in a later step'),
          ),
        ),
      ],
    );
  }
}
