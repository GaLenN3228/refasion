import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScaffoldChildrenData {
  final String message;

  final Widget child;

  final List<Widget> children;

  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final Widget Function(BuildContext, int) separatorBuilder;

  const ScaffoldChildrenData(
      {this.message,
      this.child,
      this.children,
      this.itemCount,
      this.itemBuilder,
      this.separatorBuilder});

  factory ScaffoldChildrenData.message(String message) =>
      ScaffoldChildrenData(message: message);

  factory ScaffoldChildrenData.single(Widget child) =>
      ScaffoldChildrenData(child: child);

  factory ScaffoldChildrenData.logo() => ScaffoldChildrenData.single(
        Center(
          child: SvgPicture.asset("assets/logo/svg/refashioned_logo.svg"),
        ),
      );

  factory ScaffoldChildrenData.list(List<Widget> children) =>
      ScaffoldChildrenData(children: children);

  factory ScaffoldChildrenData.builder(
    int itemCount,
    Widget Function(BuildContext, int) itemBuilder,
  ) =>
      ScaffoldChildrenData(
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      );

  factory ScaffoldChildrenData.separated(
    int itemCount,
    Widget Function(BuildContext, int) itemBuilder,
    Widget Function(BuildContext, int) separatorBuilder,
  ) =>
      ScaffoldChildrenData(
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        separatorBuilder: separatorBuilder,
      );
}
