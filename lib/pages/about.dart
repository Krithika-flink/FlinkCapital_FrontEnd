// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

void showAboutDialog({
  @required BuildContext context,
}) {
  assert(context != null);
  showDialog<void>(
    context: context,
    builder: (context) {
      return _AboutDialog();
    },
  );
}

Future<String> getVersionNumber() async {
  final packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

class _AboutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bodyTextStyle =
        textTheme.bodyText1.apply(color: colorScheme.onPrimary);

    final name = 'Flink Capital'; // Don't need to localize.
    final legalese = '© 2021 The WTFABRIKAT team'; // Don't need to localize.
    final repoText = ' Flink Capital Website ';
    final seeSource = 'To see more about Flink Capital,Please visit the';
    //GalleryLocalizations.of(context).aboutDialogDescription(repoText);
    /* final repoLinkIndex = seeSource.indexOf(repoText);
    final repoLinkIndexEnd = repoLinkIndex + repoText.length;
    final seeSourceFirst = seeSource.substring(0, repoLinkIndex);
    final seeSourceSecond = seeSource.substring(repoLinkIndexEnd); */

    return AlertDialog(
      backgroundColor: colorScheme.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder(
              future: getVersionNumber(),
              builder: (context, snapshot) => Text(
                snapshot.hasData ? '$name ${snapshot.data}' : '$name',
                style: textTheme.headline4.apply(color: colorScheme.onPrimary),
              ),
            ),
            const SizedBox(height: 24),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    style: bodyTextStyle,
                    text: seeSource,
                  ),
                  TextSpan(
                    style: bodyTextStyle.copyWith(
                      color: colorScheme.primary,
                    ),
                    text: repoText,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final url = 'https://flinkcapital.com';
                        if (await canLaunch(url)) {
                          await launch(
                            url,
                            forceSafariVC: false,
                          );
                        }
                      },
                  ),
                  TextSpan(
                    style: bodyTextStyle,
                    text: '.Thank You!',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              legalese,
              style: bodyTextStyle,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            MaterialLocalizations.of(context).viewLicensesButtonLabel,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (context) => Theme(
                data: Theme.of(context).copyWith(
                  textTheme: Typography.material2018(
                    platform: Theme.of(context).platform,
                  ).black,
                  scaffoldBackgroundColor: Colors.white,
                ),
                child: LicensePage(
                  applicationName: name,
                  applicationLegalese: legalese,
                ),
              ),
            ));
          },
        ),
        TextButton(
          child: Text(MaterialLocalizations.of(context).closeButtonLabel),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
