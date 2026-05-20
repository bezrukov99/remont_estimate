import 'package:flutter/material.dart';
import 'package:remont_estimate/core/theme/app_palette.dart';
import 'package:remont_estimate/core/theme/app_spacing.dart';

/// Opens a styled modal bottom sheet with rounded corners and drag handle.
Future<T?> showRemontSheet<T>(
  BuildContext context, {
  required Widget child,
  bool isScrollControlled = true,
  bool useSafeArea = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: useSafeArea,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (context) => AppBottomSheetFrame(child: child),
  );
}

/// Rounded sheet shell with handle — wrap sheet content.
class AppBottomSheetFrame extends StatelessWidget {
  const AppBottomSheetFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final maxHeight = media.size.height * 0.92 - media.padding.top;

    final palette = context.palette;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppSpacing.cardRadiusLarge),
      ),
      child: Material(
        color: palette.surface,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppSpacing.sm),
              const _SheetDragHandle(),
              Flexible(
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetDragHandle extends StatelessWidget {
  const _SheetDragHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.palette.progressTrack,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

/// Standard sheet layout: title + scrollable/fixed body with keyboard padding.
class AppSheetBody extends StatelessWidget {
  const AppSheetBody({
    super.key,
    this.title,
    this.titleWidget,
    required this.children,
    this.footer,
  });

  final String? title;
  final Widget? titleWidget;
  final List<Widget> children;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg + bottomInset,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...?switch ((title, titleWidget)) {
              (final String t, _) => [
                Text(
                  t,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 22,
                        letterSpacing: -0.3,
                      ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              (_, final Widget w) => [w, const SizedBox(height: AppSpacing.lg)],
              _ => null,
            },
            ...children,
            if (footer != null) ...[
              const SizedBox(height: AppSpacing.lg),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Tappable row for settings-style sheets.
class AppSheetListTile extends StatelessWidget {
  const AppSheetListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final titleStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: palette.textPrimary,
      height: 1.2,
    );
    final subtitleStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: palette.textTertiary,
      height: 1.2,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: palette.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          child: SizedBox(
            height: AppSpacing.sheetListTileHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  Icon(icon, color: palette.accent, size: 22),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: subtitle != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: titleStyle,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                subtitle!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: subtitleStyle,
                              ),
                            ],
                          )
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: titleStyle,
                            ),
                          ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: palette.textTertiary,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Section label inside sheets.
class AppSheetSectionTitle extends StatelessWidget {
  const AppSheetSectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
