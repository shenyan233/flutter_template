import 'package:flutter/material.dart';

class FloatButtonToTop extends StatefulWidget {
  final ScrollController scrollController;
  const FloatButtonToTop({super.key, required this.scrollController});

  @override
  State<FloatButtonToTop> createState() => _FloatButtonToTopState();
}

class _FloatButtonToTopState extends State<FloatButtonToTop> {
  final double _scrollThreshold = 200.0;
  bool _showScrollToTopButton = false;

  @override
  void initState() {
    widget.scrollController.addListener(_handleScroll);
    super.initState();
  }

  void _handleScroll() {
    if (widget.scrollController.offset > _scrollThreshold && !_showScrollToTopButton) {
      setState(() {
        _showScrollToTopButton = true;
      });
    } else if (widget.scrollController.offset <= _scrollThreshold && _showScrollToTopButton) {
      setState(() {
        _showScrollToTopButton = false;
      });
    }
  }

  void _scrollToTop() {
    widget.scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _showScrollToTopButton,
      child: FloatingActionButton(
        onPressed: _scrollToTop,
        child: const Icon(Icons.navigation),
      ),
    );
  }
}
