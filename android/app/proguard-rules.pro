# Flutter and Firebase proguard rules
# Keep Flutter embedding classes
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.app.** { *; }

# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Keep Gson/Json models if used via reflection
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

# Keep Kotlin metadata
-keepclassmembers class kotlin.Metadata { *; }

# Keep classes referenced from native code
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep ProGuard/obfuscation mapping useful attributes
-keepattributes Exceptions,InnerClasses,Signature,Deprecated,SourceFile,LineNumberTable,*Annotation*

# Keep parcelable implementations
-keepclassmembers class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator CREATOR;
}

# If you use reflection or libraries that require keep rules, add them here.

# Keep Play Core classes used for Play Store deferred components
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Keep SplitCompat and deferred component manager classes referenced by Flutter
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class io.flutter.embedding.android.FlutterPlayStoreSplitApplication { *; }
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
