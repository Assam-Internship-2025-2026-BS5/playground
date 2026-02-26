import 'component_metadata.dart';
import 'package:flutter/material.dart' hide Text, TextField, Icon, Image, Checkbox, Button;
import 'package:designkit/components/atoms/glass_card.dart';
import 'package:designkit/components/atoms/text.dart' as atom;
import 'package:designkit/components/atoms/checkbox.dart' as atom;
import 'package:designkit/components/atoms/text_field.dart' as atom;
import 'package:designkit/components/atoms/image.dart' as atom;
import 'package:designkit/components/atoms/button.dart' as atom;
import 'package:designkit/components/atoms/icon.dart' as atom;
import 'package:designkit/components/atoms/text_button.dart' as atom;
import 'package:designkit/components/molecules/fingerprint_login.dart';
import 'package:designkit/components/molecules/qr_scan.dart';
import 'package:designkit/components/molecules/action_items.dart';
import 'package:designkit/components/molecules/login.dart';
import 'package:designkit/components/organisms/header.dart';
import 'package:designkit/components/organisms/bottom_nav.dart';

import 'package:designkit/components/pages/home_page.dart';

final List<ComponentMetadata> componentRegistry = [
  ComponentMetadata(
    name: 'QRScan',
    category: 'Molecules',
    defaultProps: {
      'title': 'QR Scan',
      'subtitle': '',
      'imagePath': 'assets/Qr_scan.png',
      'width': 484.0,
      'height': 180.0,
      'opacity': 0.2,
    },
    builder: (Map<String, dynamic> props) {
      return QRScan(
        title: props['title'] ?? 'QR Scan',
        subtitle: props['subtitle'] ?? '',
        imagePath: props['imagePath'] ?? 'assets/Qr_scan.png',
        width: (props['width'] as num?)?.toDouble() ?? 484.0,
        height: (props['height'] as num?)?.toDouble() ?? 180.0,
        blur: (props['blur'] as num?)?.toDouble() ?? 15.0,
        opacity: (props['opacity'] as num?)?.toDouble() ?? 0.2,
      );
    },
  ),
  ComponentMetadata(
    name: 'FingerprintLogin',
    category: 'Molecules',
    defaultProps: {
      'title': 'Login with Fingerprint',
      'width': 380.0,
      'height': 56.0,
    },
    builder: (Map<String, dynamic> props) {
      return FingerprintLogin(
        title: props['title'] ?? 'Login with Fingerprint',
        width: (props['width'] as num?)?.toDouble() ?? 380.0,
        height: (props['height'] as num?)?.toDouble() ?? 56.0,
        onTap: () => debugPrint('Fingerprint Login Button Tapped'),
      );
    },
  ),
  ComponentMetadata(
    name: 'Login',
    category: 'Molecules',
    defaultProps: {},
    builder: (Map<String, dynamic> props) {
      return Login(
        onMPINLogin: () => debugPrint('mPIN Login Tapped'),
        onForgotMPIN: () => debugPrint('Forgot mPIN Tapped'),
      );
    },
  ),
  ComponentMetadata(
    name: 'ActionItems',
    category: 'Molecules',
    defaultProps: {},
    builder: (Map<String, dynamic> props) {
      return ActionItems(
        onItemTap: (item) => debugPrint('Tapped: ${item.title}'),
      );
    },
  ),
  ComponentMetadata(
    name: 'Header',
    category: 'Organisms',
    defaultProps: {
      'userName': 'MHONBENI NGULLIE',
      'customerId': '******1010',
    },
    builder: (Map<String, dynamic> props) {
      return Header(
        userName: props['userName'] ?? 'MHONBENI NGULLIE',
        customerId: props['customerId'] ?? '******1010',
      );
    },
  ),

  ComponentMetadata(
    name: 'BottomNav',
    category: 'Organisms',
    defaultProps: {},
    builder: (Map<String, dynamic> props) {
      return BottomNav(
        onNavTap: (label) => debugPrint('Nav Tapped: $label'),
      );
    },
  ),
  ComponentMetadata(
    name: 'Text',
    category: 'Atoms',
    defaultProps: {
      'text': 'Hello World',
      'fontSize': 20.0,
      'color': Colors.white,
      'fontWeight': FontWeight.normal,
    },
    builder: (Map<String, dynamic> props) {
      return atom.Text(
        text: props['text'] ?? 'Hello World',
        fontSize: (props['fontSize'] as num?)?.toDouble() ?? 20.0,
        color: props['color'] ?? Colors.white,
        fontWeight: props['fontWeight'] ?? FontWeight.normal,
      );
    },
  ),
  ComponentMetadata(
    name: 'Checkbox',
    category: 'Atoms',
    defaultProps: {
      'value': false,
      'label': 'Tick me',
    },
    builder: (Map<String, dynamic> props) {
      return atom.Checkbox(
        value: props['value'] ?? false,
        label: props['label'],
        onChanged: (val) => debugPrint('Checkbox: $val'),
      );
    },
  ),
  ComponentMetadata(
    name: 'TextField',
    category: 'Atoms',
    defaultProps: {
      'hintText': 'Enter text',
      'maxLength': 20,
      'width': 320.0,
    },
    builder: (Map<String, dynamic> props) {
      return atom.TextField(
        hintText: props['hintText'] ?? 'Enter text',
        maxLength: (props['maxLength'] as num?)?.toInt() ?? 20,
        width: (props['width'] as num?)?.toDouble(),
      );
    },
  ),
  ComponentMetadata(
    name: 'Image',
    category: 'Atoms',
    defaultProps: {
      'width': 240.0,
      'height': 31.0,
      'offsetX': 0.0,
      'offsetY': 0.0,
      'showShadow': false,
    },
    builder: (Map<String, dynamic> props) {
      return atom.Image(
        width: (props['width'] as num?)?.toDouble() ?? 240.0,
        height: (props['height'] as num?)?.toDouble() ?? 31.0,
        offsetX: (props['offsetX'] as num?)?.toDouble() ?? 0.0,
        offsetY: (props['offsetY'] as num?)?.toDouble() ?? 0.0,
        showShadow: props['showShadow'] ?? false,
      );
    },
  ),
  ComponentMetadata(
    name: 'Button',
    category: 'Atoms',
    defaultProps: {
      'text': 'Know More',
      'width': 321.0,
      'height': 61.0,
      'disabled': false,
      'color': const Color(0xFF5371F9),
      'showOutline': true,
      'opacity': 0.3,
    },
    builder: (Map<String, dynamic> props) {
      return atom.Button(
        text: props['text'] ?? 'Know More',
        width: (props['width'] as num?)?.toDouble() ?? 321.0,
        height: (props['height'] as num?)?.toDouble() ?? 61.0,
        disabled: props['disabled'] ?? false,
        color: props['color'] ?? const Color(0xFF5371F9),
        showOutline: props['showOutline'] ?? true,
        blur: (props['blur'] as num?)?.toDouble() ?? 10.0,
        opacity: (props['opacity'] as num?)?.toDouble() ?? 0.3,
        onTap: () => debugPrint('Button Pressed'),
      );
    },
  ),
  ComponentMetadata(
    name: 'Icon',
    category: 'Atoms',
    defaultProps: {
      'icon': null,
      'imagePath': 'assets/Icon.png',
      'size': 60.0,
      'color': const Color(0xFF2938AD),
    },
    builder: (Map<String, dynamic> props) {
      return atom.Icon(
        props['icon'],
        imagePath: props['imagePath'] ?? 'assets/Icon.png',
        size: (props['size'] as num?)?.toDouble() ?? 24.0,
        color: props['color'] ?? const Color(0xFF2938AD),
      );
    },
  ),
  ComponentMetadata(
    name: 'TextButton',
    category: 'Atoms',
    defaultProps: {
      'text': 'Click Me',
      'fontSize': 18.0,
      'color': const Color(0xFF2938AD),
      'underline': true,
      'fontWeight': FontWeight.bold,
    },
    builder: (Map<String, dynamic> props) {
      return atom.TextButton(
        text: props['text'] ?? 'Click Me',
        fontSize: (props['fontSize'] as num?)?.toDouble() ?? 18.0,
        color: props['color'] ?? const Color(0xFF2938AD),
        fontWeight: props['fontWeight'] ?? FontWeight.bold,
        underline: props['underline'] ?? true,
        onPressed: () => debugPrint('TextButton Pressed'),
      );
    },
  ),
  ComponentMetadata(
    name: 'HomePage',
    category: 'Pages',
    defaultProps: {},
    builder: (Map<String, dynamic> props) {
      return const HomePage();
    },
  ),
];
