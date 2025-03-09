import 'package:flutter/material.dart';

import 'floating_navbar_item.dart';

typedef ItemBuilder = Widget Function(
    BuildContext context, int index, FloatingNavbarItem items);

class FloatingNavbar extends StatefulWidget {
  final List<FloatingNavbarItem> items;
  final int currentIndex;
  final void Function(int val)? onTap;
  final Color selectedBackgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final Color backgroundColor;
  final double fontSize;
  final double iconSize;
  final double itemBorderRadius;
  final double itemSpace;
  final double borderRadius;
  final ItemBuilder itemBuilder;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double width;
  final double elevation;
  final bool inLine;

  FloatingNavbar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    ItemBuilder? itemBuilder,
    this.backgroundColor = Colors.black,
    this.selectedBackgroundColor = Colors.white,
    this.selectedItemColor = Colors.black,
    this.iconSize = 24.0,
    this.fontSize = 11.0,
    this.borderRadius = 8,
    this.itemBorderRadius = 8,
    this.itemSpace = 5,
    this.unselectedItemColor = Colors.white,
    this.margin = const EdgeInsets.all(8),
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.width = double.infinity,
    this.inLine = false,
    this.elevation = 0.0,
  })  : assert(items.length > 1),
        assert(items.length <= 5),
        assert(currentIndex <= items.length),
        assert(width > 50),
        itemBuilder = itemBuilder ??
            _defaultItemBuilder(
              unselectedItemColor: unselectedItemColor,
              selectedItemColor: selectedItemColor,
              borderRadius: borderRadius,
              fontSize: fontSize,
              width: width,
              backgroundColor: backgroundColor,
              currentIndex: currentIndex,
              iconSize: iconSize,
              itemSpace: itemSpace,
              itemBorderRadius: itemBorderRadius,
              items: items,
              onTap: onTap,
              inLine: inLine,
              selectedBackgroundColor: selectedBackgroundColor,
            );

  @override
  _FloatingNavbarState createState() => _FloatingNavbarState();
}

class _FloatingNavbarState extends State<FloatingNavbar> {
  List<FloatingNavbarItem> get items => widget.items;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: widget.padding,
          margin: widget.margin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: widget.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey
                    .withValues(alpha: 0.5), // Choose your shadow color
                spreadRadius: 0.3,
                blurRadius: 3,
                offset:
                    const Offset(0, 3), // Changes the position of the shadow
              ),
            ],
          ),
          width: widget.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: items
                  .asMap()
                  .map((i, f) {
                    return MapEntry(i, widget.itemBuilder(context, i, f));
                  })
                  .values
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

ItemBuilder _defaultItemBuilder({
  Function(int val)? onTap,
  required List<FloatingNavbarItem> items,
  int? currentIndex,
  Color? selectedBackgroundColor,
  Color? selectedItemColor,
  Color? unselectedItemColor,
  Color? backgroundColor,
  double width = double.infinity,
  double? fontSize,
  double? iconSize,
  double? itemSpace,
  double? itemBorderRadius,
  double? borderRadius,
  bool? inLine = false,
}) {
  return (BuildContext context, int index, FloatingNavbarItem item) => Expanded(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                  color: currentIndex == index
                      ? selectedBackgroundColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(itemBorderRadius!)),
              child: InkWell(
                onTap: () {
                  onTap!(index);
                },
                borderRadius: BorderRadius.circular(8),
                child: IntrinsicWidth(
                  child: Container(
                    // width: 30,
                    width:
                        MediaQuery.of(context).size.width / items.length - 24,
                    // width: width.isFinite ? (width / items.length - 8) : MediaQuery.of(context).size.width / items.length - 24,
                    padding: EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: item.title != null
                            ? inLine == true
                                ? 8
                                : 4
                            : 8),

                    child: inLine == true
                        ? Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              item.customWidget == null
                                  ? Icon(
                                      item.icon,
                                      color: currentIndex == index
                                          ? selectedItemColor
                                          : unselectedItemColor,
                                      size: iconSize,
                                    )
                                  : item.customWidget!,
                              if (item.title != null)
                                SizedBox(
                                  width: itemSpace,
                                ),
                              if (item.title != null)
                                Flexible(
                                  child: Text(
                                    '${item.title}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: currentIndex == index
                                          ? selectedItemColor
                                          : unselectedItemColor,
                                      fontSize: fontSize,
                                    ),
                                  ),
                                ),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              item.customWidget == null
                                  ? Icon(
                                      item.icon,
                                      color: currentIndex == index
                                          ? selectedItemColor
                                          : unselectedItemColor,
                                      size: iconSize,
                                    )
                                  : item.customWidget!,
                              SizedBox(
                                height: itemSpace,
                              ),
                              if (item.title != null)
                                Text(
                                  '${item.title}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: currentIndex == index
                                        ? selectedItemColor
                                        : unselectedItemColor,
                                    fontSize: fontSize,
                                  ),
                                ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
