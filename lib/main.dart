import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => MoodModel(), child: const MyApp()),
  );
}

/// MoodModel = app state (Provider)
class MoodModel with ChangeNotifier {
  String _current = 'happy';

  final Map<String, Color> _bg = {
    'happy': Colors.yellowAccent,
    'sad': Colors.lightBlueAccent,
    'excited': Colors.orangeAccent,
  };

  final Map<String, int> _counts = {'happy': 0, 'sad': 0, 'excited': 0};

  String get currentMoodKey => _current;
  Color get currentBackground => _bg[_current]!;
  Map<String, int> get counts => Map.unmodifiable(_counts);

  void _setMood(String key) {
    _current = key;
    _counts[key] = (_counts[key] ?? 0) + 1;
    notifyListeners();
  }

  void setHappy() => _setMood('happy');
  void setSad() => _setMood('sad');
  void setExcited() => _setMood('excited');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Toggle Challenge',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final bg = context.watch<MoodModel>().currentBackground;
    return Scaffold(
      appBar: AppBar(title: const Text('Mood Toggle Challenge')),
      backgroundColor: bg,
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('How are you feeling?', style: TextStyle(fontSize: 24)),
              SizedBox(height: 30),
              MoodDisplay(),
              SizedBox(height: 40),
              MoodButtons(),
              SizedBox(height: 24),
              MoodCounterRow(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows emoji instead of images (for now)
class MoodDisplay extends StatelessWidget {
  const MoodDisplay({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<MoodModel>(
      builder: (_, model, __) {
        final moodMap = {'happy': '😊', 'sad': '😢', 'excited': '🎉'};
        return Text(
          moodMap[model.currentMoodKey]!,
          style: const TextStyle(fontSize: 100),
        );
      },
    );
  }
}

class MoodButtons extends StatelessWidget {
  const MoodButtons({super.key});
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MoodModel>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: model.setHappy,
          icon: const Icon(Icons.sentiment_satisfied_alt),
          label: const Text('Happy'),
        ),
        ElevatedButton.icon(
          onPressed: model.setSad,
          icon: const Icon(Icons.sentiment_dissatisfied),
          label: const Text('Sad'),
        ),
        ElevatedButton.icon(
          onPressed: model.setExcited,
          icon: const Icon(Icons.celebration),
          label: const Text('Excited'),
        ),
      ],
    );
  }
}

class MoodCounterRow extends StatelessWidget {
  const MoodCounterRow({super.key});
  @override
  Widget build(BuildContext context) {
    final counts = context.watch<MoodModel>().counts;
    Widget chip(String label, int value) => Chip(label: Text('$label: $value'));
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        chip('Happy', counts['happy'] ?? 0),
        chip('Sad', counts['sad'] ?? 0),
        chip('Excited', counts['excited'] ?? 0),
      ],
    );
  }
}
