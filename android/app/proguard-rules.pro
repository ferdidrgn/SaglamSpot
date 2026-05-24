# ================================================
# 🛡️ SAĞLAM SPOT - PROGUARD GÜVENLİK KURALLARI
# ================================================

# --- Temel Obfuscation Ayarları ---
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# --- Uyarıları Kapat ---
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**
-dontwarn javax.annotation.**
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-dontwarn org.openjsse.**
-dontwarn com.google.android.play.core.**

# --- Flutter Çekirdek ---
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.editing.** { *; }

# --- Firebase Güvenliği ---
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-keepclassmembers class com.google.firebase.** { *; }

# --- Play Store & Split Install Koruması ---
-keep class com.google.android.play.core.** { *; }

# --- Kotlin ---
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-keepclassmembers class **$WhenMappings { <fields>; }
-keepclassmembers class kotlin.Metadata {
    public <methods>;
}

# --- Kriptografi Koruması ---
-keepclassmembers class * {
    javax.crypto.** *;
}
-keep class javax.crypto.** { *; }
-keep class java.security.** { *; }

# --- R8 / Code Shrinking ---
-optimizationpasses 5
-allowaccessmodification
-repackageclasses ''
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*

# --- Android Manifest Bileşenleri ---
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.backup.BackupAgentHelper
-keep public class * extends android.preference.Preference

# --- Parcelable ---
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# --- Serializable ---
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# --- Enum ---
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# --- Uygulama Sınıfları ---
-keep class com.ferdidrgn.saglamspot.** { *; }

# --- AdMob ---
-keep class com.google.android.gms.ads.** { *; }
-dontwarn com.google.android.gms.ads.**

# --- Debug İzleme ---
-printmapping mapping.txt
-printseeds seeds.txt
-printusage unused.txt