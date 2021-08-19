// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:animations/animations.dart';
import 'package:gallery/data/gallery_options.dart';
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:gallery/layout/adaptive.dart';
import 'package:gallery/layout/text_scale.dart';
import 'package:gallery/studies/rally/charts/line_chart.dart';
import 'package:gallery/studies/rally/charts/pie_chart.dart';
import 'package:gallery/studies/rally/charts/vertical_fraction_bar.dart';
import 'package:gallery/studies/rally/colors.dart';
import 'package:gallery/studies/rally/data.dart';
import 'package:gallery/studies/rally/formatters.dart';
import 'package:gallery/api_response.dart';
import 'package:gallery/quote_bloc.dart';
import 'package:gallery/studies/rally/InputPage.dart';
import 'package:gallery/quote_response.dart';

class FinancialEntityView extends StatelessWidget {
  const FinancialEntityView({
    this.heroLabel,
    this.heroAmount,
    this.wholeAmount,
    this.segments,
    this.financialEntityCards,
  }) : assert(segments.length == financialEntityCards.length);

  /// The amounts to assign each item.
  final List<RallyPieChartSegment> segments;
  final String heroLabel;
  final double heroAmount;
  final double wholeAmount;
  final List<FinancialEntityCategoryView> financialEntityCards;

  @override
  Widget build(BuildContext context) {
    final maxWidth = pieChartMaxSize + (cappedTextScale(context) - 1.0) * 100.0;
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              // We decrease the max height to ensure the [RallyPieChart] does
              // not take up the full height when it is smaller than
              // [kPieChartMaxSize].
              maxHeight: math.min(
                constraints.biggest.shortestSide * 0.9,
                maxWidth,
              ),
            ),
            child: RallyPieChart(
              heroLabel: heroLabel,
              heroAmount: heroAmount,
              wholeAmount: wholeAmount,
              segments: segments,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            height: 1,
            constraints: BoxConstraints(maxWidth: maxWidth),
            color: RallyColors.inputBackground,
          ),
          Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            color: RallyColors.cardBackground,
            child: Column(
              children: financialEntityCards,
            ),
          ),
        ],
      );
    });
  }
}

/// A reusable widget to show balance information of a single entity as a card.
class FinancialEntityCategoryView extends StatelessWidget {
  const FinancialEntityCategoryView({
    @required this.indicatorColor,
    @required this.indicatorFraction,
    @required this.title,
    @required this.subtitle,
    @required this.semanticsLabel,
    @required this.amount,
    @required this.suffix,
  });

  final Color indicatorColor;
  final double indicatorFraction;
  final String title;
  final String subtitle;
  final String semanticsLabel;
  final String amount;
  final Widget suffix;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        button: true,
        enabled: true,
        label: semanticsLabel,
      ),
      excludeSemantics: true,
      // TODO(shihaohong): State restoration of
      // FinancialEntityCategoryDetailsPage on mobile is blocked because
      // OpenContainer does not support restorablePush.
      // See https://github.com/flutter/flutter/issues/69924.
      child: OpenContainer(
        transitionDuration: const Duration(milliseconds: 350),
        transitionType: ContainerTransitionType.fade,
        openBuilder: (context, openContainer) => MultiplierView(),
        openColor: RallyColors.primaryBackground,
        closedColor: RallyColors.primaryBackground,
        closedElevation: 0,
        closedBuilder: (context, openContainer) {
          return TextButton(
            style: TextButton.styleFrom(primary: Colors.black),
            onPressed: openContainer,
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 32 + 60 * (cappedTextScale(context) - 1),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: VerticalFractionBar(
                          color: indicatorColor,
                          fraction: indicatorFraction,
                        ),
                      ),
                      Expanded(
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: textTheme.bodyText2
                                      .copyWith(fontSize: 16),
                                ),
                                Text(
                                  subtitle,
                                  style: textTheme.bodyText2
                                      .copyWith(color: RallyColors.gray60),
                                ),
                              ],
                            ),
                            Text(
                              amount,
                              style: textTheme.bodyText1.copyWith(
                                fontSize: 20,
                                color: RallyColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(minWidth: 32),
                        padding: const EdgeInsetsDirectional.only(start: 12),
                        child: suffix,
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
          );
        },
      ),
    );
  }
}

