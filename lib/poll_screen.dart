import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PollScreen extends StatefulWidget {
  const PollScreen({Key? key}) : super(key: key);

  @override
  State<PollScreen> createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Poll"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(96.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    vote(true);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[Icon(Icons.icecream), Text("Ice-cream")],
                  )),
              ElevatedButton(
                  onPressed: () {
                    vote(false);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[Icon(Icons.local_pizza), Text("Pizza")],
                  ))
            ],
          ),
        ));
  }

  Future vote(bool voteForPizza) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    // we get a collection now , but only the refere3nce
    CollectionReference collection = db.collection("poll");

    // and now we get the actual snapshot object - so we get documents in the query
    QuerySnapshot snapshot = await collection.get();

    // and now we get a list of query document snapshots
    List<QueryDocumentSnapshot> list = snapshot.docs;

    // and now we get the first document
    DocumentSnapshot document = list[0];

    // and we get id of this document
    final id = document.id;

    if (voteForPizza) {
      // so we geta  afield inside a document
      int pizzaVotes = document.get("pizza");

      // note the key in the map - has to be string
      collection.doc(id).update({"pizza": ++pizzaVotes});
    } else {
      int iceCreamVotes = document.get("ice-cream");
      collection.doc(id).update({"ice-cream": ++iceCreamVotes});
    }
  }
}
