import 'package:flutter/material.dart';

/// A layout helper that keeps a footer widget pinned to the bottom of the
/// screen, even when the on-screen keyboard is visible.
///
/// The [body] receives additional bottom padding so that scrollable content
/// is not hidden behind the footer. The [footer] area ignores bottom view
/// insets to prevent the keyboard from pushing it upward.
class PersistentFooterLayout extends StatelessWidget {
  const PersistentFooterLayout({
    super.key,
    required this.body,
    required this.footer,
    this.footerPadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.backgroundColor = Colors.white,
    this.addElevation = true,
  });

  final Widget body;
  final Widget footer;
  final EdgeInsetsGeometry footerPadding;
  final Color backgroundColor;
  final bool addElevation;

  @override
  Widget build(BuildContext context) {
    final double bottomSafe = MediaQuery.of(context).padding.bottom;
    return ColoredBox(
      color: backgroundColor,
      child: Stack(
        children: [
          Positioned.fill(
            child: body,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                boxShadow: addElevation
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 14,
                          offset: const Offset(0, -4),
                        ),
                      ]
                    : null,
              ),
              padding: footerPadding
                  .resolve(Directionality.of(context))
                  .copyWith(
                    bottom: footerPadding
                            .resolve(Directionality.of(context))
                            .bottom +
                        bottomSafe,
                  ),
              child: footer,
            ),
          ),
        ],
      ),
    );
  }
}
