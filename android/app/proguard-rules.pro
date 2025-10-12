#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class androidx.** { *; }
-keep class com.google.** { *; }

# 保留特定的Flutter方法
-dontwarn io.flutter.embedding.**
-keep class io.flutter.embedding.** { *; }

# 如果您的应用使用了MethodChannel，请保留您的MethodChannel实现类
# -keep class com.example.app.** { *; }

# 保留所有基本数据类型和Java核心库
-keepattributes Signature
-keepattributes Exceptions
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable

# 确保枚举不被混淆
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# 保留所有实现了Parcelable接口的类
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator CREATOR;
}

# 保留所有实现了Serializable接口的类
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# 禁止警告
-dontwarn kotlin.**
-dontwarn javax.annotation.**
-dontwarn javax.inject.**