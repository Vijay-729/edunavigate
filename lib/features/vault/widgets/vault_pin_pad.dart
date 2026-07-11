import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// 6-digit PIN pad: dot indicator + numeric keypad, used by both PIN setup
/// and the lock screen. [onComplete] fires once 6 digits are entered; the
/// caller decides what happens next (confirm, verify, etc.) and calls
/// [VaultPinPadController.clear] / [VaultPinPadController.shake] as needed.
class VaultPinPadController {
  _VaultPinPadState? _state;

  void clear() => _state?._clear();
  void shake() => _state?._shake();
}

class VaultPinPad extends StatefulWidget {
  const VaultPinPad({
    super.key,
    required this.onComplete,
    this.controller,
    this.showBiometricButton = false,
    this.onBiometricTap,
    this.length = 6,
  });

  final ValueChanged<String> onComplete;
  final VaultPinPadController? controller;
  final bool showBiometricButton;
  final VoidCallback? onBiometricTap;
  final int length;

  @override
  State<VaultPinPad> createState() => _VaultPinPadState();
}

class _VaultPinPadState extends State<VaultPinPad>
    with SingleTickerProviderStateMixin {
  String _entered = '';
  late final AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    widget.controller?._state = this;
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _clear() => setState(() => _entered = '');

  void _shake() {
    _shakeController.forward(from: 0);
    _clear();
  }

  void _onDigit(String digit) {
    if (_entered.length >= widget.length) return;
    setState(() => _entered += digit);
    if (_entered.length == widget.length) {
      final value = _entered;
      Future.delayed(const Duration(milliseconds: 120), () {
        if (mounted) widget.onComplete(value);
      });
    }
  }

  void _onBackspace() {
    if (_entered.isEmpty) return;
    setState(() => _entered = _entered.substring(0, _entered.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _shakeController,
          builder: (context, child) {
            final t = _shakeController.value;
            final offset = (t == 0 || t == 1)
                ? 0.0
                : (16 * (0.5 - (t * 4).round() % 2)) * (1 - t);
            return Transform.translate(
              offset: Offset(offset, 0),
              child: child,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.length, (i) {
              final filled = i < _entered.length;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.symmetric(horizontal: 7),
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: filled
                      ? AppColors.accent
                      : Colors.white.withValues(alpha: 0.12),
                  border: Border.all(
                    color: filled
                        ? AppColors.accent
                        : Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 36),
        _Keypad(
          onDigit: _onDigit,
          onBackspace: _onBackspace,
          showBiometric: widget.showBiometricButton,
          onBiometricTap: widget.onBiometricTap,
        ),
      ],
    );
  }
}

class _Keypad extends StatelessWidget {
  const _Keypad({
    required this.onDigit,
    required this.onBackspace,
    required this.showBiometric,
    required this.onBiometricTap,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final bool showBiometric;
  final VoidCallback? onBiometricTap;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final digit in row)
                  _PadKey(label: digit, onTap: () => onDigit(digit)),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showBiometric)
                _PadKey(
                  icon: Icons.fingerprint_rounded,
                  onTap: onBiometricTap ?? () {},
                )
              else
                const SizedBox(width: 72, height: 72),
              _PadKey(label: '0', onTap: () => onDigit('0')),
              _PadKey(icon: Icons.backspace_outlined, onTap: onBackspace),
            ],
          ),
        ),
      ],
    );
  }
}

class _PadKey extends StatelessWidget {
  const _PadKey({this.label, this.icon, required this.onTap});

  final String? label;
  final IconData? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        color: Colors.white.withValues(alpha: 0.06),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 72,
            height: 72,
            child: Center(
              child: label != null
                  ? Text(
                      label!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : Icon(icon, color: Colors.white70, size: 24),
            ),
          ),
        ),
      ),
    );
  }
}
