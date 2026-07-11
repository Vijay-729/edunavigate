import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/theme/app_colors.dart';
import '../models/selected_location.dart';
import '../providers/explore_providers.dart';
import '../services/nearby_places_service.dart';

/// Shows the shared "Select Your Location" bottom sheet (common to Nearby
/// Colleges, Nearby Schools and Coaching Explorer) and, if the student
/// picks a location, persists it via [selectedLocationProvider]. Returns the
/// chosen location, or null if the sheet was dismissed without one.
Future<SelectedLocation?> showLocationSelectionSheet(
  BuildContext context,
  WidgetRef ref,
) async {
  final result = await showModalBottomSheet<SelectedLocation>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const LocationSelectionSheet(),
  );
  if (result != null) {
    await ref.read(selectedLocationProvider.notifier).setLocation(result);
  }
  return result;
}

enum _LocationChoice { gps, manual }

class LocationSelectionSheet extends StatefulWidget {
  const LocationSelectionSheet({super.key});

  @override
  State<LocationSelectionSheet> createState() => _LocationSelectionSheetState();
}

class _LocationSelectionSheetState extends State<LocationSelectionSheet> {
  _LocationChoice _choice = _LocationChoice.gps;
  bool _resolving = false;
  String? _errorMessage;
  String? _errorActionLabel;
  VoidCallback? _errorAction;

  final _searchController = TextEditingController();
  Timer? _debounce;
  List<SelectedLocation> _results = [];
  bool _searching = false;
  SelectedLocation? _manualSelection;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    setState(() {
      _manualSelection = null;
      _errorMessage = null;
    });
    if (value.trim().length < 2) {
      setState(() => _results = []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() => _searching = true);
      final results = await NearbyPlacesService.searchCities(value);
      if (mounted) {
        setState(() {
          _results = results;
          _searching = false;
        });
      }
    });
  }

  Future<void> _handleContinue() async {
    setState(() => _errorMessage = null);
    if (_choice == _LocationChoice.manual) {
      if (_manualSelection == null) {
        setState(() => _errorMessage = 'Please select a city or area first.');
        return;
      }
      Navigator.pop(context, _manualSelection);
      return;
    }
    await _useGps();
  }

  Future<void> _useGps() async {
    setState(() {
      _resolving = true;
      _errorMessage = null;
      _errorAction = null;
      _errorActionLabel = null;
    });
    try {
      final position = await NearbyPlacesService.getCurrentLocation();
      final cs = await NearbyPlacesService.cityStateComponents(
          position.latitude, position.longitude);
      final location = SelectedLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        source: LocationSource.gps,
        city: cs.city,
        state: cs.state,
      );
      if (mounted) Navigator.pop(context, location);
    } on AppLocationServiceDisabledException {
      setState(() {
        _errorMessage = 'Your device\'s location services are off. Enable '
            'GPS to use your current location.';
        _errorActionLabel = 'Enable Location';
        _errorAction = () => Geolocator.openLocationSettings();
      });
    } on LocationPermissionDeniedException {
      setState(() {
        _errorMessage = 'EduNavigate AI needs location permission to find '
            'institutions near you. Please allow it and try again.';
      });
    } on LocationPermissionDeniedForeverException {
      setState(() {
        _errorMessage = 'Location permission is blocked. Enable it from '
            'Settings to use your current location.';
        _errorActionLabel = 'Open Settings';
        _errorAction = () => Geolocator.openAppSettings();
      });
    } catch (_) {
      setState(() {
        _errorMessage = 'Could not detect your location. Please try again '
            'or search a city manually.';
      });
    } finally {
      if (mounted) setState(() => _resolving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFF0B1830),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.location_on_rounded,
                        color: AppColors.accent, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Select Your Location',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose how you want to search nearby institutions.',
                style:
                    TextStyle(color: Colors.white54, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 22),
              _OptionCard(
                icon: Icons.my_location_rounded,
                title: 'Use My Current Location',
                subtitle: 'Recommended',
                selected: _choice == _LocationChoice.gps,
                onTap: () => setState(() {
                  _choice = _LocationChoice.gps;
                  _errorMessage = null;
                }),
              ),
              const SizedBox(height: 12),
              _OptionCard(
                icon: Icons.search_rounded,
                title: 'Search City / Area Manually',
                subtitle: 'e.g. Delhi, Jammu, Pune, Mumbai',
                selected: _choice == _LocationChoice.manual,
                onTap: () => setState(() {
                  _choice = _LocationChoice.manual;
                  _errorMessage = null;
                }),
              ),
              if (_choice == _LocationChoice.manual) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search city, e.g. Bangalore, Chandigarh…',
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: _searching
                        ? const Padding(
                            padding: EdgeInsets.all(14),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: AppColors.accent),
                            ),
                          )
                        : const Icon(Icons.search_rounded,
                            color: Colors.white38, size: 20),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.06),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                if (_results.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 220),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: _results.length,
                      separatorBuilder: (_, __) =>
                          const Divider(color: Colors.white12, height: 1),
                      itemBuilder: (_, i) {
                        final r = _results[i];
                        final selected = identical(_manualSelection, r);
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            selected
                                ? Icons.radio_button_checked_rounded
                                : Icons.location_on_outlined,
                            color: selected ? AppColors.accent : Colors.white38,
                            size: 20,
                          ),
                          title: Text(
                            r.label,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13.5),
                          ),
                          subtitle: r.displayName == null
                              ? null
                              : Text(
                                  r.displayName!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white38, fontSize: 11.5),
                                ),
                          onTap: () => setState(() {
                            _manualSelection = r;
                            _errorMessage = null;
                          }),
                        );
                      },
                    ),
                  ),
                ] else if (_searchController.text.trim().length >= 2 &&
                    !_searching) ...[
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text('No matching cities found.',
                        style:
                            TextStyle(color: Colors.white38, fontSize: 12.5)),
                  ),
                ],
              ],
              if (_errorMessage != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.redAccent.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_errorMessage!,
                          style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12.5,
                              height: 1.4)),
                      if (_errorAction != null) ...[
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _errorAction,
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          child: Text(_errorActionLabel ?? 'Fix this',
                              style: const TextStyle(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.5)),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: _resolving ? null : _handleContinue,
                  child: _resolving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.4, color: Colors.white),
                        )
                      : const Text('Continue',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.16)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: selected ? AppColors.primary : Colors.white12,
              width: selected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: selected ? AppColors.accent : Colors.white38,
              size: 20,
            ),
            const SizedBox(width: 12),
            Icon(icon,
                color: selected ? AppColors.accent : Colors.white54, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.5,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          color: Colors.white38, fontSize: 11.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
