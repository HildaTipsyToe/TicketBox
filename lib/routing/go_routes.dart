import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:ticketbox/presentation/views/dashboard/dashboard_view.dart';
import 'package:ticketbox/presentation/views/group/group_view.dart';

import '../config/injection_container.dart';
import '../domain/entities/settings.dart';

import '../presentation/views/chat/chat_view.dart';
import '../presentation/views/login/login_view.dart';
import 'nav_enums.dart';

GoRouter goRoutes = GoRouter(
  initialLocation: sl<Settings>().isLoggedIn ? '/' : '/login',
  routes: [
    // ShellRoute(
    //   builder: (context, state, child) => MainLayout(
    //     state: state,
    //     child: child,
    //   ),
    //   routes: <RouteBase>[
    GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return DashboardView();
        }),
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return LoginView();
      },
    ),
    GoRoute(
      name: 'dashboard',
      path: '/dashboard',
      builder: (BuildContext context, GoRouterState state) {
        return DashboardView();
      },
    ),
    // GoRoute(
    //   name: 'fines',
    //   path: '/fines',
    //   builder: (BuildContext context, GoRouterState state) {
    //     return FinesView(
    //       groupId: state.uri.queryParameters['groupId']!,
    //       roleId: state.uri.queryParameters['roleId']!,
    //     );
    //   },
    // ),
    GoRoute(
      name: 'group',
      path: '/group',
      builder: (BuildContext context, GoRouterState state) {
        return GroupView(
          receiverId: state.uri.queryParameters['receiverId']!,
          groupId: state.uri.queryParameters['groupId']!,
          groupName: state.uri.queryParameters['groupName']!,
          saldo: state.uri.queryParameters['saldo']!,
          roleId: state.uri.queryParameters['roleId']!,
        );
      },
    ),
    // GoRoute(
    //   name: 'members',
    //   path: '/members',
    //   builder: (BuildContext context, GoRouterState state){
    //     return MembersView(
    //       groupId: state.uri.queryParameters['groupId']!,
    //       groupName: state.uri.queryParameters['groupName']!,
    //       roleId: state.uri.queryParameters['roleId']!,
    //     );
    //   }
    //   ),
    // GoRoute(
    //   path: '/group_admin',
    //   builder: (BuildContext context, GoRouterState state) {
    //     return GroupAdminView();
    //   },
    // ),
    GoRoute(
      name: 'chat',
      path: '/chat',
      builder: (BuildContext context, GoRouterState state) {
        return ChatView(
          groupId: state.uri.queryParameters['groupId']!,
          roleId: state.uri.queryParameters['roleId']!,
        );
      },
    ),
    //     ],
    //   ),
  ],
  errorBuilder: (context, state) => MainLayout(
    state: state,
    child: LoginView(),
  ),
);
