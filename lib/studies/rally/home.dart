// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:gallery/data/gallery_options.dart';
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:gallery/layout/adaptive.dart';
import 'package:gallery/layout/text_scale.dart';
import 'package:gallery/studies/rally/colors.dart';
import 'package:gallery/studies/rally/tabs/futures.dart';
import 'package:gallery/studies/rally/tabs/options.dart';
import 'package:gallery/studies/rally/tabs/casheq.dart';
import 'package:gallery/studies/rally/tabs/overview.dart';
import 'package:gallery/studies/rally/tabs/orderview.dart';
import 'package:gallery/studies/rally/tabs/signout.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

const int tabCount = 6;
const int turnsToRotateRight = 1;
const int turnsToRotateLeft = 3;

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, RestorationMixin {
  TabController _tabController;
  RestorableInt tabIndex = RestorableInt(0);

  @override
  String get restorationId => 'home_page';

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabCount, vsync: this)
      ..addListener(() {
        // Set state to make sure that the [_RallyTab] widgets get updated when changing tabs.
        setState(() {
          tabIndex.value = _tabController.index;
        });
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = isDisplayDesktop(context);
    Widget tabBarView;
    if (isDesktop) {
      final isTextDirectionRtl =
          GalleryOptions.of(context).resolvedTextDirection() ==
              TextDirection.rtl;
      final verticalRotation =
          isTextDirectionRtl ? turnsToRotateLeft : turnsToRotateRight;
      final revertVerticalRotation =
          isTextDirectionRtl ? turnsToRotateRight : turnsToRotateLeft;
      tabBarView = Row(
        children: [
          Container(
            width: 150 + 50 * (cappedTextScale(context) - 1),
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              border: Border(
                  //side:BorderSide.merge(a, b),
                  //color: RallyColors.cardBackground,
                  right:
                      BorderSide(width: 3.0, color: RallyColors.cardBackground)
                  //width: 2,
                  ),
            ),
            child: Expanded(
              child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //const SizedBox(height: 12),
                  ExcludeSemantics(
                    child: SizedBox(
                      height: 60,
                      child: Image.asset(
                        'assets/logo.png',
                      ),
                    ),
                  ),
                  Text("Follow us:",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: Colors.black),
                      textAlign: TextAlign.center),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(child: SizedBox(width: 200)),
                      IconButton(
                        icon: const Icon(FontAwesomeIcons.instagram, size: 20),
                        color: const Color(0xFF8a3ab9),
                        //highlightColor: Colors.pink,
                        // Buttons.Facebook,
                        // mini: true,
                        onPressed: () async {
                          const url = 'https://www.facebook.com/rk.nallakumar';
                          if (await canLaunch(url) != null) {
                            await launch(url, forceWebView: true);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                      const Expanded(child: SizedBox(width: 200)),
                      IconButton(
                          icon: Icon(FontAwesomeIcons.twitterSquare, size: 20),
                          color: Color(0xFF1DA1F2),
                          //highlightColor: Colors.pink,
                          // Buttons.Facebook,
                          // mini: true,onPressed

                          onPressed: () async {
                            const url = 'https://twitter.com/RK_Nallakumar';
                            if (await canLaunch(url) != null) {
                              await launch(url, forceWebView: true);
                            } else {
                              throw 'Could not launch $url';
                            }
                          }),
                      const Expanded(child: SizedBox(width: 200)),
                      IconButton(
                        icon: Icon(FontAwesomeIcons.facebookSquare, size: 20),
                        color: Color(0xFF1877f2),
                        //highlightColor: Colors.pink,
                        // Buttons.Facebook,
                        // mini: true,
                        onPressed: () async {
                          const url = 'https://www.facebook.com/rk.nallakumar';
                          if (await canLaunch(url) != null) {
                            await launch(url, forceWebView: true);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                      const Expanded(child: SizedBox(width: 200)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Rotate the tab bar, so the animation is vertical for desktops.
                  RotatedBox(
                    quarterTurns: verticalRotation,
                    child: _RallyTabBar(
                      tabs: _buildTabs(
                              context: context, theme: theme, isVertical: true)
                          .map(
                        (widget) {
                          // Revert the rotation on the tabs.
                          return RotatedBox(
                            quarterTurns: revertVerticalRotation,
                            child: widget,
                          );
                        },
                      ).toList(),
                      tabController: _tabController,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            // Rotate the tab views so we can swipe up and down.
            child: RotatedBox(
              quarterTurns: verticalRotation,
              child: TabBarView(
                controller: _tabController,
                children: _buildTabViews(context).map(
                  (widget) {
                    // Revert the rotation on the tab views.
                    return RotatedBox(
                      quarterTurns: revertVerticalRotation,
                      child: widget,
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      );
    } else {
      tabBarView = Column(
        children: [
          _RallyTabBar(
            tabs: _buildTabs(context: context, theme: theme),
            tabController: _tabController,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _buildTabViews(context),
            ),
          ),
        ],
      );
    }
    return ApplyTextOptions(
      child: Scaffold(
        body: SafeArea(
          // For desktop layout we do not want to have SafeArea at the top and
          // bottom to display 100% height content on the accounts view.
          top: !isDesktop,
          bottom: !isDesktop,
          child: Theme(
            // This theme effectively removes the default visual touch
            // feedback for tapping a tab, which is replaced with a custom
            // animation.
            data: theme.copyWith(
              //splashColor: RallyColors.cardBackground,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: tabBarView,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTabs(
      {BuildContext context, ThemeData theme, bool isVertical = false}) {
    return [
      _RallyTab(
        theme: theme,
        iconData: Icons.pie_chart,
        title: GalleryLocalizations.of(context).rallyTitleOverview,
        tabIndex: 0,
        tabController: _tabController,
        isVertical: isVertical,
      ),
      _RallyTab(
        theme: theme,
        iconData: Icons.list_alt,
        title: GalleryLocalizations.of(context).rallyTitleOrder,
        tabIndex: 1,
        tabController: _tabController,
        isVertical: isVertical,
      ),
      _RallyTab(
        theme: theme,
        iconData: Icons.monitor,
        title: GalleryLocalizations.of(context).rallyTitleAccounts,
        tabIndex: 2,
        tabController: _tabController,
        isVertical: isVertical,
      ),
      _RallyTab(
        theme: theme,
        iconData: Icons.money,
        title: GalleryLocalizations.of(context).rallyTitleBills,
        tabIndex: 3,
        tabController: _tabController,
        isVertical: isVertical,
      ),
      _RallyTab(
        theme: theme,
        iconData: Icons.table_chart,
        title: GalleryLocalizations.of(context).rallyTitleBudgets,
        tabIndex: 4,
        tabController: _tabController,
        isVertical: isVertical,
      ),
      _RallyTab(
        theme: theme,
        iconData: Icons.settings,
        title: GalleryLocalizations.of(context).rallyTitleSettings,
        tabIndex: 5,
        tabController: _tabController,
        isVertical: isVertical,
      ),
    ];
  }

  List<Widget> _buildTabViews(BuildContext buildContext) {
    return [
      OverviewView(),
      OrderView(),
      FuturesView(),
      //openFuture(buildContext),
      OptionsView(),
      CashView(),
      SignOutView(),
    ];
  }
}

// ignore: always_declare_return_types
Widget openFuture(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FuturesView(),
    ),
  );
}

class _RallyTabBar extends StatelessWidget {
  const _RallyTabBar({Key key, this.tabs, this.tabController})
      : super(key: key);

  final List<Widget> tabs;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return FocusTraversalOrder(
      order: const NumericFocusOrder(0),
      child: TabBar(
        // Setting isScrollable to true prevents the tabs from being
        // wrapped in [Expanded] widgets, which allows for more
        // flexible sizes and size animations among tabs.
        isScrollable: true,
        labelPadding: EdgeInsets.zero,
        tabs: tabs,
        controller: tabController,
        // This hides the tab indicator.
        indicatorColor: Colors.blueGrey.shade400,
      ),
    );
  }
}

class _RallyTab extends StatefulWidget {
  _RallyTab({
    ThemeData theme,
    IconData iconData,
    String title,
    int tabIndex,
    TabController tabController,
    this.isVertical,
  })  : titleText = Text(title,
            style: (theme.textTheme.button
                .copyWith(color: Colors.blueGrey.shade400))),
        isExpanded = tabController.index == tabIndex,
        icon = Icon(iconData, semanticLabel: title);

  final Text titleText;
  final Icon icon;
  bool isExpanded;
  final bool isVertical;

  @override
  _RallyTabState createState() => _RallyTabState();
}

class _RallyTabState extends State<_RallyTab>
    with SingleTickerProviderStateMixin {
  Animation<double> _titleSizeAnimation;
  Animation<double> _titleFadeAnimation;
  Animation<double> _iconFadeAnimation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _titleSizeAnimation = _controller.view;
    _titleFadeAnimation = _controller.drive(CurveTween(curve: Curves.easeOut));
    _iconFadeAnimation = _controller.drive(Tween<double>(begin: 0.6, end: 1));
    if (widget.isExpanded) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(_RallyTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isVertical) {
      return Column(
        children: [
          const SizedBox(height: 18),
          FadeTransition(
            child: widget.icon,
            opacity: _iconFadeAnimation,
          ),
          const SizedBox(height: 12),
          FadeTransition(
            child: SizeTransition(
              child: Center(child: ExcludeSemantics(child: widget.titleText)),
              axis: Axis.vertical,
              axisAlignment: -1,
              sizeFactor: _titleSizeAnimation,
            ),
            opacity: _titleFadeAnimation,
          ),
          const SizedBox(height: 18),
        ],
      );
    }

    // Calculate the width of each unexpanded tab by counting the number of
    // units and dividing it into the screen width. Each unexpanded tab is 1
    // unit, and there is always 1 expanded tab which is 1 unit + any extra
    // space determined by the multiplier.
    final width = MediaQuery.of(context).size.width;
    const expandedTitleWidthMultiplier = 2;
    final unitWidth = width / (tabCount + expandedTitleWidthMultiplier);

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Row(
        children: [
          FadeTransition(
            child: SizedBox(
              width: unitWidth,
              child: widget.icon,
            ),
            opacity: _iconFadeAnimation,
          ),
          FadeTransition(
            child: SizeTransition(
              child: SizedBox(
                width: unitWidth * expandedTitleWidthMultiplier,
                child: Center(
                  child: ExcludeSemantics(child: widget.titleText),
                ),
              ),
              axis: Axis.horizontal,
              axisAlignment: -1,
              sizeFactor: _titleSizeAnimation,
            ),
            opacity: _titleFadeAnimation,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
