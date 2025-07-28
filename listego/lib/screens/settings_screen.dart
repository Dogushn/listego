import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _enableNotifications = true;
  bool _enableReminders = true;
  int _reminderTimeInMinutes = 30;
  bool _showCompletedItems = true;
  String _sortOrder = 'created';
  bool _autoArchiveCompletedLists = false;
  int _autoArchiveDays = 7;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Load settings from Hive
      // For now, using default values
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        Helpers.showSnackBar(context, 'Error loading settings: $e', isError: true);
      }
    }
  }

  Future<void> _saveSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Save settings to Hive
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate save
      
      if (mounted) {
        Helpers.showSnackBar(context, 'Settings saved successfully!');
      }
    } catch (e) {
      if (mounted) {
        Helpers.showSnackBar(context, 'Error saving settings: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateNotificationSettings(bool enabled) async {
    setState(() {
      _enableNotifications = enabled;
    });

    try {
      if (enabled) {
        final granted = await NotificationService.instance.requestPermissions();
        if (!granted) {
          setState(() {
            _enableNotifications = false;
          });
          if (mounted) {
            Helpers.showSnackBar(
              context,
              'Notification permissions are required for reminders',
              isError: true,
            );
          }
          return;
        }
      } else {
        await NotificationService.instance.cancelAllNotifications();
      }
      
      await _saveSettings();
    } catch (e) {
      if (mounted) {
        Helpers.showSnackBar(context, 'Error updating notifications: $e', isError: true);
      }
    }
  }

  Future<void> _updateThemeMode(String mode) async {
    final provider = Provider.of<SettingsProvider>(context, listen: false);
    await provider.updateThemeSettings(themeMode: mode);
    // No need to call setState, provider will notify listeners
  }

  Future<void> _clearAllData() async {
    final confirmed = await Helpers.showConfirmationDialog(
      context,
      'Clear All Data',
      'This will permanently delete all shopping lists and items. This action cannot be undone.',
    );

    if (confirmed && mounted) {
      try {
        await StorageService.instance.clearAllData();
        await NotificationService.instance.cancelAllNotifications();
        
        if (mounted) {
          Helpers.showSnackBar(context, 'All data cleared successfully!');
          Navigator.pop(context); // Go back to home screen
        }
      } catch (e) {
        if (mounted) {
          Helpers.showSnackBar(context, 'Error clearing data: $e', isError: true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header
                _buildSectionHeader('Preferences'),
                
                // Notifications Section
                _buildNotificationSection(),
                
                const SizedBox(height: 24),
                
                // Appearance Section
                _buildAppearanceSection(),
                
                const SizedBox(height: 24),
                
                // List Settings Section
                _buildListSettingsSection(),
                
                const SizedBox(height: 24),
                
                // Data Management Section
                _buildDataManagementSection(),
                
                const SizedBox(height: 24),
                
                // About Section
                _buildAboutSection(),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Receive reminders for shopping items'),
            value: _enableNotifications,
            onChanged: _updateNotificationSettings,
            secondary: const Icon(Icons.notifications_outlined),
          ),
          if (_enableNotifications) ...[
            const Divider(),
            SwitchListTile(
              title: const Text('Enable Reminders'),
              subtitle: const Text('Schedule reminders for items with due dates'),
              value: _enableReminders,
              onChanged: (value) {
                setState(() {
                  _enableReminders = value;
                });
                _saveSettings();
              },
              secondary: const Icon(Icons.alarm_outlined),
            ),
            const Divider(),
            ListTile(
              title: const Text('Default Reminder Time'),
              subtitle: Text('$_reminderTimeInMinutes minutes before due date'),
              leading: const Icon(Icons.access_time_outlined),
              trailing: DropdownButton<int>(
                value: _reminderTimeInMinutes,
                items: [15, 30, 60, 120, 1440].map((minutes) {
                  return DropdownMenuItem(
                    value: minutes,
                    child: Text('$minutes min'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _reminderTimeInMinutes = value;
                    });
                    _saveSettings();
                  }
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAppearanceSection() {
    final provider = Provider.of<SettingsProvider>(context);
    final currentThemeMode = provider.themeMode;
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('Theme Mode'),
            subtitle: Text(_getThemeModeDescription(currentThemeMode)),
            leading: const Icon(Icons.palette_outlined),
            trailing: DropdownButton<String>(
              value: currentThemeMode,
              items: [
                DropdownMenuItem(
                  value: 'light',
                  child: const Text('Light'),
                ),
                DropdownMenuItem(
                  value: 'dark',
                  child: const Text('Dark'),
                ),
                DropdownMenuItem(
                  value: 'system',
                  child: const Text('System'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  _updateThemeMode(value);
                }
              },
            ),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Show Completed Items'),
            subtitle: const Text('Display completed items in lists'),
            value: _showCompletedItems,
            onChanged: (value) {
              setState(() {
                _showCompletedItems = value;
              });
              _saveSettings();
            },
            secondary: const Icon(Icons.check_circle_outline),
          ),
        ],
      ),
    );
  }

  Widget _buildListSettingsSection() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('Sort Order'),
            subtitle: Text(_getSortOrderDescription()),
            leading: const Icon(Icons.sort_outlined),
            trailing: DropdownButton<String>(
              value: _sortOrder,
              items: [
                DropdownMenuItem(
                  value: 'created',
                  child: const Text('Date Created'),
                ),
                DropdownMenuItem(
                  value: 'updated',
                  child: const Text('Last Updated'),
                ),
                DropdownMenuItem(
                  value: 'name',
                  child: const Text('Name'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _sortOrder = value;
                  });
                  _saveSettings();
                }
              },
            ),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Auto-archive Completed Lists'),
            subtitle: const Text('Automatically archive lists when all items are completed'),
            value: _autoArchiveCompletedLists,
            onChanged: (value) {
              setState(() {
                _autoArchiveCompletedLists = value;
              });
              _saveSettings();
            },
            secondary: const Icon(Icons.archive_outlined),
          ),
          if (_autoArchiveCompletedLists) ...[
            const Divider(),
            ListTile(
              title: const Text('Archive After'),
              subtitle: Text('${_autoArchiveDays} days'),
              leading: const Icon(Icons.schedule_outlined),
              trailing: DropdownButton<int>(
                value: _autoArchiveDays,
                items: [1, 3, 7, 14, 30].map((days) {
                  return DropdownMenuItem(
                    value: days,
                    child: Text('$days days'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _autoArchiveDays = value;
                    });
                    _saveSettings();
                  }
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDataManagementSection() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('Export Data'),
            subtitle: const Text('Export your shopping lists'),
            leading: const Icon(Icons.file_download_outlined),
            onTap: () {
              // TODO: Implement export functionality
              Helpers.showSnackBar(context, 'Export functionality coming soon!');
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Import Data'),
            subtitle: const Text('Import shopping lists from file'),
            leading: const Icon(Icons.file_upload_outlined),
            onTap: () {
              // TODO: Implement import functionality
              Helpers.showSnackBar(context, 'Import functionality coming soon!');
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Clear All Data'),
            subtitle: const Text('Permanently delete all lists and items'),
            leading: const Icon(Icons.delete_forever_outlined, color: Colors.red),
            textColor: Colors.red,
            onTap: _clearAllData,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('App Version'),
            subtitle: Text(AppConstants.appVersion),
            leading: const Icon(Icons.info_outlined),
          ),
          const Divider(),
          ListTile(
            title: const Text('About ListeGo'),
            subtitle: const Text('Smart Shopping Lists'),
            leading: const Icon(Icons.shopping_basket_outlined),
            onTap: () {
              _showAboutDialog();
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Help & Support'),
            subtitle: const Text('Get help and report issues'),
            leading: const Icon(Icons.help_outline),
            onTap: () {
              // TODO: Navigate to help screen
              Helpers.showSnackBar(context, 'Help screen coming soon!');
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Privacy Policy'),
            subtitle: const Text('Read our privacy policy'),
            leading: const Icon(Icons.privacy_tip_outlined),
            onTap: () {
              // TODO: Show privacy policy
              Helpers.showSnackBar(context, 'Privacy policy coming soon!');
            },
          ),
        ],
      ),
    );
  }

  String _getThemeModeDescription(String mode) {
    switch (mode) {
      case 'dark':
        return 'Dark mode';
      case 'light':
        return 'Light mode';
      default:
        return 'Follows system setting';
    }
  }

  String _getSortOrderDescription() {
    switch (_sortOrder) {
      case 'created':
        return 'Sort by creation date';
      case 'updated':
        return 'Sort by last updated';
      case 'name':
        return 'Sort alphabetically';
      default:
        return 'Sort by creation date';
    }
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About ListeGo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConstants.appDescription,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Version: ${AppConstants.appVersion}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Text(
              'ListeGo is a modern shopping list app built with Flutter and Material Design 3. '
              'It helps you organize your shopping with smart features like reminders, '
              'multiple lists, and a beautiful interface.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
} 