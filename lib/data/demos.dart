// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show describeEnum;
import 'package:flutter/material.dart';
import 'package:gallery/codeviewer/code_displayer.dart';
import 'package:gallery/codeviewer/code_segments.dart';
import 'package:gallery/data/icons.dart';

import 'package:gallery/deferred_widget.dart';
import 'package:gallery/demos/cupertino/cupertino_demos.dart'
    deferred as cupertino_demos;
import 'package:gallery/demos/cupertino/demo_types.dart';
import 'package:gallery/demos/material/material_demos.dart'
    deferred as material_demos;
import 'package:gallery/demos/material/material_demo_types.dart';
import 'package:gallery/demos/reference/motion_demo_container_transition.dart'
    deferred as motion_demo_container;
import 'package:gallery/demos/reference/motion_demo_fade_through_transition.dart';
import 'package:gallery/demos/reference/motion_demo_fade_scale_transition.dart';
import 'package:gallery/demos/reference/motion_demo_shared_x_axis_transition.dart';
import 'package:gallery/demos/reference/motion_demo_shared_y_axis_transition.dart';
import 'package:gallery/demos/reference/motion_demo_shared_z_axis_transition.dart';
import 'package:gallery/demos/reference/colors_demo.dart'
    deferred as colors_demo;
import 'package:gallery/demos/reference/transformations_demo.dart'
    deferred as transformations_demo;
import 'package:gallery/demos/reference/typography_demo.dart'
    deferred as typography;
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:flutter_gen/gen_l10n/gallery_localizations_en.dart'
    show GalleryLocalizationsEn;

const _docsBaseUrl = 'https://api.flutter.dev/flutter';
const _docsAnimationsUrl =
    'https://pub.dev/documentation/animations/latest/animations';

enum GalleryDemoCategory {
  study,
  material,
  cupertino,
  other,
}

extension GalleryDemoExtension on GalleryDemoCategory {
  String get name => describeEnum(this);

  String displayTitle(GalleryLocalizations localizations) {
    switch (this) {
      case GalleryDemoCategory.material:
        return 'HOW IT WORKS';
      case GalleryDemoCategory.cupertino:
        return 'FAQ';
      case GalleryDemoCategory.other:
        return 'SUBSCRIPTIONS & OTHERS';
      case GalleryDemoCategory.study:
    }
    return null;
  }
}

class GalleryDemo {
  const GalleryDemo({
    @required this.title,
    @required this.category,
    @required this.subtitle,
    // This parameter is required for studies.
    this.studyId,
    // Parameters below are required for non-study demos.
    this.slug,
    this.icon,
    this.configurations,
  })  : assert(title != null),
        assert(category != null),
        assert(subtitle != null),
        assert(category == GalleryDemoCategory.study ||
            (slug != null && icon != null && configurations != null)),
        assert(slug != null || studyId != null);

  final String title;
  final GalleryDemoCategory category;
  final String subtitle;
  final String studyId;
  final String slug;
  final IconData icon;
  final List<GalleryDemoConfiguration> configurations;

  String get describe => '${slug ?? studyId}@${category.name}';
}

class GalleryDemoConfiguration {
  const GalleryDemoConfiguration({
    this.title,
    this.description,
    this.documentationUrl,
    this.buildRoute,
    this.code,
  });

  final String title;
  final String description;
  final String documentationUrl;
  final WidgetBuilder buildRoute;
  final CodeDisplayer code;
}

List<GalleryDemo> allGalleryDemos(GalleryLocalizations localizations) =>
    studies(localizations).values.toList() +
    materialDemos(localizations) +
    cupertinoDemos(localizations) +
    otherDemos(localizations);

List<String> allGalleryDemoDescriptions() =>
    allGalleryDemos(GalleryLocalizationsEn())
        .map((demo) => demo.describe)
        .toList();

Map<String, GalleryDemo> studies(GalleryLocalizations localizations) {
  return <String, GalleryDemo>{
    'shrine': GalleryDemo(
      title: 'Shrine',
      subtitle: localizations.shrineDescription,
      category: GalleryDemoCategory.study,
      studyId: 'shrine',
    ),
    'BiggBott': GalleryDemo(
      title: '',
      subtitle: localizations.rallyDescription,
      category: GalleryDemoCategory.study,
      studyId: 'BiggBott',
    ),
    'crane': GalleryDemo(
      title: 'Crane',
      subtitle: localizations.craneDescription,
      category: GalleryDemoCategory.study,
      studyId: 'crane',
    ),
    'fortnightly': GalleryDemo(
      title: 'Fortnightly',
      subtitle: localizations.fortnightlyDescription,
      category: GalleryDemoCategory.study,
      studyId: 'fortnightly',
    ),
    'reply': GalleryDemo(
      title: 'Reply',
      subtitle: localizations.replyDescription,
      category: GalleryDemoCategory.study,
      studyId: 'reply',
    ),
    'starterApp': GalleryDemo(
      title: localizations.starterAppTitle,
      subtitle: localizations.starterAppDescription,
      category: GalleryDemoCategory.study,
      studyId: 'starter',
    ),
  };
}

