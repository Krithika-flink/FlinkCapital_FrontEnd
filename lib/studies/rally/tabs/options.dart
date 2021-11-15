// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:gallery/studies/rally/charts/pie_chart.dart';
import 'package:gallery/studies/rally/data.dart';
import 'package:gallery/studies/rally/finance.dart';
import 'package:gallery/studies/rally/tabs/sidebar.dart';

/// A page that shows a summary of Options.
class OptionsView extends StatefulWidget {
  @override
  _OptionsViewState createState() => _OptionsViewState();
}

class _OptionsViewState extends State<OptionsView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final items = DummyDataService.getOptionsDataList(context);
    final dueTotal = sumOptionsDataPrimaryAmount(items);
    final paidTotal = sumOptionsDataPaidAmount(items);
    final detailItems = DummyDataService.getOptionsDetailList(
      context,
      dueTotal: dueTotal,
      paidTotal: paidTotal,
    );

    return TabWithSidebar(
      restorationId: 'bills_view',
      mainView: FinancialEntityView(
        heroLabel: GalleryLocalizations.of(context).rallyBillsDue,
        heroAmount: dueTotal,
        segments: buildSegmentsFromBillItems(items),
        wholeAmount: dueTotal,
        financialEntityCards: buildOptionsDataListViews(items, context),
      ),
      sidebarItems: [
        for (UserDetailData item in detailItems)
          SidebarItem(title: item.title, value: item.value)
      ],
    );
  }
}
