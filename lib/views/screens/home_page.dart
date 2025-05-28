import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import '../../utils/helpers/db_helper.dart';
import '../components/firestore_services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final FirestoreService _firestore = FirestoreService();

  List<UserModel> _users = [];

  void _loadUsers() async {
    final data = await _dbHelper.getUsers();
    setState(() {
      _users = data;
    });
  }

  void _confirmDeleteUser(int id, String email) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Confirm Delete'),
            content: Text('Are you sure you want to delete this user?'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('Delete', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.pop(context);
                  _deleteUser(id, email);
                },
              ),
            ],
          ),
    );
  }

  void _deleteUser(int id, String email) async {
    // Delete from local DB
    await _dbHelper.deleteUser(id);

    // Delete from Firestore favourites if exists
    final favSnapshot =
        await FirebaseFirestore.instance
            .collection('favourite_users')
            .where('email', isEqualTo: email)
            .get();

    for (var doc in favSnapshot.docs) {
      await FirebaseFirestore.instance
          .collection('favourite_users')
          .doc(doc.id)
          .delete();
    }

    _loadUsers();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('User deleted')));
  }

  void _markFavourite(UserModel user) async {
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('favourite_users')
            .where('email', isEqualTo: user.email)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('User is already in favourites')));
      return;
    }

    await _firestore.addFavouriteUser({
      'username': user.username,
      'email': user.email,
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Added to favourites')));
  }

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Users'),
        elevation: 4,
        backgroundColor: Colors.indigo.shade500,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            color: Colors.orange,
            tooltip: 'View Favourites',
            onPressed: () {
              Navigator.pushNamed(context, '/favourites');
            },
          ),
        ],
      ),
      body:
          _users.isEmpty
              ? Center(
                child: Text(
                  'No users found.\nAdd new users using the button below.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  UserModel user = _users[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo.shade700,
                        child: Text(
                          user.email.isNotEmpty
                              ? user.email[0].toUpperCase()
                              : '?',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      title: Text(
                        user.email,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.indigo.shade900,
                        ),
                      ),
                      trailing: SizedBox(
                        width: 110,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.star_border,
                                color: Colors.amber.shade700,
                                size: 28,
                              ),
                              tooltip: 'Add to Favourites',
                              onPressed: () => _markFavourite(user),
                            ),
                            SizedBox(width: 8),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red.shade700,
                                size: 28,
                              ),
                              tooltip: 'Delete User',
                              onPressed:
                                  () =>
                                      _confirmDeleteUser(user.id!, user.email),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo.shade300,
        child: Icon(Icons.person_add, size: 28),
        tooltip: 'Add New User',
        onPressed: () {
          Navigator.pushNamed(context, '/signup');
        },
      ),
    );
  }
}
