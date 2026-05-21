# Firebase: авторизация и облачное хранение

Приложение сохраняет смету локально (HydratedBloc) и **дублирует её в Firebase** после входа:

- **Firebase Auth** — Google и email/пароль
- **Cloud Firestore** — JSON сметы (`users/{uid}/data/main`)
- **Firebase Storage** — фото материалов (`users/{uid}/photos/{materialId}/…`)

## 1. Создайте проект Firebase

1. [Firebase Console](https://console.firebase.google.com/) → **Add project**
2. Включите **Authentication** → Sign-in methods: **Google**, **Email/Password**
3. Создайте **Firestore** (режим production, регион ближе к пользователям)
4. Создайте **Storage** bucket

## 2. Подключите Flutter

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Команда перезапишет `lib/firebase_options.dart` и добавит `google-services.json` / `GoogleService-Info.plist`.

## 3. Правила безопасности

**Firestore** (`Firestore → Rules`) — скопируйте из [`firestore.rules`](../firestore.rules) в корне репозитория и нажмите **Publish**:

```
match /users/{userId}/data/{estimateId} {
  allow read, write: if request.auth != null && request.auth.uid == userId;
}
```

Путь в приложении: `users/{ваш_uid}/data/main`. Без этих правил будет `permission-denied`.

**Storage** (`Storage → Rules`) — из [`storage.rules`](../storage.rules), **Publish**.

## 4. Google Sign-In — пошагово

### Шаг A. Firebase Console (один раз)

1. [Authentication → Sign-in method](https://console.firebase.google.com/project/smetochka-22b83/authentication/providers) → **Google** → **Enable** → Save.
2. Запомните **Web client ID** (тот же, что в `DefaultFirebaseOptions.googleWebClientId` в `lib/firebase_options.dart`).

### Шаг B. Android (обязательно для Google на телефоне)

Сейчас в `android/app/google-services.json` только web-клиент (`client_type: 3`). После добавления SHA появится android-клиент (`client_type: 1`) — без этого Google на Android не заработает.

1. [Project settings → Your apps → Android](https://console.firebase.google.com/project/smetochka-22b83/settings/general) (`com.remontestimate.remont_estimate`).
2. **Add fingerprint** — добавьте **оба** keystore:

| Назначение | SHA-1 |
|------------|--------|
| Debug (`flutter run`) | `08:44:60:2E:1D:0B:2D:4C:87:9C:B4:DA:52:E8:F6:83:EA:74:9B:F4` |
| Release (Play / AAB) | `3E:FA:9D:E5:77:B5:52:A5:D2:E1:C4:49:B7:21:27:C9:0E:9C:7E:C2` |

3. SHA-256 для тех же keystore — кнопка **Add fingerprint** ещё раз (из `keytool -list -v ...`, поля SHA256).

Получить отпечатки вручную:

```bash
# Debug
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Release (если есть upload-keystore.jks)
keytool -list -v -keystore android/upload-keystore.jks -alias upload
```

4. **Скачайте новый** `google-services.json` → замените `android/app/google-services.json`.
5. Проверка: в json в `oauth_client` должен появиться объект с `"client_type": 1`.
6. Пересоберите: `flutter clean && flutter run`.

**Эмулятор:** нужен образ **с Google Play** (не AOSP). На части эмуляторов Google не открывается — проверяйте на реальном телефоне.

### Шаг C. iOS

Уже сделано через `flutterfire configure`:

- `ios/Runner/GoogleService-Info.plist`
- URL scheme в `ios/Runner/Info.plist` (REVERSED_CLIENT_ID)

Достаточно: Google включён в Authentication (шаг A) → сборка на iPhone: `flutter run`.

### Шаг D. Проверка

1. Настройки → **Аккаунт и облако** → **Войти через Google**.
2. Выберите аккаунт Google → в Firebase **Authentication → Users** появится пользователь с провайдером Google.
3. Смета синхронизируется как при входе по email.

### Типичные ошибки Android

| Симптом | Причина |
|---------|---------|
| `ApiException: 10` / `DEVELOPER_ERROR` | Нет SHA-1 или старый `google-services.json` |
| Окно Google не открывается | Эмулятор без Google Play |
| Вход есть, Firebase падает | Не включён провайдер Google в Authentication |

## 6. Сборка

```bash
flutter pub get
flutter run
```

В настройках проекта: **Аккаунт и облако** → войдите. Данные синхронизируются автоматически (с задержкой ~2 с после изменений). Потяните список комнат вниз для принудительной загрузки из облака.

## Письма (сброс пароля, спам, русский текст)

См. [`FIREBASE_EMAIL_TEMPLATES.md`](FIREBASE_EMAIL_TEMPLATES.md) — Public-facing name **Сметочка**, готовый текст шаблона, «Не спам» в Gmail.

## Политика конфиденциальности

После включения облака обновите [privacy-policy](privacy-policy.html): указать Firebase (Auth, Firestore, Storage), какие данные хранятся и что пользователь может удалить аккаунт в Firebase Console.

## Без Firebase в сборке

Пока `lib/firebase_options.dart` содержит `CONFIGURE_ME`, облако отключено — приложение работает только локально, как раньше.
