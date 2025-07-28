import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../utils/helpers.dart';

class ItemTile extends StatelessWidget {
  final ShoppingItem item;
  final VoidCallback? onTap;
  final VoidCallback? onToggleCompletion;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const ItemTile({
    super.key,
    required this.item,
    this.onTap,
    this.onToggleCompletion,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ListTile(
        leading: Checkbox(
          value: item.isCompleted,
          onChanged: (_) => onToggleCompletion?.call(),
          activeColor: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          item.name,
          style: TextStyle(
            decoration: item.isCompleted ? TextDecoration.lineThrough : null,
            color: item.isCompleted 
                ? Theme.of(context).colorScheme.outline 
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: _buildSubtitle(context),
        trailing: _buildTrailing(context),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    final widgets = <Widget>[];
    
    // Quantity
    if (item.quantity > 1) {
      widgets.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_basket_outlined,
              size: 12,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(width: 4),
            Text(
              'Qty: ${item.quantity}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }
    
    // Notes
    if (item.notes != null && item.notes!.isNotEmpty) {
      if (widgets.isNotEmpty) {
        widgets.add(const SizedBox(height: 4));
      }
      widgets.add(
        Text(
          item.notes!,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.outline,
            fontStyle: FontStyle.italic,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
    
    // Reminder
    if (item.reminderDate != null) {
      if (widgets.isNotEmpty) {
        widgets.add(const SizedBox(height: 4));
      }
      widgets.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.alarm_outlined,
              size: 12,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Text(
              Helpers.formatRelativeDate(item.reminderDate!),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildTrailing(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit?.call();
            break;
          case 'duplicate':
            // TODO: Implement duplicate functionality
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined),
              SizedBox(width: 8),
              Text('Edit Item'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'duplicate',
          child: Row(
            children: [
              Icon(Icons.copy_outlined),
              SizedBox(width: 8),
              Text('Duplicate'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}

// Alternative compact version for lists with many items
class CompactItemTile extends StatelessWidget {
  final ShoppingItem item;
  final VoidCallback? onToggleCompletion;
  final VoidCallback? onDelete;

  const CompactItemTile({
    super.key,
    required this.item,
    this.onToggleCompletion,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Checkbox(
        value: item.isCompleted,
        onChanged: (_) => onToggleCompletion?.call(),
        activeColor: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        item.name,
        style: TextStyle(
          decoration: item.isCompleted ? TextDecoration.lineThrough : null,
          color: item.isCompleted 
              ? Theme.of(context).colorScheme.outline 
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: item.quantity > 1 
          ? Text('Qty: ${item.quantity}')
          : null,
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, size: 18),
        onPressed: onDelete,
        color: Colors.red,
      ),
    );
  }
} 