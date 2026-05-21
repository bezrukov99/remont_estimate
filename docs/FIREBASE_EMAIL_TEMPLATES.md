# Красивые письма Firebase (сброс пароля, подтверждение)

Письма «Забыли пароль?» отправляет **Firebase Authentication**, не Flutter-приложение. Внешний вид настраивается в [Firebase Console](https://console.firebase.google.com/project/smetochka-22b83/authentication/emails).

## 1. Название проекта вместо `project-666709576823`

1. [Project settings → General](https://console.firebase.google.com/project/smetochka-22b83/settings/general)
2. Блок **Public settings** → **Public-facing name**: `Сметочка`
3. Сохраните.

В письмах вместо технического ID будет **Сметочка**.

## 2. Шаблон «Сброс пароля»

1. [Authentication → Templates](https://console.firebase.google.com/project/smetochka-22b83/authentication/emails)
2. **Password reset** → иконка карандаша (Edit)
3. Включите нужный язык или задайте один шаблон на русском.

### Тема письма

```
Сметочка — сброс пароля
```

### Текст письма (вставьте в поле Message)

```
Здравствуйте!

Вы запросили сброс пароля для аккаунта %EMAIL% в приложении Сметочка.

Нажмите ссылку ниже, чтобы задать новый пароль (ссылка действует ограниченное время):

%LINK%

Если вы не запрашивали сброс — просто удалите это письмо. Пароль не изменится.

С уважением,
команда Сметочка
```

Переменные Firebase (не удаляйте):

| Переменная | Назначение |
|------------|------------|
| `%LINK%` | Ссылка сброса (обязательна) |
| `%EMAIL%` | Email пользователя |

4. **Save**.

После сохранения отправьте тест: в приложении снова «Забыли пароль?».

## 3. Почему письмо в «Спаме»

Адрес `noreply@…firebaseapp.com` часто попадает в спам у Gmail.

**Сейчас:** нажмите **«Не спам»** — следующие письма чаще попадают во «Входящие».

**Позже (для Play / продакшена):**

- Подключить **свой домен** и отправку через [Custom email domain](https://firebase.google.com/docs/auth/custom-email-handler) (нужен Blaze + DNS).
- Или сервис вроде SendGrid / Mailgun + Cloud Function (сложнее).

Для тестов достаточно «Не спам» + русский шаблон из п. 2.

## 4. Страница по ссылке из письма

Ссылка открывается на `smetochka-22b83.firebaseapp.com` — стандартная страница Firebase (форма нового пароля). Её можно брендировать:

1. [Authentication → Templates → Customize action URL](https://console.firebase.google.com/project/smetochka-22b83/authentication/emails) (если доступно в вашем тарифе).
2. Или [Hosting](https://console.firebase.google.com/project/smetochka-22b83/hosting) + [custom email handler](https://firebase.google.com/docs/auth/custom-email-handler) — отдельная вёрстка, больше работы.

Для MVP обычно хватает русского письма + Public-facing name **Сметочка**.

## 5. Другие письма

На той же вкладке **Templates** настройте по желанию:

- **Email address verification** — подтверждение email при регистрации
- **Email address change** — смена почты

Тот же тон и подпись «команда Сметочка», те же `%LINK%` / `%EMAIL%`.

## 6. Ограничения бесплатного тарифа

На Spark-тарифе шаблон **без полноценного HTML** (кнопки, логотип в теле письма) — в основном текст и одна ссылка. Полноценный HTML-дизайн — custom domain + свой отправитель или Extension.

Логотип в письме на Spark напрямую не вставить; «красота» = русский текст, нормальное имя отправителя, не спам.
