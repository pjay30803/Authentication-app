import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../components/firestore_services.dart';

class FavouriteUsersScreen extends StatelessWidget {
  final FirestoreService _firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favourite Users')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.getFavouriteUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user['username']),
                subtitle: Text(user['email']),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _firestore.deleteFavouriteUser(user.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
