// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:gallery/studies/rally/charts/pie_chart.dart';
import 'package:gallery/studies/rally/data.dart';
import 'package:gallery/studies/rally/finance.dart';
import 'package:gallery/studies/rally/tabs/sidebar.dart';

class CashView extends StatefulWidget {
  @override
  _CashViewState createState() => _CashViewState();
}

class _CashViewState extends State<CashView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final items = DummyDataService.getCashDataList(context);
    final capTotal = sumCashDataPrimaryAmount(items);
    final usedTotal = sumCashDataAmountUsed(items);
    final detailItems = DummyDataService.getCashDetailList(
      context,
      capTotal: capTotal,
      usedTotal: usedTotal,
    );

    return TabWithSidebar(
      restorationId: 'budgets_view',
      mainView: FinancialEntityView(
        heroLabel: GalleryLocalizations.of(context).rallyBudgetLeft,
        heroAmount: capTotal - usedTotal,
        segments: buildSegmentsFromBudgetItems(items),
        wholeAmount: capTotal,
        financialEntityCards: buildCashDataListViews(items, context),
      ),
      sidebarItems: [
        for (UserDetailData item in detailItems)
          SidebarItem(title: item.title, value: item.value)
      ],
    );
  }
}
