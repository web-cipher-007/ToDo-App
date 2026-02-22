import 'package:flutter/material.dart';
import 'package:flutter_forms_files/models/todo.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Todo> todos = [];
  final Set<int> _completedIndexes = {};

  Color _priorityColor(Priority p) {
    switch (p) {
      case Priority.urgent:
        return Colors.red;
      case Priority.high:
        return Colors.orange;
      case Priority.medium:
        return Colors.amber;
      case Priority.low:
        return Colors.green;
    }
  }

  void _openTodo(BuildContext context, int index) {
    final todo = todos[index];
    final isCompleted = _completedIndexes.contains(index);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // priority badge + title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _priorityColor(todo.priority).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: _priorityColor(todo.priority)),
                      const SizedBox(width: 6),
                      Text(
                        todo.priority.title,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _priorityColor(todo.priority),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, size: 14, color: Colors.green),
                        SizedBox(width: 4),
                        Text('Done', style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            Text(
              todo.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                decorationColor: Colors.black45,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              todo.description,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // tick/untick button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: () {
                  setState(() {
                    if (isCompleted) {
                      _completedIndexes.remove(index);
                    } else {
                      _completedIndexes.add(index);
                    }
                  });
                  Navigator.pop(context);
                },
                icon: Icon(isCompleted ? Icons.refresh : Icons.check),
                label: Text(
                  isCompleted ? 'Mark as Incomplete' : 'Mark as Complete',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: isCompleted ? Colors.grey[800] : Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pending = todos.where((t) => !_completedIndexes.contains(todos.indexOf(t))).length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text(
          'My Tasks',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.grey[200]),
        ),
      ),
      body: todos.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.checklist_rounded, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tap + to add your first task',
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
              itemCount: todos.length + 1,
              itemBuilder: (context, index) {
                // summary header
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      '$pending task${pending == 1 ? '' : 's'} remaining',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                final i = index - 1;
                final todo = todos[i];
                final isCompleted = _completedIndexes.contains(i);
                final priorityColor = _priorityColor(todo.priority);

                return GestureDetector(
                  onTap: () => _openTodo(context, i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isCompleted ? Colors.grey[50] : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isCompleted ? Colors.grey[200]! : Colors.grey[200]!,
                      ),
                      boxShadow: isCompleted
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Row(
                      children: [
                        // checkbox
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isCompleted) {
                                _completedIndexes.remove(i);
                              } else {
                                _completedIndexes.add(i);
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: isCompleted ? Colors.black : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isCompleted ? Colors.black : Colors.grey[400]!,
                                width: 2,
                              ),
                            ),
                            child: isCompleted
                                ? const Icon(Icons.check, size: 14, color: Colors.white)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 14),

                        // title + description
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                todo.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: isCompleted ? Colors.grey[400] : Colors.black87,
                                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                                  decorationColor: Colors.grey[400],
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                todo.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),

                        // priority dot
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: priorityColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTodo = await Navigator.pushNamed(context, '/add');
          if (newTodo != null && newTodo is Todo) {
            setState(() {
              todos.add(newTodo);
            });
          }
        },
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        tooltip: 'Add Task',
        elevation: 2,
        child: const Icon(Icons.add),
      ),
    );
  }
}