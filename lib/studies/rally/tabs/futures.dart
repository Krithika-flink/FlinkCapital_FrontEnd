// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:gallery/studies/rally/charts/pie_chart.dart';
import 'package:gallery/studies/rally/data.dart';
import 'package:gallery/studies/rally/finance.dart';
import 'package:gallery/studies/rally/tabs/sidebar.dart';
import 'package:gallery/userModel.dart';
import 'package:gallery/utils/database.dart';
import 'package:flutter/src/foundation/change_notifier.dart';

/// A page that shows a summary of futures.
/* class FuturesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = DummyDataService.getAccountDataList(context);
    final detailItems = DummyDataService.getAccountDetailList(context);
    final balanceTotal = sumAccountDataPrimaryAmount(items);

    return TabWithSidebar(
      restorationId: 'futures_view',
      mainView: FinancialEntityView(
        heroLabel: GalleryLocalizations.of(context).rallyAccountTotal,
        heroAmount: balanceTotal,
        segments: buildSegmentsFromAccountItems(items),
        wholeAmount: balanceTotal,
        financialEntityCards: buildAccountDataListViews(items, context),
      ),
      sidebarItems: [
        for (UserDetailData item in detailItems)
          SidebarItem(title: item.title, value: item.value)
      ],
    );
  }
}
 */
class FuturesView extends StatefulWidget {
  //final DummyDataService _dummy;
  // final Function getDetailedEventItems;
  //FinancialEntityCategoryDetailsPage(this._dummy);
  //const FuturesView();
  @override
  _FuturesViewState createState() => _FuturesViewState();
}

class _FuturesViewState extends State<FuturesView> {
  Future<UserModel> usermodel;

  Timer _timer;
  //String _timeUntil = "loading...";
  /* TabController _tabController;
  RestorableInt tabIndex = RestorableInt(0); */
  //Animation<double> _animation;

  /* @override
  void initState() {
    super.initState();
    asyncMethod().then((value) {
      // setState(() {});
      print('Async done');
      user1 = value;
      print('user uid:${user1.fullName}');
    });
  }
 */
  /* void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          //_timeUntil = TimeLeft().timeLeft(_groupModel.currentBookDue.toDate());
        });
      }
    });
  } */

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    usermodel = Database.getUser(FirebaseAuth.instance.currentUser.uid);
    setState(() {});
    //_startTimer();
  }

  /*  @override
  void initState() {
    super.initState();
    //  WidgetsBinding.instance.addPostFrameCallback((_) {
    usermodel = asyncMethod();
    //}); */
  //setState(() { });
  //_startTimer();
  //} */

  /* Future<UserModel> asyncMethod() async {
    user1 = Database.getUser(FirebaseAuth.instance.currentUser.uid);
    //print('user uid:${user1.email}');
    //setState(() {});
    return user1;
    // ....
  } */

  @override
  void dispose() {
    /*  if (_timer != null) {
      _timer.cancel();
    } */
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: usermodel,
            builder: (context, AsyncSnapshot<UserModel> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final items = DummyDataService.getFutureDataList(context);
                final detailItems = DummyDataService.getAccountDetailList(
                    context,
                    user: snapshot.data);
                final balanceTotal = sumFutureDataPrimaryAmount(items);

                // CircularProgressIndicator(value: _animation.value);
                return TabWithSidebar(
                  restorationId: 'futures_view',
                  mainView: FinancialEntityView(
                    heroLabel:
                        GalleryLocalizations.of(context).rallyAccountTotal,
                    heroAmount: balanceTotal,
                    segments: buildSegmentsFromFutureItems(items),
                    wholeAmount: balanceTotal,
                    financialEntityCards:
                        buildFutureDataListViews(items, context),
                  ),
                  sidebarItems: [
                    for (UserDetailData item in detailItems)
                      SidebarItem(title: item.title, value: item.value)
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
/*   final RestorableInt _currentPage = RestorableInt(0);
  @override
  // TODO: implement restorationId
  String get restorationId => 'futures_view';

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    // TODO: implement restoreState
    registerForRestoration(tabIndex, 'carousel_page');
    _tabController.index = tabIndex.value;
  } */
}
