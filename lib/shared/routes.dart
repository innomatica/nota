import 'package:go_router/go_router.dart' show GoRouter, GoRoute;
import 'package:provider/provider.dart';

import '../pages/home/model.dart';
import '../pages/home/view.dart';
import '../pages/item/model.dart';
import '../pages/item/view.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return HomeView(model: context.read<HomeViewModel>()..load());
      },
      routes: [
        GoRoute(
          path: 'item/:itemId',
          builder: (context, state) {
            return ItemView(
              model: context.read<ItemViewModel>(),
              itemId: int.tryParse(state.pathParameters['itemId'] ?? '') ?? 0,
            );
          },
        ),
      ],
    ),
  ],
);
