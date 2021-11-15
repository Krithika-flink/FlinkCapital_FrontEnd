// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';

// BEGIN cupertinoActivityIndicatorDemo

class CupertinoProgressIndicatorDemo extends StatelessWidget {
  const CupertinoProgressIndicatorDemo();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Text(
            //GalleryLocalizations.of(context).interestedFAQ,
            'What should I do?'),
      ),
      child: const Center(
        child: Text(
            'We provide one-week free trial. Just go to https://flinkcapital.web.app/'
            'and start your free trial with your existing account of Aliceblue, Fyers, Angel Broking'
            'and Trustline.If you do not have an account, you can open account using the same link '
            'and get started.Users who open account under our referral get additional three '
            'months subscriptions at free of cost if they subscribe to one year plan.'
            'So, all users who open account under us will get 1 year + 3 months of validity'),
      ),
    );
  }
}

// END
