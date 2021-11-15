// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gallery/data/gallery_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:gallery/layout/adaptive.dart';
import 'package:gallery/layout/text_scale.dart';
import 'package:gallery/studies/rally/app.dart';
import 'package:gallery/studies/rally/colors.dart';
import 'package:gallery/userModel.dart';
import 'package:gallery/utils/database.dart';
import 'charts/vertical_fraction_bar.dart';

/// A page that shows a input multiplier.
class MultiplierView extends StatefulWidget {
  @override
  _MultiplierViewState createState() => _MultiplierViewState();
}

class _MultiplierViewState extends State<MultiplierView> {
  Future<MultiplierModel> multiplier;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    multiplier =
        Database.getUserMultiplier(FirebaseAuth.instance.currentUser.uid);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: multiplier,
            builder: (BuildContext context,
                AsyncSnapshot<MultiplierModel> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (isDisplayDesktop(context)) {
                  const sortKeyName = 'Multiplier';
                  return SingleChildScrollView(
                    restorationId: 'multiplier_scroll_view',
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 7,
                            child: Semantics(
                              sortKey:
                                  const OrdinalSortKey(1, name: sortKeyName),
                              child: _MultiplierGrid(
                                  spacing: 24, multiplier: snapshot.data),
                            ),
                          ),
                          //const SizedBox(width: 24),
                        ],
                      ),
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    restorationId: 'multiplier_scroll_view',
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          //_AlertsView(alerts: alerts.sublist(0, 1)),
                          const SizedBox(height: 12),
                          _MultiplierGrid(
                              spacing: 12, multiplier: snapshot.data),
                        ],
                      ),
                    ),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}

// ignore: must_be_immutable
class _MultiplierGrid extends StatelessWidget {
  _MultiplierGrid({Key key, @required this.spacing, @required this.multiplier})
      : super(key: key);

  final double spacing;
  final MultiplierModel multiplier;

