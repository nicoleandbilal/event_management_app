import 'package:flutter/material.dart';

class DraggableModalLayout extends StatelessWidget {
  final Widget modalChild;
  final Widget backgroundChild;
  final double modalHeightFraction;

  const DraggableModalLayout({
    Key? key,
    required this.modalChild,
    required this.backgroundChild,
    this.modalHeightFraction = 0.8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Background content
        backgroundChild,
        // Draggable modal
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              // Close the modal on downward swipe
              if (details.primaryDelta! > 50) {
                Navigator.of(context).pop();
              }
            },
            child: Container(
              height: screenHeight * modalHeightFraction,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: modalChild,
            ),
          ),
        ),
      ],
    );
  }
}