/// Data model for [FinancialEntityCategoryView].
class FinancialEntityCategoryModel {
  const FinancialEntityCategoryModel(
    this.indicatorColor,
    this.indicatorFraction,
    this.title,
    this.subtitle,
    this.usdAmount,
    this.suffix,
  );

  final Color indicatorColor;
  final double indicatorFraction;
  final String title;
  final String subtitle;
  final double usdAmount;
  final Widget suffix;
}

FinancialEntityCategoryView buildFinancialEntityFromAccountData(
  AccountData model,
  int accountDataIndex,
  BuildContext context,
) {
  final amount = usdWithSignFormat(context).format(model.primaryAmount);
  //final shortAccountNumber = model.InputLot;
  return FinancialEntityCategoryView(
    suffix: const Icon(Icons.chevron_right, color: Colors.grey),
    title: model.name,
    subtitle: model.InputLot,
    semanticsLabel: GalleryLocalizations.of(context).rallyAccountAmount(
      model.name,
      model.InputLot,
      amount,
    ),
    indicatorColor: RallyColors.accountColor(accountDataIndex),
    indicatorFraction: 1,
    amount: amount,
  );
}

FinancialEntityCategoryView buildFinancialEntityFromBillData(
  BillData model,
  int billDataIndex,
  BuildContext context,
) {
  final amount = usdWithSignFormat(context).format(model.primaryAmount);
  return FinancialEntityCategoryView(
    suffix: const Icon(Icons.chevron_right, color: Colors.grey),
    title: model.name,
    subtitle: model.dueDate,
    semanticsLabel: GalleryLocalizations.of(context).rallyBillAmount(
      model.name,
      model.dueDate,
      amount,
    ),
    indicatorColor: RallyColors.billColor(billDataIndex),
    indicatorFraction: 1,
    amount: amount,
  );
}

FinancialEntityCategoryView buildFinancialEntityFromBudgetData(
  BudgetData model,
  int budgetDataIndex,
  BuildContext context,
) {
  final amountUsed = usdWithSignFormat(context).format(model.amountUsed);
  final primaryAmount = usdWithSignFormat(context).format(model.primaryAmount);
  final amount =
      usdWithSignFormat(context).format(model.primaryAmount - model.amountUsed);

  return FinancialEntityCategoryView(
    suffix: Text(
      GalleryLocalizations.of(context).rallyFinanceLeft,
      style: Theme.of(context)
          .textTheme
          .bodyText2
          .copyWith(color: RallyColors.gray60, fontSize: 10),
    ),
    title: model.name,
    //subtitle: amountUsed + ' / ' + primaryAmount,
    subtitle: 'Click here to Input Capital',
    semanticsLabel: GalleryLocalizations.of(context).rallyBudgetAmount(
      model.name,
      model.amountUsed,
      model.primaryAmount,
      amount,
    ),
    indicatorColor: RallyColors.budgetColor(budgetDataIndex),
    indicatorFraction: 1,
    amount: amount,
  );
}

List<FinancialEntityCategoryView> buildAccountDataListViews(
  List<AccountData> items,
  BuildContext context,
) {
  return List<FinancialEntityCategoryView>.generate(
    items.length,
    (i) => buildFinancialEntityFromAccountData(items[i], i, context),
  );
}

List<FinancialEntityCategoryView> buildBillDataListViews(
  List<BillData> items,
  BuildContext context,
) {
  return List<FinancialEntityCategoryView>.generate(
    items.length,
    (i) => buildFinancialEntityFromBillData(items[i], i, context),
  );
}

List<FinancialEntityCategoryView> buildBudgetDataListViews(
  List<BudgetData> items,
  BuildContext context,
) {
  return <FinancialEntityCategoryView>[
    for (int i = 0; i < items.length; i++)
      buildFinancialEntityFromBudgetData(items[i], i, context)
  ];
}

