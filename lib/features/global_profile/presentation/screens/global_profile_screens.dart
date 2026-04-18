import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/bootstrap/app_bootstrap_controller.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radii.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_screen_scaffold.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/profile_nav_tile.dart';

class ProfileOverviewScreen extends StatelessWidget {
  const ProfileOverviewScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  String get _modeLabel => bootstrap.isGuestMode ? 'GUEST' : 'ACCOUNT';

  String _routeWithOrigin(BuildContext context, String route) {
    final String? origin = _originRouteFromContext(context);
    if (origin == null) {
      return route;
    }
    return '$route?origin=${Uri.encodeComponent(origin)}';
  }

  String _routeWithReturnTo(BuildContext context, String route) {
    final String? origin = _originRouteFromContext(context);
    final String returnTo = origin ?? GoRouterState.of(context).uri.toString();
    final Map<String, String> queryParameters = <String, String>{
      'returnTo': returnTo,
      if (origin != null) 'origin': origin,
    };
    return Uri(path: route, queryParameters: queryParameters).toString();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bootstrap,
      builder: (context, _) {
        return GlobalScreenScaffold(
          title: 'Profile',
          subtitle: 'Guest-first overview',
          originRoute: _originRouteFromContext(context),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              AppCard(
                variant: AppCardVariant.primary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Current mode',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.accentStrong,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      bootstrap.isGuestMode
                          ? 'You are using the app in guest mode'
                          : 'Your account mode is active',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(fontSize: 30),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      bootstrap.isGuestMode
                          ? 'This device keeps your starter preferences locally until you choose account sync.'
                          : 'Your account can now keep your preferences with you on this device.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        _SummaryPill(label: 'Mode', value: _modeLabel),
                        _SummaryPill(
                          label: 'Categories',
                          value: '${bootstrap.selectedCategories.length}',
                        ),
                        _SummaryPill(
                          label: 'Notifications',
                          value: bootstrap.notificationsEnabled ? 'On' : 'Off',
                        ),
                        _SummaryPill(
                          label: 'Daily time',
                          value: bootstrap.dailyNotificationLabel,
                        ),
                      ],
                    ),
                    if (bootstrap.authFeedbackMessage != null) ...<Widget>[
                      const SizedBox(height: AppSpacing.lg),
                      _NoticeBanner(message: bootstrap.authFeedbackMessage!),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ProfileInfoCard(
                title: 'Profile options',
                subtitle:
                    'Manage how this device is being used and learn about optional account features.',
                icon: Icons.person_outline_rounded,
                child: Column(
                  children: <Widget>[
                    ProfileNavTile(
                      title: 'Auth status',
                      subtitle:
                          'See whether you are currently using guest mode or account mode.',
                      icon: Icons.badge_outlined,
                      trailingLabel: _modeLabel,
                      onTap: () => context.push(
                        _routeWithOrigin(context, AppRoutes.profileAuthStatus),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ProfileNavTile(
                      title: 'Data sync',
                      subtitle:
                          'See what stays on this device and what can follow your account.',
                      icon: Icons.sync_outlined,
                      onTap: () => context.push(
                        _routeWithOrigin(context, AppRoutes.profileDataSync),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (bootstrap.isGuestMode) ...<Widget>[
                      ProfileNavTile(
                        title: 'Sign in',
                        subtitle:
                            'Sign in when you want your preferences to follow your account.',
                        icon: Icons.login_rounded,
                        onTap: () => context.push(
                          _routeWithReturnTo(context, AppRoutes.profileSignIn),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ProfileNavTile(
                        title: 'Sign up',
                        subtitle:
                            'Create an account and prepare this device for cross-device continuity later on.',
                        icon: Icons.person_add_alt_1_rounded,
                        onTap: () => context.push(
                          _routeWithReturnTo(context, AppRoutes.profileSignUp),
                        ),
                      ),
                    ] else ...<Widget>[
                      ProfileNavTile(
                        title: 'Sign out',
                        subtitle:
                            'End the current account session and stay usable in guest mode.',
                        icon: Icons.logout_rounded,
                        onTap: () => context.push(
                          _routeWithReturnTo(context, AppRoutes.profileSignOut),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AuthStatusScreen extends StatelessWidget {
  const AuthStatusScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bootstrap,
      builder: (context, _) {
        return GlobalScreenScaffold(
          title: 'Auth status',
          subtitle: 'Current access mode',
          originRoute: _originRouteFromContext(context),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              ProfileInfoCard(
                title: bootstrap.isGuestMode
                    ? 'Guest mode active'
                    : 'Account mode active',
                subtitle:
                    'A simple view of how you are using the app right now.',
                icon: bootstrap.isGuestMode
                    ? Icons.person_outline_rounded
                    : Icons.verified_rounded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _StatusRow(
                      label: 'Account features',
                      value: bootstrap.cloudSyncAvailable
                          ? 'Available'
                          : 'Not available in this build',
                    ),
                    _StatusRow(
                      label: 'Mode',
                      value: bootstrap.isGuestMode ? 'Guest' : 'Account',
                    ),
                    _StatusRow(
                      label: 'Email',
                      value: bootstrap.accountEmail ?? 'Not signed in',
                    ),
                    _StatusRow(
                      label: 'Display name',
                      value: bootstrap.isGuestMode
                          ? 'Guest user'
                          : (bootstrap.accountDisplayName ?? 'Account user'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ProfileInfoCard(
                title: 'How access works',
                icon: Icons.layers_outlined,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _ProfileBullet(
                      text:
                          'Guest mode saves onboarding, reminder, category, and widget preferences locally on this device.',
                    ),
                    _ProfileBullet(
                      text:
                          'Account mode keeps your main reading preferences connected to your sign-in.',
                    ),
                    _ProfileBullet(
                      text:
                          'Some saved reading items still remain on this device for now.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DataSyncScreen extends StatelessWidget {
  const DataSyncScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bootstrap,
      builder: (context, _) {
        return GlobalScreenScaffold(
          title: 'Data sync',
          subtitle: 'This device and future account sync',
          originRoute: _originRouteFromContext(context),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Your current sync view',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      bootstrap.isGuestMode
                          ? 'Your preferences are currently tied to this device'
                          : 'Your preferences can now follow your account',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(fontSize: 30),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Your main reading preferences can stay with this device now and expand to account-based continuity as support becomes available.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ProfileInfoCard(
                title: 'What is local right now',
                icon: Icons.phone_android_outlined,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _ProfileBullet(
                      text:
                          'Onboarding, reminder choices, widget preferences, and selected categories stay on this device in guest mode.',
                    ),
                    _ProfileBullet(
                      text:
                          'Guest mode stays fully usable even when account features are unavailable.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ProfileInfoCard(
                title: 'What can follow your account',
                icon: Icons.cloud_outlined,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _ProfileBullet(
                      text:
                          'Your display name and key profile details can be tied to your account.',
                    ),
                    _ProfileBullet(
                      text:
                          'Reading, reminder, and widget preferences can follow your sign-in.',
                    ),
                    _ProfileBullet(
                      text:
                          'Your selected Today categories can stay connected to your account.',
                    ),
                    _ProfileBullet(
                      text:
                          'Today stays aligned after sign-in so your daily verse remains consistent.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ProfileInfoCard(
                title: 'What is still ahead',
                icon: Icons.schedule_outlined,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _ProfileBullet(
                      text:
                          'Bookmarks, highlights, notes, and progress still need fuller account sync support.',
                    ),
                    _ProfileBullet(
                      text:
                          'Reading continuity will keep becoming smoother across devices over time.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.bootstrap, this.returnTo});

  final AppBootstrapController bootstrap;
  final String? returnTo;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final result = await widget.bootstrap.signInWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(result.message)));

    if (result.success) {
      _goToPostAuthDestination(context, widget.returnTo);
    }
  }

  Future<void> _sendRecovery() async {
    final String email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter your email first.')));
      return;
    }

    final result = await widget.bootstrap.sendPasswordResetEmail(email);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(result.message)));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.bootstrap,
      builder: (context, _) {
        return GlobalScreenScaffold(
          title: 'Sign in',
          subtitle: 'Optional account access',
          originRoute: _originRouteFromContext(context),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              ProfileInfoCard(
                title: 'Sign in is optional',
                subtitle:
                    'Use an account when you want your preferences to follow you more easily.',
                icon: Icons.login_rounded,
                child: Text(
                  widget.bootstrap.cloudSyncAvailable
                      ? 'You can keep using guest mode, or sign in whenever you want account-based continuity.'
                      : 'Account features are not available in this build yet, so you can keep using guest mode.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Email sign in',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'you@example.com',
                        ),
                        validator: (value) {
                          final String text = (value ?? '').trim();
                          if (text.isEmpty) return 'Enter your email.';
                          if (!text.contains('@'))
                            return 'Enter a valid email.';
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        validator: (value) {
                          if ((value ?? '').isEmpty) {
                            return 'Enter your password.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: widget.bootstrap.authBusy ? null : _submit,
                          child: Text(
                            widget.bootstrap.authBusy
                                ? 'Working...'
                                : 'Sign in',
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: widget.bootstrap.authBusy
                              ? null
                              : _sendRecovery,
                          child: const Text('Send password recovery email'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.bootstrap, this.returnTo});

  final AppBootstrapController bootstrap;
  final String? returnTo;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final result = await widget.bootstrap.signUpWithEmail(
      displayName: _displayNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(result.message)));

    if (result.success) {
      _goToPostAuthDestination(context, widget.returnTo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.bootstrap,
      builder: (context, _) {
        return GlobalScreenScaffold(
          title: 'Sign up',
          subtitle: 'Create an optional account',
          originRoute: _originRouteFromContext(context),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              ProfileInfoCard(
                title: 'An account is not required',
                subtitle:
                    'Reading stays open and available whether you create an account or not.',
                icon: Icons.person_add_alt_1_rounded,
                child: const Text(
                  'Your main preferences can follow your account, while some saved reading items still stay on this device for now.',
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Create account',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: _displayNameController,
                        decoration: const InputDecoration(
                          labelText: 'Display name',
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) {
                            return 'Enter a display name.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'you@example.com',
                        ),
                        validator: (value) {
                          final String text = (value ?? '').trim();
                          if (text.isEmpty) return 'Enter your email.';
                          if (!text.contains('@'))
                            return 'Enter a valid email.';
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        validator: (value) {
                          if ((value ?? '').length < 8) {
                            return 'Use at least 8 characters.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirm password',
                        ),
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: widget.bootstrap.authBusy ? null : _submit,
                          child: Text(
                            widget.bootstrap.authBusy
                                ? 'Working...'
                                : 'Create account',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SignOutScreen extends StatelessWidget {
  const SignOutScreen({super.key, required this.bootstrap, this.returnTo});

  final AppBootstrapController bootstrap;
  final String? returnTo;

  Future<void> _submit(BuildContext context) async {
    final result = await bootstrap.signOut();
    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(result.message)));

    _goToPostAuthDestination(context, returnTo);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bootstrap,
      builder: (context, _) {
        return GlobalScreenScaffold(
          title: 'Sign out',
          subtitle: 'Account and guest use on this device',
          originRoute: _originRouteFromContext(context),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              ProfileInfoCard(
                title: bootstrap.isGuestMode
                    ? 'You are already in guest mode'
                    : 'Signed-in access',
                subtitle:
                    'A simple explanation of how the app handles account and guest use.',
                icon: Icons.logout_rounded,
                child: Text(
                  bootstrap.isGuestMode
                      ? 'There is no account session to end right now, so you can simply keep reading in guest mode.'
                      : 'Signing out ends your current account session while keeping the app usable in guest mode.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: bootstrap.authBusy ? null : () => _submit(context),
                  child: Text(
                    bootstrap.authBusy ? 'Working...' : 'Sign out now',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AuthCallbackScreen extends StatefulWidget {
  const AuthCallbackScreen({super.key, required this.bootstrap, this.returnTo});

  final AppBootstrapController bootstrap;
  final String? returnTo;

  @override
  State<AuthCallbackScreen> createState() => _AuthCallbackScreenState();
}

class _AuthCallbackScreenState extends State<AuthCallbackScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.bootstrap.clearPendingAuthRedirect();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScreenScaffold(
      title: 'Account ready',
      subtitle: 'Sign-in completed',
      originRoute: _originRouteFromContext(context),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: <Widget>[
          ProfileInfoCard(
            title: 'Session updated',
            subtitle:
                'Your sign-in finished successfully and your account session is now ready.',
            icon: Icons.mark_email_read_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.bootstrap.authFeedbackMessage ??
                      'Your account session is now active.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () =>
                        _goToPostAuthDestination(context, widget.returnTo),
                    child: const Text('Back to profile'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.bootstrap,
    this.returnTo,
  });

  final AppBootstrapController bootstrap;
  final String? returnTo;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.bootstrap.clearPendingAuthRedirect();
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final result = await widget.bootstrap.updatePassword(
      _passwordController.text,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(result.message)));

    if (result.success) {
      _goToPostAuthDestination(context, widget.returnTo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.bootstrap,
      builder: (context, _) {
        return GlobalScreenScaffold(
          title: 'Reset password',
          subtitle: 'Choose a new password',
          originRoute: _originRouteFromContext(context),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              ProfileInfoCard(
                title: 'Choose a new password',
                subtitle: 'Create a new password to finish account recovery.',
                icon: Icons.lock_reset_rounded,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'New password',
                        ),
                        validator: (value) {
                          if ((value ?? '').length < 8) {
                            return 'Use at least 8 characters.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirm new password',
                        ),
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: widget.bootstrap.authBusy ? null : _submit,
                          child: Text(
                            widget.bootstrap.authBusy
                                ? 'Working...'
                                : 'Update password',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NoticeBanner extends StatelessWidget {
  const _NoticeBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(padding: const EdgeInsets.all(14), child: Text(message)),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileBullet extends StatelessWidget {
  const _ProfileBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Icon(Icons.circle, size: 8, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

void _goToPostAuthDestination(BuildContext context, String? returnTo) {
  context.go(_resolvePostAuthDestination(returnTo));
}

String _resolvePostAuthDestination(String? returnTo) {
  final String candidate = (returnTo ?? '').trim();
  if (candidate.isEmpty) {
    return AppRoutes.profileOverview;
  }

  final Uri? uri = Uri.tryParse(candidate);
  final String path = uri?.path ?? '';
  if (_isSafePostAuthPath(path)) {
    final String query = uri?.hasQuery == true ? '?${uri!.query}' : '';
    final String fragment = uri?.fragment.isNotEmpty == true
        ? '#${uri!.fragment}'
        : '';
    return '$path$query$fragment';
  }

  return AppRoutes.profileOverview;
}

bool _isSafePostAuthPath(String path) {
  if (path.isEmpty) {
    return false;
  }

  const Set<String> blockedPaths = <String>{
    AppRoutes.profileSignIn,
    AppRoutes.profileSignUp,
    AppRoutes.profileSignOut,
    AppRoutes.authCallback,
    AppRoutes.authResetPassword,
  };
  if (blockedPaths.contains(path)) {
    return false;
  }

  return path.startsWith('/tab_') ||
      path.startsWith('/global_') ||
      path == AppRoutes.profileOverview;
}

String? _originRouteFromContext(BuildContext context) {
  final String raw =
      (GoRouterState.of(context).uri.queryParameters['origin'] ?? '').trim();
  if (raw.isEmpty) {
    return null;
  }

  final Uri? uri = Uri.tryParse(raw);
  final String path = uri?.path ?? '';
  if (!_isSafeOriginPath(path)) {
    return null;
  }

  final String query = uri?.hasQuery == true ? '?${uri!.query}' : '';
  final String fragment = uri?.fragment.isNotEmpty == true
      ? '#${uri!.fragment}'
      : '';
  return '$path$query$fragment';
}

bool _isSafeOriginPath(String path) {
  if (path.isEmpty) {
    return false;
  }

  return !path.startsWith('/auth/') &&
      !path.startsWith('/global_profile/') &&
      !path.startsWith('/global_settings/');
}
