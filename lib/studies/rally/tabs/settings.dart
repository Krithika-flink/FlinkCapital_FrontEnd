// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:gallery/layout/adaptive.dart';
import 'package:gallery/studies/rally/routes.dart' as rally_route;
import 'package:gallery/studies/rally/colors.dart';
import 'package:gallery/studies/rally/data.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: Container(
        padding: EdgeInsets.only(top: isDisplayDesktop(context) ? 24 : 0),
        child: ListView(
          restorationId: 'settings_list_view',
          shrinkWrap: true,
          children: [
            for (SettingsData title
                in DummyDataService.getSettingsTitles(context)) ...[
              _SettingsItem(title),
              const Divider(
                color: RallyColors.dividerColor,
                height: 1,
              )
            ]
          ],
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem(this.title);

  final SettingsData title;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.white,
        padding: EdgeInsets.zero,
      ),
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        color: RallyColors.cardBackground,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
        child: Text(title.title, style: const TextStyle(color: Colors.black)),
      ),
      onPressed: () {
        Navigator.of(context).restorablePushNamed(rally_route.loginRoute);
      },
    );
  }
}
