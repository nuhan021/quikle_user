# Proguard / R8 rules to avoid minification errors for transitive desktop/server libs
# tika-core (pulled by file_picker plugin) references javax.xml.stream which isn't
# available on Android; suppress warnings and keep necessary Tika classes.
-keep class org.apache.tika.** { *; }
-keep class javax.xml.stream.XMLResolver.** { *; }
-dontwarn javax.xml.stream.**
-dontwarn javax.xml.stream.XMLStreamException

# Keep SLF4J API used by some libraries
-dontwarn org.slf4j.**

# Keep commons-io used by tika
-keep class org.apache.commons.io.** { *; }
-dontwarn org.apache.commons.io.**
