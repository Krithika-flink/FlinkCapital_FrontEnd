// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery/data/gallery_options.dart';

import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:gallery/layout/adaptive.dart';
import 'package:gallery/layout/text_scale.dart';
import 'package:gallery/studies/rally/colors.dart';
import 'package:gallery/studies/rally/data.dart';
import 'package:gallery/studies/rally/finance.dart';
import 'package:gallery/studies/rally/formatters.dart';

/// A page that shows a status overview.
class OverviewView extends StatefulWidget {
  @override
  _OverviewViewState createState() => _OverviewViewState();
}

class _OverviewViewState extends State<OverviewView> {
  @override
  Widget build(BuildContext context) {
    final alerts = DummyDataService.getAlerts(context);

    if (isDisplayDesktop(context)) {
      const sortKeyName = 'Overview';
      return SingleChildScrollView(
        restorationId: 'overview_scroll_view',
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 7,
                child: Semantics(
                  sortKey: const OrdinalSortKey(1, name: sortKeyName),
                  child: const _OverviewGrid(spacing: 24),
                ),
              ),
              const SizedBox(width: 24),
              Flexible(
                flex: 3,
                child: Container(
                  width: 400,
                  child: Semantics(
                    sortKey: const OrdinalSortKey(2, name: sortKeyName),
                    child: FocusTraversalGroup(
                      child: _AlertsView(alerts: alerts),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        restorationId: 'overview_scroll_view',
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              //_AlertsView(alerts: alerts.sublist(0, 1)),
              _AlertsView(alerts: alerts),
              const SizedBox(height: 12),
              const _OverviewGrid(spacing: 12),
            ],
          ),
        ),
      );
    }
  }
}

class _OverviewGrid extends StatelessWidget {
  const _OverviewGrid({Key key, @required this.spacing}) : super(key: key);

  final double spacing;

  @override
  Widget build(BuildContext context) {
    final accountDataList = DummyDataService.getFutureDataList(context);
    final optionsDataList = DummyDataService.getOptionsDataList(context);
    final cashDataList = DummyDataService.getCashDataList(context);

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

      return Wrap(
        runSpacing: spacing,
        children: [
          Container(
            width: boxWidth,
            child: _FinancialView(
              title: GalleryLocalizations.of(context).rallyAccounts,
              total: sumFutureDataPrimaryAmount(accountDataList),
              financialItemViews:
                  buildFutureDataListViews(accountDataList, context),
              buttonSemanticsLabel:
                  GalleryLocalizations.of(context).rallySeeAllAccounts,
              order: 1,
            ),
          ),
          if (hasMultipleColumns) SizedBox(width: spacing),
          Container(
            width: boxWidth,
            child: _FinancialView(
              title: GalleryLocalizations.of(context).rallyBills,
              total: sumOptionsDataPrimaryAmount(optionsDataList),
              financialItemViews:
                  buildOptionsDataListViews(optionsDataList, context),
              buttonSemanticsLabel:
                  GalleryLocalizations.of(context).rallySeeAllBills,
              order: 2,
            ),
          ),
          _FinancialView(
            title: GalleryLocalizations.of(context).rallyBudgets,
            total: sumCashDataPrimaryAmount(cashDataList),
            financialItemViews: buildCashDataListViews(cashDataList, context),
            buttonSemanticsLabel:
                GalleryLocalizations.of(context).rallySeeAllBudgets,
            order: 3,
          ),
        ],
      );
    });
  }
}

class _AlertsView extends StatefulWidget {
  _AlertsView({Key key, this.alerts}) : super(key: key);
  List<AlertData> alerts;

  @override
  _AlertsViewState createState() => _AlertsViewState();
}

class _AlertsViewState extends State<_AlertsView> {
  bool seeall = false;
  List<AlertData> tempalerts;

  void _toggleseeallView(BuildContext context) {
    setState(() {
      seeall = !seeall;
    });

    if (seeall) {
      tempalerts = widget.alerts;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    tempalerts = widget.alerts;
    if (!isDesktop && !seeall) {
      tempalerts = widget.alerts.sublist(0, 1);
    }
    return Container(
      padding: const EdgeInsetsDirectional.only(start: 16, top: 4, bottom: 4),
      color: RallyColors.cardBackground,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding:
                isDesktop ? const EdgeInsets.symmetric(vertical: 16) : null,
            child: MergeSemantics(
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(GalleryLocalizations.of(context).rallyAlerts),
                  if (!isDesktop)
                    TextButton(
                      style: TextButton.styleFrom(primary: Colors.white),
                      onPressed: () {
                        _toggleseeallView(context);
                      },
                      child: seeall ? const Text('See Less') : Text("See All"),
                    )
                ],
              ),
            ),
          ),
          for (AlertData alert in tempalerts) ...[
            Container(color: RallyColors.primaryBackground, height: 1),
            _Alert(alert: alert),
          ]
        ],
      ),
    );
  }
}

class _Alert extends StatelessWidget {
  const _Alert({
    Key key,
    @required this.alert,
  }) : super(key: key);

  final AlertData alert;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Container(
        padding: isDisplayDesktop(context)
            ? const EdgeInsets.symmetric(vertical: 8)
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(alert.message),
            ),
            SizedBox(
              width: 100,
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(alert.iconData, color: RallyColors.white60),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FinancialView extends StatelessWidget {
  const _FinancialView({
    this.title,
    this.total,
    this.financialItemViews,
    this.buttonSemanticsLabel,
    this.order,
  });

  final String title;
  final String buttonSemanticsLabel;
  final double total;
  final List<FinancialEntityCategoryView> financialItemViews;
  final double order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FocusTraversalOrder(
      order: NumericFocusOrder(order),
      child: Container(
        //color: RallyColors.cardBackground,
        decoration: BoxDecoration(
          border: Border.all(
            //side:BorderSide.merge(a, b),
            color: RallyColors.cardBackground,
            //right: BorderSide(width: 1.0, color: RallyColors.cardBackground)
            width: 1,
          ),
          color: RallyColors.cardBackground,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MergeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                        left: 16,
                        right: 16,
                      ),
                      child: Text(
                        title,
                        style: theme.textTheme.bodyText1.copyWith(
                            fontSize: 22 / reducedTextScale(context),
                            fontWeight: FontWeight.w500),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0, left: 16, right: 16, bottom: 5),
                    child: Text(
                      usdWithSignFormat(context).format(total),
                      style: theme.textTheme.subtitle1.copyWith(
                        fontSize: 20 / reducedTextScale(context),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...financialItemViews.sublist(
                0, math.min(financialItemViews.length, 3)),
            SizedBox(
              //height: 30,
              child: TextButton(
                style: TextButton.styleFrom(primary: Colors.white),
                child: Text(
                  GalleryLocalizations.of(context).rallySeeAll,
                  semanticsLabel: buttonSemanticsLabel,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
