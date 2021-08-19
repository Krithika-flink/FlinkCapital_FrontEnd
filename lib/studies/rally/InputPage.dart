// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gallery/data/gallery_options.dart';

import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:gallery/layout/adaptive.dart';
import 'package:gallery/layout/text_scale.dart';
import 'package:gallery/studies/rally/colors.dart';
import 'package:gallery/studies/rally/data.dart';
import 'package:gallery/studies/rally/finance.dart';
import 'package:gallery/studies/rally/formatters.dart';
import 'package:gallery/studies/rally/colors.dart';

import 'charts/vertical_fraction_bar.dart';

/// A page that shows a input multiplier.
class MultiplierView extends StatefulWidget {
  @override
  _MultiplierViewState createState() => _MultiplierViewState();
}

class _MultiplierViewState extends State<MultiplierView> {
  @override
  Widget build(BuildContext context) {
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
                  sortKey: const OrdinalSortKey(1, name: sortKeyName),
                  child: const _MultiplierGrid(spacing: 24),
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
            children: [
              //_AlertsView(alerts: alerts.sublist(0, 1)),
              const SizedBox(height: 12),
              const _MultiplierGrid(spacing: 12),
            ],
          ),
        ),
      );
    }
  }
}

class _MultiplierGrid extends StatelessWidget {
  const _MultiplierGrid({Key key, @required this.spacing}) : super(key: key);

  final double spacing;

