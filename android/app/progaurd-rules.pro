######################################
# FLUTTER CORE
######################################
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

######################################
# DIO / HTTP / RETROFIT / OKHTTP / GSON
######################################
-keepattributes Signature
-keepattributes *Annotation*
-keep class retrofit2.** { *; }
-keep interface retrofit2.** { *; }
-dontwarn retrofit2.**
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep class okio.** { *; }

# GSON
-keep class com.google.gson.** { *; }
-keepattributes EnclosingMethod

######################################
# FIREBASE & GOOGLE PLAY SERVICES
######################################
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

######################################
# FLUTTER LOCAL NOTIFICATIONS
######################################
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-dontwarn com.dexterous.flutterlocalnotifications.**

######################################
# PATH PROVIDER / FILE IO
######################################
-keep class io.flutter.plugins.pathprovider.** { *; }

######################################
# SHARED PREFERENCES
######################################
-keep class io.flutter.plugins.sharedpreferences.** { *; }

######################################
# PERMISSION HANDLER
######################################
-keep class com.baseflow.permissionhandler.** { *; }
-dontwarn com.baseflow.permissionhandler.**

######################################
# MULTI IMAGE PICKER / IMAGE PICKER
######################################
-keep class com.esafirm.imagepicker.** { *; }
-dontwarn com.esafirm.imagepicker.**
-keep class io.flutter.plugins.imagepicker.** { *; }

######################################
# INTERNET CONNECTION CHECKER PLUS
######################################
-keep class dev.britannio.inetconnectioncheckerplus.** { *; }
-dontwarn dev.britannio.inetconnectioncheckerplus.**


######################################
# PDF / PRINTING LIBS
######################################
-keep class net.nfet.flutter.printing.** { *; }
-dontwarn net.nfet.flutter.printing.**
-keep class net.nfet.flutter.pdf.** { *; }
-dontwarn net.nfet.flutter.pdf.**

######################################
# YOUR APPLICATION CODE
######################################
-keep class com.promatrix.rental_service.** { *; }

######################################
# NATIVE METHODS
######################################
-keepclasseswithmembers class * {
    native <methods>;
}



######################################
# LOGGING / LOGGER
######################################
-keep class com.orhanobut.logger.** { *; }
-dontwarn com.orhanobut.logger.**

######################################
# GENERAL SAFEKEEP
######################################
-dontnote kotlinx.**
-dontwarn kotlinx.**
