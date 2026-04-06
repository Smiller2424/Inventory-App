import 'package:cloud_firestore/cloud_firestore.dart';
import 'task.dart';

class FirestoreService {
  final CollectionReference tasksRef =
      FirebaseFirestore.instance.collection('tasks');

  // CREATE (add task)
  Future<void> addTask(Task task) async {
    await tasksRef.add(task.toMap());
  }

  // READ 
  Stream<List<Task>> getTasks() {
    return tasksRef.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) =>
              Task.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList(),
    );
  }

  // UPDATE 
  Future<void> updateTask(Task task) async {
    await tasksRef.doc(task.id).update(task.toMap());
  }

  // DELETE
  Future<void> deleteTask(String id) async {
    await tasksRef.doc(id).delete();
  }
}