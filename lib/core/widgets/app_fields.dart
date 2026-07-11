import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

InputDecoration _fieldDecoration(String hint, IconData icon, {Widget? suffix}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppColors.textMuted),
    prefixIcon: Icon(icon, color: AppColors.textSecondary),
    suffixIcon: suffix,
    filled: true,
    fillColor: Colors.white.withValues(alpha: 0.08),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    ),
  );
}

/// Themed text field used across onboarding forms.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.controller,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
  });

  final String hint;
  final IconData icon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: _fieldDecoration(hint, icon),
    );
  }
}

/// Themed obscured password field with a visibility toggle.
class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    super.key,
    required this.hint,
    this.controller,
  });

  final String hint;
  final TextEditingController? controller;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscure,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: _fieldDecoration(
        widget.hint,
        Icons.lock_outline,
        suffix: IconButton(
          onPressed: () => setState(() => _obscure = !_obscure),
          icon: Icon(
            _obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

/// Themed dropdown used for gender, state, education level, etc.
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.value,
    required this.hint,
    required this.icon,
    required this.items,
    required this.onChanged,
  });

  final T? value;
  final String hint;
  final IconData icon;
  final List<T> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      dropdownColor: AppColors.dropdownSurface,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: _fieldDecoration(hint, icon),
      items: items
          .map(
            (e) => DropdownMenuItem<T>(
              value: e,
              child: Text(e.toString(), overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

/// Floating error/info snackbar helper.
void showAppSnack(BuildContext context, String message, {bool error = true}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : AppColors.primary,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
}
