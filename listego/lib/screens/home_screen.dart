import 'package:flutter/material.dart';
import '../models/shopping_list_model.dart';
import '../services/storage_service.dart';
import '../widgets/shopping_list_tile.dart';
import '../utils/helpers.dart';
import 'item_list_screen.dart';
import 'add_list_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ShoppingList> _shoppingLists = [];
  List<ShoppingList> _activeLists = [];
  List<ShoppingList> _archivedLists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadShoppingLists();
  }

  Future<void> _loadShoppingLists() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final lists = await StorageService.instance.getAllShoppingLists();
      setState(() {
        _shoppingLists = lists;
        _activeLists = lists.where((list) => !list.isArchived).toList();
        _archivedLists = lists.where((list) => list.isArchived).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        Helpers.showSnackBar(context, 'Error loading lists: $e', isError: true);
      }
    }
  }

  Future<void> _refreshLists() async {
    await _loadShoppingLists();
  }

  void _navigateToList(ShoppingList list) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemListScreen(list: list),
      ),
    ).then((_) => _loadShoppingLists()); // Refresh when returning
  }

  void _navigateToAddList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddListScreen(),
      ),
    ).then((_) => _loadShoppingLists()); // Refresh when returning
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  void _handleListAction(String action, ShoppingList list) async {
    try {
      switch (action) {
        case 'duplicate':
          await StorageService.instance.duplicateShoppingList(list.id);
          Helpers.showSnackBar(context, 'List duplicated successfully!');
          break;
        case 'archive':
          await StorageService.instance.archiveShoppingList(list.id);
          Helpers.showSnackBar(context, 'List archived successfully!');
          break;
        case 'unarchive':
          await StorageService.instance.unarchiveShoppingList(list.id);
          Helpers.showSnackBar(context, 'List unarchived successfully!');
          break;
        case 'delete':
          await _showDeleteDialog(list);
          break;
      }
      _loadShoppingLists(); // Refresh the list
    } catch (e) {
      Helpers.showSnackBar(context, 'Error: $e', isError: true);
    }
  }

  Future<void> _showDeleteDialog(ShoppingList list) async {
    final confirmed = await Helpers.showConfirmationDialog(
      context,
      'Delete List',
      'Are you sure you want to delete "${list.name}"? This action cannot be undone.',
    );

    if (confirmed && mounted) {
      try {
        await StorageService.instance.deleteShoppingList(list.id);
        Helpers.showSnackBar(context, 'List deleted successfully!');
      } catch (e) {
        Helpers.showSnackBar(context, 'Error deleting list: $e', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('ListeGo'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: _navigateToSettings,
            tooltip: 'Settings',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshLists,
              child: CustomScrollView(
                slivers: [
                  // Stats Header
                  SliverToBoxAdapter(
                    child: _buildStatsHeader(),
                  ),
                  
                  // Active Lists
                  if (_activeLists.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: _buildSectionHeader('Active Lists'),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final list = _activeLists[index];
                          return ShoppingListTile(
                            list: list,
                            onTap: () => _navigateToList(list),
                            onEdit: () => _navigateToList(list), // For now, edit opens the list
                            onDuplicate: () => _handleListAction('duplicate', list),
                            onArchive: () => _handleListAction('archive', list),
                            onDelete: () => _handleListAction('delete', list),
                          );
                        },
                        childCount: _activeLists.length,
                      ),
                    ),
                  ],
                  
                  // Archived Lists
                  if (_archivedLists.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: _buildSectionHeader('Archived Lists'),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final list = _archivedLists[index];
                          return ShoppingListTile(
                            list: list,
                            isArchived: true,
                            onTap: () => _navigateToList(list),
                            onUnarchive: () => _handleListAction('unarchive', list),
                            onDelete: () => _handleListAction('delete', list),
                          );
                        },
                        childCount: _archivedLists.length,
                      ),
                    ),
                  ],
                  
                  // Empty State
                  if (_shoppingLists.isEmpty)
                    SliverFillRemaining(
                      child: _buildEmptyState(),
                    ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddList,
        icon: const Icon(Icons.add),
        label: const Text('New List'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }

  Widget _buildStatsHeader() {
    final totalLists = _shoppingLists.length;
    final activeLists = _activeLists.length;
    final totalItems = _shoppingLists.fold<int>(0, (sum, list) => sum + list.totalItems);
    final completedItems = _shoppingLists.fold<int>(0, (sum, list) => sum + list.completedItems);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Lists',
                '$totalLists',
                Icons.list_alt_outlined,
              ),
              _buildStatItem(
                'Active',
                '$activeLists',
                Icons.check_circle_outline,
              ),
              _buildStatItem(
                'Items',
                '$totalItems',
                Icons.shopping_basket_outlined,
              ),
              _buildStatItem(
                'Completed',
                '$completedItems',
                Icons.done_all_outlined,
              ),
            ],
          ),
          if (totalItems > 0) ...[
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: totalItems > 0 ? completedItems / totalItems : 0,
              backgroundColor: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${Helpers.calculateProgress(completedItems, totalItems).toStringAsFixed(1)}% Complete',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_basket_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No Shopping Lists Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first shopping list to get started!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _navigateToAddList,
            icon: const Icon(Icons.add),
            label: const Text('Create First List'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
} 