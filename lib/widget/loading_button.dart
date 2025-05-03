import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final bool isLoading;
  final void Function() onPressed;
  final Widget child;
  final double minWidth;
  const LoadingButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.child,
    this.minWidth = 150,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth),
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        child: (isLoading)
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(),
              )
            : child,
      ),
    );
  }
}
