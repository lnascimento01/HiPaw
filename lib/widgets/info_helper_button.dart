import 'package:flutter/material.dart';

class InfoHelperButton extends StatelessWidget {
  const InfoHelperButton({
    super.key,
    required this.title,
    required this.child,
    this.icon,
  });

  final String title;
  final Widget child;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon ?? Icons.help_outline),
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (context) {
            return DraggableScrollableSheet(
              expand: false,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      child,
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
