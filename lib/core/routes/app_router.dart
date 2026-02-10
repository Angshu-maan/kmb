import 'package:go_router/go_router.dart';
import 'package:kmb_app/core/routes/role_router.dart';
import 'package:kmb_app/features/admin/screens/application/application_list_screen.dart';
import 'package:kmb_app/features/admin/screens/application/applictaion_details_screen.dart';
import 'package:kmb_app/features/admin/screens/driver/model/driver_model.dart';

import 'package:kmb_app/features/admin/screens/driver/ui/driver_details_screen.dart';
import 'package:kmb_app/features/admin/screens/driver/ui/driver_screen_list.dart';

import 'package:kmb_app/features/admin/screens/owner/ui/owner_screen_list.dart';
import 'package:kmb_app/features/admin/screens/owner/model/owner_model.dart';
import 'package:kmb_app/features/admin/screens/vehicle/model/vehicle_model.dart';
import 'package:kmb_app/features/admin/screens/vehicle/ui/vehicle_details_screen.dart';
import 'package:kmb_app/features/admin/screens/vehicle/ui/vehicle_list_screen.dart';
import 'package:kmb_app/features/provider/auth_provider.dart';
import 'package:provider/provider.dart';

// import 'package:kmb_app/features/auth/services/auth_service.dart';
// import 'package:provider/provider.dart';
// import 'package:kmb_app/core/provider/auth_provider.dart';

import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/otp_screen.dart';

import '../../features/admin/screens/dashboard/chairman_screen.dart';
import '../../features/admin/screens/dashboard/dealer_screen.dart';
import '../../features/admin/screens/dashboard/executive_screen.dart';
import '../../features/admin/screens/dashboard/main_dashboard.dart';

import '../../features/admin/widgets/dashboard_widgets.dart';

import '../../features/admin/screens/owner/ui/owner_details_screen.dart';

// final GoRouter appRouter = GoRouter(
//   initialLocation: '/splash',

  
//   routes: [
//     // Splash
//     GoRoute(
//       path: '/splash',
//       name: 'splash',
//       builder: (context, state) => const SplashScreen(),
//     ),

//     // Login
//     GoRoute(
//       path: '/login',
//       name: 'login',
//       builder: (context, state) => const LoginPage(),
//     ),

//     // OTP Verification
//     GoRoute(
//       path: '/otp',
//       name: 'otp',
//       builder: (context, state) => OTPScreen.fromGoRouter(context, state),
//     ),

//     // Screen Routing
//     // GoRoute(
//     //   path: '/home',
//     //   name: 'home',
//     //   redirect: (_, __) {
//     //     final session = AuthService.currentSession;

//     //     if (session == null) return '/login';

//     //     final routeName = RoleRouter.homeRouteForRole(session.activeRole);

//     //     return _pathFromRouteName(routeName);
//     //   },
//     // ),

//     // Dealer Dashboard
//     GoRoute(
//       path: '/dashboard/dealer',
//       name: 'dealer_dashboard',
//       builder: (context, state) => DealerDashboardPage(),
//     ),
//     GoRoute(
//       path: '/dashboard/superAdmin',
//       name: 'admin_dashboard',
//       builder: (context, state) => SuperAdminDashboard(),
//     ),

//     // Executive Dashboard
//     GoRoute(
//       path: '/dashboard/executive',
//       name: 'executive_dashboard',
//       builder: (context, state) => Executivedashboardpage(),
//     ),

//     // Chairman Dashboard
//     GoRoute(
//       path: '/dashboard/chairman',
//       name: 'chairman_dashboard',
//       builder: (context, state) => ChairmanDashboard(),
//     ),
//     GoRoute(
//       path: '/application/list',
//       name: "application_list",
//       builder: (context, state) => const ApplicationScreen(),
//     ),

//     GoRoute(
//       path: '/details/application',
//       name: "application_details",
//       builder: (context, state) => const ApplicationDetailsScreen(),
//     ),

    

//     //Widgets Routing
//     GoRoute(
//       path: '/widgets/dashboard',
//       name: 'dashboard_widgets',
//       builder: (context, state) => const DashboardWidgets(),
//     ),

//     GoRoute(
//       path: '/list/owner',
//       name: 'owner_list',
//       builder: (context, state) => const OwnerScreen(),
//     ),

//     GoRoute(
//       path: '/details/owner',
//       name: 'owner_details',
//       builder: (context, state) {
//         final owner = state.extra as OwnerModel;