List<GalleryDemo> materialDemos(GalleryLocalizations localizations) {
  LibraryLoader materialDemosLibrary = material_demos.loadLibrary;
  return [
    GalleryDemo(
      title: localizations.demoAppBarTitle,
      icon: GalleryIcons.appbar,
      slug: 'app-bar',
      subtitle: localizations.demoAppBarSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoAppBarTitle,
          description: localizations.demoAppBarDescription,
          documentationUrl: '$_docsBaseUrl/material/AppBar-class.html',
          buildRoute: (_) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.AppBarDemo()),
          code: CodeSegments.appbarDemo,
        ),
      ],
      category: GalleryDemoCategory.material,
    ),
    GalleryDemo(
      title: localizations.demoBannerTitle,
      icon: GalleryIcons.listsLeaveBehind,
      slug: 'banner',
      subtitle: localizations.demoBannerSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoBannerTitle,
          description: localizations.demoBannerDescription,
          documentationUrl: '$_docsBaseUrl/material/MaterialBanner-class.html',
          buildRoute: (_) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.BannerDemo()),
          code: CodeSegments.bannerDemo,
        ),
      ],
      category: GalleryDemoCategory.material,
    ),
    GalleryDemo(
      title: localizations.demoBottomAppBarTitle,
      icon: GalleryIcons.bottomAppBar,
      slug: 'bottom-app-bar',
      subtitle: localizations.demoBottomAppBarSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoBottomAppBarTitle,
          description: localizations.demoBottomAppBarDescription,
          documentationUrl: '$_docsBaseUrl/material/BottomAppBar-class.html',
          buildRoute: (_) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.BottomAppBarDemo()),
          code: CodeSegments.bottomAppBarDemo,
        ),
      ],
      category: GalleryDemoCategory.material,
    ),
    GalleryDemo(
      title: localizations.demoBottomNavigationTitle,
      icon: GalleryIcons.bottomNavigation,
      slug: 'bottom-navigation',
      subtitle: localizations.demoBottomNavigationSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoBottomNavigationPersistentLabels,
          description: localizations.demoBottomNavigationDescription,
          documentationUrl:
              '$_docsBaseUrl/material/BottomNavigationBar-class.html',
          buildRoute: (_) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.BottomNavigationDemo(
                    type: BottomNavigationDemoType.withLabels,
                    restorationId: 'bottom_navigation_labels_demo',
                  )),
          code: CodeSegments.bottomNavigationDemo,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoBottomNavigationSelectedLabel,
          description: localizations.demoBottomNavigationDescription,
          documentationUrl:
              '$_docsBaseUrl/material/BottomNavigationBar-class.html',
          buildRoute: (_) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.BottomNavigationDemo(
                    type: BottomNavigationDemoType.withoutLabels,
                    restorationId: 'bottom_navigation_without_labels_demo',
                  )),
          code: CodeSegments.bottomNavigationDemo,
        ),
      ],
      category: GalleryDemoCategory.material,
    ),
    GalleryDemo(
      title: localizations.demoBottomSheetTitle,
      icon: GalleryIcons.bottomSheets,
      slug: 'bottom-sheet',
      subtitle: localizations.demoBottomSheetSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoBottomSheetPersistentTitle,
          description: localizations.demoBottomSheetPersistentDescription,
          documentationUrl: '$_docsBaseUrl/material/BottomSheet-class.html',
          buildRoute: (_) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.BottomSheetDemo(
                    type: BottomSheetDemoType.persistent,
                  )),
          code: CodeSegments.bottomSheetDemoPersistent,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoBottomSheetModalTitle,
          description: localizations.demoBottomSheetModalDescription,
          documentationUrl: '$_docsBaseUrl/material/BottomSheet-class.html',
          buildRoute: (_) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.BottomSheetDemo(
                    type: BottomSheetDemoType.modal,
                  )),
          code: CodeSegments.bottomSheetDemoModal,
        ),
      ],
      category: GalleryDemoCategory.material,
    ),
    GalleryDemo(
      title: localizations.demoButtonTitle,
      icon: GalleryIcons.genericButtons,
      slug: 'button',
      subtitle: localizations.demoButtonSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoTextButtonTitle,
          description: localizations.demoTextButtonDescription,
          documentationUrl: '$_docsBaseUrl/material/TextButton-class.html',
          buildRoute: (_) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.ButtonDemo(type: ButtonDemoType.text)),
          code: CodeSegments.buttonDemoText,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoElevatedButtonTitle,
          description: localizations.demoElevatedButtonDescription,
          documentationUrl: '$_docsBaseUrl/material/ElevatedButton-class.html',
          buildRoute: (_) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.ButtonDemo(type: ButtonDemoType.elevated)),
          code: CodeSegments.buttonDemoElevated,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoOutlinedButtonTitle,
          description: localizations.demoOutlinedButtonDescription,
          documentationUrl: '$_docsBaseUrl/material/OutlinedButton-class.html',
          buildRoute: (_) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.ButtonDemo(type: ButtonDemoType.outlined)),
          code: CodeSegments.buttonDemoOutlined,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoToggleButtonTitle,
          description: localizations.demoToggleButtonDescription,
          documentationUrl: '$_docsBaseUrl/material/ToggleButtons-class.html',
          buildRoute: (_) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.ButtonDemo(type: ButtonDemoType.toggle)),
          code: CodeSegments.buttonDemoToggle,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoFloatingButtonTitle,
          description: localizations.demoFloatingButtonDescription,
          documentationUrl:
              '$_docsBaseUrl/material/FloatingActionButton-class.html',
          buildRoute: (_) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.ButtonDemo(type: ButtonDemoType.floating)),
          code: CodeSegments.buttonDemoFloating,
        ),
      ],
      category: GalleryDemoCategory.material,
    ),
    GalleryDemo(
      title: localizations.demoCardTitle,
      icon: GalleryIcons.cards,
      slug: 'card',
      subtitle: localizations.demoCardSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoCardTitle,
          description: localizations.demoCardDescription,
          documentationUrl: '$_docsBaseUrl/material/Card-class.html',
          buildRoute: (context) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.CardsDemo()),
          code: CodeSegments.cardsDemo,
        ),
      ],
      category: GalleryDemoCategory.material,
    ),
    GalleryDemo(
      title: localizations.demoChipTitle,
      icon: GalleryIcons.chips,
      slug: 'chip',
      subtitle: localizations.demoChipSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoActionChipTitle,
          description: localizations.demoActionChipDescription,
          documentationUrl: '$_docsBaseUrl/material/ActionChip-class.html',
          buildRoute: (context) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.ChipDemo(type: ChipDemoType.action)),
          code: CodeSegments.chipDemoAction,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoChoiceChipTitle,
          description: localizations.demoChoiceChipDescription,
          documentationUrl: '$_docsBaseUrl/material/ChoiceChip-class.html',
          buildRoute: (context) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.ChipDemo(type: ChipDemoType.choice)),
          code: CodeSegments.chipDemoChoice,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoFilterChipTitle,
          description: localizations.demoFilterChipDescription,
          documentationUrl: '$_docsBaseUrl/material/FilterChip-class.html',
          buildRoute: (context) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.ChipDemo(type: ChipDemoType.filter)),
          code: CodeSegments.chipDemoFilter,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoInputChipTitle,
          description: localizations.demoInputChipDescription,
          documentationUrl: '$_docsBaseUrl/material/InputChip-class.html',
          buildRoute: (context) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.ChipDemo(type: ChipDemoType.input)),
          code: CodeSegments.chipDemoInput,
        ),
      ],
      category: GalleryDemoCategory.material,
    ),
    GalleryDemo(
      title: localizations.demoDataTableTitle,
      icon: GalleryIcons.dataTable,
      slug: 'data-table',
      subtitle: localizations.demoDataTableSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoDataTableTitle,
          description: localizations.demoDataTableDescription,
          documentationUrl: '$_docsBaseUrl/material/DataTable-class.html',
          buildRoute: (context) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.DataTableDemo()),
          code: CodeSegments.dataTableDemo,
        ),
      ],
      category: GalleryDemoCategory.material,
    ),
    GalleryDemo(
      title: localizations.demoDialogTitle,
      icon: GalleryIcons.dialogs,
      slug: 'dialog',
      subtitle: localizations.demoDialogSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoAlertDialogTitle,
          description: localizations.demoAlertDialogDescription,
          documentationUrl: '$_docsBaseUrl/material/AlertDialog-class.html',
          buildRoute: (context) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.DialogDemo(type: DialogDemoType.alert)),
          code: CodeSegments.dialogDemo,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoAlertTitleDialogTitle,
          description: localizations.demoAlertDialogDescription,
          documentationUrl: '$_docsBaseUrl/material/AlertDialog-class.html',
          buildRoute: (context) => DeferredWidget(materialDemosLibrary,
              () => material_demos.DialogDemo(type: DialogDemoType.alertTitle)),
          code: CodeSegments.dialogDemo,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoSimpleDialogTitle,
          description: localizations.demoSimpleDialogDescription,
          documentationUrl: '$_docsBaseUrl/material/SimpleDialog-class.html',
          buildRoute: (context) => DeferredWidget(materialDemosLibrary,
              () => material_demos.DialogDemo(type: DialogDemoType.simple)),
          code: CodeSegments.dialogDemo,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoFullscreenDialogTitle,
          description: localizations.demoFullscreenDialogDescription,
          documentationUrl:
              '$_docsBaseUrl/widgets/PageRoute/fullscreenDialog.html',
          buildRoute: (context) => DeferredWidget(materialDemosLibrary,
              () => material_demos.DialogDemo(type: DialogDemoType.fullscreen)),
          code: CodeSegments.dialogDemo,
        ),
      ],
      category: GalleryDemoCategory.material,
    ),
    GalleryDemo(
      title: localizations.demoDividerTitle,
      icon: GalleryIcons.divider,
      slug: 'divider',
      subtitle: localizations.demoDividerSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoDividerTitle,
          description: localizations.demoDividerDescription,
          documentationUrl: '$_docsBaseUrl/material/Divider-class.html',
          buildRoute: (_) => DeferredWidget(
              materialDemosLibrary,
              () =>
                  // ignore: prefer_const_constructors
                  material_demos.DividerDemo(type: DividerDemoType.horizontal)),
          code: CodeSegments.dividerDemo,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoVerticalDividerTitle,
          description: localizations.demoDividerDescription,
          documentationUrl: '$_docsBaseUrl/material/VerticalDivider-class.html',
          buildRoute: (_) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.DividerDemo(type: DividerDemoType.vertical)),
          code: CodeSegments.verticalDividerDemo,
        ),
      ],
      category: GalleryDemoCategory.material,
    ),
    GalleryDemo(
      title: localizations.demoGridListsTitle,
      icon: GalleryIcons.gridOn,
      slug: 'grid-lists',
      subtitle: localizations.demoGridListsSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoGridListsImageOnlyTitle,
          description: localizations.demoGridListsDescription,
          documentationUrl: '$_docsBaseUrl/widgets/GridView-class.html',
          buildRoute: (context) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.GridListDemo(
                  type: GridListDemoType.imageOnly)),
          code: CodeSegments.gridListsDemo,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoGridListsHeaderTitle,
          description: localizations.demoGridListsDescription,
          documentationUrl: '$_docsBaseUrl/widgets/GridView-class.html',
          buildRoute: (context) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.GridListDemo(type: GridListDemoType.header)),
          code: CodeSegments.gridListsDemo,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoGridListsFooterTitle,
          description: localizations.demoGridListsDescription,
          documentationUrl: '$_docsBaseUrl/widgets/GridView-class.html',
          buildRoute: (context) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.GridListDemo(type: GridListDemoType.footer)),
          code: CodeSegments.gridListsDemo,
        ),
      ],
      category: GalleryDemoCategory.material,
    ),
    GalleryDemo(
      title: localizations.demoListsTitle,
      icon: GalleryIcons.listAlt,
      slug: 'lists',
      subtitle: localizations.demoListsSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoOneLineListsTitle,
          description: localizations.demoListsDescription,
          documentationUrl: '$_docsBaseUrl/material/ListTile-class.html',
          buildRoute: (context) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.ListDemo(type: ListDemoType.oneLine)),
          code: CodeSegments.listDemo,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoTwoLineListsTitle,
          description: localizations.demoListsDescription,
          documentationUrl: '$_docsBaseUrl/material/ListTile-class.html',
          buildRoute: (context) => DeferredWidget(
              materialDemosLibrary,
              // ignore: prefer_const_constructors
              () => material_demos.ListDemo(type: ListDemoType.twoLine)),
          code: CodeSegments.listDemo,
        ),
      ],
      category: GalleryDemoCategory.material,
    ),
    GalleryDemo(
      title: localizations.demoMenuTitle,
      icon: GalleryIcons.moreVert,
      slug: 'menu',
      subtitle: localizations.demoMenuSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoContextMenuTitle,
          description: localizations.demoMenuDescription,
          documentationUrl: '$_docsBaseUrl/material/PopupMenuItem-class.html',
          buildRoute: (context) => DeferredWidget(
            materialDemosLibrary,
            // ignore: prefer_const_constructors
            () => material_demos.MenuDemo(type: MenuDemoType.contextMenu),
          ),
          code: CodeSegments.menuDemoContext,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoSectionedMenuTitle,
          description: localizations.demoMenuDescription,
          documentationUrl: '$_docsBaseUrl/material/PopupMenuItem-class.html',
          buildRoute: (context) => DeferredWidget(
            materialDemosLibrary,
            // ignore: prefer_const_constructors
            () => material_demos.MenuDemo(type: MenuDemoType.sectionedMenu),
          ),
          code: CodeSegments.menuDemoSectioned,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoChecklistMenuTitle,
          description: localizations.demoMenuDescription,
          documentationUrl:
              '$_docsBaseUrl/material/CheckedPopupMenuItem-class.html',
          buildRoute: (context) => DeferredWidget(
            materialDemosLibrary,
            // ignore: prefer_const_constructors
            () => material_demos.MenuDemo(type: MenuDemoType.checklistMenu),
          ),
          code: CodeSegments.menuDemoChecklist,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoSimpleMenuTitle,
          description: localizations.demoMenuDescription,
          documentationUrl: '$_docsBaseUrl/material/PopupMenuItem-class.html',
          buildRoute: (context) => DeferredWidget(
            materialDemosLibrary,
            // ignore: prefer_const_constructors
            () => material_demos.MenuDemo(type: MenuDemoType.simpleMenu),
          ),
          code: CodeSegments.menuDemoSimple,
        ),
      ],
      category: GalleryDemoCategory.material,
    ),
    GalleryDemo(
      title: localizations.demoNavigationDrawerTitle,
      icon: GalleryIcons.menu,
      slug: 'nav_drawer',
      subtitle: localizations.demoNavigationDrawerSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoNavigationDrawerTitle,
          description: localizations.demoNavigationDrawerDescription,
          documentationUrl: '$_docsBaseUrl/material/Drawer-class.html',
          buildRoute: (context) => DeferredWidget(
            materialDemosLibrary,
            // ignore: prefer_const_constructors
            () => material_demos.NavDrawerDemo(),
          ),
          code: CodeSegments.navDrawerDemo,
        ),
      ],
      category: GalleryDemoCategory.material,
    ),
    GalleryDemo(
      title: localizations.demoNavigationRailTitle,
      icon: GalleryIcons.navigationRail,
      slug: 'nav_rail',
      subtitle: localizations.demoNavigationRailSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoNavigationRailTitle,
          description: localizations.demoNavigationRailDescription,
          documentationUrl: '$_docsBaseUrl/material/NavigationRail-class.html',
          buildRoute: (context) => DeferredWidget(
            materialDemosLibrary,
            // ignore: prefer_const_constructors
            () => material_demos.NavRailDemo(),
          ),
          code: CodeSegments.navRailDemo,
        ),
      ],
      category: GalleryDemoCategory.material,
    ),
    GalleryDemo(
      title: localizations.demoPickersTitle,
      icon: GalleryIcons.event,
      slug: 'pickers',
      subtitle: localizations.demoPickersSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoDatePickerTitle,
          description: localizations.demoDatePickerDescription,
          documentationUrl: '$_docsBaseUrl/material/showDatePicker.html',
          buildRoute: (context) => DeferredWidget(
            materialDemosLibrary,
            // ignore: prefer_const_constructors
            () => material_demos.PickerDemo(type: PickerDemoType.date),
          ),
          code: CodeSegments.pickerDemo,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoTimePickerTitle,
          description: localizations.demoTimePickerDescription,
          documentationUrl: '$_docsBaseUrl/material/showTimePicker.html',
          buildRoute: (context) => DeferredWidget(
            materialDemosLibrary,
            // ignore: prefer_const_constructors
            () => material_demos.PickerDemo(type: PickerDemoType.time),
          ),
          code: CodeSegments.pickerDemo,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoDateRangePickerTitle,
          description: localizations.demoDateRangePickerDescription,
          documentationUrl: '$_docsBaseUrl/material/showDateRangePicker.html',
          buildRoute: (context) => DeferredWidget(
            materialDemosLibrary,
            // ignore: prefer_const_constructors
            () => material_demos.PickerDemo(type: PickerDemoType.range),
          ),
          code: CodeSegments.pickerDemo,
        ),
      ],
      category: GalleryDemoCategory.material,
    ),
    GalleryDemo(
      title: localizations.demoProgressIndicatorTitle,
      icon: GalleryIcons.progressActivity,
      slug: 'progress-indicator',
      subtitle: localizations.demoProgressIndicatorSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoCircularProgressIndicatorTitle,
          description: localizations.demoCircularProgressIndicatorDescription,
          documentationUrl:
              '$_docsBaseUrl/material/CircularProgressIndicator-class.html',
          buildRoute: (context) => DeferredWidget(
            materialDemosLibrary,
            // ignore: prefer_const_constructors
            () => material_demos.ProgressIndicatorDemo(
              type: ProgressIndicatorDemoType.circular,
            ),
          ),
          code: CodeSegments.progressIndicatorsDemo,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoLinearProgressIndicatorTitle,
          description: localizations.demoLinearProgressIndicatorDescription,
          documentationUrl:
              '$_docsBaseUrl/material/LinearProgressIndicator-class.html',
          buildRoute: (context) => DeferredWidget(
            materialDemosLibrary,
            // ignore: prefer_const_constructors
            () => material_demos.ProgressIndicatorDemo(
              type: ProgressIndicatorDemoType.linear,
            ),
          ),
          code: CodeSegments.progressIndicatorsDemo,
        ),
      ],
      category: GalleryDemoCategory.material,
    ),
    GalleryDemo(
      title: localizations.demoSelectionControlsTitle,
      icon: GalleryIcons.checkBox,
      slug: 'selection-controls',
      subtitle: localizations.demoSelectionControlsSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoSelectionControlsCheckboxTitle,
          description: localizations.demoSelectionControlsCheckboxDescription,
          documentationUrl: '$_docsBaseUrl/material/Checkbox-class.html',
          buildRoute: (context) => DeferredWidget(
            materialDemosLibrary,
            // ignore: prefer_const_constructors
            () => material_demos.SelectionControlsDemo(
              type: SelectionControlsDemoType.checkbox,
            ),
          ),
          code: CodeSegments.selectionControlsDemoCheckbox,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoSelectionControlsRadioTitle,
          description: localizations.demoSelectionControlsRadioDescription,
          documentationUrl: '$_docsBaseUrl/material/Radio-class.html',
          buildRoute: (context) => DeferredWidget(
            materialDemosLibrary,
            // ignore: prefer_const_constructors
            () => material_demos.SelectionControlsDemo(
              type: SelectionControlsDemoType.radio,
            ),
          ),
          code: CodeSegments.selectionControlsDemoRadio,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoSelectionControlsSwitchTitle,
          description: localizations.demoSelectionControlsSwitchDescription,
          documentationUrl: '$_docsBaseUrl/material/Switch-class.html',
          buildRoute: (context) => DeferredWidget(
            materialDemosLibrary,
            // ignore: prefer_const_constructors
            () => material_demos.SelectionControlsDemo(
              type: SelectionControlsDemoType.switches,
            ),
          ),
          code: CodeSegments.selectionControlsDemoSwitches,
        ),
      ],
      category: GalleryDemoCategory.material,
    ),
    GalleryDemo(
      title: localizations.demoSlidersTitle,
      icon: GalleryIcons.sliders,
      slug: 'sliders',
      subtitle: localizations.demoSlidersSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoSlidersTitle,
          description: localizations.demoSlidersDescription,
          documentationUrl: '$_docsBaseUrl/material/Slider-class.html',
          buildRoute: (context) => DeferredWidget(
            materialDemosLibrary,
            // ignore: prefer_const_constructors
            () => material_demos.SlidersDemo(type: SlidersDemoType.sliders),
          ),
          code: CodeSegments.slidersDemo,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoRangeSlidersTitle,
          description: localizations.demoRangeSlidersDescription,
          documentationUrl: '$_docsBaseUrl/material/RangeSlider-class.html',
          buildRoute: (context) => DeferredWidget(
            materialDemosLibrary,
            () =>
                // ignore: prefer_const_constructors
                material_demos.SlidersDemo(type: SlidersDemoType.rangeSliders),
          ),
          code: CodeSegments.rangeSlidersDemo,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoCustomSlidersTitle,
          description: localizations.demoCustomSlidersDescription,
          documentationUrl: '$_docsBaseUrl/material/SliderTheme-class.html',
          buildRoute: (context) => DeferredWidget(
            materialDemosLibrary,
            () =>
                // ignore: prefer_const_constructors
                material_demos.SlidersDemo(type: SlidersDemoType.customSliders),
          ),
          code: CodeSegments.customSlidersDemo,
        ),
      ],
      category: GalleryDemoCategory.material,
    ),
    GalleryDemo(
      title: localizations.demoSnackbarsTitle,
      icon: GalleryIcons.snackbar,
      slug: 'snackbars',
      subtitle: localizations.demoSnackbarsSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoSnackbarsTitle,
          description: localizations.demoSnackbarsDescription,
          documentationUrl: '$_docsBaseUrl/material/SnackBar-class.html',
          buildRoute: (context) => DeferredWidget(
            materialDemosLibrary,
            // ignore: prefer_const_constructors
            () => material_demos.SnackbarsDemo(),
          ),
          code: CodeSegments.snackbarsDemo,
        ),
      ],
      category: GalleryDemoCategory.material,
    ),
    GalleryDemo(
      title: localizations.demoTabsTitle,
      icon: GalleryIcons.tabs,
      slug: 'tabs',
      subtitle: localizations.demoTabsSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoTabsScrollingTitle,
          description: localizations.demoTabsDescription,
          documentationUrl: '$_docsBaseUrl/material/TabBar-class.html',
          buildRoute: (context) => DeferredWidget(
            materialDemosLibrary,
            // ignore: prefer_const_constructors
            () => material_demos.TabsDemo(type: TabsDemoType.scrollable),
          ),
          code: CodeSegments.tabsScrollableDemo,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoTabsNonScrollingTitle,
          description: localizations.demoTabsDescription,
          documentationUrl: '$_docsBaseUrl/material/TabBar-class.html',
          buildRoute: (context) => DeferredWidget(
            materialDemosLibrary,
            // ignore: prefer_const_constructors
            () => material_demos.TabsDemo(type: TabsDemoType.nonScrollable),
          ),
          code: CodeSegments.tabsNonScrollableDemo,
        ),
      ],
      category: GalleryDemoCategory.material,
    ),
    GalleryDemo(
      title: localizations.demoTextFieldTitle,
      icon: GalleryIcons.textFieldsAlt,
      slug: 'text-field',
      subtitle: localizations.demoTextFieldSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoTextFieldTitle,
          description: localizations.demoTextFieldDescription,
          documentationUrl: '$_docsBaseUrl/material/TextField-class.html',
          buildRoute: (context) => DeferredWidget(
            materialDemosLibrary,
            // ignore: prefer_const_constructors
            () => material_demos.TextFieldDemo(),
          ),
          code: CodeSegments.textFieldDemo,
        ),
      ],
      category: GalleryDemoCategory.material,
    ),
    GalleryDemo(
      title: localizations.demoTooltipTitle,
      icon: GalleryIcons.tooltip,
      slug: 'tooltip',
      subtitle: localizations.demoTooltipSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoTooltipTitle,
          description: localizations.demoTooltipDescription,
          documentationUrl: '$_docsBaseUrl/material/Tooltip-class.html',
          buildRoute: (context) => DeferredWidget(
            materialDemosLibrary,
            // ignore: prefer_const_constructors
            () => material_demos.TooltipDemo(),
          ),
          code: CodeSegments.tooltipDemo,
        ),
      ],
      category: GalleryDemoCategory.material,
    ),
  ];
}

