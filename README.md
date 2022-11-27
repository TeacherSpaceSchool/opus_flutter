#Очистить кэш сборшика
flutter clean
#Показать информацию об установленных инструментах.
flutter doctor
#Проверка размера
flutter build apk --target-platform android-arm,android-arm64,android-x64 --analyze-size
#Сборка тонкого APK
flutter build apk --split-per-abi