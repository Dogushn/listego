import 'package:flutter/material.dart';
import '../models/shopping_list_model.dart';
import '../models/item_model.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class AddItemScreen extends StatefulWidget {
  final ShoppingList list;
  final ShoppingItem? itemToEdit; // Optional item to edit

  const AddItemScreen({
    super.key, 
    required this.list,
    this.itemToEdit, // Pass null for adding new items
  });

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  
  int _quantity = 1;
  DateTime? _reminderDate;
  TimeOfDay? _reminderTime;
  bool _isLoading = false;
  bool _enableReminder = false;

  @override
  void initState() {
    super.initState();
    // If editing an item, populate the form with existing data
    if (widget.itemToEdit != null) {
      _nameController.text = widget.itemToEdit!.name;
      _notesController.text = widget.itemToEdit!.notes ?? '';
      _quantity = widget.itemToEdit!.quantity;
      _enableReminder = widget.itemToEdit!.reminderDate != null;
      if (_enableReminder && widget.itemToEdit!.reminderDate != null) {
        _reminderDate = DateTime(
          widget.itemToEdit!.reminderDate!.year,
          widget.itemToEdit!.reminderDate!.month,
          widget.itemToEdit!.reminderDate!.day,
        );
        _reminderTime = TimeOfDay(
          hour: widget.itemToEdit!.reminderDate!.hour,
          minute: widget.itemToEdit!.reminderDate!.minute,
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    final itemName = _nameController.text.trim();
    
    // Check if item already exists in the list (only for new items, not when editing)
    if (widget.itemToEdit == null && widget.list.hasItemWithName(itemName)) {
      // Show confirmation dialog
      final shouldAdd = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Item Already Exists'),
            content: Text(
              '"$itemName" is already in your list. Do you still want to add it?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          );
        },
      );

      // If user cancels, don't add the item
      if (shouldAdd != true) {
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      ShoppingItem itemToSave;
      
      if (widget.itemToEdit != null) {
        // Update existing item
        itemToSave = widget.itemToEdit!.copyWith(
          name: itemName,
          quantity: _quantity,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          reminderDate: _enableReminder && _reminderDate != null && _reminderTime != null
              ? DateTime(
                  _reminderDate!.year,
                  _reminderDate!.month,
                  _reminderDate!.day,
                  _reminderTime!.hour,
                  _reminderTime!.minute,
                )
              : null,
          updatedAt: DateTime.now(),
        );
        
        // Update in database
        await StorageService.instance.updateItemInList(widget.list.id, itemToSave);
      } else {
        // Create new item
        itemToSave = ShoppingItem.create(
          name: itemName,
          quantity: _quantity,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          reminderDate: _enableReminder && _reminderDate != null && _reminderTime != null
              ? DateTime(
                  _reminderDate!.year,
                  _reminderDate!.month,
                  _reminderDate!.day,
                  _reminderTime!.hour,
                  _reminderTime!.minute,
                )
              : null,
        );
        
        // Save to database
        await StorageService.instance.addItemToList(widget.list.id, itemToSave);
      }

      // Schedule notification if reminder is set
      if (_enableReminder && itemToSave.reminderDate != null) {
        try {
          await NotificationService.instance.scheduleItemReminder(itemToSave, widget.list);
        } catch (e) {
          // Don't fail the save if notification fails
          print('Failed to schedule notification: $e');
        }
      }

      if (mounted) {
        Navigator.pop(context);
        Helpers.showSnackBar(
          context,
          widget.itemToEdit != null 
              ? 'Updated "${itemToSave.name}" successfully!'
              : 'Added "${itemToSave.name}" to your list!',
        );
      }
    } catch (e) {
      if (mounted) {
        Helpers.showSnackBar(
          context,
          'Error ${widget.itemToEdit != null ? 'updating' : 'adding'} item: $e',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _quickAddItem(String itemName) {
    _nameController.text = itemName;
    // Trigger validation
    _formKey.currentState?.validate();
  }

  void _onBarcodeScanned(String barcode) {
    setState(() {
      _nameController.text = barcode;
    });
    Navigator.pop(context);
    Helpers.showSnackBar(context, 'Barcode scanned: $barcode');
  }

  void _openBarcodeScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Scan Barcode')),
          body: MobileScanner(
            onDetect: (capture) {
              final barcode = capture.barcodes.first.rawValue;
              if (barcode != null) {
                _onBarcodeScanned(barcode);
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _reminderDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _reminderDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.itemToEdit != null ? 'Edit Item' : 'Add Item'),
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
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveItem,
              tooltip: 'Save Item',
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Item Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Item Name',
                hintText: 'e.g., Milk, Bread, Apples',
                prefixIcon: const Icon(Icons.shopping_basket_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  tooltip: 'Scan Barcode',
                  onPressed: _openBarcodeScanner,
                ),
              ),
              validator: Helpers.validateItemName,
              textCapitalization: TextCapitalization.words,
              autofocus: true,
            ),
            
            const SizedBox(height: 16),
            
            // Quantity Field
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: _quantity.toString(),
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      prefixIcon: const Icon(Icons.numbers_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: Helpers.validateQuantity,
                    onChanged: (value) {
                      final quantity = int.tryParse(value);
                      if (quantity != null && quantity > 0) {
                        setState(() {
                          _quantity = quantity;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (_quantity > 1) _quantity--;
                        });
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                      tooltip: 'Decrease',
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      tooltip: 'Increase',
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Notes Field
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Notes (Optional)',
                hintText: 'e.g., Organic, Brand preference, etc.',
                prefixIcon: const Icon(Icons.note_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: Helpers.validateNotes,
              maxLines: 3,
              maxLength: AppConstants.maxItemNotesLength,
            ),
            
            const SizedBox(height: 24),
            
            // Reminder Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.alarm_outlined),
                        const SizedBox(width: 8),
                        Text(
                          'Reminder',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Switch(
                          value: _enableReminder,
                          onChanged: (value) {
                            setState(() {
                              _enableReminder = value;
                              if (!value) {
                                _reminderDate = null;
                                _reminderTime = null;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    if (_enableReminder) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _selectDate,
                              icon: const Icon(Icons.calendar_today_outlined),
                              label: Text(
                                _reminderDate != null
                                    ? Helpers.formatDate(_reminderDate!)
                                    : 'Select Date',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _selectTime,
                              icon: const Icon(Icons.access_time_outlined),
                              label: Text(
                                _reminderTime != null
                                    ? _reminderTime!.format(context)
                                    : 'Select Time',
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_reminderDate != null && _reminderTime != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Reminder set for: ${Helpers.formatDateTime(DateTime(
                            _reminderDate!.year,
                            _reminderDate!.month,
                            _reminderDate!.day,
                            _reminderTime!.hour,
                            _reminderTime!.minute,
                          ))}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Quick Add Section
            Text(
              'Quick Add',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppConstants.quickItems.map((item) {
                return ActionChip(
                  label: Text(item),
                  onPressed: () => _quickAddItem(item),
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 24),
            
            // Tips Section
            Card(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tips',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onTertiaryContainer,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Use specific names for better organization\n'
                      '• Add notes for brand preferences or special requirements\n'
                      '• Set reminders for time-sensitive items\n'
                      '• Use quick add for common items',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _saveItem,
        icon: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.save),
        label: Text(_isLoading 
            ? 'Saving...' 
            : (widget.itemToEdit != null ? 'Update Item' : 'Save Item')),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
} 