import 'package:flutter/material.dart';

class ComponentMetadata {
  final String name;
  final String category; 
  final Widget Function(Map<String, dynamic> props, {void Function(String, dynamic)? onPropChanged}) builder;
  final String Function(Map<String, dynamic> props) codeBuilder;
  final Map<String, dynamic> defaultProps;

  ComponentMetadata({
    required this.name,
    required this.category,
    required this.builder,
    required this.codeBuilder,
    required this.defaultProps,
  });
}
