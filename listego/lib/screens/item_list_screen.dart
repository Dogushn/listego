import 'package:flutter/material.dart';
import '../models/shopping_list_model.dart';
import '../models/item_model.dart';
import '../services/storage_service.dart';
import '../widgets/item_tile.dart';
import '../utils/helpers.dart';
import 'add_item_screen.dart';

class ItemListScreen extends StatefulWidget {
  final ShoppingList list;

  const ItemListScreen({super.key, required this.list});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  ShoppingList? _currentList;
  bool _isLoading = true;
  bool _showCompletedItems = true;

  @override
  void initState() {
    super.initState();
    _loadList();
  }

  Future<void> _loadList() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final list = await StorageService.instance.getShoppingList(widget.list.id);
      setState(() {
        _currentList = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        Helpers.showSnackBar(context, 'Error loading list: $e', isError: true);
      }
    }
  }

  Future<void> _refreshList() async {
    await _loadList();
  }

  void _navigateToAddItem() {
    if (_currentList != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddItemScreen(list: _currentList!),
        ),
      ).then((_) => _loadList()); // Refresh when returning
    }
  }

  Future<void> _toggleItemCompletion(String itemId) async {
    if (_currentList != null) {
      try {
        await StorageService.instance.toggleItemCompletion(_currentList!.id, itemId);
        await _loadList(); // Refresh the list
        // Check if all items are completed
        if (_currentList != null &&
            _currentList!.items.isNotEmpty &&
            _currentList!.items.every((item) => item.isCompleted)) {
          final shouldDelete = await Helpers.showConfirmationDialog(
            context,
            'Delete List?',
            'All items are completed. Do you want to delete this list?',
          );
          if (shouldDelete == true && mounted) {
            await StorageService.instance.deleteShoppingList(_currentList!.id);
            if (mounted) {
              Navigator.pop(context); // Go back to home screen
              Helpers.showSnackBar(context, 'List deleted successfully!');
            }
          }
        }
      } catch (e) {
        Helpers.showSnackBar(context, 'Error updating item: $e', isError: true);
      }
    }
  }

  Future<void> _deleteItem(String itemId) async {
    if (_currentList != null) {
      try {
        await StorageService.instance.removeItemFromList(_currentList!.id, itemId);
        await _loadList(); // Refresh the list
        Helpers.showSnackBar(context, 'Item removed successfully!');
      } catch (e) {
        Helpers.showSnackBar(context, 'Error removing item: $e', isError: true);
      }
    }
  }

  Future<void> _clearCompletedItems() async {
    if (_currentList != null) {
      final confirmed = await Helpers.showConfirmationDialog(
        context,
        'Clear Completed Items',
        'Are you sure you want to remove all completed items from this list?',
      );

      if (confirmed && mounted) {
        try {
          await StorageService.instance.clearCompletedItems(_currentList!.id);
          await _loadList(); // Refresh the list
          Helpers.showSnackBar(context, 'Completed items cleared!');
        } catch (e) {
          Helpers.showSnackBar(context, 'Error clearing items: $e', isError: true);
        }
      }
    }
  }

  void _showListOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildListOptionsSheet(),
    );
  }

  Widget _buildListOptionsSheet() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Edit List'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to edit list screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.share_outlined),
            title: const Text('Share List'),
            onTap: () {
              Navigator.pop(context);
              _shareList();
            },
          ),
          ListTile(
            leading: const Icon(Icons.copy_outlined),
            title: const Text('Duplicate List'),
            onTap: () {
              Navigator.pop(context);
              _duplicateList();
            },
          ),
          if (_currentList?.completedItems != null && _currentList!.completedItems > 0)
            ListTile(
              leading: const Icon(Icons.clear_all_outlined),
              title: const Text('Clear Completed Items'),
              onTap: () {
                Navigator.pop(context);
                _clearCompletedItems();
              },
            ),
          ListTile(
            leading: const Icon(Icons.archive_outlined),
            title: const Text('Archive List'),
            onTap: () {
              Navigator.pop(context);
              _archiveList();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _shareList() async {
    if (_currentList != null) {
      // TODO: Implement sharing functionality
      Helpers.showSnackBar(context, 'Share functionality coming soon!');
    }
  }

  Future<void> _duplicateList() async {
    if (_currentList != null) {
      try {
        await StorageService.instance.duplicateShoppingList(_currentList!.id);
        Helpers.showSnackBar(context, 'List duplicated successfully!');
        Navigator.pop(context); // Go back to home screen
      } catch (e) {
        Helpers.showSnackBar(context, 'Error duplicating list: $e', isError: true);
      }
    }
  }

  Future<void> _archiveList() async {
    if (_currentList != null) {
      try {
        await StorageService.instance.archiveShoppingList(_currentList!.id);
        Helpers.showSnackBar(context, 'List archived successfully!');
        Navigator.pop(context); // Go back to home screen
      } catch (e) {
        Helpers.showSnackBar(context, 'Error archiving list: $e', isError: true);
      }
    }
  }

  List<ShoppingItem> _getFilteredItems() {
    if (_currentList == null) return [];
    
    if (_showCompletedItems) {
      return _currentList!.items;
    } else {
      return _currentList!.items.where((item) => !item.isCompleted).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.list.name),
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_currentList == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.list.name),
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
        ),
        body: const Center(child: Text('List not found')),
      );
    }

    final filteredItems = _getFilteredItems();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(_currentList!.name),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_showCompletedItems ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _showCompletedItems = !_showCompletedItems;
              });
            },
            tooltip: _showCompletedItems ? 'Hide completed' : 'Show completed',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showListOptions,
            tooltip: 'List options',
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Header
          _buildProgressHeader(),
          
          // Items List
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshList,
              child: filteredItems.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return ItemTile(
                          item: item,
                          onToggleCompletion: () => _toggleItemCompletion(item.id),
                          onDelete: () => _deleteItem(item.id),
                          onEdit: () {
                            // TODO: Navigate to edit item screen
                            Helpers.showSnackBar(context, 'Edit functionality coming soon!');
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddItem,
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }

  Widget _buildProgressHeader() {
    final totalItems = _currentList!.totalItems;
    final completedItems = _currentList!.completedItems;
    final pendingItems = _currentList!.pendingItems;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              Text(
                '${completedItems}/${totalItems}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: totalItems > 0 ? completedItems / totalItems : 0,
            backgroundColor: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${Helpers.calculateProgress(completedItems, totalItems).toStringAsFixed(1)}% Complete',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              if (pendingItems > 0)
                Text(
                  '$pendingItems remaining',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
            ],
          ),
        ],
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
            _showCompletedItems ? 'No Items Yet' : 'No Pending Items',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _showCompletedItems
                ? 'Add your first item to get started!'
                : 'All items are completed!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _navigateToAddItem,
            icon: const Icon(Icons.add),
            label: const Text('Add First Item'),
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