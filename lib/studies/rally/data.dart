// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:gallery/studies/rally/formatters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gallery/userModel.dart';
import 'package:gallery/utils/database.dart';
import 'package:gallery/studies/rally/finance.dart';

final User user = FirebaseAuth.instance.currentUser;
final userid = user.uid;
UserModel userdetails;

/// Calculates the sum of the primary amounts of a list of [FutureData].
double sumFutureDataPrimaryAmount(List<FutureData> items) =>
    sumOf<FutureData>(items, (item) => item.primaryAmount);

/// Calculates the sum of the primary amounts of a list of [OptionsData].
double sumOptionsDataPrimaryAmount(List<OptionsData> items) =>
    sumOf<OptionsData>(items, (item) => item.primaryAmount);

/// Calculates the sum of the primary amounts of a list of [OptionsData].
double sumOptionsDataPaidAmount(List<OptionsData> items) => sumOf<OptionsData>(
      items.where((item) => item.isPaid).toList(),
      (item) => item.primaryAmount,
    );

/// Calculates the sum of the primary amounts of a list of [CashData].
double sumCashDataPrimaryAmount(List<CashData> items) =>
    sumOf<CashData>(items, (item) => item.primaryAmount);

/// Calculates the sum of the amounts used of a list of [CashData].
double sumCashDataAmountUsed(List<CashData> items) =>
    sumOf<CashData>(items, (item) => item.amountUsed);

/// Utility function to sum up values in a list.
double sumOf<T>(List<T> list, double Function(T elt) getValue) {
  var sum = 0.0;
  for (var elt in list) {
    sum += getValue(elt);
  }
  return sum;
}

/// A data model for an account.
///
/// The [primaryAmount] is the balance of the account in USD.
class FutureData {
  const FutureData({this.name, this.primaryAmount, this.InputLot});

  /// The display name of this entity.
  final String name;

  /// The primary amount or value of this entity.
  final double primaryAmount;

  /// The full displayable account number.
  final String InputLot;
}

/// A data model for a bill.
///
/// The [primaryAmount] is the Profit in USD.
class OptionsData {
  const OptionsData({
    this.name,
    this.primaryAmount,
    this.dueDate,
    this.isPaid = false,
  });

  /// The display name of this entity.
  final String name;

  /// The primary amount or value of this entity.
  final double primaryAmount;

  /// The due date of this bill.
  final String dueDate;

  /// If this bill has been paid.
  final bool isPaid;
}

/// A data model for a budget.
///
/// The [primaryAmount] is the budget cap in USD.
class CashData {
  const CashData({this.name, this.primaryAmount, this.amountUsed, this.text1});

  /// The display name of this entity.
  final String name;

  /// The primary amount or value of this entity.
  final double primaryAmount;

  /// Amount of the budget that is consumed or used.
  final double amountUsed;

  final String text1;
}

/// A data model for an alert.
class AlertData {
  AlertData({this.message, this.iconData});

  /// The alert message to display.
  final String message;

  /// The icon to display with the alert.
  final IconData iconData;
}

class SettingsData {
  SettingsData({this.title, this.order});

  /// The alert message to display.
  final String title;

  /// The icon to display with the alert.
  final int order;
}

class DetailedEventData {
  const DetailedEventData({
    this.title,
    this.date,
    this.amount,
  });

  final String title;
  final DateTime date;
  final double amount;
}

/// A data model for data displayed to the user.
class UserDetailData {
  UserDetailData({this.title, this.value});

  /// The display name of this entity.
  final String title;

  /// The value of this entity.
  final String value;
}

/// Class to return dummy data lists.
///
/// In a real app, this might be replaced with some asynchronous service.
/* class DummyDataService extends StatefulWidget {
  final UserModel userModel;

  const DummyDataService({@required this.userModel});
  @override
  /* State<StatefulWidget> createState() {
    return _DummyDataServiceState();
  } */
  _DummyDataServiceState createState() => _DummyDataServiceState();
} */

class DummyDataService {
  /* void didChangeDependencies() async {
    super.didChangeDependencies();
    user1 = await Database.getUser(userid);
    //setState(() {});
  }
 */
  static List<FutureData> getFutureDataList(BuildContext context) {
    return <FutureData>[
      FutureData(
        name: GalleryLocalizations.of(context).rallyAccountDataChecking,
        primaryAmount: 2215.13,
        InputLot: 'Click here to Input No. of lots',
      ),
      FutureData(
        name: GalleryLocalizations.of(context).rallyAccountDataHomeSavings,
        primaryAmount: 8678.88,
        InputLot: 'Click here to Input No. of lots',
      ),
      FutureData(
        name: GalleryLocalizations.of(context).rallyAccountDataCarSavings,
        primaryAmount: 987.48,
        InputLot: 'Click here to Input No. of lots',
      )
      //FutureData(
      //name: GalleryLocalizations.of(context).rallyAccountDataVacation,
      //primaryAmount: 253,
      //InputLot: '1231233456',
      //),
    ];
  }