List<GalleryDemo> cupertinoDemos(GalleryLocalizations localizations) {
  LibraryLoader cupertinoLoader = cupertino_demos.loadLibrary;
  return [
    GalleryDemo(
      // title: localizations.interestedFAQ,
      title: 'How to take a trial?',
      icon: GalleryIcons.cupertinoProgress,
      slug: 'cupertino-activity-indicator',
      subtitle: 'We provide one-week...',
      //localizations.demoCupertinoActivityIndicatorSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: 'How to take a trial?',
          description: '',
          //localizations.demoCupertinoActivityIndicatorDescription,
          //documentationUrl: '',
          /*'$_docsBaseUrl/cupertino/CupertinoActivityIndicator-class.html',*/
          buildRoute: (_) => const Text(
              'We provide one-week free trial. Just go to https://flinkcapital.web.app/ '
              'and start your free trial with your existing account of Aliceblue, Fyers, Angel Broking'
              'and Trustline.If you do not have an account, you can open account using the same link '
              'and get started.Users who open account under our referral get additional three '
              'months subscriptions at free of cost if they subscribe to one year plan.'
              'So, all users who open account under us will get 1 year + 3 months of validity'),
          // DeferredWidget(
          //   cupertinoLoader,
          // ignore: prefer_const_constructors
          //() => Text(""),
          // () =>cupertino_demos.CupertinoProgressIndicatorDemo()),
          code: CodeSegments.cupertinoActivityIndicatorDemo,
        ),
      ],
      category: GalleryDemoCategory.cupertino,
    ),
    GalleryDemo(
      title: 'What is the cost?',
      //localizations.demoCupertinoAlertsTitle,
      icon: GalleryIcons.dialogs,
      slug: 'cupertino-alerts',
      subtitle: 'We charge...',
      //localizations.demoCupertinoAlertsSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: 'Subscription Plans',
          description: '',
          //localizations.demoCupertinoAlertDescription,
          documentationUrl:
              '$_docsBaseUrl/cupertino/CupertinoAlertDialog-class.html',
          buildRoute: (_) => const Text(
              'Flink Capital charges Quarterly (INR 21000), Half Yearly (INR 34000) and Yearly (INR 55000) on the entire gamut of strategies.'
              'If you want to access any individual bot it costs Rs.9,700 per year.'),
          /* DeferredWidget(
              cupertinoLoader,
              // ignore: prefer_const_constructors
              () => cupertino_demos.CupertinoAlertDemo(
                  type: AlertDemoType.alert)), */
          code: CodeSegments.cupertinoAlertDemo,
        ),
        GalleryDemoConfiguration(
          title: 'Do you provide monthly subscription plans?',
          //localizations.demoCupertinoAlertWithTitleTitle,
          description: '',
          //localizations.demoCupertinoAlertDescription,
          documentationUrl:
              '$_docsBaseUrl/cupertino/CupertinoAlertDialog-class.html',
          buildRoute: (_) => Text(
              'No, all our trading bots’ subscriptions are available only on quarterly,half-yearly or yearly basis.'),
          /* DeferredWidget(
              cupertinoLoader,
              // ignore: prefer_const_constructors
              () => cupertino_demos.CupertinoAlertDemo(
                  type: AlertDemoType.alertTitle)), */
          code: CodeSegments.cupertinoAlertDemo,
        ),
        GalleryDemoConfiguration(
          title: 'Do you provide any discounts?',

          //localizations.demoCupertinoAlertButtonsTitle,
          description: '',
          //localizations.demoCupertinoAlertDescription,
          documentationUrl:
              '$_docsBaseUrl/cupertino/CupertinoAlertDialog-class.html',
          buildRoute: (_) => const Text(
              'We provide you access to all bots at discounted price, each bot is priced at Rs.9,700 for 12 months, we have 9 different bots, so if you wanted to subscribe to all bots, you end up paying more than Rs.87300 to get access to 9 bots just for 1 year whereas with just Rs.55,000 per year, you can get access to all our trading bots for one full year.'), // https://rzp.io/l/alicebluebots'),
          code: CodeSegments.cupertinoAlertDemo,
        ),
        GalleryDemoConfiguration(
          title: 'Where should I make the payment',
          //localizations.demoCupertinoAlertButtonsOnlyTitle,
          description: '',
          //localizations.demoCupertinoAlertDescription,
          documentationUrl:
              '$_docsBaseUrl/cupertino/CupertinoAlertDialog-class.html',
          buildRoute: (_) => const Text(
              'You can pay in the given link.https://rzp.io/l/alicebluebots'),
          //code: CodeSegments.cupertinoAlertDemo,
        ),
        /*  GalleryDemoConfiguration(
          title: localizations.demoCupertinoActionSheetTitle,
          description: localizations.demoCupertinoActionSheetDescription,
          documentationUrl:
              '$_docsBaseUrl/cupertino/CupertinoActionSheet-class.html',
          buildRoute: (_) => DeferredWidget(
              cupertinoLoader,
              // ignore: prefer_const_constructors
              () => cupertino_demos.CupertinoAlertDemo(
                  type: AlertDemoType.actionSheet)),
          code: CodeSegments.cupertinoAlertDemo,
        ), */
      ],
      category: GalleryDemoCategory.cupertino,
    ),
    GalleryDemo(
      title: 'Is it fully automated?',
      //localizations.demoCupertinoButtonsTitle,
      icon: GalleryIcons.genericButtons,
      slug: 'cupertino-buttons',
      subtitle: 'Yes...',
      configurations: [
        GalleryDemoConfiguration(
          title: 'Is it fully automated?',
          description: '',
          documentationUrl:
              '$_docsBaseUrl/cupertino/CupertinoButton-class.html',
          buildRoute: (_) => const Text(
              'Yes, our platform places entry orders and stop loss orders/target orders automatically as per the strategy. No manual intervention required. Only by day end around 3 pm, if there are any open positions, users must square off these positions by clicking Flink Capital all button available in our platform. That would close all your open intraday position with a single click. If you don’t do it, broker will automatically close all your open position.'),
          code: CodeSegments.cupertinoButtonDemo,
        ),
        GalleryDemoConfiguration(
          title:
              'Why it’s not fully automated with Zerodha or Upstox or with other brokers?',
          description: '',
          documentationUrl:
              '$_docsBaseUrl/cupertino/CupertinoButton-class.html',
          buildRoute: (_) => const Text(
              'Brokers like Upstox/Zerodha charges almost Rs.4000 per month to use their API, it’s an additional cost the user has to pay, if they wanted to use fully automated platform, where brokers like Aliceblue and Trustline provide api free of cost, so traders don’t need to spend extra cost for fully automated platform.'),
          code: CodeSegments.cupertinoButtonDemo,
        ),
        GalleryDemoConfiguration(
          title: 'Do I need to click any button during the market hours?',
          description: '',
          documentationUrl:
              '$_docsBaseUrl/cupertino/CupertinoButton-class.html',
          buildRoute: (_) => const Text(
              'No manual intervention required. You just need to login once every day and update your capital, that’s all. Bot will automatically place all trades.'),
          code: CodeSegments.cupertinoButtonDemo,
        ),
        GalleryDemoConfiguration(
          title: 'Does your platform support customized strategy?',
          description: '',
          documentationUrl:
              '$_docsBaseUrl/cupertino/CupertinoButton-class.html',
          buildRoute: (_) => const Text(
              'No, our platform comes with inbuilt strategy. Doesn’t support any customized strategy.'),
          code: CodeSegments.cupertinoButtonDemo,
        ),
      ],
      category: GalleryDemoCategory.cupertino,
    ),
    GalleryDemo(
      title:
          'Do you provide any offer if user open account under your referral?',
      icon: GalleryIcons.moreVert,
      slug: 'cupertino-context-menu',
      subtitle: 'Yes...',
      configurations: [
        GalleryDemoConfiguration(
          title:
              'Do you provide any offer if user open account under your referral?',
          description: '',
          documentationUrl:
              '$_docsBaseUrl/cupertino/CupertinoContextMenu-class.html',
          buildRoute: (_) => const Text(
              'Yes, Users who open account under our referral get additional three months subscriptions at free of cost, if they subscribe to one year plan. So, all users who open account under us will get 1 year + 3 months of validity.'),
          code: CodeSegments.cupertinoContextMenuDemo,
        ),
      ],
      category: GalleryDemoCategory.cupertino,
    ),
    GalleryDemo(
      title: 'Will this product suit a working professional?',
      icon: GalleryIcons.bottomSheetPersistent,
      slug: 'cupertino-navigation-bar',
      subtitle: 'Yes...',
      configurations: [
        GalleryDemoConfiguration(
          title: 'Am a working professional, will this product suit me?',
          description: '',
          documentationUrl:
              '$_docsBaseUrl/cupertino/CupertinoNavigationBar-class.html',
          buildRoute: (_) => Text(
              'Yes, our platform doesn’t require you to sit in front of the system all the time, you just need to login to our platform once in the morning before market opens and update your capital, that’s all. You can carry on with your work, our fully automated bot will take care of all order placement by itself.'),
          code: CodeSegments.cupertinoNavigationBarDemo,
        ),
        GalleryDemoConfiguration(
          title:
              'Do I need to keep the laptop/mobile web page open and running after logging in the morning?',
          description: '',
          documentationUrl:
              '$_docsBaseUrl/cupertino/CupertinoNavigationBar-class.html',
          buildRoute: (_) => Text(
              'No, not required. Once you login to the platform and update your capital, its done. System records it. You don’t need to maintain any server or download any software or keep laptop open.'),
          code: CodeSegments.cupertinoNavigationBarDemo,
        ),
      ],
      category: GalleryDemoCategory.cupertino,
    ),
    GalleryDemo(
      title: 'Can I monitor the trades real time?',
      icon: GalleryIcons.event,
      slug: 'cupertino-picker',
      subtitle: 'Yes...',
      configurations: [
        GalleryDemoConfiguration(
          title: 'Can I monitor the trades real time?',
          description: '',
          documentationUrl:
              '$_docsBaseUrl/cupertino/CupertinoNavigationBar-class.html',
          buildRoute: (_) => Text(
              'Yes, you can login to your trading account and check the trades in real time.'),
          code: CodeSegments.cupertinoNavigationBarDemo,
        ),
        GalleryDemoConfiguration(
          title: 'Can I monitor the trades triggered by bot on real time?',
          description: '',
          documentationUrl:
              '$_docsBaseUrl/cupertino/CupertinoNavigationBar-class.html',
          buildRoute: (_) => Text(
              'Yes, in our algo dashboard we have orders tab, clicking that tab would show you list of orders triggered from each bot'),
          code: CodeSegments.cupertinoNavigationBarDemo,
        ),
      ],
      category: GalleryDemoCategory.cupertino,
    ),
    GalleryDemo(
      title: 'What is the minimum capital required to trade?',
      icon: GalleryIcons.cupertinoPullToRefresh,
      slug: 'cupertino-pull-to-refresh',
      subtitle: '',
      configurations: [
        GalleryDemoConfiguration(
          title:
              'What is the minimum capital required to trade the trading bots?',
          description: '',
          documentationUrl:
              '$_docsBaseUrl/cupertino/CupertinoSliverRefreshControl-class.html',
          buildRoute: (_) =>
              Text('Even with Rs.250,000 one can trade using our bots.'),
          code: CodeSegments.cupertinoRefreshDemo,
        ),
      ],
      category: GalleryDemoCategory.cupertino,
    ),
    GalleryDemo(
      title: 'Does it generate profits every month?',
      icon: GalleryIcons.tabs,
      slug: 'cupertino-segmented-control',
      subtitle: '',
      configurations: [
        GalleryDemoConfiguration(
          title: 'Does it generate profits every month?',
          description: '',
          documentationUrl:
              '$_docsBaseUrl/cupertino/CupertinoSegmentedControl-class.html',
          buildRoute: (_) => const Text(
              'No, please note that algo trading makes the execution easier, it doesn’t guarantee profits. Just like any trading system, these trading bots also goes through streaks of losses. So, we should focus only on quarterly/half yearly period about the performance'),
          code: CodeSegments.cupertinoSegmentedControlDemo,
        ),
      ],
      category: GalleryDemoCategory.cupertino,
    ),
    GalleryDemo(
      title: 'Can I use the same account for my own manual Trading?',
      icon: GalleryIcons.cupertinoPullToRefresh,
      slug: 'cupertino-pull-to-refresh',
      subtitle: 'Yes, you can use it.',
      configurations: [
        GalleryDemoConfiguration(
          title: 'How can I reach Flink Capital for support?',
          description: '',
          documentationUrl:
              '$_docsBaseUrl/cupertino/CupertinoSliverRefreshControl-class.html',
          buildRoute: (_) => const Text(
              'We can be reached at catalyst@flinkcapital.com or ping us in telegram at http://t.me/flinkcapital we do not have any help desk voice support, all queries are addressed only through our email/chat support system'),
          code: CodeSegments.cupertinoRefreshDemo,
        ),
      ],
      category: GalleryDemoCategory.cupertino,
    ),
    GalleryDemo(
      title: 'How can I reach Flink Capital?',
      icon: GalleryIcons.cupertinoPullToRefresh,
      slug: 'cupertino-pull-to-refresh',
      subtitle: 'We can be reached at...',
      configurations: [
        GalleryDemoConfiguration(
          title: 'How can I reach Flink Capital for support?',
          description: '',
          documentationUrl:
              '$_docsBaseUrl/cupertino/CupertinoSliverRefreshControl-class.html',
          buildRoute: (_) => const Text(
              'We can be reached at catalyst@flinkcapital.com or ping us in telegram at http://t.me/flinkcapital we do not have any help desk voice support, all queries are addressed only through our email/chat support system'),
          code: CodeSegments.cupertinoRefreshDemo,
        ),
      ],
      category: GalleryDemoCategory.cupertino,
    ),
  ];
}

