# AQILEXA Project Status (Android + Web)

এই ZIP-এ বর্তমান Local Mode এবং বিদ্যমান feature-গুলো অক্ষত রাখা হয়েছে।

## এই প্রস্তুতিতে যা করা হয়েছে
- Supabase SDK-এর deprecated `anonKey` initialization argument-কে `publishableKey` করা হয়েছে।
- Supabase এখনো disabled রাখা হয়েছে, কারণ project URL/key এবং Teacher-এর Supabase rules এখনো দেওয়া হয়নি।
- Local Authentication, Hive local database, Notebook, To-do Calendar, Focus Timer, Dashboard এবং Settings-এর existing implementation পরিবর্তন করা হয়নি।
- Courses, Analytics এবং Exam Analyzer-এর আগের deletion অক্ষত রাখা হয়েছে।

## গুরুত্বপূর্ণ সীমাবদ্ধতা
এই ZIP এখনো Supabase Primary + Local Fallback implementation নয়। Supabase Auth, secure account linking, RLS policy, offline sync queue, conflict resolution এবং cross-device sync implement করা হয়নি। এগুলো Teacher-এর rules, database schema এবং Supabase project configuration দেখে নিরাপদে implement করতে হবে।

## Windows-এ যাচাই
Project root-এ গিয়ে চালান:

```cmd
flutter pub get
flutter analyze
flutter test
```

তারপর Chrome:

```cmd
flutter run -d chrome
```

Android device/emulator থাকলে:

```cmd
flutter devices
flutter run -d <device-id>
```

`flutter analyze` এবং runtime test আপনার Flutter SDK-সহ environment-এ চালিয়ে ফলাফল নিশ্চিত করতে হবে।