  static List<UserDetailData> getAccountDetailList(BuildContext context,
      {UserModel user}) {
    //var accountdetails = getUserdetails();
    //UserModel user1;
    //getUserdetails().then((user1) {
    return <UserDetailData>[
      UserDetailData(
        title: GalleryLocalizations.of(context)
            .rallyAccountDetailDataAnnualPercentageYield,
        value: percentFormat(context).format(0.001),
      ),
      UserDetailData(
        title:
            GalleryLocalizations.of(context).rallyAccountDetailDataInterestRate,
        value: usdWithSignFormat(context).format(1676.14),
      ),
      UserDetailData(
        title:
            GalleryLocalizations.of(context).rallyAccountDetailDataInterestYtd,
        value: usdWithSignFormat(context).format(81.45),
      ),
      UserDetailData(
        title: GalleryLocalizations.of(context)
            .rallyAccountDetailDataInterestPaidLastYear,
        value: usdWithSignFormat(context).format(987.12),
      ),
      UserDetailData(
        title: GalleryLocalizations.of(context)
            .rallyAccountDetailDataNextStatement,
        value: shortDateFormat(context).format(DateTime.utc(2019, 12, 25)),
      ),
      UserDetailData(
        title:
            GalleryLocalizations.of(context).rallyAccountDetailDataAccountOwner,
        value: user.fullName,
      ),
    ];

    ///});
  }

  static List<DetailedEventData> getDetailedEventItems() {
    // The following titles are not localized as they're product/brand names.
    return <DetailedEventData>[
      DetailedEventData(
        title: 'Genoe',
        date: DateTime.utc(2019, 1, 24),
        amount: -16.54,
      ),
      DetailedEventData(
        title: 'Fortnightly Subscribe',
        date: DateTime.utc(2019, 1, 5),
        amount: -12.54,
      ),
      DetailedEventData(
        title: 'Circle Cash',
        date: DateTime.utc(2019, 1, 5),
        amount: 365.65,
      ),
      DetailedEventData(
        title: 'Crane Hospitality',
        date: DateTime.utc(2019, 1, 4),
        amount: -705.13,
      ),
      DetailedEventData(
        title: 'ABC Payroll',
        date: DateTime.utc(2018, 12, 15),
        amount: 1141.43,
      ),
      DetailedEventData(
        title: 'Shrine',
        date: DateTime.utc(2018, 12, 15),
        amount: -88.88,
      ),
      DetailedEventData(
        title: 'Foodmates',
        date: DateTime.utc(2018, 12, 4),
        amount: -11.69,
      ),
    ];
  }

  static List<OptionsData> getOptionsDataList(BuildContext context) {
    // The following names are not localized as they're product/brand names.
    return <OptionsData>[
      const OptionsData(
        name: 'Flink Athena',
        primaryAmount: 1245.36,
        dueDate: 'Click here to Input No. of lots',
      ),
      OptionsData(
        name: 'Flink Demeter',
        primaryAmount: 1200,
        dueDate: 'Click here to Input No. of lots',
        isPaid: true,
      ),
      OptionsData(
        name: 'Flink Artemis',
        primaryAmount: 1287.33,
        dueDate: 'Click here to Input No. of lots',
      )
      //OptionsData(
      //name: 'ABC Loans',
      //primaryAmount: 400,
      //dueDate: dateFormatAbbreviatedMonthDay(context)
      //  .format(DateTime.utc(2019, 2, 29)),
      //),
    ];
  }

  static List<UserDetailData> getOptionsDetailList(BuildContext context,
      {double dueTotal, double paidTotal}) {
    return <UserDetailData>[
      UserDetailData(
        title: GalleryLocalizations.of(context).rallyBillDetailTotalAmount,
        value: usdWithSignFormat(context).format(paidTotal + dueTotal),
      ),
      UserDetailData(
        title: GalleryLocalizations.of(context).rallyBillDetailAmountPaid,
        value: usdWithSignFormat(context).format(paidTotal),
      ),
      UserDetailData(
        title: GalleryLocalizations.of(context).rallyBillDetailAmountDue,
        value: usdWithSignFormat(context).format(dueTotal),
      ),
    ];
  }

