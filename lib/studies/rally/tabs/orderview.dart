// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gallery/layout/text_scale.dart';
import 'package:gallery/studies/rally/colors.dart';
import 'package:gallery/studies/rally/data.dart';
import 'package:gallery/data/gallery_options.dart';

/// A page that shows a summary of bills.

class OrderView extends StatefulWidget {
  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    //  final isDesktop = isDisplayDesktop(context);
    final theme = Theme.of(context);
    return ApplyTextOptions(
      child: Scaffold(
        body:
            // QuoteScreen(),
            Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 90),
            // ignore: prefer_const_constructors
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  'ORDER SUMMARY',
                  // style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic,color:RallyColors.cardBackground),
                  style: theme.textTheme.headline1.copyWith(
                      fontSize: 25 / reducedTextScale(context),
                      fontWeight: FontWeight.w600,
                      color: RallyColors.cardBackground),
                  textAlign: TextAlign.left,
                )
              ],
            ),
            const SizedBox(height: 45),
            Expanded(
              child: Padding(
                  padding:
                      // isDesktop ? const EdgeInsets.all(40) : EdgeInsets.zero,
                      const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 20.0,
                  ),
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
          ],
        ),
      ),
    );
  }
}
