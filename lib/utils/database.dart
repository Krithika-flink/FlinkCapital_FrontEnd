import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gallery/userModel.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final User user = FirebaseAuth.instance.currentUser;
final userid = user.uid;

final CollectionReference _mainCollection =
    _firestore.collection('order_history');
//final CollectionReference _collection = _firestore.collection('order_history');

class Database {
  static String userUid;

  static Future<void> addItem({
    String title,
    String description,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('items').doc();

    Map<String, dynamic> data = <String, dynamic>{
      'title': title,
      'description': description,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print('Note item added to the database'))
        .catchError((e) => print(e));
  }

  static Future<void> updateItem({
    String title,
    String description,
    String docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('items').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      'title': title,
      'description': description,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print('Note item updated in the database'))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readItems() {
    /*  CollectionReference notesItemCollection =
        _mainCollection.doc('M9JjID7Fr9P6X4KlTQuB').collection('order_history'); */
    CollectionReference notesItemCollection = _mainCollection
        //.doc('ljhJjxmMriWQXhLzfvy5Z8xYXxk2')
        .doc(userUid)
        .collection('order_id');
    return notesItemCollection.snapshots();
  }

  static Future<void> deleteItem({
    String docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('items').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }

  static Future<String> createUser(UserModel user) async {
    String retVal = 'error';

    try {
      await _firestore.collection('users').doc(user.uid).set(({
            'fullName': user.fullName.trim(),
            'email': user.email.trim(),
            'accountCreated': Timestamp.now(),
            //'notifToken': user.notifToken,
          }));
      retVal = 'success';
      var _returnString = await createMultiplier(user);
      if (_returnString == 'success') {
        retVal = 'success';
      } else {
        retVal = _returnString;
      }
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  static Future<String> createMultiplier(UserModel user) async {
    var retVal = 'error';

    try {
      await _firestore.collection('multipliers').doc(user.uid).set(({
            'apollo': 0,
            'zeus': 0,
            'ares': 0,
            'athena': 0,
            'demeter': 0,
            'artemis': 0,
            'equity': 0,
            'etf': 0,
            'commodity': 0
            //'notifToken': user.notifToken,
          }));
      retVal = 'success';
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  static Future<UserModel> getUser(String uid) async {
    UserModel retVal;

    try {
      DocumentSnapshot _docSnapshot =
          await _firestore.collection('users').doc(uid).get();
      retVal = UserModel.fromDocumentSnapshot(doc: _docSnapshot);
    } catch (e) {
      print(e);
    }
    print('user return $retVal');
    return retVal;
  }

  static Future<MultiplierModel> getUserMultiplier(String uid) async {
    MultiplierModel retVal;

    try {
      DocumentSnapshot _docSnapshot =
          await _firestore.collection('multipliers').doc(uid).get();
      retVal = MultiplierModel.fromDocumentSnapshot(doc: _docSnapshot);
    } catch (e) {
      print(e);
    }
    print('multiplier return ${retVal.apollo},${retVal.zeus}');
    return retVal;
  }

  static Future<String> updateMultiplier(
      MultiplierModel multiplier, String currentUser) async {
    var retval = 'error';
    DocumentReference documentReferencer =
        _firestore.collection('multipliers').doc(currentUser);
    var data = <String, dynamic>{
      'apollo': multiplier.apollo,
      'zeus': multiplier.zeus,
      'ares': multiplier.ares,
      'athena': multiplier.athena,
      'demeter': multiplier.demeter,
      'artemis': multiplier.artemis,
      'equity': multiplier.equity,
      'etf': multiplier.etf,
      'commodity': multiplier.commodity
    };
    try {
      await documentReferencer
          .update(data)
          .whenComplete(() => print('Note item updated in the database'));
      retval = 'success';
    } catch (e) {
      print(e);
    }
    return retval;
//        .catchError((e) => print(e));
  }
}
