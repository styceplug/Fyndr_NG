import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.dreamsoftware.fyndr.fyndr_ng"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.dreamsoftware.fyndr.fyndr_ng"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                val storeFilePath = keystoreProperties["storeFile"] as String?
                val storePasswordVal = keystoreProperties["storePassword"] as String?
                val keyAliasVal = keystoreProperties["keyAlias"] as String?
                val keyPasswordVal = keystoreProperties["keyPassword"] as String?

                if (
                    !storeFilePath.isNullOrBlank() &&
                    !storePasswordVal.isNullOrBlank() &&
                    !keyAliasVal.isNullOrBlank() &&
                    !keyPasswordVal.isNullOrBlank()
                ) {
                    storeFile = file(storeFilePath)
                    storePassword = storePasswordVal
                    keyAlias = keyAliasVal
                    keyPassword = keyPasswordVal
                } else {
                    println("⚠️ key.properties exists but is missing required signing fields. Release signing will be skipped.")
                }
            } else {
                println("ℹ️ key.properties not found. Release signing will be skipped.")
            }
        }


    }

    buildTypes {
        getByName("debug") {
            // debug uses default debug keystore automatically
        }

        getByName("release") {
            // Only apply signing if storeFile was actually set
            if (signingConfigs.getByName("release").storeFile != null) {
                signingConfig = signingConfigs.getByName("release")
            }
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }
}




flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
