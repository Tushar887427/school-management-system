# 🚀 How to Trigger APK Build Through GitHub Actions

This guide explains how to build your Android APK using the GitHub Actions workflow.

## ✅ Current Status

The GitHub Actions workflow is **ready and configured**:
- ✓ Workflow file: `.github/workflows/build-apk.yml`
- ✓ Triggers: Push to main/master OR manual dispatch
- ✓ Documentation: Complete guides in `docs/` folder
- ✓ Build script: Available for local testing

## 🎯 Three Ways to Build APK

### Method 1: Manual Workflow Dispatch (EASIEST FOR TESTING)

**This is the recommended method for your first build.**

1. **Go to your GitHub repository:**
   ```
   https://github.com/Tushar887427/school-management-system
   ```

2. **Click the "Actions" tab** at the top of the repository

3. **Select "Build Android APK"** from the left sidebar

4. **Click "Run workflow"** button (on the right side)

5. **Configure the build:**
   - Branch: Select `copilot/add-github-actions-build-apk` (or `main` if merged)
   - App version: Leave default `1.0.0` or enter custom version

6. **Click "Run workflow"** (green button)

7. **Watch the build progress:**
   - The workflow will appear in the list below
   - Click on it to see detailed logs
   - Build takes approximately 8-12 minutes

8. **Download your APK:**
   - After successful build, click on the workflow run
   - Scroll down to "Artifacts" section
   - Download `android-apk` artifact
   - Extract the ZIP file to get your APK

### Method 2: Automatic Build on Push

The workflow automatically runs when you push to main or master branch:

```bash
# If on main/master branch
git push origin main
```

This will:
- Trigger the workflow automatically
- Build the APK
- Create a GitHub Release with the APK attached

### Method 3: Merge Pull Request

When you merge the PR to main branch:
1. The workflow automatically triggers
2. Builds the APK
3. Creates a GitHub Release
4. Attaches the APK to the release

## 📦 What Happens During the Build

The workflow performs these steps:

1. **Environment Setup** (~3 minutes)
   - Checks out your code
   - Installs Node.js 18.x
   - Installs Java JDK 11
   - Installs Android SDK

2. **Cordova Setup** (~2 minutes)
   - Installs Cordova CLI
   - Creates Cordova project structure
   - Adds Android platform

3. **Application Packaging** (~2 minutes)
   - Copies your web application files
   - Configures Android app settings
   - Sets up network security

4. **APK Building** (~3-4 minutes)
   - Builds Android APK
   - Signs APK (if secrets configured)
   - Verifies signature

5. **Artifact Upload** (~1 minute)
   - Uploads APK as workflow artifact
   - Creates GitHub Release (if on main/master)

**Total Time: 8-12 minutes**

## 🔐 Signed vs Unsigned APK

### Unsigned APK (Default - No Configuration Needed)
- ✅ Good for testing
- ✅ Can install on your device
- ✅ No setup required
- ❌ Cannot publish to Play Store
- ❌ Shows as "Unverified developer"

### Signed APK (Requires GitHub Secrets)
- ✅ Production ready
- ✅ Can publish to Play Store
- ✅ Verified developer
- ⚙️ Requires keystore setup

**To build signed APKs**, you need to configure 4 GitHub Secrets:

1. Go to: Repository → Settings → Secrets and variables → Actions
2. Add these secrets:
   - `ANDROID_KEYSTORE_BASE64` - Your keystore file (base64 encoded)
   - `ANDROID_KEYSTORE_PASSWORD` - Keystore password
   - `ANDROID_KEY_ALIAS` - Key alias
   - `ANDROID_KEY_PASSWORD` - Key password

See `docs/APK_BUILD_GUIDE.md` for detailed instructions on generating these.

## 📱 Installing the APK

After downloading the APK:

1. **Transfer to Android device:**
   - Email it to yourself
   - Use USB cable
   - Upload to cloud storage (Google Drive, Dropbox)

2. **Enable installation from unknown sources:**
   - Settings → Security → Unknown sources (enable)
   - Or: Settings → Apps → Special access → Install unknown apps

3. **Install the APK:**
   - Open the APK file on your device
   - Tap "Install"
   - Wait for installation
   - Tap "Open" to launch

## 🐛 Troubleshooting

### Workflow doesn't appear in Actions tab
- Make sure you're on the correct branch
- The workflow file must be in `.github/workflows/` folder
- Check that the YAML syntax is valid

### Build fails immediately
- Check the workflow logs for specific error
- Ensure you're not hitting GitHub Actions limits
- Verify the workflow file hasn't been modified incorrectly

### APK build succeeds but shows errors when installing
- This is expected - PHP requires a backend server
- See "PHP Limitation" section in `docs/APK_BUILD_GUIDE.md`
- You need to host your PHP backend separately

### Can't download artifacts
- Artifacts expire after 30 days
- Make sure the workflow completed successfully
- Check you have access to the repository

## 📚 Additional Resources

- **Complete Guide:** `docs/APK_BUILD_GUIDE.md`
- **Quick Start:** `docs/QUICK_START.md`
- **Deployment Checklist:** `docs/DEPLOYMENT_CHECKLIST.md`
- **Workflow Details:** `.github/workflows/README.md`

## 🎬 Quick Start Command

If you want to test locally first:

```bash
# Make the script executable (if not already)
chmod +x scripts/setup-cordova.sh

# Run local build (unsigned)
./scripts/setup-cordova.sh

# Run local build (signed - requires keystore)
./scripts/setup-cordova.sh --release
```

## ✅ Checklist Before First Build

- [ ] Workflow file exists at `.github/workflows/build-apk.yml`
- [ ] On correct branch (has the workflow file)
- [ ] Decided: signed or unsigned APK?
- [ ] If signed: GitHub Secrets configured
- [ ] Ready to wait 8-12 minutes for build
- [ ] Android device ready for testing

## 🎉 Ready to Build!

You're all set! Choose one of the three methods above and start building your APK through GitHub Actions.

**Recommended first build:** Use Method 1 (Manual Workflow Dispatch) to test the workflow.

---

**Need Help?** Check the troubleshooting section in `docs/APK_BUILD_GUIDE.md` or open an issue.
