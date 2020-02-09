import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:talkAndroidLifecycleObservers/slide.theme.dart';
import 'package:talkAndroidLifecycleObservers/ui/responsive/ResponsiveBreakpointsLayout.dart';

class _ResponsiveTheme extends InheritedWidget {
  final ResponsiveThemeWidgetState data;

  _ResponsiveTheme({Key key, @required Widget child, @required this.data})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_ResponsiveTheme oldWidget) {
    return true;
  }
}

class ResponsiveThemeWidget extends StatefulWidget {
  final Widget child;

  ResponsiveThemeWidget({Key key, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ResponsiveThemeWidgetState();
  }

  static ResponsiveThemeWidgetState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_ResponsiveTheme>())
        .data;
  }
}

class ResponsiveThemeWidgetState extends State<ResponsiveThemeWidget> {
  ResponsiveThemeStyle style;
  ResponsiveThemeBreakpoint breakpoint;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (style == null) {
      style = buildStyleBasedOnBreakpoint(_buildResponsiveTextStyle(context),
          ResponsiveThemeBreakpoint.fromSize(MediaQuery.of(context).size));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBreakpointsLayout(builder: (builder, breakpoint) {
      _handleBreakPointChanges(breakpoint);
      return _ResponsiveTheme(
        data: this,
        child: widget.child,
      );
    });
  }

  ResponsiveThemeStyle buildStyleBasedOnBreakpoint(
      ResponsiveThemeStyle style, ResponsiveThemeBreakpoint breakpoint) {
    switch (breakpoint) {
      case ResponsiveThemeBreakpoint.MOBILE:
        return _applyMobileStyle(style);
      case ResponsiveThemeBreakpoint.DESKTOP:
        return _applyDesktopStyle(style);
      case ResponsiveThemeBreakpoint.DESKTOP_WIDE:
        return _applyDesktopWideStyle(style);
      default:
        return style;
    }
  }

  void _handleBreakPointChanges(ResponsiveThemeBreakpoint newBreakpoint) {
    if (newBreakpoint != breakpoint) {
      SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {
            breakpoint = newBreakpoint;
            style = buildStyleBasedOnBreakpoint(style, breakpoint);
          }));
    }
  }
}

class ResponsiveThemeStyle {
  ResponsiveThemeStyle({this.textStyle, this.paddingStyle});

  ResponsiveTextStyle textStyle;
  ResponsivePaddingStyle paddingStyle;
}

class ResponsiveTextStyle {
  ResponsiveTextStyle(
      {this.display1,
      this.display2,
      this.display3,
      this.headline,
      this.body1,
      this.body2,
      this.code});

  TextStyle display1;
  TextStyle display2;
  TextStyle display3;
  TextStyle headline;
  TextStyle body1;
  TextStyle body2;
  TextStyle code;
}

class ResponsivePaddingStyle {
  ResponsivePaddingStyle(
      {this.paddingXS,
      this.paddingS,
      this.paddingM,
      this.paddingL,
      this.paddingXL});

  double paddingXS;
  double paddingS;
  double paddingM;
  double paddingL;
  double paddingXL;
}

class ResponsiveThemeBreakpoint {
  final String name;
  final RangeValues range;

  const ResponsiveThemeBreakpoint._internal(this.name, this.range);

  static const MOBILE =
      ResponsiveThemeBreakpoint._internal("MOBILE", RangeValues(0.0, 800.0));
  static const DESKTOP = ResponsiveThemeBreakpoint._internal(
      "DESKTOP", RangeValues(800.0, 1200.0));
  static const DESKTOP_WIDE = ResponsiveThemeBreakpoint._internal(
      "DESKTOP_WIDE", RangeValues(1200.0, double.infinity));
  static const _VALUES = [MOBILE, DESKTOP, DESKTOP_WIDE];

  get isVertical {
    switch (this) {
      case MOBILE:
      case DESKTOP:
        return true;
      default:
        return false;
    }
  }

  static ResponsiveThemeBreakpoint fromSize(Size size) {
    return _VALUES.fold(MOBILE,
        (acc, current) => size.width < current.range.start ? acc : current);
  }
}

ResponsiveThemeStyle _buildResponsiveTextStyle(BuildContext context) =>
    ResponsiveThemeStyle(
        textStyle: ResponsiveTextStyle(
            display1: Theme.of(context).textTheme.display1,
            display2: Theme.of(context).textTheme.display2,
            display3: Theme.of(context).textTheme.display3,
            headline: Theme.of(context).textTheme.headline,
            body1: Theme.of(context).textTheme.body1.copyWith(fontSize: 20),
            body2: Theme.of(context).textTheme.body1.copyWith(fontSize: 16),
            code: TextStyle(
                fontSize: 18,
                backgroundColor: SlideTheme.of(context).textBackground)),
        paddingStyle: ResponsivePaddingStyle(
          paddingXS: 4.0,
          paddingS: 8.0,
          paddingM: 16.0,
          paddingL: 32.0,
          paddingXL: 64.0,
        ));

ResponsiveThemeStyle _applyMobileStyle(ResponsiveThemeStyle style) => style
  ..textStyle = (style.textStyle
    ..display1 = style.textStyle.display1.copyWith(fontSize: 14)
    ..display2 = style.textStyle.display2.copyWith(fontSize: 18)
    ..display3 = style.textStyle.display3.copyWith(fontSize: 24)
    ..headline = style.textStyle.headline.copyWith(fontSize: 12)
    ..body1 = style.textStyle.body1.copyWith(fontSize: 12)
    ..body2 = style.textStyle.body2.copyWith(fontSize: 10)
    ..code = TextStyle(fontSize: 12))
  ..paddingStyle = (style.paddingStyle
    ..paddingXS = 2.0
    ..paddingS = 4.0
    ..paddingM = 8.0
    ..paddingL = 16.0
    ..paddingXL = 32.0);

ResponsiveThemeStyle _applyDesktopStyle(ResponsiveThemeStyle style) => style
  ..textStyle = (style.textStyle
    ..display1 = style.textStyle.display1.copyWith(fontSize: 28)
    ..display2 = style.textStyle.display2.copyWith(fontSize: 38)
    ..display3 = style.textStyle.display3.copyWith(fontSize: 42)
    ..headline = style.textStyle.headline.copyWith(fontSize: 20)
    ..body1 = style.textStyle.body1.copyWith(fontSize: 16)
    ..body2 = style.textStyle.body2.copyWith(fontSize: 14)
    ..code = TextStyle(fontSize: 14))
  ..paddingStyle = (style.paddingStyle
    ..paddingXS = 4.0
    ..paddingS = 8.0
    ..paddingM = 16.0
    ..paddingL = 32.0
    ..paddingXL = 64.0);

ResponsiveThemeStyle _applyDesktopWideStyle(ResponsiveThemeStyle style) => style
  ..textStyle = (style.textStyle
    ..display1 = style.textStyle.display1.copyWith(fontSize: 34)
    ..display2 = style.textStyle.display2.copyWith(fontSize: 45)
    ..display3 = style.textStyle.display3.copyWith(fontSize: 56)
    ..headline = style.textStyle.headline.copyWith(fontSize: 24)
    ..body1 = style.textStyle.body1.copyWith(fontSize: 20)
    ..body2 = style.textStyle.body2.copyWith(fontSize: 16)
    ..code = TextStyle(fontSize: 18))
  ..paddingStyle = (style.paddingStyle
    ..paddingXS = 4.0
    ..paddingS = 8.0
    ..paddingM = 16.0
    ..paddingL = 32.0
    ..paddingXL = 64.0);
