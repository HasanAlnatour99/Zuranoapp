import 'package:flutter/material.dart';

class AppLoadingIndicator extends StatefulWidget {
  const AppLoadingIndicator({this.size = 20, this.color, super.key});

  final double size;
  final Color? color;

  @override
  State<AppLoadingIndicator> createState() => _AppLoadingIndicatorState();
}

class _AppLoadingIndicatorState extends State<AppLoadingIndicator> {
  static const _fadeDuration = Duration(milliseconds: 600);

  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _opacity = 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final resolved = widget.color ?? Theme.of(context).colorScheme.primary;
    return AnimatedOpacity(
      opacity: _opacity,
      duration: _fadeDuration,
      child: SizedBox(
        height: widget.size,
        width: widget.size,
        child: CircularProgressIndicator(
          strokeWidth: 2.4,
          valueColor: AlwaysStoppedAnimation<Color>(resolved),
        ),
      ),
    );
  }
}

/// App-wide loading spinner (alias for [AppLoadingIndicator]).
typedef AppLoader = AppLoadingIndicator;
