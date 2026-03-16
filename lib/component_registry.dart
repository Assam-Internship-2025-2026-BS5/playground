import 'component_metadata.dart';
import 'package:flutter/material.dart' hide Text, TextField, Icon, Image, Checkbox, Button;
import 'package:designkit/designkit.dart';
import 'package:designkit/designkit.dart' as atom;


String _formatColor(dynamic color) {
  if (color is Color) {
    return "Color(0x${color.value.toRadixString(16).toUpperCase()})";
  }
  return "Colors.transparent";
}

String _formatFontWeight(dynamic weight) {
  if (weight is FontWeight) {
    if (weight == FontWeight.bold) return "FontWeight.bold";
    if (weight == FontWeight.normal) return "FontWeight.normal";
    if (weight == FontWeight.w100) return "FontWeight.w100";
    if (weight == FontWeight.w200) return "FontWeight.w200";
    if (weight == FontWeight.w300) return "FontWeight.w300";
    if (weight == FontWeight.w400) return "FontWeight.w400";
    if (weight == FontWeight.w500) return "FontWeight.w500";
    if (weight == FontWeight.w600) return "FontWeight.w600";
    if (weight == FontWeight.w700) return "FontWeight.w700";
    if (weight == FontWeight.w800) return "FontWeight.w800";
    if (weight == FontWeight.w900) return "FontWeight.w900";
  }
  return "FontWeight.normal";
}

final List<BottomNavItemData> _defaultNavItems = [
  BottomNavItemData(icon: Icons.settings, label: "Maintenance"),
  BottomNavItemData(icon: Icons.help, label: "Reach Us"),
  BottomNavItemData(icon: Icons.more_horiz, label: "More"),
];

