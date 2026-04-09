import 'package:flutter/material.dart';

class MultiFingerSwipeUpDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback onSwipeUp;
  final int requiredFingers; // 4 atau 5

  const MultiFingerSwipeUpDetector({
    super.key,
    required this.child,
    required this.onSwipeUp,
    this.requiredFingers = 4,
  });

  @override
  State<MultiFingerSwipeUpDetector> createState() =>
      _MultiFingerSwipeUpDetectorState();
}

class _MultiFingerSwipeUpDetectorState
    extends State<MultiFingerSwipeUpDetector> {
  Set<int> pointers = {};
  Map<int, Offset> lastPositions = {};

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        pointers.add(event.pointer);
        lastPositions[event.pointer] = event.position;
      },
      onPointerMove: (event) {
        lastPositions[event.pointer] = event.position;

        if (pointers.length >= widget.requiredFingers) {
          bool allSwipeUp = true;

          for (var id in pointers) {
            final last = lastPositions[id];
            if (last == null) continue;
            final deltaY = event.position.dy - last.dy;
            if (deltaY > -50) {
              // minimal gerakan ke atas
              allSwipeUp = false;
              break;
            }
          }

          if (allSwipeUp) {
            widget.onSwipeUp();
            pointers.clear();
            lastPositions.clear();
          }
        }
      },
      onPointerUp: (event) {
        pointers.remove(event.pointer);
        lastPositions.remove(event.pointer);
      },
      onPointerCancel: (event) {
        pointers.remove(event.pointer);
        lastPositions.remove(event.pointer);
      },
      child: widget.child,
    );
  }
}
