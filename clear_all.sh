flutter clean
rm -rf android/.gradle
rm -rf build
flutter pub get

flutter pub run flutter_native_splash:create
dart run flutter_launcher_icons