final List<ComponentMetadata> componentRegistry = [
  ComponentMetadata(
    name: 'BottomNav',
    category: 'Organisms',
    defaultProps: {},
    builder: (Map<String, dynamic> props, {void Function(String, dynamic)? onPropChanged}) {
      return BottomNav(
        items: _defaultNavItems,
        onNavTap: (label) {
          debugPrint('Nav Tapped: $label');
        },
      );
    },
    codeBuilder: (Map<String, dynamic> props) {
      return "BottomNav(\n"
          "  items: [\n"
          "    BottomNavItemData(icon: Icons.settings, label: 'Maintenance'),\n"
          "    BottomNavItemData(icon: Icons.help, label: 'Reach Us'),\n"
          "    BottomNavItemData(icon: Icons.more_horiz, label: 'More'),\n"
          "  ],\n"
          "  onNavTap: (label) => print(label),\n"
          ")";
    },
  ),
  ComponentMetadata(
    name: 'QR Scan',
    category: 'Molecules',
    defaultProps: {
      'title': 'QR Scan',
      'subtitle': '',
      'popupTitle': 'Scan Code',
      'textColor': const Color(0xFF1E3A8A),
      'circleColor': const Color(0xFFE8EEFF),
      'width': 130.0,
      'height': 130.0,
    },
    builder: (Map<String, dynamic> props, {onPropChanged}) {
      return Scan(
        title: props['title'] ?? 'QR Scan',
        subtitle: props['subtitle'] ?? '',
        popupTitle: props['popupTitle'] ?? 'Scan Code',
        qrData: 'https://www.hdfcbank.com',
        imagePath: 'assets/Qr_scan.png',
        textColor: props['textColor'] ?? const Color(0xFF1E3A8A),
        circleColor: props['circleColor'] ?? const Color(0xFFE8EEFF),
        accentColor: const Color(0xFF8B5CF6),
        width: (props['width'] as num?)?.toDouble() ?? 130.0,
        height: (props['height'] as num?)?.toDouble() ?? 130.0,
        blur: 15.0,
        opacity: 0.2,
      );
    },
    codeBuilder: (Map<String, dynamic> props) {
      return "Scan(\n"
          "  title: '${props['title']}',\n"
          "  subtitle: '${props['subtitle']}',\n"
          "  popupTitle: '${props['popupTitle']}',\n"
          "  textColor: ${_formatColor(props['textColor'])},\n"
          "  circleColor: ${_formatColor(props['circleColor'])},\n"
          "  width: ${props['width']},\n"
          "  height: ${props['height']},\n"
          "  onTap: () => print('Tapped'),\n"
          ")";
    },
  ),
  ComponentMetadata(
    name: 'PrimaryButton',
    category: 'Molecules',
    defaultProps: {
      'title': 'Login with Fingerprint',
      'subtitle': '',
      'imagePath': 'assets/fingerprint.png',
      'width': 380.0,
      'height': 56.0,
      'primaryColor': const Color(0xFF004C8F),
      'secondaryColor': const Color(0xFF003366),
    },
    builder: (Map<String, dynamic> props, {onPropChanged}) {
      return PrimaryButton(
        title: props['title'] ?? 'Login with Fingerprint',
        subtitle: props['subtitle'] ?? '',
        imagePath: props['imagePath'] ?? '',
        width: (props['width'] as num?)?.toDouble() ?? 380.0,
        height: (props['height'] as num?)?.toDouble() ?? 56.0,
        gradientColors: [
          props['primaryColor'] ?? const Color(0xFF004C8F),
          props['secondaryColor'] ?? const Color(0xFF003366),
        ],
        onTap: () => debugPrint('Button Tapped'),
      );
    },
    codeBuilder: (Map<String, dynamic> props) {
      return "PrimaryButton(\n"
          "  title: '${props['title']}',\n"
          "  subtitle: '${props['subtitle']}',\n"
          "  imagePath: '${props['imagePath']}',\n"
          "  width: ${props['width']},\n"
          "  height: ${props['height']},\n"
          "  gradientColors: [${_formatColor(props['primaryColor'])}, ${_formatColor(props['secondaryColor'])}],\n"
          "  onTap: () => print('Tapped'),\n"
          ")";
    },
  ),
  ComponentMetadata(
    name: 'InlineActionRow',
    category: 'Molecules',
    defaultProps: {
      'leftLabel': 'Or, login with mPIN',
      'rightLabel': 'Forgot mPIN?',
      'textColor': const Color(0xFF1565C0),
      'spacing': 80.0,
    },
    builder: (Map<String, dynamic> props, {onPropChanged}) {
      return InlineActionRow(
        leftLabel: props['leftLabel'] ?? 'Or, login with mPIN',
        rightLabel: props['rightLabel'] ?? 'Forgot mPIN?',
        textColor: props['textColor'] ?? const Color(0xFF1565C0),
        spacing: (props['spacing'] as num?)?.toDouble() ?? 80.0,
        onLeftTap: () => debugPrint('Left Label Tapped'),
        onRightTap: () => debugPrint('Right Label Tapped'),
      );
    },
    codeBuilder: (Map<String, dynamic> props) {
      return "InlineActionRow(\n"
          "  leftLabel: '${props['leftLabel']}',\n"
          "  rightLabel: '${props['rightLabel']}',\n"
          "  textColor: ${_formatColor(props['textColor'])},\n"
          "  spacing: ${props['spacing']},\n"
          "  onLeftTap: () => print('Left Tapped'),\n"
          "  onRightTap: () => print('Right Tapped'),\n"
          ")";
    },
  ),
  ComponentMetadata(
    name: 'ActionItems',
    category: 'Molecules',
    defaultProps: {
      'itemWidth': 100.0,
      'itemHeight': 100.0,
      'opacity': 0.1,
    },
    builder: (Map<String, dynamic> props, {onPropChanged}) {
      return ActionItems(
        items: [
          ActionItemData(title: 'Send Money', imagePath: 'assets/Send_money.png', isFullImage: true),
          ActionItemData(title: 'Pay Bills', imagePath: 'assets/Pay_bills.png', isFullImage: true),
          ActionItemData(title: 'Products', imagePath: 'assets/Product_services.png', isFullImage: true, showBadge: true),
        ],
        itemWidth: (props['itemWidth'] as num?)?.toDouble() ?? 100.0,
        itemHeight: (props['itemHeight'] as num?)?.toDouble() ?? 100.0,
        opacity: (props['opacity'] as num?)?.toDouble() ?? 0.1,
        onItemTap: (item) => debugPrint('Tapped: ${item.title}'),
      );
    },
    codeBuilder: (Map<String, dynamic> props) {
      return "ActionItems(\n"
          "  items: [\n"
          "    ActionItemData(title: 'Send Money', imagePath: 'assets/Send_money.png'),\n"
          "    ActionItemData(title: 'Pay Bills', imagePath: 'assets/Pay_bills.png'),\n"
          "    ActionItemData(title: 'Products', imagePath: 'assets/Product_services.png', showBadge: true),\n"
          "  ],\n"
          "  itemWidth: ${props['itemWidth']},\n"
          "  itemHeight: ${props['itemHeight']},\n"
          "  onItemTap: (item) => print(item.title),\n"
          ")";
    },
  ),
<<<<<<< Updated upstream

=======
  ComponentMetadata(
    name: 'BottomNav',
    category: 'Organisms',
    defaultProps: {
      'backgroundColor': Colors.white,
      'activeColor': const Color(0xFF004C8F),
      'inactiveColor': const Color(0xFF4B5563),
    },
    builder: (Map<String, dynamic> props, {onPropChanged}) {
      return BottomNav(
        items: [
          BottomNavItemData(icon: Icons.build_circle_outlined, label: "Maintenance"),
          BottomNavItemData(icon: Icons.chat_bubble_outline, label: "Reach Us"),
          BottomNavItemData(icon: Icons.more_horiz_rounded, label: "More"),
        ],
        backgroundColor: props['backgroundColor'] ?? Colors.white,
        activeColor: props['activeColor'] ?? const Color(0xFF004C8F),
        inactiveColor: props['inactiveColor'] ?? const Color(0xFF4B5563),
        onNavTap: (label) => debugPrint('Nav Tapped: $label'),
      );
    },
    codeBuilder: (Map<String, dynamic> props) {
      return "BottomNav(\n"
          "  items: [...],\n"
          "  backgroundColor: ${_formatColor(props['backgroundColor'])},\n"
          "  activeColor: ${_formatColor(props['activeColor'])},\n"
          "  inactiveColor: ${_formatColor(props['inactiveColor'])},\n"
          "  onNavTap: (label) => print(label),\n"
          ")";
    },
  ),
>>>>>>> Stashed changes
  ComponentMetadata(
    name: 'AppHeader',
    category: 'Organisms',
    defaultProps: {
      'userName': 'MHONBENI NGULLIE',
      'customerId': '******1010',
      'width': 375.0,
      'backgroundColor': const Color(0xFFC7E2FE),
    },
    builder: (Map<String, dynamic> props, {onPropChanged}) {
      return AppHeader(
        userName: props['userName'] ?? 'MHONBENI NGULLIE',
        customerId: props['customerId'] ?? '******1010',
        logoPath: 'assets/hdfc_logo.png',
        backgroundColor: props['backgroundColor'] ?? const Color(0xFFC7E2FE),
        width: (props['width'] as num?)?.toDouble() ?? 375.0,
        onNotificationTap: () => debugPrint('Notification Tapped'),
      );
    },
    codeBuilder: (Map<String, dynamic> props) {
      return "AppHeader(\n"
          "  userName: '${props['userName']}',\n"
          "  customerId: '${props['customerId']}',\n"
          "  logoPath: 'assets/hdfc_logo.png',\n"
          "  backgroundColor: ${_formatColor(props['backgroundColor'])},\n"
          "  width: ${props['width']},\n"
          "  onNotificationTap: () => print('Notification Tapped'),\n"
          ")";
    },
  ),
  ComponentMetadata(
    name: 'AuthSection',
    category: 'Organisms',
    defaultProps: {
      'primaryActionTitle': 'Login with Fingerprint',
      'leftActionLabel': 'Or, login with mPIN',
      'rightActionLabel': 'Forgot mPIN?',
      'width': 450.0,
      'opacity': 0.1,
    },
    builder: (Map<String, dynamic> props, {onPropChanged}) {
      return AuthSection(
        primaryActionTitle: props['primaryActionTitle'] ?? 'Login with Fingerprint',
        leftActionLabel: props['leftActionLabel'] ?? 'Or, login with mPIN',
        rightActionLabel: props['rightActionLabel'] ?? 'Forgot mPIN?',
        width: (props['width'] as num?)?.toDouble() ?? 450.0,
        opacity: (props['opacity'] as num?)?.toDouble() ?? 0.1,
        onPrimaryActionTap: () => debugPrint('Primary Tapped'),
        onLeftActionTap: () => debugPrint('Left Tapped'),
        onRightActionTap: () => debugPrint('Right Tapped'),
      );
    },
    codeBuilder: (Map<String, dynamic> props) {
      return "AuthSection(\n"
          "  primaryActionTitle: '${props['primaryActionTitle']}',\n"
          "  leftActionLabel: '${props['leftActionLabel']}',\n"
          "  rightActionLabel: '${props['rightActionLabel']}',\n"
          "  width: ${props['width']},\n"
          "  opacity: ${props['opacity']},\n"
          "  onPrimaryActionTap: () => print('Primary'),\n"
          "  onLeftActionTap: () => print('Left'),\n"
          "  onRightActionTap: () => print('Right'),\n"
          ")";
    },
  ),
  ComponentMetadata(
    name: 'Text',
    category: 'Atoms',
    defaultProps: {
      'text': 'Hello World',
      'fontSize': 20.0,
      'color': Colors.black,
      'fontWeight': FontWeight.normal,
    },
    builder: (Map<String, dynamic> props, {onPropChanged}) {
      return atom.Text(
        text: props['text'] ?? 'Hello World',
        fontSize: (props['fontSize'] as num?)?.toDouble() ?? 20.0,
        color: props['color'] ?? Colors.black,
        fontWeight: props['fontWeight'] ?? FontWeight.normal,
      );
    },
    codeBuilder: (Map<String, dynamic> props) {
      return "Text(\n"
          "  text: '${props['text']}',\n"
          "  fontSize: ${props['fontSize']},\n"
          "  color: ${_formatColor(props['color'])},\n"
          "  fontWeight: ${_formatFontWeight(props['fontWeight'])},\n"
          "  textAlign: TextAlign.left,\n"
          ")";
    },
  ),
  ComponentMetadata(
    name: 'Checkbox',
    category: 'Atoms',
    defaultProps: {
      'value': false,
      'label': 'Tick me',
      'activeColor': const Color(0xFF2938AD),
      'checkColor': Colors.white,
    },
    builder: (Map<String, dynamic> props, {onPropChanged}) {
      return atom.Checkbox(
        value: props['value'] ?? false,
        label: props['label'],
        activeColor: props['activeColor'] ?? const Color(0xFF2938AD),
        checkColor: props['checkColor'] ?? Colors.white,
        onChanged: (val) {
          debugPrint('Checkbox: $val');
          if (onPropChanged != null) {
            onPropChanged('value', val);
          }
        },
      );
    },
    codeBuilder: (Map<String, dynamic> props) {
      return "Checkbox(\n"
          "  value: ${props['value']},\n"
          "  label: '${props['label']}',\n"
          "  activeColor: ${_formatColor(props['activeColor'])},\n"
          "  checkColor: ${_formatColor(props['checkColor'])},\n"
          "  onChanged: (val) => print(val),\n"
          ")";
    },
  ),
  ComponentMetadata(
    name: 'TextField',
    category: 'Atoms',
    defaultProps: {
      'hintText': 'Enter text',
      'width': 320.0,
      'fontSize': 22.0,
      'textColor': const Color(0xFF000000),
      'fontWeight': FontWeight.w500,
      'borderRadius': 30.0,
      'fillColor': const Color(0x1FFFFFFF),
    },
    builder: (Map<String, dynamic> props, {onPropChanged}) {
      return atom.TextField(
        hintText: props['hintText'] ?? 'Enter text',
        width: (props['width'] as num?)?.toDouble(),
        fontSize: (props['fontSize'] as num?)?.toDouble() ?? 22.0,
        textColor: props['textColor'] ?? const Color(0xFF000000),
        fontWeight: props['fontWeight'] ?? FontWeight.w500,
        borderRadius: (props['borderRadius'] as num?)?.toDouble() ?? 30.0,
        fillColor: props['fillColor'] ?? const Color(0xFFE2E8F0),
      );
    },
    codeBuilder: (Map<String, dynamic> props) {
      return "TextField(\n"
          "  hintText: '${props['hintText']}',\n"
          "  width: ${props['width']},\n"
          "  fontSize: ${props['fontSize']},\n"
          "  textColor: ${_formatColor(props['textColor'])},\n"
          "  fontWeight: ${_formatFontWeight(props['fontWeight'])},\n"
          "  borderRadius: ${props['borderRadius']},\n"
          "  fillColor: ${_formatColor(props['fillColor'])},\n"
          "  validator: (value) => value.isEmpty ? 'Required' : null,\n"
          "  inputFormatters: [],\n"
          ")";
    },
  ),
  ComponentMetadata(
    name: 'Image',
    category: 'Atoms',
    defaultProps: {
      'offsetX': 0.0,
      'offsetY': 0.0,
      'showShadow': false,
    },
    builder: (Map<String, dynamic> props, {onPropChanged}) {
      return atom.Image(
        offsetX: (props['offsetX'] as num?)?.toDouble() ?? 0.0,
        offsetY: (props['offsetY'] as num?)?.toDouble() ?? 0.0,
        showShadow: props['showShadow'] ?? false,
      );
    },
    codeBuilder: (Map<String, dynamic> props) {
      return "Image(\n"
          "  offsetX: ${props['offsetX']},\n"
          "  offsetY: ${props['offsetY']},\n"
          "  showShadow: ${props['showShadow']},\n"
          ")";
    },
  ),
  ComponentMetadata(
    name: 'Button',
    category: 'Atoms',
    defaultProps: {
      'text': 'Button',
      'width': 321.0,
      'height': 61.0,
      'disabled': false,
      'buttonColor': const Color(0xFF5371F9),
      'showOutline': true,
      'opacity': 0.3,
      'textColor': Colors.white,
      'fontSize': 22.0,
      'fontWeight': FontWeight.w600,
      'borderRadius': 20.0,
    },
    builder: (Map<String, dynamic> props, {onPropChanged}) {
      return atom.Button(
        text: props['text'] ?? 'Button',
        width: (props['width'] as num?)?.toDouble() ?? 321.0,
        height: (props['height'] as num?)?.toDouble() ?? 61.0,
        disabled: props['disabled'] ?? false,
        buttonColor: props['buttonColor'] ?? const Color(0xFF5371F9),
        showOutline: props['showOutline'] ?? true,
        opacity: (props['opacity'] as num?)?.toDouble() ?? 0.3,
        textColor: props['textColor'] ?? Colors.white,
        fontSize: (props['fontSize'] as num?)?.toDouble() ?? 22.0,
        fontWeight: props['fontWeight'] ?? FontWeight.w600,
        borderRadius: (props['borderRadius'] as num?)?.toDouble() ?? 20.0,
        onTap: () => debugPrint('Button Pressed'),
      );
    },
    codeBuilder: (Map<String, dynamic> props) {
      return "Button(\n"
          "  text: '${props['text']}',\n"
          "  width: ${props['width']},\n"
          "  height: ${props['height']},\n"
          "  disabled: ${props['disabled']},\n"
          "  buttonColor: ${_formatColor(props['buttonColor'])},\n"
          "  showOutline: ${props['showOutline']},\n"
          "  opacity: ${props['opacity']},\n"
          "  textColor: ${_formatColor(props['textColor'])},\n"
          "  fontSize: ${props['fontSize']},\n"
          "  fontWeight: ${_formatFontWeight(props['fontWeight'])},\n"
          "  borderRadius: ${props['borderRadius']},\n"
          "  onTap: () => print('Pressed'),\n"
          ")";
    },
  ),
  ComponentMetadata(
    name: 'Icon',
    category: 'Atoms',
    defaultProps: {
      'icon': null,
      'size': 60.0,
    },
    builder: (Map<String, dynamic> props, {onPropChanged}) {
      return atom.Icon(
        props['icon'],
        imagePath: 'assets/Icon.png',
        size: (props['size'] as num?)?.toDouble() ?? 24.0,
        color: const Color(0xFF2938AD),
      );
    },
    codeBuilder: (Map<String, dynamic> props) {
      return "Icon(\n"
          "  ${props['icon'] != null ? 'Icons.${props['icon'].toString().split('.').last}' : 'null'},\n"
          "  size: ${props['size']},\n"
          ")";
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
    builder: (Map<String, dynamic> props, {onPropChanged}) {
      return atom.TextButton(
        text: props['text'] ?? 'Click Me',
        fontSize: (props['fontSize'] as num?)?.toDouble() ?? 18.0,
        color: props['color'] ?? const Color(0xFF2938AD),
        fontWeight: props['fontWeight'] ?? FontWeight.bold,
        underline: props['underline'] ?? true,
        onPressed: () => debugPrint('TextButton Pressed'),
      );
    },
    codeBuilder: (Map<String, dynamic> props) {
      return "TextButton(\n"
          "  text: '${props['text']}',\n"
          "  fontSize: ${props['fontSize']},\n"
          "  color: ${_formatColor(props['color'])},\n"
          "  fontWeight: ${_formatFontWeight(props['fontWeight'])},\n"
          "  underline: ${props['underline']},\n"
          "  onPressed: () => print('Pressed'),\n"
          ")";
    },
  ),
  ComponentMetadata(
    name: 'HomePage',
    category: 'Pages',
    defaultProps: {
      'userName': 'MHONBENI NGULLIE',
      'customerId': '******1010',
    },
    builder: (Map<String, dynamic> props, {onPropChanged}) {
      return HomePage(
        userName: props['userName'] ?? 'MHONBENI NGULLIE',
        customerId: props['customerId'] ?? '******1010',
        logoPath: 'assets/hdfc_logo.png',
        actionItems: [
          ActionItemData(title: 'Send Money', imagePath: 'assets/Send_money.png', isFullImage: true),
          ActionItemData(title: 'Pay Bills', imagePath: 'assets/Pay_bills.png', isFullImage: true),
          ActionItemData(title: 'Products', imagePath: 'assets/Product_services.png', isFullImage: true),
        ],
        navItems: [
          BottomNavItemData(icon: Icons.build_circle_outlined, label: "Maintenance"),
          BottomNavItemData(icon: Icons.chat_bubble_outline, label: "Reach Us"),
          BottomNavItemData(icon: Icons.more_horiz_rounded, label: "More"),
        ],
        primaryButtonTitle: "Login with Fingerprint",
        primaryButtonIcon: Icons.fingerprint,
        leftActionLabel: "Or, login with mPIN",
        rightActionLabel: "Forgot mPIN?",
        scanTitle: "QR Scan",
        scanPopupTitle: "Scan Code",
      );
    },
    codeBuilder: (Map<String, dynamic> props) {
<<<<<<< Updated upstream
      return "Scaffold(\n"
          "  body: Column(\n"
          "    children: [\n"
          "      Header(),\n"
          "      Expanded(\n"
          "        child: SingleChildScrollView(\n"
          "          child: Column(\n"
          "            children: [\n"
          "              Scan(title: \"Scan\"),\n"
          "              ActionItems(),\n"
          "              PrimaryButton(),\n"
          "              InlineActionRow(),\n"
          "            ],\n"
          "          ),\n"
          "        ),\n"
          "      ),\n"
          "      BottomNav(\n"
          "        items: [\n"
          "          BottomNavItemData(icon: Icons.build_circle_outlined, label: 'Maintenance'),\n"
          "          BottomNavItemData(icon: Icons.chat_bubble_outline, label: 'Reach Us'),\n"
          "          BottomNavItemData(icon: Icons.more_horiz_rounded, label: 'More'),\n"
          "        ],\n"
          "      ),\n"
          "    ],\n"
          "  ),\n"
=======
      return "HomePage(\n"
          "  userName: '${props['userName']}',\n"
          "  customerId: '${props['customerId']}',\n"
          "  logoPath: 'assets/hdfc_logo.png',\n"
          "  actionItems: [...],\n"
          "  navItems: [...],\n"
>>>>>>> Stashed changes
          ")";
    },
  ),
];
