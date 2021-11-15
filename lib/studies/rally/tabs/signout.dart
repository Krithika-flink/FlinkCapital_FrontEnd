// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:gallery/gen_l10n/gallery_localizations.dart';

import 'package:gallery/layout/adaptive.dart';
import 'package:gallery/studies/rally/routes.dart' as rally_route;
import 'package:gallery/studies/rally/colors.dart';
import 'package:gallery/studies/rally/data.dart';
import 'package:gallery/utils/authentication.dart';
import 'package:url_launcher/url_launcher.dart';

class SignOutView extends StatefulWidget {
  @override
  _SignOutViewState createState() => _SignOutViewState();
}

class _SignOutViewState extends State<SignOutView> {
  int order = 0;
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
              //order = order+1;
              _SettingsItem(title),
              const Divider(
                color: RallyColors.dividerColor,
                height: 1,
              ),
              /* TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  color: RallyColors.cardBackground,
                  alignment: AlignmentDirectional.centerStart,
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
                  child:
                      Text(GalleryLocalizations.of(context).rallySettingsHelp),
                ),
                onPressed: () async {
                  const url = 'https://www.flinkcapital.com/';
                  if (await canLaunch(url)) {
                    await launch(url, forceWebView: true);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ), */
            ],
          ],
        ),
      ),
      //),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem(this.settings);

  final SettingsData settings;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.white,
        padding: EdgeInsets.zero,
      ),
      child: Container(
        color: RallyColors.cardBackground,
        alignment: AlignmentDirectional.centerStart,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
        child: Text(settings.title),
      ),
      onPressed: () async {
        switch (settings.order) {
          case 3:
            await Authentication.signOut(context: context);
            return Navigator.of(context)
                .restorablePushNamed(rally_route.loginRoute);
          case 2:
            const url = 'https://www.flinkcapital.com/our-tools/';
            if (await canLaunch(url)) {
              await launch(url, forceWebView: true);
            } else {
              throw ('Could not launch $url');
            }
            break;
          case 1:
          //return const String.fromEnvironment('onlyReply',
          //  defaultValue: 'false');
          default:
            throw 'unknown message';
        }
      },
    );
  }
}
