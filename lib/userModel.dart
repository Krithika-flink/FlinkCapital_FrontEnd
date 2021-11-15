import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String email;
  Timestamp accountCreated;
  String fullName;
  String groupId;
  //String notifToken;
  double annualPercentage;
  double totalProfits;
  double profitYTD;
  double totalCap;
  Timestamp subscriptionEnd;
  double optTotalAmt;
  double optcurrentPortFolio;
  double optProfit;
  double cashTotalCap;
  double cashAmtused;
  double cashProfit;

  UserModel({
    this.uid,
    this.email,
    this.accountCreated,
    this.fullName,
    this.groupId,
    this.annualPercentage,
    this.totalProfits,
    this.profitYTD,
    this.totalCap,
    this.subscriptionEnd,
    this.optTotalAmt,
    this.optcurrentPortFolio,
    this.optProfit,
    this.cashTotalCap,
    this.cashAmtused,
    this.cashProfit,
    //this.notifToken,
  });

  UserModel.fromDocumentSnapshot({DocumentSnapshot doc}) {
    uid = doc.id.toString();
    email = (doc.data() as dynamic)['email'].toString();
    accountCreated = (doc.data() as dynamic)['accountCreated'] as Timestamp;
    fullName = (doc.data() as dynamic)['fullName'].toString();
    groupId = (doc.data() as dynamic)['groupId'].toString();
    //notifToken = (doc.data() as dynamic)['notifToken'].toString();
  }
}

class MultiplierModel {
  String userId;
  int apollo;
  int zeus;
  int ares;
  int athena;
  int demeter;
  int artemis;
  int equity;
  int etf;
  int commodity;

  MultiplierModel(
      {this.userId,
      this.apollo,
      this.zeus,
      this.ares,
      this.athena,
      this.demeter,
      this.artemis,
      this.equity,
      this.etf,
      this.commodity});

  MultiplierModel.fromDocumentSnapshot({DocumentSnapshot doc}) {
    userId = doc.id.toString();
    apollo = (doc.data() as dynamic)['apollo'] as int;
    zeus = (doc.data() as dynamic)['zeus'] as int;
    ares = (doc.data() as dynamic)['ares'] as int;
    athena = (doc.data() as dynamic)['athena'] as int;
    demeter = (doc.data() as dynamic)['demeter'] as int;
    artemis = (doc.data() as dynamic)['artemis'] as int;
    equity = (doc.data() as dynamic)['equity'] as int;
    etf = (doc.data() as dynamic)['etf'] as int;
    commodity = (doc.data() as dynamic)['commodity'] as int;
    //rating = doc.data["rating"];
    //review = doc.data["review"];
  }
}