List<GalleryDemo> otherDemos(GalleryLocalizations localizations) {
  return [
    GalleryDemo(
      title: localizations.demoMotionTitle,
      icon: GalleryIcons.animation,
      slug: 'motion',
      subtitle: localizations.demoMotionSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoContainerTransformTitle,
          description: localizations.demoContainerTransformDescription,
          documentationUrl: '$_docsAnimationsUrl/OpenContainer-class.html',
          buildRoute: (_) => DeferredWidget(
              motion_demo_container.loadLibrary,
              // ignore: prefer_const_constructors
              () => motion_demo_container.OpenContainerTransformDemo()),
          code: CodeSegments.openContainerTransformDemo,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoSharedXAxisTitle,
          description: localizations.demoSharedAxisDescription,
          documentationUrl:
              '$_docsAnimationsUrl/SharedAxisTransition-class.html',
          buildRoute: (_) => const SharedXAxisTransitionDemo(),
          code: CodeSegments.sharedXAxisTransitionDemo,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoSharedYAxisTitle,
          description: localizations.demoSharedAxisDescription,
          documentationUrl:
              '$_docsAnimationsUrl/SharedAxisTransition-class.html',
          buildRoute: (_) => const SharedYAxisTransitionDemo(),
          code: CodeSegments.sharedYAxisTransitionDemo,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoSharedZAxisTitle,
          description: localizations.demoSharedAxisDescription,
          documentationUrl:
              '$_docsAnimationsUrl/SharedAxisTransition-class.html',
          buildRoute: (_) => const SharedZAxisTransitionDemo(),
          code: CodeSegments.sharedZAxisTransitionDemo,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoFadeThroughTitle,
          description: localizations.demoFadeThroughDescription,
          documentationUrl:
              '$_docsAnimationsUrl/FadeThroughTransition-class.html',
          buildRoute: (_) => const FadeThroughTransitionDemo(),
          code: CodeSegments.fadeThroughTransitionDemo,
        ),
        GalleryDemoConfiguration(
          title: localizations.demoFadeScaleTitle,
          description: localizations.demoFadeScaleDescription,
          documentationUrl:
              '$_docsAnimationsUrl/FadeScaleTransition-class.html',
          buildRoute: (_) => const FadeScaleTransitionDemo(),
          code: CodeSegments.fadeScaleTransitionDemo,
        ),
      ],
      category: GalleryDemoCategory.other,
    ),
    GalleryDemo(
      title: localizations.demoColorsTitle,
      icon: GalleryIcons.colors,
      slug: 'colors',
      subtitle: localizations.demoColorsSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoColorsTitle,
          description: localizations.demoColorsDescription,
          documentationUrl: '$_docsBaseUrl/material/MaterialColor-class.html',
          buildRoute: (_) => DeferredWidget(
              colors_demo.loadLibrary,
              // ignore: prefer_const_constructors
              () => colors_demo.ColorsDemo()),
          code: CodeSegments.colorsDemo,
        ),
      ],
      category: GalleryDemoCategory.other,
    ),
    GalleryDemo(
      title: localizations.demoTypographyTitle,
      icon: GalleryIcons.customTypography,
      slug: 'typography',
      subtitle: localizations.demoTypographySubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demoTypographyTitle,
          description: localizations.demoTypographyDescription,
          documentationUrl: '$_docsBaseUrl/material/TextTheme-class.html',
          buildRoute: (_) => DeferredWidget(
              typography.loadLibrary,
              // ignore: prefer_const_constructors
              () => typography.TypographyDemo()),
          code: CodeSegments.typographyDemo,
        ),
      ],
      category: GalleryDemoCategory.other,
    ),
    GalleryDemo(
      title: localizations.demo2dTransformationsTitle,
      icon: GalleryIcons.gridOn,
      slug: '2d-transformations',
      subtitle: localizations.demo2dTransformationsSubtitle,
      configurations: [
        GalleryDemoConfiguration(
          title: localizations.demo2dTransformationsTitle,
          description: localizations.demo2dTransformationsDescription,
          documentationUrl: '$_docsBaseUrl/widgets/GestureDetector-class.html',
          buildRoute: (_) => DeferredWidget(
              transformations_demo.loadLibrary,
              // ignore: prefer_const_constructors
              () => transformations_demo.TransformationsDemo()),
          code: CodeSegments.transformationsDemo,
        ),
      ],
      category: GalleryDemoCategory.other,
    ),
  ];
}

Map<String, GalleryDemo> slugToDemo(BuildContext context) {
  final localizations = GalleryLocalizations.of(context);
  return LinkedHashMap<String, GalleryDemo>.fromIterable(
    allGalleryDemos(localizations),
    key: (dynamic demo) => demo.slug as String,
  );
}

/// Awaits all deferred libraries for tests.
Future<void> pumpDeferredLibraries() {
  final futures = <Future<void>>[
    DeferredWidget.preload(cupertino_demos.loadLibrary),
    DeferredWidget.preload(material_demos.loadLibrary),
    DeferredWidget.preload(motion_demo_container.loadLibrary),
    DeferredWidget.preload(colors_demo.loadLibrary),
    DeferredWidget.preload(transformations_demo.loadLibrary),
    DeferredWidget.preload(typography.loadLibrary),
  ];
  return Future.wait(futures);
}
