# Keep the SLF4J LoggerFactory class
-keep class org.slf4j.** { *; }
-dontwarn org.slf4j.**

# Keep the StaticLoggerBinder class
-keep class org.slf4j.impl.StaticLoggerBinder { *; }
-dontwarn org.slf4j.impl.StaticLoggerBinder