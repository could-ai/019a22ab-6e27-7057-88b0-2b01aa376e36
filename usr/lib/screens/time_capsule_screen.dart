import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/time_capsule.dart';
import '../providers/memory_provider.dart';

class TimeCapsuleScreen extends StatefulWidget {
  const TimeCapsuleScreen({super.key});

  @override
  State<TimeCapsuleScreen> createState() => _TimeCapsuleScreenState();
}

class _TimeCapsuleScreenState extends State<TimeCapsuleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _recipientController = TextEditingController();

  DateTime? _unlockDate;
  bool _isPrivate = false;

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    _recipientController.dispose();
    super.dispose();
  }

  Future<void> _selectUnlockDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _unlockDate) {
      setState(() {
        _unlockDate = picked;
      });
    }
  }

  void _createTimeCapsule() {
    if (_formKey.currentState!.validate() && _unlockDate != null) {
      final timeCapsule = TimeCapsule(
        id: DateTime.now().toString(),
        title: _titleController.text,
        message: _messageController.text,
        recipient: _recipientController.text.isNotEmpty ? _recipientController.text : null,
        createdDate: DateTime.now(),
        unlockDate: _unlockDate!,
        isPrivate: _isPrivate,
      );

      context.read<MemoryProvider>().addTimeCapsule(timeCapsule);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Time capsule created!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Time Capsule'),
        actions: [
          TextButton(
            onPressed: _createTimeCapsule,
            child: const Text('Create'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Inspirational Header
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        size: 32,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '"Messages to our future selves remind us of our capacity for change and growth."',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Capsule Title',
                  hintText: 'A meaningful title for your time capsule',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Message Field
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Your Message',
                  hintText: 'Write a message to your future self or loved ones',
                  border: OutlineInputBorder(),
                ),
                maxLines: 8,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please write a message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Recipient Field (Optional)
              TextFormField(
                controller: _recipientController,
                decoration: const InputDecoration(
                  labelText: 'Recipient (Optional)',
                  hintText: 'Who is this message for?',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Unlock Date Selection
              Text(
                'Unlock Date',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (_unlockDate != null) ...[
                        Text(
                          'Will unlock on: ${_unlockDate!.toString().split(' ')[0]}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                      ],
                      ElevatedButton.icon(
                        onPressed: () => _selectUnlockDate(context),
                        icon: const Icon(Icons.calendar_today),
                        label: Text(_unlockDate == null ? 'Select Unlock Date' : 'Change Date'),
                      ),
                    ],
                  ),
                ),
              ),
              if (_unlockDate == null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Required: Choose when this capsule can be opened',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Privacy Toggle
              Card(
                child: SwitchListTile(
                  title: const Text('Private Capsule'),
                  subtitle: const Text('Only you can open this capsule'),
                  value: _isPrivate,
                  onChanged: (bool value) {
                    setState(() {
                      _isPrivate = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Create Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _createTimeCapsule,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Create Time Capsule'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}