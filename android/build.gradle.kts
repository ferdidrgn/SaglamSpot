buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.9.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.3.0")
        classpath("com.google.gms:google-services:4.4.2")
        classpath("com.google.firebase:firebase-crashlytics-gradle:3.0.2")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}
// ==============================================================================
// 🛡️ SAGLAMSPOT GLOBAL GRADLE MIDDLEWARE — ANTI-EVALUATION CRASH
// ==============================================================================
// afterEvaluate yerine plugins.withId kullanarak eval hatasını engelliyoruz.

subprojects {
    plugins.withId("com.android.library") {
        configureAndroidNamespace(this@subprojects)
    }
    plugins.withId("com.android.application") {
        configureAndroidNamespace(this@subprojects)
    }
}

fun configureAndroidNamespace(project: Project) {
    val android = project.extensions.findByName("android")
    if (android is com.android.build.gradle.BaseExtension) {
        if (android.namespace == null) {
            val sanitizedName = project.name.replace("-", "_")
            android.namespace = "com.ferdidrgn.saglamspot.patched.$sanitizedName"
            project.logger.lifecycle("🛡️ Yama: [${project.name}] modülü için namespace enjekte edildi.")
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}