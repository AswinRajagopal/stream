# 📱 Rudo App 

## 🚀 Overview
This Flutter application implements **Firebase Authentication** using **BLoC state management**. It supports multiple authentication methods:
- **Email & Password Login**
- **Google Sign-In**
- **Phone Number Authentication with OTP Verification**
- **Anonymous Authentication**
- **Dynamic UI & Dashboard from JSON**

The app is built with **Flutter & Firebase** and follows **Material Design principles** for a modern UI experience.

---

## ✨ Features
✅ Firebase Authentication (Email, Google, Phone, Anonymous)  
✅ OTP-based Login (Firebase Phone Authentication)  
✅ State Management using **BLoC**  
✅ Dynamic UI for **App Tour & Dashboard** (JSON-based)  
✅ Responsive Layout & Beautiful Animations  
✅ Uses **GetX** for Navigation  
✅ Deployed using **Docker Swarm & Kubernetes**  

---

## 🛠️ Tech Stack
- **Frontend:** Flutter, Dart, Material Design
- **State Management:** BLoC + GetX
- **Authentication:** Firebase Auth
- **Backend:** Firebase Firestore (if required)
- **Deployment:** Docker Swarm, Kubernetes

---

## 📂 Folder Structure
```bash
├── lib
│   ├── main.dart                # App Entry Point
│   ├── blocs                    # BLoC State Management
│   │   ├── auth_bloc.dart        # Handles Authentication Logic
│   ├── data                     # Data Layer
│   │   ├── api_service.dart      # API Calls (if any)
│   ├── ui                       # UI Components
│   │   ├── login_screen.dart     # Login Screen
│   │   ├── dashboard.dart        # Dashboard Screen
│   │   ├── app_tour.dart         # Dynamic App Tour
├── pubspec.yaml                  # Dependencies
├── android/app/src/main          # Android Native Code
├── ios/Runner                    # iOS Native Code
```

---

## 🔧 Installation & Setup
### Prerequisites
- Flutter **3.x** Installed
- Firebase Setup in Console
- Android/iOS Emulator or Device

### 1️⃣ Clone the Repository
```sh
git clone https://github.com/your-repo/flutter-auth-app.git
cd flutter-auth-app
```

### 2️⃣ Install Dependencies
```sh
flutter pub get
```

### 3️⃣ Firebase Setup
1. **Create a Firebase Project** at [Firebase Console](https://console.firebase.google.com/)
2. **Enable Authentication** for Email, Google & Phone
3. **Download google-services.json** (Android) & **GoogleService-Info.plist** (iOS)
4. Place them inside:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`

### 4️⃣ Run the App
```sh
flutter run
```

---

## 🔌 API & Backend Setup
### 1️⃣ Enable Firebase Authentication
- Navigate to **Firebase Console** → **Authentication** → **Sign-in Methods**
- Enable **Email, Google & Phone Authentication**

### 2️⃣ Firebase Firestore (if required)
- Enable Firestore Database for storing user profiles
- Define Firestore rules for security

---

## 🚀 Deployment (Docker & Kubernetes)
### Docker Swarm Setup
```sh
docker swarm init
docker stack deploy -c docker-compose.yml flutter-auth-app
```

### Kubernetes Deployment
```sh
kubectl apply -f k8s/deployment.yaml
```

---

## 🎯 Future Enhancements
- Add Facebook Authentication
- Implement Push Notifications (Firebase Cloud Messaging)
- Improve Animations & UI Enhancements

---

## 📜 License
This project is licensed under the MIT License - see the LICENSE file for details.

---

## 📧 Contact
For any questions, reach out to **mailaswin15@gmail.com**

