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

# --- Flutter / Firebase / Play Services / Play Core / Kotlin ---
# Önceden burada io.flutter.**, com.google.firebase.**, com.google.android.gms.**,
# com.google.android.play.core.** ve kotlin.** için blok "-keep class X.** { *; }"
# kuralları vardı — bu bağımlılık ağaçları uygulamanın DEX kodunun büyük
# kısmını oluşturuyor, bu yüzden hepsini karartmadan (obfuscation) muaf
# tutmak Play Console'un "Kod Karartma" vitals metriğini ~%19'a düşürüyordu
# (eşik %25). Bu SDK'ların hepsi (Flutter engine, tüm Firebase paketleri,
# Play Services, Kotlin stdlib) yıllardır kendi AAR'larının içinde R8
# "consumer proguard rules" taşıyor — yani gerçekten JNI/reflection'la
# erişilen ne varsa zaten otomatik korunuyor; burada tekrar blok halinde
# tutmaya gerek yok. Bu uygulama Firebase'e sadece Dart tarafındaki resmi
# eklentiler (cloud_firestore vb.) üzerinden erişiyor — native tarafta elle
# POJO/reflection eşlemesi yapılmıyor (bkz. ProductModel.fromFirestore gibi
# Dart factory'ler); Play Core ise pubspec.yaml'da hiç kullanılmıyor
# (in_app_update/in_app_review yok) — hepsi bu kaldırmayı güvenli kılıyor.
-dontwarn kotlin.**
-keep class kotlin.Metadata { *; }
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
# Tüm paketi tutan blok kural kaldırıldı — manifest'te native tarafta
# tanımlı tek sınıf MainActivity, o da yukarıdaki "extends
# android.app.Activity" kuralıyla zaten korunuyor. Reflection'la
# çağrılan başka bir native sınıf yok.

# --- AdMob ---
-keep class com.google.android.gms.ads.** { *; }
-dontwarn com.google.android.gms.ads.**

# --- Debug İzleme ---
-printmapping mapping.txt
-printseeds seeds.txt
-printusage unused.txt