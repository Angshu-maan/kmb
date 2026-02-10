lib/
│
├── core/                         # App-wide, feature-agnostic
│   │
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_styles.dart
│   │   └── app_text.dart
│   │
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── app_dark_theme.dart
│   │
│   ├── router/                   # go_router config
│   │   ├── app_router.dart
│   │   └── route_paths.dart
│   │
│   ├── errors/
│   │   ├── failures.dart
│   │   └── exceptions.dart
│   │
│   ├── network/
│   │   ├── api_client.dart
│   │   ├── network_info.dart
│   │   └── interceptors.dart
│   │
│   ├── utils/
│   │   ├── date_utils.dart
│   │   ├── dialog_utils.dart
│   │   └── otp_validator.dart
│   │
│   └── widgets/                  # Reusable UI components
│       ├── info_row.dart
│       ├── section_card.dart
│       ├── status_chip.dart
│       └── bars/
│           ├── app_bottom_bar.dart
│           ├── app_sidebar.dart
│           └── app_topbar.dart
│
├── features/                     # Feature-first (DDD style)
│   │
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       └── logout_usecase.dart
│   │   │
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── auth_provider.dart
│   │       ├── screens/
│   │       │   ├── splash_screen.dart
│   │       │   ├── login_screen.dart
│   │       │   └── otp_screen.dart
│   │       └── widgets/
│   │
│   ├── admin/
│   │   ├── dashboard/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │
│   │   ├── drivers/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │
│   │   ├── owners/
│   │   ├── vehicles/
│   │   └── applications/
│
├── shared/                       # Cross-feature shared widgets
│   ├── widgets/
│   │   ├── empty_state.dart
│   │   ├── loading_indicator.dart
│   │   └── primary_button.dart
│   └── back_button_handler.dart
│
├── injection.dart                # Dependency Injection
├── app.dart                      # MaterialApp.router
└── main.dart
