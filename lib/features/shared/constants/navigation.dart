import 'package:flutter/material.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/features/shared/widgets/app_bottom_navbar.dart';

final bottomNavigationItems = [
  NavigationItem(
    icon: Icons.home_outlined,
    label: 'Home',
    routePath: RouteNames.home,
  ),
  NavigationItem(
    icon: Icons.wallet_outlined,
    label: 'Wallet',
    routePath: RouteNames.wallet,
  ),
  NavigationItem(
    icon: Icons.person_outline,
    label: 'Profile',
    routePath: RouteNames.profile,
  ),
];
