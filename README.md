

````markdown
# Nexly Plus 💬

**Nexly Plus** is a modern, real-time communication app built using **Flutter**, designed to provide a seamless messaging and calling experience. It integrates **ZEGOCLOUD** for chat, voice, and video communication, and uses **Firebase Authentication** for secure phone-based login.

---

## 🚀 Features

- 🔐 **Phone authentication** via Firebase Auth (OTP-based)
- 💬 **1-on-1 text chat** powered by Zego ZIMKit
- 📞 **Voice & video calls** using Zego UIKit Prebuilt Call
- ⚙️ **Modular & scalable code structure**
- 🌐 **Real-time synchronization** across devices
- ✨ **Clean UI** using Flutter Material 3
- 🔁 **OTP resend support**

---

## 🧠 How It Works

Upon launching the app, users authenticate via **Firebase Phone Auth**. After successful verification, the app programmatically logs the user into **ZEGOCLOUD's ZIMKit**, initializing messaging and call capabilities using the user's UID.

Here's a breakdown of the workflow:

1. User enters phone number
2. OTP is sent via Firebase
3. Firebase validates the code and authenticates the user
4. The app uses the user's UID to sign in to ZEGOCLOUD ZIMKit
5. User is redirected to the **Chat List Page**
6. From there, they can:
   - Start new conversations
   - Initiate audio/video calls
   - Manage their profile

---

## 📁 Project Structure

```plaintext
lib/
│
├── main.dart                 # Entry point
├── app.dart                  # App configuration & theme
├── firebase_options.dart     # Firebase generated config
│
├── constants/                # App-wide constants
│   └── colors.dart
│
├── pages/                    # App screens
│   ├── auth/                 # OTP flow
│   │   └── otp_page.dart
│   ├── chat/                 # Chat UIs
│   │   ├── chat_list_page.dart
│   │   └── chat_with_call_page.dart
│   └── login/                # Login, profile, splash
│       ├── login_page.dart
│       ├── profile_page.dart
│       ├── splash_page.dart
│       ├── login_button.dart
│       └── login_form.dart
│
├── services/                 # Logic layer
│   ├── auth_service.dart
│   ├── chat_service.dart
│   ├── login_service.dart
│   ├── resend_otp_service.dart
│   ├── user_info_service.dart
│   ├── zego_initializer.dart
│   └── zim_service.dart
│
├── utils/                    # Helper files
│   └── secrets.dart
│
├── widgets/                  # Reusable UI components
│   ├── auth/
│   │   └── otp_input.dart
│   ├── call_buttons/
│   │   ├── audio_call_button.dart
│   │   └── video_call_button.dart
│   └── chat/
│       ├── chat_app_bar.dart
│       ├── chat_list_view.dart
│       └── start_chat_button.dart
````

---

## 🛠️ Tech Stack

| Category         | Tech                          |
| ---------------- | ----------------------------- |
| UI Framework     | Flutter + Material 3          |
| Auth             | Firebase Authentication       |
| Messaging        | ZEGOCLOUD ZIMKit              |
| Calls            | Zego UIKit Prebuilt Call      |
| Backend Sync     | Firebase + Zego Cloud         |
| State Management | Basic state + Firebase stream |
| Language         | Dart                          |

---

## 🌱 Future Plans

This is just the beginning. Planned upcoming features include:

* 👥 **Group chat support**
* 🧾 **Media sharing** (images, videos, docs)
* 🌍 **Real-time message translation**
* 📲 **Push notifications (FCM)**
* ⏳ **Self-destructing messages**
* 🛠 **Admin panel** for monitoring activity
* ✍️ **User presence & typing indicators**

---

## 💡 Design Philosophy

The project is structured in a **modular and scalable** way, where:

* UI components are separated from logic
* Services are clearly divided (auth, chat, call, etc.)
* Each screen is lightweight and easy to test
* ZEGOCLOUD is fully abstracted through service layers

This allows for **easy feature expansion** and **clean integration** with other services in the future.

---

## 📬 Contribution

Feel free to fork this repo and open a Pull Request if you'd like to contribute.
All constructive feedback and suggestions are welcome.

---

## 📸 Screenshots (Coming Soon)

UI previews and demo walkthroughs will be added in the next update.

```
