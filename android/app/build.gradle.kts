plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.flow_flutter_new"
    compileSdk = 35
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    buildFeatures {
        compose = true // ✅ Enable Compose
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }
    composeOptions {
        kotlinCompilerExtensionVersion = "1.5.3" // ✅ Match your Kotlin version (e.g., 1.9.x)
    }
    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.flow_flutter_new"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}


dependencies {
    implementation("com.checkout:checkout-android-components:1.0.0-beta-6")
     // Lifecycle + ViewModel
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.8.7")

//    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.8.7")//new


    implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:2.8.7")
    implementation("androidx.activity:activity-ktx:1.10.1")
    implementation("androidx.activity:activity-compose:1.10.1")
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:2.8.7")
    implementation("androidx.lifecycle:lifecycle-extensions:2.2.0")
    implementation("androidx.savedstate:savedstate:1.2.1")
    // ✅ Required for ViewTreeLifecycleOwner
//    implementation("androidx.activity:activity-compose:1.10.1")
    // ✅ Compose BOM (manages all versions consistently)
    implementation(platform("androidx.compose:compose-bom:2025.03.01"))

    // ✅ Core Compose UI libraries
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation ("androidx.appcompat:appcompat:1.7.0")
    // ✅ Material Design Components (M3)
    implementation("androidx.compose.material3:material3")
    implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:2.9.0-alpha13")
    implementation("androidx.lifecycle:lifecycle-viewmodel:2.9.0-alpha13")

    implementation("com.google.android.gms:play-services-wallet:19.4.0")
    implementation("com.google.android.gms:play-services-base:18.6.0")

    // ✅ Lifecycle + Activity Compose Integration
//    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.8.7")
//    implementation("androidx.activity:activity-compose:1.10.1")

}