class FinancialEntityCategoryDetailsPage extends StatelessWidget {
  final List<DetailedEventData> items =
      DummyDataService.getDetailedEventItems();

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);

    return ApplyTextOptions(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            GalleryLocalizations.of(context).rallyAccountDataChecking,
            style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 18),
          ),
        ),
        body:
            // QuoteScreen(),
            Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                child: Text('Click here to Input No. of Lots'),
                style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey,
                    onPrimary: Colors.white,
                    shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
                onPressed: () {}),
            const SizedBox(height: 30),
            Text(
              "ORDER SUMMARY",
              style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
              textAlign: TextAlign.left,
            ),
            /* Expanded(
              child: Padding(
                padding: isDesktop ? const EdgeInsets.all(40) : EdgeInsets.zero,
                child: ItemList(),
              ),
            ), */
            /*  child: ListView(
                  shrinkWrap: true,
                  children: ItemList(),
                ),  */
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                  padding:
                      // isDesktop ? const EdgeInsets.all(40) : EdgeInsets.zero,
                      const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 20.0,
                  ),
                  /* child: Text('ORDER DETAILS',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 14),
                      textAlign: TextAlign.left), */
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.grey),
                          //child: Flinktable(),
                          child: ItemList(),
                        )),
                  )),
            ),
            /* Container(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                      'Brief Description:\n Flink Apollo is a Niftybased strategy with low  risk'
                      ' and decent returns.The strategy generates only 1 signal at most for'
                      ' 18 out of 22 days in a month,you just need to enter the number of lots each day.'
                      'Each signal will have 3 orders.i.e.,BO order:A buy or sell order,Target Order and Stop Loss Order.'
                      'You can modify the values of stop loss and target after placement of an order.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 16),
                      textAlign: TextAlign.left)),
            ) */
          ],
        ),
      ),
    );
  }
}

class InputLotsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    TextEditingController _input1 = new TextEditingController();
    TextEditingController _input2 = new TextEditingController();
    TextEditingController _input3 = new TextEditingController();
    TextEditingController _input4 = new TextEditingController();
    TextEditingController _input5 = new TextEditingController();
    TextEditingController _input6 = new TextEditingController();
    TextEditingController _input7 = new TextEditingController();
    TextEditingController _input8 = new TextEditingController();
    TextEditingController _input9 = new TextEditingController();
    final spacing = const SizedBox(width: 30);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 10,
          title: const Text('Assign Multipliers to your Preferred Strategies',
              style: TextStyle(color: Colors.white70, fontSize: 18)),
        ),
        body: SafeArea(
            child: Row(children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              width: double.infinity,
              //alignment: Alignment.center,
              //constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
              // padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Flink Apollo',
                        style: TextStyle(
                            fontSize: 15, fontStyle: FontStyle.normal),
                      ),
                      const SizedBox(width: 200),
                      SizedBox(
                        width: 50,
                        height: 20,
                        child: TextField(
                          controller: _input1,
                          decoration: const InputDecoration(hintText: '1X'),
                          autofocus: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Flink Zeus',
                        style: TextStyle(
                            fontSize: 15, fontStyle: FontStyle.normal),
                      ),
                      const SizedBox(width: 200),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _input2,
                          autofocus: true,
                          decoration: const InputDecoration(hintText: '1X'),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          const SizedBox(width: 30),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              width: double.infinity,
              //alignment: Alignment.center,
              //constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
              // padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Flink Apollo',
                        style: TextStyle(
                            fontSize: 15, fontStyle: FontStyle.normal),
                      ),
                      const SizedBox(width: 200),
                      SizedBox(
                        width: 50,
                        height: 20,
                        child: TextField(
                          controller: _input1,
                          decoration: const InputDecoration(hintText: '1X'),
                          autofocus: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Flink Zeus',
                        style: TextStyle(
                            fontSize: 15, fontStyle: FontStyle.normal),
                      ),
                      const SizedBox(width: 200),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _input2,
                          autofocus: true,
                          decoration: const InputDecoration(hintText: '1X'),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ])
            /* const SizedBox(height: 50),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () {},
          ) */
            ));
    /* return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      onPressed: () {},
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            width: double.infinity,
            child: isDesktop
                ? Row(
                    children: [
                      Expanded(
                        flex: 1,
                        //child: _EventTitle(title: title),
                      ),
                      //_EventDate(date: date),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          //child: _EventAmount(amount: amount),
                        ),
                      ),
                    ],
                  )
                : Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // _EventTitle(title: title),
                          //_EventDate(date: date),
                        ],
                      ),
                      // _EventAmount(amount: amount),
                    ],
                  ),
          ),
          SizedBox(
            height: 1,
            child: Container(
              color: RallyColors.dividerColor,
            ),
          ),
        ],
      ),
    ); */
  }
}

