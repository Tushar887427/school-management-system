# 🚀 How to Trigger APK Build

Quick guide on how to trigger the Android APK build for the School Management System.

## 🎯 Three Ways to Build

### 1️⃣ Automatic Build (Easiest)
The APK is **automatically built** when you push code to:
- `main` branch
- `master` branch  
- Any branch starting with `copilot/`

Just commit and push your changes:
```bash
git add .
git commit -m "Your changes"
git push origin main
```

The build will start automatically! ⚡

---

### 2️⃣ Manual Trigger via GitHub UI (Recommended)
Perfect when you want to build without making code changes.

**Steps:**
1. Go to your repository on GitHub
2. Click the **Actions** tab
3. Click on **Build Android APK** workflow (left sidebar)
4. Click the **Run workflow** dropdown button (right side)
5. Select your branch (usually `main`)
6. Click the green **Run workflow** button

✅ Done! The build will start immediately.

---

### 3️⃣ Empty Commit Trigger
Build without making actual changes to your code.

```bash
git commit --allow-empty -m "Trigger APK build"
git push origin main
```

This creates an empty commit that triggers the workflow.

---

## 📥 Downloading Your APK

After the workflow completes (takes about 8-12 minutes):

### Method A: Download from Artifacts
1. Go to **Actions** tab
2. Click on your workflow run (shows with a ✅ green checkmark when complete)
3. Scroll down to **Artifacts** section
4. Click on **android-apk** to download (it's a ZIP file)
5. Extract the ZIP file to get your APK

**Note:** Artifacts are kept for 30 days

### Method B: Download from Releases (main/master only)
If you pushed to `main` or `master` branch:
1. Go to **Releases** section (right sidebar on repo homepage)
2. Click on the latest release
3. Download the APK file directly

---

## 📊 Checking Build Status

### Live Progress
1. Go to **Actions** tab
2. Click on the running workflow
3. Watch the real-time logs

### Build States
- 🟡 **Yellow dot**: Build in progress
- ✅ **Green checkmark**: Build successful
- ❌ **Red X**: Build failed (check logs)

---

## 🔐 Building Signed APKs

By default, builds create **unsigned APKs** (fine for testing).

For **production/distribution**, add these repository secrets:
1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Add these four secrets:
   - `ANDROID_KEYSTORE_BASE64` (your keystore file, base64 encoded)
   - `ANDROID_KEYSTORE_PASSWORD` (keystore password)
   - `ANDROID_KEY_ALIAS` (key alias name)
   - `ANDROID_KEY_PASSWORD` (key password)

Once secrets are added, all builds will be automatically signed! 🎉

---

## ⏱️ Build Time

Typical build times:
- **First build**: 10-12 minutes (downloads dependencies)
- **Subsequent builds**: 8-10 minutes (uses cache)

---

## 🐛 Troubleshooting

### Build Failed?
1. Go to the failed workflow run
2. Click on the failed job
3. Expand the failed step to see error logs
4. Common issues:
   - Missing secrets (for signed builds)
   - Syntax errors in workflow file
   - Network issues (rare)

### No Artifact to Download?
- Make sure the build completed successfully (green checkmark)
- Check that you're looking at the right workflow run
- Verify the workflow has upload-artifact step

### Can't Find the Workflow?
- Make sure `.github/workflows/build-apk.yml` exists
- Check if Actions are enabled for your repository
- Settings → Actions → General → "Allow all actions"

---

## 💡 Pro Tips

1. **Watch your builds**: Enable email notifications for workflow runs
   - Settings → Notifications → GitHub Actions

2. **Build from specific branch**: Use manual trigger and select any branch

3. **Test before merging**: Build from feature branches (use `copilot/` prefix)

4. **Keep artifacts organized**: Releases are better for main builds, artifacts for testing

5. **Check logs**: Even successful builds may have warnings worth reviewing

---

## 🎓 Example Workflow

**Typical development flow:**
```bash
# 1. Make your changes
git checkout -b feature/my-feature
# ... make changes ...

# 2. Push to trigger test build (use copilot/ prefix)
git checkout -b copilot/test-build
git commit -m "Test changes"
git push origin copilot/test-build

# 3. Download artifact and test on device

# 4. Merge to main for production build
git checkout main
git merge copilot/test-build
git push origin main

# 5. Download from Release
```

---

## 📖 Related Documentation

- [Full APK Build Guide](./APK_BUILD_GUIDE.md) - Detailed build instructions
- [Local Build Guide](./APK_BUILD_GUIDE.md#method-2-build-locally) - Build on your computer
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

---

## ✅ Quick Checklist

Before triggering a build:
- [ ] Code is committed
- [ ] Branch name is correct (main/master/copilot/*)
- [ ] GitHub Actions are enabled
- [ ] (Optional) Signing secrets configured
- [ ] Ready to wait 8-12 minutes

After build completes:
- [ ] Check for green checkmark
- [ ] Download artifact or release
- [ ] Extract ZIP (if artifact)
- [ ] Test APK on Android device

---

## 🤝 Need Help?

If you're stuck:
1. Check the [troubleshooting section](#-troubleshooting) above
2. Review workflow logs for specific errors
3. Open an issue on GitHub with:
   - What you tried
   - Error messages
   - Workflow run link

Happy building! 🎉📱