  @override
  Widget build(BuildContext context) {
    var _input1 = TextEditingController();
    final textTheme = Theme.of(context).textTheme;
    var _input2 = TextEditingController();
    var _input3 = TextEditingController();
    var _input4 = TextEditingController();
    var _input5 = TextEditingController();
    var _input6 = TextEditingController();
    var _input7 = TextEditingController();
    var _input8 = TextEditingController();
    var _input9 = TextEditingController();

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
        children: [
          Container(
            width: 375,
            color: RallyColors.cardBackground,
            child: Container(
              //color: RallyColors.cardBackground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MergeSemantics(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Text(
                            GalleryLocalizations.of(context).rallyAccounts,
                            style: theme.textTheme.bodyText1.copyWith(
                              fontSize: 30 / reducedTextScale(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
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
                                      Text(
                                        'Flink Apollo',
                                        style: textTheme.bodyText2
                                            .copyWith(fontSize: 16),
                                      ),
                                      Text(
                                        'Default Value:0',
                                        style: textTheme.bodyText2.copyWith(
                                            color: RallyColors.gray60),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 30,
                                    child: TextFormField(
                                      controller: _input1,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[1-5]"))
                                      ],
                                      textInputAction: TextInputAction.next,
                                      validator: validateInput,
                                      maxLines: 1,
                                      decoration: const InputDecoration(
                                        hintText: '0',
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
                      Container(
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
                                      Text(
                                        'Flink Zeus',
                                        style: textTheme.bodyText2
                                            .copyWith(fontSize: 16),
                                      ),
                                      Text(
                                        'Default Value:0',
                                        style: textTheme.bodyText2.copyWith(
                                            color: RallyColors.gray60),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 30,
                                    child: TextFormField(
                                      controller: _input2,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[1-5]"))
                                      ],
                                      textInputAction: TextInputAction.next,
                                      validator: validateInput,
                                      maxLines: 1,
                                      decoration: const InputDecoration(
                                        hintText: '0',
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
                      Container(
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
                                      Text(
                                        'Flink Ares',
                                        style: textTheme.bodyText2
                                            .copyWith(fontSize: 16),
                                      ),
                                      Text(
                                        'Default Value:0',
                                        style: textTheme.bodyText2.copyWith(
                                            color: RallyColors.gray60),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 30,
                                    child: TextFormField(
                                      controller: _input3,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[1-5]"))
                                      ],
                                      textInputAction: TextInputAction.next,
                                      validator: validateInput,
                                      maxLines: 1,
                                      decoration: const InputDecoration(
                                        hintText: '0',
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
                        color: RallyColors.dividerColor,
                      ),
                    ],
                  ),
                  TextButton(
                    style: TextButton.styleFrom(primary: Colors.white),
                    child: Text(
                      'SAVE',
                      semanticsLabel:
                          GalleryLocalizations.of(context).rallySeeAllAccounts,
                    ),
                    onPressed: () {
                      // if(_formKey.currentState.validate()){}
                    },
                  ),
                ],
              ),
            ),
          ),
          if (hasMultipleColumns) SizedBox(width: spacing),
          Container(
            width: 375,
            color: RallyColors.cardBackground,
            child: Container(
              //color: RallyColors.cardBackground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MergeSemantics(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Text(
                            GalleryLocalizations.of(context).rallyBills,
                            style: theme.textTheme.bodyText1.copyWith(
                              fontSize: 30 / reducedTextScale(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
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
                                      Text(
                                        'Flink Athena',
                                        style: textTheme.bodyText2
                                            .copyWith(fontSize: 16),
                                      ),
                                      Text(
                                        'Default Value:0',
                                        style: textTheme.bodyText2.copyWith(
                                            color: RallyColors.gray60),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 30,
                                    child: TextFormField(
                                      controller: _input4,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[1-5]"))
                                      ],
                                      textInputAction: TextInputAction.next,
                                      validator: validateInput,
                                      maxLines: 1,
                                      decoration: const InputDecoration(
                                        hintText: '0',
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
                      Container(
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
                                      Text(
                                        'Flink Demeter',
                                        style: textTheme.bodyText2
                                            .copyWith(fontSize: 16),
                                      ),
                                      Text(
                                        'Default Value:0',
                                        style: textTheme.bodyText2.copyWith(
                                            color: RallyColors.gray60),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 30,
                                    child: TextFormField(
                                      controller: _input5,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[1-5]"))
                                      ],
                                      textInputAction: TextInputAction.next,
                                      validator: validateInput,
                                      maxLines: 1,
                                      decoration: const InputDecoration(
                                        hintText: '0',
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
                      Container(
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
                                      Text(
                                        'Flink Artemis',
                                        style: textTheme.bodyText2
                                            .copyWith(fontSize: 16),
                                      ),
                                      Text(
                                        'Default Value:0',
                                        style: textTheme.bodyText2.copyWith(
                                            color: RallyColors.gray60),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 30,
                                    child: TextFormField(
                                      controller: _input6,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[1-5]"))
                                      ],
                                      textInputAction: TextInputAction.next,
                                      validator: validateInput,
                                      maxLines: 1,
                                      decoration: const InputDecoration(
                                        hintText: '0',
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
                        color: RallyColors.dividerColor,
                      ),
                    ],
                  ),
                  TextButton(
                    style: TextButton.styleFrom(primary: Colors.white),
                    child: Text(
                      'SAVE',
                      semanticsLabel:
                          GalleryLocalizations.of(context).rallySeeAllAccounts,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          if (hasMultipleColumns) SizedBox(width: spacing),
          Container(
            width: 375,
            color: RallyColors.cardBackground,
            child: Container(
              //color: RallyColors.cardBackground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MergeSemantics(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Text(
                            GalleryLocalizations.of(context).rallyBudgets,
                            style: theme.textTheme.bodyText1.copyWith(
                              fontSize: 30 / reducedTextScale(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
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
                                      Text(
                                        'Flink Equity',
                                        style: textTheme.bodyText2
                                            .copyWith(fontSize: 16),
                                      ),
                                      Text(
                                        'Default Value:0',
                                        style: textTheme.bodyText2.copyWith(
                                            color: RallyColors.gray60),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 30,
                                    child: TextFormField(
                                      controller: _input7,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[1-5]"))
                                      ],
                                      textInputAction: TextInputAction.next,
                                      validator: validateInput,
                                      maxLines: 1,
                                      decoration: const InputDecoration(
                                        hintText: '0',
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
                      Container(
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
                                      Text(
                                        'Flink ETF(SIP)',
                                        style: textTheme.bodyText2
                                            .copyWith(fontSize: 16),
                                      ),
                                      Text(
                                        'Default Value:0',
                                        style: textTheme.bodyText2.copyWith(
                                            color: RallyColors.gray60),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 30,
                                    child: TextFormField(
                                      controller: _input8,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[1-5]"))
                                      ],
                                      textInputAction: TextInputAction.next,
                                      validator: validateInput,
                                      maxLines: 1,
                                      decoration: const InputDecoration(
                                        hintText: '0',
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
                      Container(
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
                                      Text(
                                        'Flink Commodity',
                                        style: textTheme.bodyText2
                                            .copyWith(fontSize: 16),
                                      ),
                                      Text(
                                        'Default Value:0',
                                        style: textTheme.bodyText2.copyWith(
                                            color: RallyColors.gray60),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 30,
                                    child: TextFormField(
                                      controller: _input9,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[1-5]"))
                                      ],
                                      textInputAction: TextInputAction.next,
                                      validator: validateInput,
                                      maxLines: 1,
                                      decoration: const InputDecoration(
                                        hintText: '0',
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
                        color: RallyColors.dividerColor,
                      ),
                    ],
                  ),
                  TextButton(
                    style: TextButton.styleFrom(primary: Colors.white),
                    child: Text(
                      'SAVE',
                      semanticsLabel:
                          GalleryLocalizations.of(context).rallySeeAllAccounts,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
/* 
String validatePassword(String value) {
  if ((value.length > 1) != null) {
    return 'Multipliers cannot exceed 5';
  }
  return null;
} */

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
