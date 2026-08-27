# 01 — الداتابيز (المرجع الوحيد)

> Supabase / PostgreSQL. المصادقة: **Google OAuth فقط**.
> أي عمود أو دالة غير مذكورة هنا **غير موجودة**. لا تخترع.

---

## قواعد الوصول

1. **الكتابة المباشرة على `shells` مستحيلة** — يوجد trigger يرفضها. استخدم RPC.
2. **`national_id` و `citizen_no` و `legal_name` لا تتغيّر أبداً** — trigger يحميها.
3. **إنشاء مواطن عبر `register_citizen()` فقط** — لا توجد سياسة insert على `citizens`.
4. `SharedPreferences` للكاش المؤقت فقط. **Supabase هو مصدر الحقيقة.**
5. ممنوع `.catchError` صامت. كل خطأ يظهر للمستخدم برسالة عربية.

---

## الجداول

### `citizens` — المواطن
| العمود | النوع | ملاحظات |
|:---|:---|:---|
| `user_id` | uuid PK | = `auth.uid()` |
| `national_id` | text unique | ١٤ رقم، تولّده الداتابيز، **ثابت** |
| `citizen_no` | int unique | تسلسلي #0001، **ثابت** |
| `legal_name` | text | الاسم الرسمي، **ثابت مدى الحياة** |
| `display_name` | text | قابل للتغيير |
| `handle` | text unique | `^[a-z0-9_]{3,20}$` |
| `species` | text | sponge / starfish / squid / crab / squirrel / fish |
| `blood_type` | text | |
| `residence` | text | |
| `avatar_config` | jsonb | `{body, face, hair, outfit, acc}` |
| `job_key` | text | افتراضي `citizen` |
| `job_changed_at` | timestamptz | |
| `shells` | int | **للقراءة فقط** |
| `is_wanted` | bool | **للقراءة فقط** |
| `debt_total` | int | **للقراءة فقط** |
| `badges` | text[] | **للقراءة فقط** |
| `last_seen_at` | timestamptz | |
| `created_at` / `updated_at` | timestamptz | |

**View للعرض العام:** `citizen_public` — استخدمه لعرض مواطن آخر (لا يحتوي `shells` ولا `debt_total`).

### `shell_ledger` — دفتر حركة الصدف
`id, user_id, amount, reason, ref_id, balance_after, created_at`
للقراءة فقط، ويرى المواطن دفتره هو فقط.

### `game_rooms` — الترابيزات
| العمود | ملاحظات |
|:---|:---|
| `id` uuid PK | |
| `room_code` text unique | ٦ أرقام |
| `title` | |
| `owner_id` uuid | → citizens |
| `current_game` | dominoes / tawla / chess / basra |
| `max_players` | 2–4 |
| `is_private` bool | **الخاصة لا ترجع من الاستعلام أصلاً** |
| `status` | waiting / playing / finished |
| `game_state` jsonb | السيرفر هو المرجع |
| `turn_user_id`, `turn_expires_at` | |
| `last_activity_at`, `created_at` | |

### `room_members` — الجالسون
`room_id, user_id, role, seat_index, joined_at`
`role`: **player / spectator / pending** (pending = طلب انتظار موافقة).
PK مركّب `(room_id, user_id)`. كرسي واحد لكل لاعب (unique index).

### `room_messages` — الشات
`id, room_id, sender_id, kind, message, created_at`
`kind`: text / emote / system. **العميل ممنوع من إرسال `system`.**
لا يكتب إلا من هو عضو فعلي في الغرفة.

### `channels` — القنوات الرسمية
`key, name, emoji, sort_order`
الموجود: `bayan` / `3agel` / `baladeya` / `wanted`

### `posts` — الجريدة
`id, author_id, channel_key, body, reaction_count, comment_count, report_count, is_hidden, created_at`
- `channel_key = null` → بوست مواطن عادي
- **المواطن ممنوع من النشر في القنوات** (السياسة ترفضه)
- **المطلوب للعدالة ممنوع من النشر** (السياسة ترفضه)
- `body` بين ١ و ٥٠٠ حرف
- العدّادات تُحدَّث بـ triggers — **لا تحدّثها يدوياً**

### `post_reactions`
`post_id, user_id, kind, created_at` — PK `(post_id, user_id)` = رياكشن واحد لكل مواطن.
`kind`: laugh / tea / chair / crab / love / angry

### `post_comments`
`id, post_id, author_id, body, is_hidden, created_at`

### `post_reports`
`post_id, user_id, created_at` — ٣ بلاغات = إخفاء تلقائي عبر `report_post()`.

### `notifications`
`id, user_id, category, title, body, target_route, is_read, created_at`
`category`: social / cafe / official / money / broadcast
تُملأ بـ triggers. **لا تُنشئ تنبيهات من الفلاتر.**

### `buildings` — مباني الخريطة
`key, name, emoji, kind, route, grid_x, grid_y, width, height, is_locked, unlock_note, owner_id, sort_order`
**الخريطة تُرسم من هذا الجدول.** إضافة مبنى = صف جديد، لا تعديل كود.

---

## الدوال (RPC) — الطريقة الوحيدة للكتابة الحسّاسة

```dart
// تسجيل مواطن جديد بعد أول دخول بجوجل
await client.rpc('register_citizen', params: {
  'p_legal_name': name,
  'p_handle': handle,
  'p_species': species,
  'p_avatar': avatarJson,
});

// تحويل صدف لمواطن آخر
await client.rpc('transfer_shells', params: {
  'p_to_handle': handle, 'p_amount': amount,
});

// فتح ترابيزة (تولّد الكود وتُجلس صاحبها)
await client.rpc('create_room', params: {
  'p_title': title, 'p_game': 'dominoes', 'p_private': false,
});

// الانضمام بالكود (تجلسه أو تحوّله pending تلقائياً)
await client.rpc('join_room', params: {'p_code': code});

// الإبلاغ عن بوست
await client.rpc('report_post', params: {'p_post': postId});
```

**`adjust_shells` ممنوعة على العميل** — تُستدعى من الدوال الأخرى فقط.

---

## Realtime

مفعّل على: `game_rooms`, `room_members`, `room_messages`, `posts`, `notifications`

- حالة اللعبة والدور → `game_rooms`
- دخول وخروج اللاعبين → `room_members`
- الشات → `room_messages`

---

## أخطاء الدوال

الدوال ترفع أخطاء برسائل عربية جاهزة (`لديك بطاقة بالفعل`، `الرصيد غير كافٍ`، `الترابيزة غير موجودة`).
**اعرض رسالة الخطأ كما هي للمستخدم.** لا تستبدلها برسالة عامة ولا تبتلعها.
