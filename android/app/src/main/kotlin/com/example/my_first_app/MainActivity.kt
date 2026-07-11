package com.example.my_first_app

import io.flutter.embedding.android.FlutterFragmentActivity

// FlutterFragmentActivity (not FlutterActivity) is required by local_auth for
// the biometric prompt (EduVault's PIN/fingerprint/Face lock) to work.
class MainActivity : FlutterFragmentActivity()