  static List<CashData> getCashDataList(BuildContext context) {
    return <CashData>[
      CashData(
        name: GalleryLocalizations.of(context).rallyBudgetCategoryCoffeeShops,
        primaryAmount: 1270,
        amountUsed: 44,
        text1: 'Click here to Input Capital',
      ),
      CashData(
        name: GalleryLocalizations.of(context).rallyBudgetCategoryGroceries,
        primaryAmount: 31170,
        amountUsed: 23,
        text1: 'Click here to Input Capital',
      ),
      CashData(
        name: GalleryLocalizations.of(context).rallyBudgetCategoryRestaurants,
        primaryAmount: 4170,
        amountUsed: 22,
        text1: 'Click here to Input Capital',
      )
      //CashData(
      //name: GalleryLocalizations.of(context).rallyBudgetCategoryClothing,
      //primaryAmount: 70,
      //amountUsed:'Click here to Input Capital',
      //),
    ];
  }

  static List<UserDetailData> getCashDetailList(BuildContext context,
      {double capTotal, double usedTotal}) {
    return <UserDetailData>[
      UserDetailData(
        title: GalleryLocalizations.of(context).rallyBudgetDetailTotalCap,
        value: usdWithSignFormat(context).format(capTotal),
      ),
      UserDetailData(
        title: GalleryLocalizations.of(context).rallyBudgetDetailAmountUsed,
        value: usdWithSignFormat(context).format(usedTotal),
      ),
      UserDetailData(
        title: GalleryLocalizations.of(context).rallyBudgetDetailAmountLeft,
        value: usdWithSignFormat(context).format(capTotal - usedTotal),
      ),
    ];
  }

  static List<SettingsData> getSettingsTitles(BuildContext context) {
    return <SettingsData>[
      /*GalleryLocalizations.of(context).rallySettingsManageAccounts,
      GalleryLocalizations.of(context).rallySettingsTaxDocuments,
      GalleryLocalizations.of(context).rallySettingsPasscodeAndTouchId,
      GalleryLocalizations.of(context).rallySettingsNotifications,*/
      SettingsData(
          order: 1,
          title: GalleryLocalizations.of(context)
              .rallySettingsPersonalInformation),
      SettingsData(
          order: 2, title: GalleryLocalizations.of(context).rallySettingsHelp),
      SettingsData(
          order: 3,
          title: GalleryLocalizations.of(context).rallySettingsSignOut),
      /*GalleryLocalizations.of(context).rallySettingsPaperlessSettings,
      GalleryLocalizations.of(context).rallySettingsFindAtms,*/
      // GalleryLocalizations.of(context).rallySettingsHelp,
      //GalleryLocalizations.of(context).rallySettingsSignOut,
    ];
  }

  static List<AlertData> getAlerts(BuildContext context) {
    return <AlertData>[
      AlertData(
        message: GalleryLocalizations.of(context)
            .rallyAlertsMessageHeadsUpShopping(
                percentFormat(context, decimalDigits: 0).format(0.9)),
        iconData: Icons.sort,
      ),
      AlertData(
        message: GalleryLocalizations.of(context)
            .rallyAlertsMessageSpentOnRestaurants(
                usdWithSignFormat(context, decimalDigits: 0).format(120)),
        iconData: Icons.sort,
      ),
      AlertData(
        message: GalleryLocalizations.of(context).rallyAlertsMessageATMFees(
            usdWithSignFormat(context, decimalDigits: 0).format(24)),
        iconData: Icons.credit_card,
      ),
      AlertData(
        message: GalleryLocalizations.of(context)
            .rallyAlertsMessageCheckingAccount(
                percentFormat(context, decimalDigits: 0).format(0.04)),
        iconData: Icons.attach_money,
      ),
      AlertData(
        message: GalleryLocalizations.of(context)
            .rallyAlertsMessageUnassignedTransactions(16),
        iconData: Icons.not_interested,
      ),
    ];
  }
/* 
  @override
  Widget build(BuildContext context) {
    return ListBody();
  } */

  //FinancialEntityCategoryDetailsPage(getDetailedEventItems);
}

