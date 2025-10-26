import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/memory.dart';
import '../providers/memory_provider.dart';

class AddMemoryScreen extends StatefulWidget {
  const AddMemoryScreen({super.key});

  @override
  State<AddMemoryScreen> createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();

  MemoryType _selectedType = MemoryType.text;
  DateTime? _selectedDate;
  List<String> _tags = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _addTag() {
    final tag = _tagsController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagsController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveMemory() {
    if (_formKey.currentState!.validate()) {
      final memory = Memory(
        id: DateTime.now().toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        type: _selectedType,
        createdDate: DateTime.now(),
        memoryDate: _selectedDate,
        tags: _tags,
        // TODO: Add image/video handling
      );

      context.read<MemoryProvider>().addMemory(memory);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Memory saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Memory'),
        actions: [
          TextButton(
            onPressed: _saveMemory,
            child: const Text('Save'),
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
              // Memory Type Selection
              Text(
                'Memory Type',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SegmentedButton<MemoryType>(
                segments: const [
                  ButtonSegment(
                    value: MemoryType.text,
                    label: Text('Text'),
                    icon: Icon(Icons.text_fields),
                  ),
                  ButtonSegment(
                    value: MemoryType.photo,
                    label: Text('Photo'),
                    icon: Icon(Icons.photo),
                  ),
                  ButtonSegment(
                    value: MemoryType.video,
                    label: Text('Video'),
                    icon: Icon(Icons.videocam),
                  ),
                  ButtonSegment(
                    value: MemoryType.audio,
                    label: Text('Audio'),
                    icon: Icon(Icons.mic),
                  ),
                ],
                selected: {_selectedType},
                onSelectionChanged: (Set<MemoryType> selected) {
                  setState(() {
                    _selectedType = selected.first;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Give your memory a meaningful title',
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

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Share your thoughts and feelings',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date Selection
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Memory Date: ${_selectedDate != null ? _selectedDate!.toString().split(' ')[0] : 'Not set'}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Tags Section
              Text(
                'Tags',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _tagsController,
                      decoration: const InputDecoration(
                        labelText: 'Add tags',
                        hintText: 'e.g., family, birthday, happy',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _addTag(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addTag,
                    child: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    onDeleted: () => _removeTag(tag),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveMemory,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Save Memory'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}