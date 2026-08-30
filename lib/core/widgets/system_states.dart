import 'package:flutter/material.dart';

import '../theme/orenza_theme.dart';

class AurenzaLoading extends StatelessWidget {
  final String message;

  const AurenzaLoading({super.key, this.message = 'Loading securely...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: OrenzaColors.slate,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AurenzaEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const AurenzaEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: OrenzaColors.gold),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: OrenzaColors.slate, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class AurenzaErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AurenzaErrorState({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 48,
              color: OrenzaColors.danger,
            ),
            const SizedBox(height: 16),
            const Text(
              'Backend unavailable',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: OrenzaColors.slate, height: 1.5),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class BackendStatusBadge extends StatelessWidget {
  final bool configured;
  final bool online;

  const BackendStatusBadge({
    super.key,
    required this.configured,
    required this.online,
  });

  @override
  Widget build(BuildContext context) {
    final active = configured && online;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: active
            ? OrenzaColors.successBackground
            : OrenzaColors.warningBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: active ? OrenzaColors.success : OrenzaColors.warning,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            active ? 'BACKEND ONLINE' : 'BACKEND PENDING',
            style: TextStyle(
              color: active ? OrenzaColors.success : OrenzaColors.warning,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: .8,
            ),
          ),
        ],
      ),
    );
  }
}
