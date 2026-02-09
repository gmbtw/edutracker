import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../theme/colors.dart';

class Lesson {
  final String title;
  final String homework;
  Lesson(this.title, this.homework);
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Хранилище пар: Дата -> Список пар
  Map<DateTime, List<Lesson>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  void _showAddLessonDialog() {
    final titleController = TextEditingController();
    final hwController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить пару'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Название пары (например, Математика)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: hwController,
              decoration: const InputDecoration(labelText: 'Что задали?'),
            ),
            TextButton(
              onPressed: () => hwController.text = 'Нет задания',
              child: const Text('Нет задания'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && _selectedDay != null) {
                setState(() {
                  final date = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
                  if (_events[date] == null) _events[date] = [];
                  _events[date]!.add(Lesson(titleController.text, hwController.text.isEmpty ? 'Нет задания' : hwController.text));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateKey = _selectedDay != null ? DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day) : null;
    final lessons = dateKey != null ? (_events[dateKey] ?? []) : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Календарь обучения'),
        actions: [
          IconButton(onPressed: _showAddLessonDialog, icon: const Icon(Icons.add)),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) {
              return _events[DateTime(day.year, day.month, day.day)] ?? [];
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
              markerDecoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Пары на ${_selectedDay?.day}.${_selectedDay?.month}.${_selectedDay?.year}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  lessons.isEmpty
                      ? const Text('На этот день пар нет', style: TextStyle(color: AppColors.muted))
                      : Expanded(
                          child: ListView.builder(
                            itemCount: lessons.length,
                            itemBuilder: (context, i) => Card(
                              child: ListTile(
                                title: Text(lessons[i].title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('ДЗ: ${lessons[i].homework}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () => setState(() => _events[dateKey]!.removeAt(i)),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddLessonDialog,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
