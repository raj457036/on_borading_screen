library on_borading_screen;

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class OnBoardingController extends ChangeNotifier {
  int _page = 0;
  late int _maxPageExtent;
  bool initialized = false;

  int get page => _page;
  int get maxPageCount => _maxPageExtent;

  _init(int maxPage) {
    _maxPageExtent = maxPage;
    initialized = true;
  }

  nextPage() {
    if (_page + 1 > _maxPageExtent) return;
    _page++;
    notifyListeners();
  }

  previousPage() {
    if (_page - 1 < 0) return;
    _page--;
    notifyListeners();
  }

  skipToPage(int page) {
    if (page != _page && page >= 0 && page <= _maxPageExtent) {
      _page = page;
      notifyListeners();
    }
  }
}

class AnimatedDot extends StatelessWidget {
  final double childDotSize;
  final double parentDotSize;
  final double nonActiveChildDotSize;
  final Duration duration;
  final bool active;
  final Color? parentDotColor, activeDotColor;
  final VoidCallback? onTap;

  const AnimatedDot({
    Key? key,
    this.childDotSize = 12,
    this.parentDotSize = 15,
    this.nonActiveChildDotSize = 0,
    this.duration = const Duration(milliseconds: 250),
    this.active = false,
    this.parentDotColor,
    this.activeDotColor,
    this.onTap,
  })  : assert(
          childDotSize < parentDotSize,
          "parent cannot be smaller than child",
        ),
        assert(
          nonActiveChildDotSize < parentDotSize,
          "parent cannot be smaller than child",
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final pad =
        (parentDotSize - (active ? childDotSize : nonActiveChildDotSize)) / 2;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: duration,
        height: parentDotSize,
        width: parentDotSize,
        curve: Curves.easeOut,
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: parentDotColor ?? Colors.grey,
        ),
        padding: EdgeInsets.all(pad),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: activeDotColor ?? Colors.purple,
          ),
        ),
      ),
    );
  }
}

class OnBoarding extends StatefulWidget {
  final OnBoardingController? controller;
  final List<Widget> pages;
  final Widget? leftAction;
  final Widget? rightAction;
  final Color? parentDotColor, activeDotColor;
  final double childDotSize;
  final double parentDotSize;
  final double nonActiveChildDotSize;
  final bool tapDotToSwitchPage;

  const OnBoarding({
    Key? key,
    this.controller,
    required this.pages,
    this.leftAction,
    this.rightAction,
    this.parentDotColor,
    this.activeDotColor,
    this.childDotSize = 12,
    this.parentDotSize = 15,
    this.nonActiveChildDotSize = 0,
    this.tapDotToSwitchPage = true,
  }) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int _activeIndex = 0;

  late OnBoardingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? OnBoardingController();
    _controller._init(widget.pages.length - 1);
    _controller.addListener(_updateIndex);
  }

  _updateIndex() {
    setState(() {
      _activeIndex = _controller._page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageTransitionSwitcher(
            transitionBuilder: (
              Widget child,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
            },
            child: widget.pages[_activeIndex],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.leftAction != null) widget.leftAction!,
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < widget.pages.length; i++)
                    AnimatedDot(
                      active: _activeIndex == i,
                      activeDotColor: widget.activeDotColor,
                      parentDotColor: widget.parentDotColor,
                      childDotSize: widget.childDotSize,
                      parentDotSize: widget.parentDotSize,
                      nonActiveChildDotSize: widget.nonActiveChildDotSize,
                      onTap: widget.tapDotToSwitchPage
                          ? () => _controller.skipToPage(i)
                          : null,
                    ),
                ],
              ),
            ),
            if (widget.rightAction != null) widget.rightAction!,
          ],
        )
      ],
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_updateIndex);
    _controller.dispose();
    super.dispose();
  }
}
