// This is a mock file replacing the Firebase options.
// We're using mock services instead of Firebase for this demo.

/// Mock Firebase Options class
class MockFirebaseOptions {
  // This class exists only to satisfy any imports that may still reference the
  // firebase_options.dart file, but it is not actually used in our mock implementation.
  static String get mockInfo => 'Using mock services instead of Firebase';
}