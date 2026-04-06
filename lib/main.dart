import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'firestore_service.dart';
import 'task.dart';
import 'login_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task App',
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final FirestoreService service = FirestoreService();
  final TextEditingController controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void addTask() {
    service.addTask(
      Task(id: '', name: controller.text.trim(), isCompleted: false),
    );
    controller.clear();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "Enter task...",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Task cannot be empty";
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        addTask();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: service.getTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                }

                final tasks = snapshot.data ?? [];

                if (tasks.isEmpty) {
                  return const Center(child: Text("No tasks yet"));
                }

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    return ListTile(
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (value) {
                          if (value == null) return;
                          service.updateTask(
                            Task(
                              id: task.id,
                              name: task.name,
                              isCompleted: value,
                            ),
                          );
                        },
                      ),
                      title: Text(
                        task.name,
                        style: TextStyle(
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          service.deleteTask(task.id);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}