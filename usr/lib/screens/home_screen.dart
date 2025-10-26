import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/memory.dart';
import '../providers/memory_provider.dart';
import '../widgets/memory_card.dart';
import 'add_memory_screen.dart';
import 'time_capsule_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    MemoriesTab(),
    TimeCapsuleTab(),
    ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Keeper'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddMemoryScreen()),
              );
            },
            tooltip: 'Add Memory',
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Memories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Time Capsule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}

class MemoriesTab extends StatelessWidget {
  const MemoriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MemoryProvider>(
      builder: (context, memoryProvider, child) {
        final memories = memoryProvider.memories;

        if (memories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_album,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No memories yet',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Start creating your digital time capsule',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddMemoryScreen()),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Your First Memory'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: memories.length,
          itemBuilder: (context, index) {
            return MemoryCard(memory: memories[index]);
          },
        );
      },
    );
  }
}

class TimeCapsuleTab extends StatelessWidget {
  const TimeCapsuleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MemoryProvider>(
      builder: (context, memoryProvider, child) {
        final timeCapsules = memoryProvider.timeCapsules;

        if (timeCapsules.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_clock,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No time capsules',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Create messages for your future self',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TimeCapsuleScreen()),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Create Time Capsule'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: timeCapsules.length,
          itemBuilder: (context, index) {
            return TimeCapsuleCard(timeCapsule: timeCapsules[index]);
          },
        );
      },
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Memory Keeper',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'Preserving moments, connecting hearts',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'App Features',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          _buildFeatureTile(
            context,
            icon: Icons.photo,
            title: 'Digital Memories',
            description: 'Store photos, videos, and text memories',
          ),
          _buildFeatureTile(
            context,
            icon: Icons.access_time,
            title: 'Time Capsules',
            description: 'Messages for future you or loved ones',
          ),
          _buildFeatureTile(
            context,
            icon: Icons.share,
            title: 'Universal Sharing',
            description: 'Share memories across generations',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTile(BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(description),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}

class TimeCapsuleCard extends StatelessWidget {
  final TimeCapsule timeCapsule;

  const TimeCapsuleCard({super.key, required this.timeCapsule});

  @override
  Widget build(BuildContext context) {
    final bool isReady = DateTime.now().isAfter(timeCapsule.unlockDate);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          isReady ? Icons.lock_open : Icons.lock,
          color: isReady
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
        ),
        title: Text(timeCapsule.title),
        subtitle: Text(
          'Unlocks on ${timeCapsule.unlockDate.toString().split(' ')[0]}',
        ),
        trailing: isReady
            ? ElevatedButton(
                onPressed: () {
                  // TODO: Show time capsule content
                },
                child: const Text('Open'),
              )
            : null,
      ),
    );
  }
}