//         return OwnerDetailsScreen(owner: owner);
//       },
//     ),

//     GoRoute(
//       path: '/list/driver',
//       name: 'driver_list',
//       builder: (context, state) => const DriverScreenList(),
//     ),

//     GoRoute(
//       path: '/details/driver',
//       name: 'driver_details',
//       builder: (context, state) {
//         final driver = state.extra as DriverModel;

//         return DriverDetailsScreen(driver: driver);
//       },
//     ),

//     GoRoute(
//       path: '/list/vehicle',
//       name: 'vehicle_list',
//       builder: (context, state) => const VehicleListScreen(),
//     ),

//     GoRoute(
//       path: '/details/vehicle',
//       name: 'vehicle_details',
//       builder: (context, state) {
//         final vehicle = state.extra as VehicleModel;
//         return VehicleDetailsScreen(vehicle: vehicle);
//       },
//     ),
//   ],



// );


// final AuthProvider authProvider = AuthProvider();

// final GoRouter appRouter = GoRouter(
//   initialLocation: '/splash',

//   // 🔥 THIS makes GoRouter react to login / logout
//   refreshListenable: authProvider,

//   // redirect: (context, state) {
//   //   final loggedIn = authProvider.isLoggedIn;
//   //   final location = state.matchedLocation;

//   //   // Allow splash always
//   //   if (location == '/splash') return null;

//   //   // Not logged in → force login
//   //   if (!loggedIn) {
//   //     if (location == '/login' || location == '/otp') return null;
//   //     return '/login';
//   //   }

//   //   // Logged in → block auth screens
//   //   if (loggedIn && (location == '/login' || location == '/otp')) {
//   //     final role = authProvider.role;
//   //     if (role == null) return '/login';

//   //     final routeName = RoleRouter.homeRouteForRole(authProvider.role as String);
//   //     return _pathFromRouteName(routeName);
//   //   }

//   //   return null;
//   // },

//   routes: [
//     // Splash
//     GoRoute(
//       path: '/splash',
//       name: 'splash',
//       builder: (_, __) => const SplashScreen(),
//     ),

//     // Login
//     GoRoute(
//       path: '/login',
//       name: 'login',
//       builder: (_, __) => const LoginPage(),
//     ),

//     // OTP
//     GoRoute(
//       path: '/otp',
//       name: 'otp',
//       builder: (context, state) =>
//           OTPScreen.fromGoRouter(context, state),
//     ),

//     // Dashboards
//     GoRoute(
//       path: '/dashboard/dealer',
//       name: 'dealer_dashboard',
//       builder: (_, __) => DealerDashboardPage(),
//     ),

//     GoRoute(
//       path: '/dashboard/superAdmin',
//       name: 'admin_dashboard',
//       builder: (_, __) => SuperAdminDashboard(),
//     ),

//     GoRoute(
//       path: '/dashboard/executive',
//       name: 'executive_dashboard',
//       builder: (_, __) => Executivedashboardpage(),
//     ),

//     GoRoute(
//       path: '/dashboard/chairman',
//       name: 'chairman_dashboard',
//       builder: (_, __) => ChairmanDashboard(),
//     ),

//     // Application
//     GoRoute(
//       path: '/application/list',
//       name: "application_list",
//       builder: (_, __) => const ApplicationScreen(),
//     ),

//     GoRoute(
//       path: '/details/application',
//       name: "application_details",
//       builder: (_, __) => const ApplicationDetailsScreen(),
//     ),

//     // Widgets
//     GoRoute(
//       path: '/widgets/dashboard',
//       name: 'dashboard_widgets',
//       builder: (_, __) => const DashboardWidgets(),
//     ),

//     // Owners
//     GoRoute(
//       path: '/list/owner',
//       name: 'owner_list',
//       builder: (_, __) => const OwnerScreen(),
//     ),

//     GoRoute(
//       path: '/details/owner',
//       name: 'owner_details',
//       builder: (_, state) =>
//           OwnerDetailsScreen(owner: state.extra as OwnerModel),
//     ),

//     // Drivers
//     GoRoute(
//       path: '/list/driver',
//       name: 'driver_list',
//       builder: (_, __) => const DriverScreenList(),
//     ),

//     GoRoute(
//       path: '/details/driver',
//       name: 'driver_details',
//       builder: (_, state) =>
//           DriverDetailsScreen(driver: state.extra as DriverModel),
//     ),

//     // Vehicles
//     GoRoute(
//       path: '/list/vehicle',
//       name: 'vehicle_list',
//       builder: (_, __) => const VehicleListScreen(),
//     ),

