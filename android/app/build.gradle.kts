import java.io.FileInputStream
import java.util.Properties
import com.google.firebase.crashlytics.buildtools.gradle.CrashlyticsExtension

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.ferdidrgn.saglamspot"
    compileSdk = 37
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.ferdidrgn.saglamspot"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true

        // Network Security Config (SSL pinning + cleartext block)
        manifestPlaceholders["networkSecurityConfig"] = "@xml/network_security_config"

        // Backup kısıtlaması — hassas veri sızıntısını önler
        manifestPlaceholders["allowBackup"] = "false"

        // ABI filtreleri splits çakışması olmadan güvenli şekilde burada yönetilir
        ndk {
            abiFilters.addAll(setOf("armeabi-v7a", "arm64-v8a", "x86_64"))
        }
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            val storeFilePath = keystoreProperties["storeFile"] as String?
            storeFile = storeFilePath?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")

            // 🛡️ Güvenlik, Obfuscation & Optimizasyon
            isMinifyEnabled = true
            isShrinkResources = true
            isDebuggable = false

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

            ndk {
                debugSymbolLevel = "SYMBOL_TABLE"
            }

            configure<CrashlyticsExtension> {
                mappingFileUploadEnabled = true
                nativeSymbolUploadEnabled = true
            }

            // BuildConfig flag — release ortam konfigürasyonu
            buildConfigField("boolean", "IS_RELEASE", "true")
            buildConfigField("String", "BASE_URL", "\"https://saglamspotcu.web.app\"")
        }

        debug {
            isDebuggable = true
            buildConfigField("boolean", "IS_RELEASE", "false")
            buildConfigField("String", "BASE_URL", "\"https://saglamspotcu.web.app\"")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true  // API 21 altı desugar desteği
    }

    buildFeatures {
        buildConfig = true  // BuildConfig sınıfını aktif tutar
    }

    // Lint — üretim öncesi kod analiz denetimleri
    lint {
        checkReleaseBuilds = true
        abortOnError = false
        warningsAsErrors = false
        checkDependencies = true
    }

    packaging {
        resources {
            excludes += listOf(
                "/META-INF/{AL2.0,LGPL2.1}",
                "/META-INF/LICENSE*",
                "/META-INF/NOTICE*"
            )
        }
    }
}

dependencies {
    // AndroidX Core — Uçtan Uca ekran için güncel yerel kütüphaneler
    implementation("androidx.core:core-ktx:1.15.0")
    implementation("androidx.appcompat:appcompat:1.7.0")
    implementation("com.google.android.material:material:1.12.0")

    // Activity — enableEdgeToEdge pencere tetikleyicileri için
    implementation("androidx.activity:activity-ktx:1.9.3")

    // Firebase Mimari Bağımlılıkları (Aynen Korundu)
    implementation(platform("com.google.firebase:firebase-bom:33.7.0"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-crashlytics")

    // Desugar — Java 8+ modern API geriye dönük uyumluluk paketi
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}

tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinJvmCompile>().configureEach {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        freeCompilerArgs.add("-Xstdlib-call-evaluation-mode=strict")
    }
}