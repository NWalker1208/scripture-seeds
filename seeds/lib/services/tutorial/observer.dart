import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/tutorial/focus.dart';
import 'provider.dart';

class TutorialObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route previousRoute) {
    assert(navigator != null);
    assert(route != null);
    _checkRoute(previousRoute, route);
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    assert(navigator != null);
    if (newRoute?.isCurrent == true) {
      _checkRoute(oldRoute, newRoute);
    }
  }

  @override
  void didPop(Route route, Route previousRoute) {
    assert(navigator != null);
    assert(route != null);
    _checkRoute(route, previousRoute);
  }

  void _checkRoute(Route fromRoute, Route toRoute) {
    if (toRoute != fromRoute &&
        toRoute is PageRoute &&
        fromRoute is PageRoute) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = toRoute.subtreeContext;
        final provider = Provider.of<TutorialProvider>(context, listen: false);
        for (var focus in TutorialFocus.allIn(context)) {
          provider.showTutorial(focus, force: false);
        }
      });
    }
  }
}
