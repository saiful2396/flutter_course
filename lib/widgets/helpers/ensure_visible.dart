import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';

class EnsureVisibleWhenFocused extends StatefulWidget {
  const EnsureVisibleWhenFocused({
    Key key,
    @required this.focusNode,
    @required this.child,
    this.curve: Curves.ease,
    this.duration: const Duration(milliseconds: 100),
  }) : super(key: key);

  /// the node will monitor to determine if the child is focused
  final FocusNode focusNode;

  /// the child widget tha we are wrapping
  final Widget child;

  ///the curved we will use to scroll ourselves into view
  ///Default to Curves.ease;
  final Curve curve;

  ///the duration we will use to scroll ourselves into view
  ///default to 100 milliseconds
  final Duration duration;

  @override
  _EnsureVisibleWhenFocusedState createState() =>
      _EnsureVisibleWhenFocusedState();
}

class _EnsureVisibleWhenFocusedState extends State<EnsureVisibleWhenFocused> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_ensureVisible);
  }

  @override
  void dispose() {
    super.dispose();
    widget.focusNode.removeListener(_ensureVisible);
  }

  Future<Null> _ensureVisible() async {
    //wait for the keyBoard to come into view
    // TODO: position doesn't seem to notify Listeners when metrics change
    //perhaps a notificationListeners around the scrollable could avoid
    // the need insert a delay here
    await Future.delayed(
      const Duration(milliseconds: 300),
    );
    if (!widget.focusNode.hasFocus) return;
    final RenderObject object = context.findRenderObject();
    final RenderAbstractViewport viewport = RenderAbstractViewport.of(object);
    assert(viewport != null);

    ScrollableState scrollableState = Scrollable.of(context);
    assert(scrollableState != null);

    ScrollPosition position = scrollableState.position;
    double alignment;
    if (position.pixels > viewport.getOffsetToReveal(object, 0.0).offset) {
      // Move down to the top of the viewport
      alignment = 0.0;
    } else if (position.pixels > viewport.getOffsetToReveal(object, 1.0).offset ) {
      //Move up to the bottom of the viewport
    } else {
      //No scrolling in necessary to reveal the child
      return;
    }
    position.ensureVisible(
      object,
      alignment: alignment,
      duration: widget.duration,
      curve: widget.curve,
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