class Flinktable extends StatelessWidget {
  Flinktable({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'SYMBOL',
            style: TextStyle(fontStyle: FontStyle.normal),
          ),
        ),
        DataColumn(
          label: Text(
            'BUY/SELL',
            style: TextStyle(fontStyle: FontStyle.normal),
          ),
        ),
        DataColumn(
          label: Text(
            'TYPE',
            style: TextStyle(fontStyle: FontStyle.normal),
          ),
        ),
        DataColumn(
          label: Text(
            'QTY',
            style: TextStyle(fontStyle: FontStyle.normal),
          ),
        ),
        DataColumn(
          label: Text(
            'PRICE',
            style: TextStyle(fontStyle: FontStyle.normal),
          ),
        ),
        DataColumn(
          label: Text(
            'TIME',
            style: TextStyle(fontStyle: FontStyle.normal),
          ),
        ),
        DataColumn(
          label: Text(
            'STATUS',
            style: TextStyle(fontStyle: FontStyle.normal),
          ),
        ),
      ],
      // ignore: prefer_const_literals_to_create_immutables
      rows: <DataRow>[
        const DataRow(
          cells: <DataCell>[
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
          ],
        ),
      ],
    );
  }
}

class FlinkPorttable extends StatelessWidget {
  FlinkPorttable({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'SYMBOL',
            style: TextStyle(fontStyle: FontStyle.normal),
          ),
        ),
        DataColumn(
          label: Text(
            'BUY/SELL',
            style: TextStyle(fontStyle: FontStyle.normal),
          ),
        ),
        DataColumn(
          label: Text(
            'TYPE',
            style: TextStyle(fontStyle: FontStyle.normal),
          ),
        ),
        DataColumn(
          label: Text(
            'QTY',
            style: TextStyle(fontStyle: FontStyle.normal),
          ),
        ),
        DataColumn(
          label: Text(
            'PRICE',
            style: TextStyle(fontStyle: FontStyle.normal),
          ),
        ),
        DataColumn(
          label: Text(
            'TIME',
            style: TextStyle(fontStyle: FontStyle.normal),
          ),
        ),
        DataColumn(
          label: Text(
            'STATUS',
            style: TextStyle(fontStyle: FontStyle.normal),
          ),
        ),
      ],
      rows: const <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
          ],
        ),
      ],
    );
  }
}

List<DataRow> _createRows(QuerySnapshot snapshot) {
  // ignore: omit_local_variable_types
  List<DataRow> newList =
      snapshot.docs.map((DocumentSnapshot documentSnapshot) {
    return DataRow(cells: [
      DataCell(Text(documentSnapshot.id.toString())),
      DataCell(Text(documentSnapshot['symbol'].toString())),
      DataCell(Text(documentSnapshot['buy_sell'].toString())),
      DataCell(Text(documentSnapshot['type'].toString())),
      DataCell(Text(documentSnapshot['quantity'].toString())),
      DataCell(Text(documentSnapshot['price'].toString())),
      DataCell(Text(documentSnapshot['timestamp'].toString())),
      DataCell(Text(documentSnapshot['status'].toString())),
      //DataCell(Text(documentSnapshot['Rapper name'].toString())),
    ]);
  }).toList();

  return newList;
}

class ItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Database.readItems(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.hasData || snapshot.data != null) {
          return DataTable(
            // ignore: prefer_const_literals_to_create_immutables
            columns: <DataColumn>[
              const DataColumn(
                label: Text(
                  'ORDER ID',
                  style: TextStyle(fontStyle: FontStyle.normal),
                ),
              ),
              const DataColumn(
                label: Text(
                  'SYMBOL',
                  style: TextStyle(fontStyle: FontStyle.normal),
                ),
              ),
              const DataColumn(
                label: Text(
                  'BUY/SELL',
                  style: TextStyle(fontStyle: FontStyle.normal),
                ),
              ),
              const DataColumn(
                label: Text(
                  'TYPE',
                  style: TextStyle(fontStyle: FontStyle.normal),
                ),
              ),
              const DataColumn(
                label: Text(
                  'QTY',
                  style: TextStyle(fontStyle: FontStyle.normal),
                ),
              ),
              const DataColumn(
                label: Text(
                  'PRICE',
                  style: TextStyle(fontStyle: FontStyle.normal),
                ),
              ),
              const DataColumn(
                label: Text(
                  'TIME',
                  style: TextStyle(fontStyle: FontStyle.normal),
                ),
              ),
              const DataColumn(
                label: Text(
                  'STATUS',
                  style: TextStyle(fontStyle: FontStyle.normal),
                ),
              ),
              //new DataColumn(label: Text('Votes')),
              //new DataColumn(label: Text('Rapper name')),
            ],
            rows: _createRows(snapshot.data),
          );
        }
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
/* class GetUser extends StatelessWidget {
  UserModel user;
 */
//@override
Future<UserModel> getUserdetails() async {
  // super.didChangeDependencies();
  userdetails = await Database.getUser(userid);
  return userdetails;
  //setState(() {});
}

//}
