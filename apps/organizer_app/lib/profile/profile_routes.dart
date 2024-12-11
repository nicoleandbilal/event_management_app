// lib/routes/profile_routes.dart

import 'package:go_router/go_router.dart';
import 'package:organizer_app/create_brand/create_brand_screen.dart';
import 'package:shared/page_transitions.dart'; 

List<GoRoute> profileRoutes = [
  GoRoute(
    path: '/create_brand',
    pageBuilder: (context, state) => buildPageWithFadeTransition(const CreateBrandScreen(), state),
  ),

];
