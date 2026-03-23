import 'package:flutter/material.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/features/profile/presentations/models/action_item.dart';
import 'package:fpt_ojt/features/profile/presentations/models/carousel_item.dart';

final List<CarouselItem> promoItems = [
  CarouselItem(
    image: 'assets/images/profile/promo_bg.png',
    title: 'Pay for your bills',
    description:
        'Select this option if you’re shopping online, whether you are looking for something or already have something in your cart.',
  ),
  CarouselItem(
    image: 'assets/images/profile/promo_bg.png',
    title: 'Promo 2',
    description: 'Promo 2 description',
  ),
  CarouselItem(
    image: 'assets/images/profile/promo_bg.png',
    title: 'Promo 3',
    description: 'Promo 3 description',
  ),
];

final profileActionItems = [
  ActionItem(
    id: 'account',
    icon: Icons.person_outline,
    label: 'Account',
    routeName: RouteNames.editAccount,
  ),
  ActionItem(
    id: 'notification-settings',
    icon: Icons.notifications_outlined,
    label: 'Notification settings',
    routeName: RouteNames.notificationSettings,
  ),
  ActionItem(
    id: 'terms-conditions',
    icon: Icons.description_outlined,
    label: 'Terms & Conditions',
    routeName: RouteNames.termsConditions,
  ),
  ActionItem(
    id: 'live-map',
    icon: Icons.map_outlined,
    label: 'Live Map',
    routeName: RouteNames.liveMap,
  ),
];
