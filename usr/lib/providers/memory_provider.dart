import 'package:flutter/material.dart';
import '../models/memory.dart';

class MemoryProvider with ChangeNotifier {
  final List<Memory> _memories = [];
  final List<TimeCapsule> _timeCapsules = [];

  List<Memory> get memories => List.unmodifiable(_memories);
  List<TimeCapsule> get timeCapsules => List.unmodifiable(_timeCapsules);

  // Memory operations
  void addMemory(Memory memory) {
    _memories.insert(0, memory); // Add to beginning for newest first
    notifyListeners();
    // TODO: Persist to database when connected
  }

  void updateMemory(String id, Memory updatedMemory) {
    final index = _memories.indexWhere((memory) => memory.id == id);
    if (index != -1) {
      _memories[index] = updatedMemory;
      notifyListeners();
      // TODO: Update in database when connected
    }
  }

  void deleteMemory(String id) {
    _memories.removeWhere((memory) => memory.id == id);
    notifyListeners();
    // TODO: Delete from database when connected
  }

  // Time Capsule operations
  void addTimeCapsule(TimeCapsule timeCapsule) {
    _timeCapsules.add(timeCapsule);
    notifyListeners();
    // TODO: Persist to database when connected
  }

  void updateTimeCapsule(String id, TimeCapsule updatedTimeCapsule) {
    final index = _timeCapsules.indexWhere((capsule) => capsule.id == id);
    if (index != -1) {
      _timeCapsules[index] = updatedTimeCapsule;
      notifyListeners();
      // TODO: Update in database when connected
    }
  }

  void deleteTimeCapsule(String id) {
    _timeCapsules.removeWhere((capsule) => capsule.id == id);
    notifyListeners();
    // TODO: Delete from database when connected
  }

  // Get unlocked time capsules
  List<TimeCapsule> get unlockedTimeCapsules {
    return _timeCapsules.where((capsule) => capsule.isUnlocked).toList();
  }

  // Get memories by tag
  List<Memory> getMemoriesByTag(String tag) {
    return _memories.where((memory) => memory.tags.contains(tag)).toList();
  }

  // Search memories
  List<Memory> searchMemories(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _memories.where((memory) {
      return memory.title.toLowerCase().contains(lowercaseQuery) ||
             memory.description.toLowerCase().contains(lowercaseQuery) ||
             memory.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }
}