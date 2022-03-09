import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shron/screens/ProfileScreen.dart';
import 'package:shron/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isShowUsers = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(labelText: 'Search For A user'),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowUsers = true;
            });
            //print(_);
          },
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: _searchController.text)
                  .get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Material(
                        child: InkWell(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                      uid: snapshot.data!.docs[index]['uid']))),
                          child: ListTile(
                            tileColor: mobileBackgroundColor,
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  snapshot.data!.docs[index]['photoURL']),
                            ),
                            title: Text(snapshot.data!.docs[index]['username']),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    child: StaggeredGridView.countBuilder(
                      crossAxisCount: 3,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Image(
                          image: NetworkImage(
                              snapshot.data!.docs[index]['postURL']),
                          fit: BoxFit.cover,
                        );
                      },
                      staggeredTileBuilder: (index) => StaggeredTile.count(
                          (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                      //mainAxisSpacing: 1,
                      //crossAxisSpacing: 1,
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
    );
  }
}
