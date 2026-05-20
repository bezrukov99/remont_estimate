# Сметочка (remont_estimate)

Flutter-приложение для учёта сметы ремонта: комнаты, материалы, фото, бюджет, экспорт PDF/Excel.

## Запуск

```bash
flutter pub get
flutter run
```

## Сборка для Google Play

1. Настройте подпись: [docs/GOOGLE_PLAY.md](docs/GOOGLE_PLAY.md)
2. Соберите App Bundle:

```bash
chmod +x scripts/build_play_bundle.sh
./scripts/build_play_bundle.sh
```

Или: `flutter build appbundle --release`

Файл для загрузки в Play Console: `build/app/outputs/bundle/release/app-release.aab`

## Документация

| Файл | Описание |
|------|----------|
| [docs/GOOGLE_PLAY.md](docs/GOOGLE_PLAY.md) | Чеклист публикации в Google Play |
| [docs/PRIVACY_POLICY_RU.md](docs/PRIVACY_POLICY_RU.md) | Шаблон политики конфиденциальности |

## Версия

Задаётся в `pubspec.yaml` (`version: 1.0.0+1`).
