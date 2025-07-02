

import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorkey = 
  new GlobalKey<NavigatorState>();

  void removeAndNavigateToRoute(String _route){
    navigatorkey.currentState?.popAndPushNamed(_route);

    
  }
  void navigateToRoute(String _route){
    navigatorkey.currentState?.pushNamed(_route);
  }
  void navigateToPage(Widget _page){
    navigatorkey.currentState?.push(MaterialPageRoute(builder: (BuildContext _context){
      return _page;
    }
    ));
  }
  void goBack(){
    navigatorkey.currentState?.pop();
  }
}