  // ignore: avoid_void_async
  void _updatemultiplier(BuildContext context, MultiplierModel multiplier,
      String _currentUser) async {
    //UserModel _currentUser = widget.userModel;
    var _returnString =
        await Database.updateMultiplier(multiplier, _currentUser);
    if (_returnString == 'success') {
      // ignore: unawaited_futures
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MultiplierView(),
          ),
          (route) => false);
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(_returnString),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _apollo = TextEditingController(text: multiplier.apollo.toString());
    final _zeus = TextEditingController(text: multiplier.zeus.toString());
    final _ares = TextEditingController(text: multiplier.ares.toString());
    final _athena = TextEditingController(text: multiplier.athena.toString());
    final _demeter = TextEditingController(text: multiplier.demeter.toString());
    final _artemis = TextEditingController(text: multiplier.artemis.toString());
    final _equity = TextEditingController(text: multiplier.equity.toString());
    final _etf = TextEditingController(text: multiplier.etf.toString());
    final _commodity =
        TextEditingController(text: multiplier.commodity.toString());
    final textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(builder: (context, constraints) {
      final textScaleFactor =
          GalleryOptions.of(context).textScaleFactor(context);
      // Only display multiple columns when the constraints allow it and we
      // have a regular text scale factor.
      final minWidthForTwoColumns = 600;
      final hasMultipleColumns = isDisplayDesktop(context) &&
          constraints.maxWidth > minWidthForTwoColumns &&
          textScaleFactor <= 2;
      final boxWidth = hasMultipleColumns
          ? constraints.maxWidth / 2 - spacing / 2
          : double.infinity;
      final theme = Theme.of(context);
      return Wrap(
          runSpacing: spacing,
          //spacing: 10,
          //direction: Axis.vertical,
//        alignment: WrapAlignment.end,
          //runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            //const SizedBox(width: 50),
            Container(
              width: boxWidth,
              decoration: BoxDecoration(
                border: Border.all(
                  color: RallyColors.cardBackground,
                  width: 1,
                ),
              ),
              //color: RallyColors.cardBackground,
              child: Column(
                children: [
                  Container(
                    /* decoration: BoxDecoration(
                    border: Border.all(
                      color: RallyColors.cardBackground,
                      width: 2,
                    ),
                  ), */
                    color: RallyColors.cardBackground,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MergeSemantics(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: Text(
                                  GalleryLocalizations.of(context)
                                      .rallyAccounts,
                                  style: theme.textTheme.bodyText1.copyWith(
                                    fontSize: 22 / reducedTextScale(context),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 10.0),
                      Container(
                        width: boxWidth - 25,
                        //padding:
                        //  const EdgeInsets.only(left: 10, right: 10, top: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: RallyColors.cardBackground,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 8),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 32 + 60 * (cappedTextScale(context) - 1),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: VerticalFractionBar(
                                color: RallyColors.accountColor(1),
                                fraction: 1,
                              ),
                            ),
                            Expanded(
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Flink Apollo',
                                          style: textTheme.bodyText2.copyWith(
                                              fontSize: 16,
                                              color:
                                                  RallyColors.cardBackground)),
                                      Text(
                                        'Recommended Capital:: 3 lacs per Multiplier (Don\'t exceed more than 5x)',
                                        style: textTheme.bodyText2.copyWith(
                                            color: RallyColors.gray60),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 30,
                                    child: TextFormField(
                                      controller: _apollo,
                                      //initialValue: multiplier.apollo.toString(),
                                      //_apollov = _apollo.text;
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[1-5]'))
                                      ],
                                      style: TextStyle(
                                          color: RallyColors.cardBackground),
                                      textInputAction: TextInputAction.next,
                                      validator: validateInput,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          // hintText: multiplier.apollo.toString(),
                                          //hintStyle:
                                          //helperText: 'Input only[0-5]',
                                          //labelText: 'Hello',
                                          /* border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  RallyColors.cardBackground)),
                                                   */
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: RallyColors.cardBackground,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    RallyColors.cardBackground),
                                          ),
                                          fillColor:
                                              RallyColors.primaryBackground),
                                      autofocus: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        width: (boxWidth - 25),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: RallyColors.cardBackground,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 8),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 32 + 60 * (cappedTextScale(context) - 1),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: VerticalFractionBar(
                                color: RallyColors.accountColor(2),
                                fraction: 1,
                              ),
                            ),
                            Expanded(
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Flink Zeus',
                                          style: textTheme.bodyText2.copyWith(
                                              fontSize: 16,
                                              color:
                                                  RallyColors.cardBackground)),
                                      Text(
                                        'Recommended Capital:: 3 lacs per Multiplier (Don\'t exceed more than 5x)',
                                        style: textTheme.bodyText2.copyWith(
                                            color: RallyColors.gray60),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 30,
                                    child: TextFormField(
                                      controller: _zeus,
                                      //initialValue: multiplier.zeus.toString(),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[1-5]'))
                                      ],
                                      style: TextStyle(
                                          color: RallyColors.cardBackground),
                                      textInputAction: TextInputAction.next,
                                      validator: validateInput,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          //hintText: multiplier.zeus.toString(),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: RallyColors.cardBackground,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    RallyColors.cardBackground),
                                          ),
                                          fillColor:
                                              RallyColors.primaryBackground),
                                      autofocus: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        width: (boxWidth - 25),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: RallyColors.cardBackground,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 8),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 32 + 60 * (cappedTextScale(context) - 1),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: VerticalFractionBar(
                                color: RallyColors.accountColor(3),
                                fraction: 1,
                              ),
                            ),
                            Expanded(
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Flink Ares',
                                          style: textTheme.bodyText2.copyWith(
                                              fontSize: 16,
                                              color:
                                                  RallyColors.cardBackground)),
                                      Text(
                                        'Recommended Capital:: 3 lacs per Multiplier (Don\'t exceed more than 5x)',
                                        style: textTheme.bodyText2.copyWith(
                                            color: RallyColors.gray60),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 30,
                                    child: TextFormField(
                                      controller: _ares,
                                      /*  onSaved: (value) {
                                      _aresv = value;
                                    }, */
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[1-5]'))
                                      ],
                                      style: TextStyle(
                                          color: RallyColors.cardBackground),
                                      textInputAction: TextInputAction.next,
                                      validator: validateInput,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          //hintText: multiplier.ares.toString(),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: RallyColors.cardBackground,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    RallyColors.cardBackground),
                                          ),
                                          fillColor:
                                              RallyColors.primaryBackground),
                                      autofocus: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  /*SizedBox(
                  height: 30,
                   boxWidth ,
                  child: TextButton(
                    autofocus: true,
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: RallyColors.cardBackground),
                    child: const Text(
                      'SAVE',
                      /* semanticsLabel:
                          GalleryLocalizations.of(context).rallySeeAllAccounts, */
                    ),
                    onPressed: () {
                      // if(_formKey.currentState.validate()){}
                    },
                  ),
                ), */
                ],
              ),
            ),
            // ),
            if (hasMultipleColumns) SizedBox(width: spacing),
            Container(
              width: boxWidth,
              decoration: BoxDecoration(
                border: Border.all(
                  color: RallyColors.cardBackground,
                  width: 1,
                ),
              ),
              // color: RallyColors.cardBackground,
              child: Column(
                children: [
                  Container(
                    color: RallyColors.cardBackground,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MergeSemantics(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: Text(
                                  GalleryLocalizations.of(context).rallyBills,
                                  style: theme.textTheme.bodyText1.copyWith(
                                    fontSize: 22 / reducedTextScale(context),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 10.0),
                      Container(
                        width: boxWidth - 25,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: RallyColors.cardBackground,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 8),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 32 + 60 * (cappedTextScale(context) - 1),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: VerticalFractionBar(
                                color: RallyColors.billColor(1),
                                fraction: 1,
                              ),
                            ),
                            Expanded(
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Flink Athena',
                                          style: textTheme.bodyText2.copyWith(
                                              fontSize: 16,
                                              color:
                                                  RallyColors.cardBackground)),
                                      Text(
                                        'Recommended Capital:: 3 lacs per Multiplier (Don\'t exceed more than 5x)',
                                        style: textTheme.bodyText2.copyWith(
                                            color: RallyColors.gray60),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 30,
                                    child: TextFormField(
                                      controller: _athena,
                                      /* onSaved: (value) {
                                      _athenav = value;
                                    }, */
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[1-5]'))
                                      ],
                                      style: TextStyle(
                                          color: RallyColors.cardBackground),
                                      textInputAction: TextInputAction.next,
                                      validator: validateInput,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          //hintText: multiplier.athena.toString(),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: RallyColors.cardBackground,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    RallyColors.cardBackground),
                                          ),
                                          fillColor:
                                              RallyColors.primaryBackground),
                                      autofocus: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        width: boxWidth - 25,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: RallyColors.cardBackground,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 8),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 32 + 60 * (cappedTextScale(context) - 1),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: VerticalFractionBar(
                                color: RallyColors.billColor(2),
                                fraction: 1,
                              ),
                            ),
                            Expanded(
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Flink Demeter',
                                          style: textTheme.bodyText2.copyWith(
                                              fontSize: 16,
                                              color:
                                                  RallyColors.cardBackground)),
                                      Text(
                                        'Recommended Capital:: 3 lacs per Multiplier (Don\'t exceed more than 5x)',
                                        style: textTheme.bodyText2.copyWith(
                                            color: RallyColors.gray60),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 30,
                                    child: TextFormField(
                                      controller: _demeter,
                                      /* onSaved: (value) {
                                      _demeterv = value;
                                    }, */
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[1-5]'))
                                      ],
                                      style: TextStyle(
                                          color: RallyColors.cardBackground),
                                      textInputAction: TextInputAction.next,
                                      validator: validateInput,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          //hintText: multiplier.demeter.toString(),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: RallyColors.cardBackground,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    RallyColors.cardBackground),
                                          ),
                                          fillColor:
                                              RallyColors.primaryBackground),
                                      autofocus: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        width: boxWidth - 25,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: RallyColors.cardBackground,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 8),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 32 + 60 * (cappedTextScale(context) - 1),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: VerticalFractionBar(
                                color: RallyColors.billColor(3),
                                fraction: 1,
                              ),
                            ),
                            Expanded(
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Flink Artemis',
                                          style: textTheme.bodyText2.copyWith(
                                              fontSize: 16,
                                              color:
                                                  RallyColors.cardBackground)),
                                      Text(
                                        'Recommended Capital:: 3 lacs per Multiplier (Don\'t exceed more than 5x)',
                                        style: textTheme.bodyText2.copyWith(
                                            color: RallyColors.gray60),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 30,
                                    child: TextFormField(
                                      controller: _artemis,
                                      /* onSaved: (value) {
                                      _artemisv = value;
                                    }, */
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[1-5]'))
                                      ],
                                      style: TextStyle(
                                          color: RallyColors.cardBackground),
                                      textInputAction: TextInputAction.next,
                                      validator: validateInput,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          //hintText: multiplier.artemis.toString(),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: RallyColors.cardBackground,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    RallyColors.cardBackground),
                                          ),
                                          fillColor:
                                              RallyColors.primaryBackground),
                                      autofocus: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  /* SizedBox(
                  height: 30,
                  width: boxWidth,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: RallyColors.cardBackground),
                    child: Text(
                      'SAVE',
                      semanticsLabel:
                          GalleryLocalizations.of(context).rallySeeAllAccounts,
                    ),
                    onPressed: () {},
                  ),
                ), */
                ],
              ),
            ),

            // if (hasMultipleColumns) SizedBox(height: spacing),
            Container(
              //alignment: AlignmentDirectional.center,
              //width: (constraints.maxWidth - spacing),
              //width: boxWidth,
              decoration: BoxDecoration(
                border: Border.all(
                  color: RallyColors.cardBackground,
                  width: 1,
                ),
              ),
              //color: RallyColors.cardBackground,
              child: Column(
                children: [
                  Container(
                    color: RallyColors.cardBackground,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MergeSemantics(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: Text(
                                  GalleryLocalizations.of(context).rallyBudgets,
                                  style: theme.textTheme.bodyText1.copyWith(
                                    fontSize: 22 / reducedTextScale(context),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 10.0),
                      Container(
                        width: constraints.maxWidth - 25,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: RallyColors.cardBackground,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 8),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 32 + 60 * (cappedTextScale(context) - 1),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: VerticalFractionBar(
                                color: RallyColors.budgetColor(1),
                                fraction: 1,
                              ),
                            ),
                            Expanded(
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Flink Equity',
                                          style: textTheme.bodyText2.copyWith(
                                              fontSize: 16,
                                              color:
                                                  RallyColors.cardBackground)),
                                      Text(
                                        'Recommended Capital:: 3 lacs per Multiplier (Don\'t exceed more than 5x)',
                                        style: textTheme.bodyText2.copyWith(
                                            color: RallyColors.gray60),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 30,
                                    child: TextFormField(
                                      controller: _equity,
                                      /*  onSaved: (value) {
                                      _equityv = value;
                                    }, */
                                      textAlign: TextAlign.center,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[1-5]'))
                                      ],
                                      style: TextStyle(
                                          color: RallyColors.cardBackground),
                                      textInputAction: TextInputAction.next,
                                      validator: validateInput,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: RallyColors.cardBackground,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    RallyColors.cardBackground),
                                          ),
                                          //hintText: multiplier.equity.toString(),
                                          fillColor:
                                              RallyColors.primaryBackground),
                                      autofocus: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        width: constraints.maxWidth - 25,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: RallyColors.cardBackground,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 8),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 32 + 60 * (cappedTextScale(context) - 1),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: VerticalFractionBar(
                                color: RallyColors.budgetColor(2),
                                fraction: 1,
                              ),
                            ),
                            Expanded(
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Flink ETF(SIP)',
                                          style: textTheme.bodyText2.copyWith(
                                              fontSize: 16,
                                              color:
                                                  RallyColors.cardBackground)),
                                      Text(
                                        'Recommended Capital:: 3 lacs per Multiplier (Don\'t exceed more than 5x)',
                                        style: textTheme.bodyText2.copyWith(
                                            color: RallyColors.gray60),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 30,
                                    child: TextFormField(
                                      controller: _etf,
                                      /*   onSaved: (value) {
                                      _etfv = value;
                                    }, */
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[1-5]'))
                                      ],
                                      style: TextStyle(
                                          color: RallyColors.cardBackground),
                                      textInputAction: TextInputAction.next,
                                      validator: validateInput,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: RallyColors.cardBackground,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    RallyColors.cardBackground),
                                          ),
                                          // hintText: multiplier.etf.toString(),
                                          fillColor:
                                              RallyColors.primaryBackground),
                                      autofocus: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: constraints.maxWidth - 25,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: RallyColors.cardBackground,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 8),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 32 + 60 * (cappedTextScale(context) - 1),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: VerticalFractionBar(
                                color: RallyColors.budgetColor(3),
                                fraction: 1,
                              ),
                            ),
                            Expanded(
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Flink Commodity',
                                          style: textTheme.bodyText2.copyWith(
                                              fontSize: 16,
                                              color:
                                                  RallyColors.cardBackground)),
                                      Text(
                                        'Recommended Capital:: 3 lacs per Multiplier (Don\'t exceed more than 5x)',
                                        style: textTheme.bodyText2.copyWith(
                                            color: RallyColors.gray60),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 30,
                                    child: TextFormField(
                                      controller: _commodity,
                                      /*  onSaved: (value) {
                                      _commodityv = value;
                                    }, */
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[1-5]'))
                                      ],
                                      style: TextStyle(
                                          color: RallyColors.cardBackground),
                                      textInputAction: TextInputAction.done,
                                      validator: validateInput,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        //hintText: multiplier.commodity.toString(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: RallyColors.cardBackground,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  RallyColors.cardBackground),
                                        ),
                                        fillColor:
                                            RallyColors.primaryBackground,
                                      ),
                                      autofocus: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  /* SizedBox(
                    height: 30,
                    width: boxWidth,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: RallyColors.cardBackground),
                      child: Text(
                        'SAVE',
                        semanticsLabel: GalleryLocalizations.of(context)
                            .rallySeeAllAccounts,
                      ),
                      onPressed: () {},
                    )), */
                ],
              ),
            ),
            //  ],
            //);
            Container(
              //height: 30,
              // padding: EdgeInsets.symmetric(
              //   ho: (constraints.maxWidth / 2) - spacing / 2),
              //if(isDisplayDesktop(context)){width:constraints.maxWidth}
              //else{width:30},
              //width: 30,
              child: Center(
                  child: SizedBox(
                      height: 30,
                      width: 120,
                      // widthFactor: boxWidth,
                      child: TextButton(
                        autofocus: true,
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: RallyColors.cardBackground),
                        child: Text(
                          'SAVE',
                          semanticsLabel: GalleryLocalizations.of(context)
                              .rallySeeAllAccounts,
                        ),
                        onPressed: () {
                          try {
                            // ignore: omit_local_variable_types
                            MultiplierModel _multiplier = MultiplierModel();
                            _multiplier.apollo =
                                int.tryParse(_apollo.text) ?? 0;
                            _multiplier.zeus = int.tryParse(_zeus.text) ?? 0;
                            _multiplier.ares = int.tryParse(_ares.text) ?? 0;
                            _multiplier.athena =
                                int.tryParse(_athena.text) ?? 0;
                            _multiplier.demeter =
                                int.tryParse(_demeter.text) ?? 0;
                            _multiplier.artemis =
                                int.tryParse(_artemis.text) ?? 0;
                            _multiplier.equity =
                                int.tryParse(_equity.text) ?? 0;
                            _multiplier.etf = int.tryParse(_etf.text) ?? 0;
                            _multiplier.commodity =
                                int.tryParse(_commodity.text) ?? 0;

                            /*   Database.updateMultiplier(
                        multiplier: _multiplier,
                        uid: FirebaseAuth.instance.currentUser.uid); */
                            _updatemultiplier(context, _multiplier,
                                FirebaseAuth.instance.currentUser.uid);
                          } catch (e) {
                            print(e);
                          }
                        },
                      ))),
            )
          ]);
      // ],
      //);
    });
  }
}

String validatePassword(String value) {
  if ((value.length > 1) != null) {
    return 'Multipliers cannot exceed 5';
  }
  return null;
}

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  // ignore: omit_local_variable_types
  // ignore: unnecessary_new
  // ignore: omit_local_variable_types
  RegExp regex = RegExp(pattern.toString());
  if (value.isEmpty || !regex.hasMatch(value))
    return 'Enter Valid Email Id!!!';
  else
    return null;
}

String validateInput(String value) {
  if (value.isEmpty) {
    return 'Enter values between 1 and 5';
  }
  return null;
}
