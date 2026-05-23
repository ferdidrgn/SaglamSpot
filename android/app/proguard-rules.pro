# 🛡️ Sağlam Spot ProGuard Güvenlik Kuralları

# Kod satır numaralarını ve kaynak dosya isimlerini silerek decompile kaynak kodunu okunamaz yap
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# Firebase ve Google kütüphanelerini koru (Çökmemesi için gerekli)
-keep attributes *Annotation*
-keep attributes Signature
-keep attributes InnerClasses
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Flutter Native kütüphane bağlantılarını zırhla
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Kriptografik algoritmaların optimize edilerek zayıflatılmasını engelle
-keepclassmembers class * {
    javax.crypto.** *;
}