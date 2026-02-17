# Quick Start - Android APK Build

This is a quick reference guide. For the complete guide, see [APK_BUILD_GUIDE.md](APK_BUILD_GUIDE.md).

## 🚀 Quick Setup (5 Steps)

### 1. Generate Keystore

```bash
keytool -genkey -v -keystore school-management.keystore \
  -alias school-mgmt-key \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

### 2. Encode Keystore to Base64

**Linux/Mac:**
```bash
base64 school-management.keystore > keystore.base64.txt
```

**Windows PowerShell:**
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("school-management.keystore")) | Out-File keystore.base64.txt
```

### 3. Add GitHub Secrets

Go to: `Repository → Settings → Secrets → Actions → New repository secret`

Add these 4 secrets:
- `ANDROID_KEYSTORE_BASE64` - Content from keystore.base64.txt
- `ANDROID_KEYSTORE_PASSWORD` - Your keystore password
- `ANDROID_KEY_ALIAS` - Your key alias (e.g., school-mgmt-key)
- `ANDROID_KEY_PASSWORD` - Your key password

### 4. Push to Trigger Build

```bash
git add .
git commit -m "Enable APK build"
git push origin main
```

### 5. Download APK

Go to: `Repository → Releases` and download your APK!

---

## 🔧 Manual Build (Local)

```bash
# Run the setup script
./scripts/setup-cordova.sh

# Or for signed release build
./scripts/setup-cordova.sh --release
```

---

## ⚡ GitHub Actions Manual Trigger

1. Go to `Actions` tab
2. Select `Build Android APK` workflow
3. Click `Run workflow`
4. Enter version (optional)
5. Click `Run workflow`

---

## 📝 Customize App

Edit `cordova-config.xml` in repository root:

```xml
<widget id="com.yourcompany.app" version="1.0.0">
    <name>Your App Name</name>
    <description>Your app description</description>
    <!-- ... -->
</widget>
```

---

## 🐛 Common Issues

### Build fails: "JAVA_HOME not set"
```bash
export JAVA_HOME=/path/to/jdk
```

### Build fails: "ANDROID_HOME not set"
```bash
export ANDROID_HOME=$HOME/Android/Sdk
```

### APK shows white screen
PHP requires a server! Options:
- Host backend on a server
- Configure app to load remote URL
- See full guide for details

---

## 📚 Full Documentation

For complete documentation including:
- Detailed troubleshooting
- FAQ
- Advanced configuration
- Publishing to Play Store

See: **[Complete APK Build Guide](APK_BUILD_GUIDE.md)**

---

## 🆘 Need Help?

1. Check [Troubleshooting](APK_BUILD_GUIDE.md#troubleshooting)
2. Review [FAQ](APK_BUILD_GUIDE.md#faq)
3. Open an [Issue](https://github.com/Tushar887427/school-management-system/issues)