//     GoRoute(
//       path: '/details/vehicle',
//       name: 'vehicle_details',
//       builder: (_, state) =>
//           VehicleDetailsScreen(vehicle: state.extra as VehicleModel),
//     ),
//   ],
// );

// String _pathFromRouteName(String routeName) {
//   switch (routeName) {
//     case 'dealer_dashboard':
//       return '/dashboard/dealer';
//     case 'admin_dashboard':
//       return '/dashboard/superAdmin';
//     case 'executive_dashboard':
//       return '/dashboard/executive';
//     case 'chairman_dashboard':
//       return '/dashboard/chairman';
//     default:
//       return '/login';
//   }
// }
GoRouter appRouter(AuthProvider authProvider) {
  return GoRouter(
    // initialLocation: '/splash',
    initialLocation: '/dashboard/superAdmin',
    
    // This makes GoRouter react to login / logout
    refreshListenable: authProvider,

    redirect: (context, state) {
      final loggedIn = authProvider.isLoggedIn;
      final location = state.matchedLocation;

      // Allow splash always
      if (location == '/splash') return null;

      // Not logged in → force login
      if (!loggedIn) {
        if (location == '/login' || location == '/otp') return null;
        return '/login';
      }

      // Logged in → block auth screens
      if (loggedIn && (location == '/login' || location == '/otp')) {
        final role = authProvider.role;
        if (role == null) return '/login';

        // If RoleRouter returns route name, convert to path
        final routeName = RoleRouter.homeRouteForRole(role.name);
        return _pathFromRouteName(routeName);
      }

      return null;
    },

    routes: [
      // Splash
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (_, __) => const SplashScreen(),
      ),

      // Login
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (_, __) => const LoginPage(),
      ),

      // OTP
      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) => OTPScreen.fromGoRouter(context, state),
      ),

      // Dashboards
      GoRoute(
        path: '/dashboard/dealer',
        name: 'dealer_dashboard',
        builder: (_, __) => DealerDashboardPage(),
      ),

      GoRoute(
        path: '/dashboard/superAdmin',
        name: 'admin_dashboard',
        builder: (_, __) => SuperAdminDashboard(),
      ),

      GoRoute(
        path: '/dashboard/executive',
        name: 'executive_dashboard',
        builder: (_, __) => Executivedashboardpage(),
      ),

      GoRoute(
        path: '/dashboard/chairman',
        name: 'chairman_dashboard',
        builder: (_, __) => ChairmanDashboard(),
      ),

      // Application
      GoRoute(
        path: '/application/list',
        name: "application_list",
        builder: (_, __) => const ApplicationScreen(),
      ),

      GoRoute(
        path: '/details/application',
        name: "application_details",
        builder: (_, __) => const ApplicationDetailsScreen(),
      ),

      // Widgets
      GoRoute(
        path: '/widgets/dashboard',
        name: 'dashboard_widgets',
        builder: (_, __) => const DashboardWidgets(),
      ),

      // Owners
      GoRoute(
        path: '/list/owner',
        name: 'owner_list',
        builder: (_, __) => const OwnerScreen(),
      ),

      GoRoute(
        path: '/details/owner',
        name: 'owner_details',
        builder: (_, state) => OwnerDetailsScreen(owner: state.extra as OwnerModel),
      ),

      // Drivers
      GoRoute(
        path: '/list/driver',
        name: 'driver_list',
        builder: (_, __) => const DriverScreenList(),
      ),

      GoRoute(
        path: '/details/driver',
        name: 'driver_details',
        builder: (_, state) => DriverDetailsScreen(driver: state.extra as DriverModel),
      ),

      // Vehicles
      GoRoute(
        path: '/list/vehicle',
        name: 'vehicle_list',
        builder: (_, __) => const VehicleListScreen(),
      ),

      GoRoute(
        path: '/details/vehicle',
        name: 'vehicle_details',
        builder: (_, state) => VehicleDetailsScreen(vehicle: state.extra as VehicleModel),
      ),
    ],
  );
}

String _pathFromRouteName(String routeName) {
  switch (routeName) {
    case 'dealer_dashboard':
      return '/dashboard/dealer';
    case 'admin_dashboard':
      return '/dashboard/superAdmin';
    case 'executive_dashboard':
      return '/dashboard/executive';
    case 'chairman_dashboard':
      return '/dashboard/chairman';
    default:
      return '/login';
  }
}
