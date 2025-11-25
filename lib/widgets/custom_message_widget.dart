import 'package:flutter/material.dart';
import 'package:kurban_open_im/services/app_event.dart';

class CustomMessageWidget extends StatefulWidget {
  const CustomMessageWidget({super.key, required this.child});

  final Widget child;

  @override
  State<CustomMessageWidget> createState() => _CustomMessageWidgetState();
}

class _CustomMessageWidgetState extends State<CustomMessageWidget> {
  late OverlayPortalController overlayPortalController;

  @override
  void initState() {
    super.initState();

    overlayPortalController = OverlayPortalController();
    AppEvent.messages.listen((value) {
      overlayPortalController.show();
      Future.delayed(Duration(seconds: 2), () {
        overlayPortalController.hide();
      });
    });
    /*    WidgetsBinding.instance.addPostFrameCallback((v) {
      var size = context.getSize;
      Overlay.of(context, debugRequiredFor: widget).insert(
        OverlayEntry(
          builder: (BuildContext context) {
            return SizedBox(width: size.width, height: size.height);
          },
        ),
      );
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (BuildContext context) {
              return OverlayPortal.overlayChildLayoutBuilder(
                controller: overlayPortalController,
                overlayLocation: OverlayChildLocation.rootOverlay,
                overlayChildBuilder: (context, info) {
                  return Center(child: Container(width: 100, height: 100, color: Colors.green));
                },
                child: widget.child,
              );
            },
          ),
        ],
      ),
    );
  }
}
