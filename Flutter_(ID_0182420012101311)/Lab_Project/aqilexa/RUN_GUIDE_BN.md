# AQILEXA চালানোর নির্দেশনা (Microsoft Edge / Google Chrome)

## ১. ZIP Extract করুন
`aqilexa.zip` Extract করে VS Code-এ ভিতরের `aqilexa` Folder Open করুন। Parent folder নয়—যে Folder-এর ভিতরে `pubspec.yaml` আছে সেটি Open করতে হবে।

## ২. Terminal-এ চালান
```bash
flutter doctor
flutter config --enable-web
flutter pub get
```

## ৩. Browser-এ Run করুন
Chrome:
```bash
flutter run -d chrome
```

Edge:
```bash
flutter run -d edge
```

## ৪. প্রথমবার ব্যবহার
1. Welcome Screen থেকে Sign Up চাপুন।
2. First Name, Last Name, Email, Password দিন।
3. Password কমপক্ষে ৮ অক্ষরের হতে হবে।
4. নিজের জন্য অন্তত ৬ অক্ষরের একটি Recovery Code তৈরি করুন এবং নিরাপদে লিখে রাখুন। এটি Local Forgot Password-এ লাগবে।
5. চাইলে Profile Photo যোগ করুন।
6. Account তৈরি হলে Sign In-এ ফিরে Email ও Password দিয়ে Login করুন।

## ৫. বর্তমান Local Mode
- Supabase এখন Disabled; কোনো Supabase account, URL বা key লাগবে না।
- Account, profile photo, notebooks, tasks এবং focus sessions browser-এর IndexedDB-ভিত্তিক local storage-এ থাকে।
- একই browser profile ব্যবহার করুন। Browser site data clear করলে local data মুছে যেতে পারে।
- Local account email ownership verify করে না এবং অন্য computer/browser-এ স্বয়ংক্রিয়ভাবে sync হয় না।
- Forgot Password-এর জন্য registration-এ দেওয়া Recovery Code প্রয়োজন; Email reset link পাঠানো হয় না।
- Google, GitHub ও Facebook icons শুধু display; এগুলো login করে না।
- Settings-এর কিছু preference ভবিষ্যতের জন্য display-only। Logout কাজ করে এবং local study data delete করে না।

## ৬. Supabase ভবিষ্যতে চালু করা
`lib/config/app_config.dart`-এ `useSupabase` বর্তমানে `false`। ভবিষ্যতে Supabase Project তৈরি করে Auth, Database, Row Level Security ও migration/sync পরিকল্পনা সম্পন্ন করার পরই এটি চালু করতে হবে। শুধু flag `true` করলেই Local Account Cloud Account হয়ে যাবে না।

## ৭. Presentation-এর আগে
একই Browser Profile-এ আগে Account তৈরি করে রাখুন। Demo-এর আগে Notebook ও Task sample data যোগ করে নিন। Browser-এর site data clear করবেন না।
