// android/app/build.gradle

plugins {
    id 'com.android.application'
    id 'kotlin-android'
    id 'com.google.gms.google-services' // Firebase
}

android {
    namespace 'com.example.xgon_app' // Altere se você usou outro nome de pacote
    compileSdk 34

    defaultConfig {
        applicationId "com.example.xgon_app" // Altere se você usou outro nome de pacote
        minSdk 21
        targetSdk 34
        versionCode 1
        versionName "1.0"

        multiDexEnabled true
    }

    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile(
                'proguard-android-optimize.txt'),
                'proguard-rules.pro'
        }
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = '17'
    }

    buildFeatures {
        viewBinding true
    }
}

dependencies {
    implementation 'androidx.multidex:multidex:2.0.1'

    // Firebase Core
implementation platform('com.google.firebase:firebase-bom:32.3.1') // versão recomendada
implementation 'com.google.firebase:firebase-analytics'
implementation 'com.google.firebase:firebase-auth'

}

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // Firebase
}