class QuoteScreen extends StatefulWidget {
  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  QuoteBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = QuoteBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Movie Mania',
            style: TextStyle(color: Colors.lightGreen, fontSize: 28)),
        backgroundColor: Colors.black54,
      ),
      backgroundColor: Colors.black54,
      body: RefreshIndicator(
        onRefresh: () => _bloc.fetchQuoteList(),
        child: StreamBuilder<ApiResponse<List<Quote>>>(
          stream: _bloc.quoteListStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return Loading(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  return QuoteList(quoteList: snapshot.data.data);
                  break;
                case Status.ERROR:
                  return Error(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () => _bloc.fetchQuoteList(),
                  );
                  break;
              }
            }
            return Container();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

class QuoteList extends StatelessWidget {
  final List<Quote> quoteList;

  const QuoteList({Key key, this.quoteList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: quoteList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5 / 1.8,
      ),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.network(
                'https://image.tmdb.org/t/p/w342${quoteList[index].posterPath}',
                fit: BoxFit.fill,
              ),
            ),
          ),
        );
      },
    );
  }
}

class Error extends StatelessWidget {
  final String errorMessage;

  final VoidCallback onRetryPressed;

  const Error({Key key, this.errorMessage, this.onRetryPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.lightGreen,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          RaisedButton(
            color: Colors.lightGreen,
            child: Text('Retry', style: TextStyle(color: Colors.white)),
            onPressed: onRetryPressed,
          )
        ],
      ),
    );
  }
}

class Loading extends StatelessWidget {
  final String loadingMessage;

  const Loading({Key key, this.loadingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            loadingMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.lightGreen,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 24),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen),
          ),
        ],
      ),
    );
  }
}

class _DetailedEventCard extends StatelessWidget {
  const _DetailedEventCard({
    @required this.title,
    @required this.date,
    @required this.amount,
  });

  final String title;
  final DateTime date;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      onPressed: () {},
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            width: double.infinity,
            child: isDesktop
                ? Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: _EventTitle(title: title),
                      ),
                      _EventDate(date: date),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: _EventAmount(amount: amount),
                        ),
                      ),
                    ],
                  )
                : Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _EventTitle(title: title),
                          _EventDate(date: date),
                        ],
                      ),
                      _EventAmount(amount: amount),
                    ],
                  ),
          ),
          SizedBox(
            height: 1,
            child: Container(
              color: RallyColors.dividerColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _EventAmount extends StatelessWidget {
  const _EventAmount({Key key, @required this.amount}) : super(key: key);

  final double amount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      usdWithSignFormat(context).format(amount),
      style: textTheme.bodyText1.copyWith(
        fontSize: 20,
        color: RallyColors.gray,
      ),
    );
  }
}

class _EventDate extends StatelessWidget {
  const _EventDate({Key key, @required this.date}) : super(key: key);

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      shortDateFormat(context).format(date),
      semanticsLabel: longDateFormat(context).format(date),
      style: textTheme.bodyText2.copyWith(color: RallyColors.gray60),
    );
  }
}

class _EventTitle extends StatelessWidget {
  const _EventTitle({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      title,
      style: textTheme.bodyText2.copyWith(fontSize: 16),
    );
  }
}
