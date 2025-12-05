# CI/CD Setup Guide for Leopard User App

This guide will help you set up Continuous Integration and Continuous Deployment for your Flutter app using GitHub Actions and Fastlane.

## 📋 Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Android Setup](#android-setup)
4. [iOS Setup](#ios-setup)
5. [GitHub Secrets Configuration](#github-secrets-configuration)
6. [Workflow Triggers](#workflow-triggers)
7. [Testing the Setup](#testing-the-setup)
8. [Troubleshooting](#troubleshooting)

## 🎯 Overview

### What's Included

- **CI Workflow** (`ci.yml`): Runs on every push/PR

  - Code formatting check
  - Static analysis
  - Unit tests with coverage
  - Build verification for Android & iOS

- **CD Workflow** (`release.yml`): Runs on version tags
  - Builds signed APK & AAB for Android
  - Builds signed IPA for iOS
  - Deploys to Play Store Internal Track
  - Deploys to TestFlight
  - Creates GitHub releases

## ✅ Prerequisites

### Required Tools

1. **GitHub Account** with admin access to the repository
2. **Google Play Console** account
3. **Apple Developer** account (for iOS)
4. **Fastlane** installed locally (for setup)

```bash
# Install Fastlane
sudo gem install fastlane

# Or using Homebrew
brew install fastlane
```

## 🤖 Android Setup

### Step 1: Prepare Keystore

Your keystore is already configured at `android/key.properties`. We need to encode it for GitHub Secrets.

```bash
# Navigate to your project
cd /Users/alisina/Documents/Projects/customers/Leopard/user/leopard-user-flutter

# Encode keystore to base64 (use the path from your key.properties)
cat android/app/upload-keystore.jks | base64 > keystore_base64.txt
# OR if your keystore is elsewhere:
cat /path/to/your/keystore.jks | base64 > keystore_base64.txt
```

Keep the `keystore_base64.txt` file safe - you'll need it for GitHub Secrets.

### Step 2: Create Google Play Service Account

1. Go to [Google Play Console](https://play.google.com/console)
2. Navigate to **Settings** → **API access**
3. Click **Create new service account**
4. Follow the link to Google Cloud Console
5. Create a new service account with name: `github-actions-leopard-user`
6. Grant these permissions:
   - Service Account User
7. Create and download the JSON key
8. Back in Play Console, grant access to the service account:
   - Admin (View app information and download bulk reports)
   - Release to production, exclude devices, and use Play App Signing
   - Release apps to testing tracks

### Step 3: Setup Fastlane (Android)

```bash
cd android
bundle install
```

## 🍎 iOS Setup

### Step 1: Create App-Specific Password

1. Go to [appleid.apple.com](https://appleid.apple.com)
2. Sign in with your Apple ID
3. Navigate to **Security** → **App-Specific Passwords**
4. Generate a new password for "GitHub Actions"
5. Save this password securely

### Step 2: Export Certificates

```bash
# Open Keychain Access on your Mac
# File → Export Items
# Select your Distribution Certificate and Private Key
# Export as .p12 file with a password

# Convert to base64
cat /path/to/Certificates.p12 | base64 > ios_certificates_base64.txt
```

### Step 3: Export Provisioning Profile

```bash
# Download your Distribution provisioning profile from Apple Developer
# Or find it in: ~/Library/MobileDevice/Provisioning Profiles/

# Convert to base64
cat /path/to/profile.mobileprovision | base64 > ios_provisioning_base64.txt
```

### Step 4: Create ExportOptions.plist

```bash
cd ios
cat > ExportOptions.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
    <key>uploadBitcode</key>
    <false/>
    <key>compileBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
    <key>signingStyle</key>
    <string>manual</string>
    <key>provisioningProfiles</key>
    <dict>
        <key>app.theleopard.rider</key>
        <string>Leopard User Distribution</string>
    </dict>
</dict>
</plist>
EOF
```

Replace `YOUR_TEAM_ID` with your actual Apple Team ID (found in Apple Developer account).

### Step 5: Setup Fastlane (iOS)

```bash
cd ios
bundle install
```

## 🔐 GitHub Secrets Configuration

Go to your GitHub repository → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

Add these secrets one by one:

### Android Secrets

| Secret Name                        | Value                                            | How to Get                                    |
| ---------------------------------- | ------------------------------------------------ | --------------------------------------------- |
| `KEYSTORE_BASE64`                  | Content of `keystore_base64.txt`                 | From Step 1 of Android Setup                  |
| `KEYSTORE_PASSWORD`                | Your keystore password                           | From `android/key.properties` (storePassword) |
| `KEY_ALIAS`                        | Your key alias                                   | From `android/key.properties` (keyAlias)      |
| `KEY_PASSWORD`                     | Your key password                                | From `android/key.properties` (keyPassword)   |
| `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` | Full content of Google Play service account JSON | From Step 2 of Android Setup                  |

### iOS Secrets

| Secret Name                   | Value                                    | How to Get                                    |
| ----------------------------- | ---------------------------------------- | --------------------------------------------- |
| `IOS_CERTIFICATES_P12`        | Content of `ios_certificates_base64.txt` | From Step 2 of iOS Setup                      |
| `IOS_CERTIFICATES_PASSWORD`   | Password you used when exporting .p12    | The password you set                          |
| `IOS_PROVISIONING_PROFILE`    | Content of `ios_provisioning_base64.txt` | From Step 3 of iOS Setup                      |
| `APPLE_ID`                    | Your Apple ID email                      | Your Apple Developer email                    |
| `APPLE_APP_SPECIFIC_PASSWORD` | App-specific password                    | From Step 1 of iOS Setup                      |
| `ITC_TEAM_ID`                 | App Store Connect Team ID                | Found in App Store Connect → Users and Access |
| `TEAM_ID`                     | Developer Team ID                        | Found in Apple Developer → Membership         |

### How to Add Secrets

```bash
# Example: Using GitHub CLI (optional)
gh secret set KEYSTORE_BASE64 < keystore_base64.txt
gh secret set KEYSTORE_PASSWORD -b "your_password"
gh secret set KEY_ALIAS -b "your_alias"
# ... etc
```

Or manually through GitHub UI:

1. Click "New repository secret"
2. Enter the name (e.g., `KEYSTORE_BASE64`)
3. Paste the value
4. Click "Add secret"

## 🚀 Workflow Triggers

### CI Workflow (Automatic)

Runs automatically on:

- Every push to `main` or `develop` branches
- Every pull request to `main` or `develop` branches

### Release Workflow (Manual/Tag-based)

**Option 1: Create a Git Tag**

```bash
# Update version in pubspec.yaml first
# Then create and push tag
git tag v1.0.0+11
git push origin v1.0.0+11
```

**Option 2: Manual Trigger**

1. Go to GitHub → Actions → "CD - Release & Deploy"
2. Click "Run workflow"
3. Enter version number (e.g., `1.0.0+11`)
4. Click "Run workflow"

## 🧪 Testing the Setup

### Test CI Workflow

```bash
# Make a small change
echo "# CI/CD Test" >> README.md
git add .
git commit -m "test: CI workflow"
git push origin main
```

Go to GitHub → Actions and watch the workflow run.

### Test Release Workflow

```bash
# Create a test tag
git tag v1.0.0+11-test
git push origin v1.0.0+11-test
```

Or use the manual trigger in GitHub Actions.

## 🐛 Troubleshooting

### Common Issues

**1. Keystore not found**

- Verify the keystore is properly base64 encoded
- Check the secret name matches exactly (case-sensitive)

**2. iOS Code signing failed**

- Ensure certificates are valid and not expired
- Verify provisioning profile matches the bundle ID
- Check Team ID is correct

**3. Google Play upload failed**

- Verify service account has correct permissions
- Check package name matches
- Ensure version code is higher than previous releases

**4. Build fails on dependencies**

- Clear cache by re-running workflow
- Check Flutter version compatibility

**5. TestFlight upload failed**

- Verify Apple ID and app-specific password
- Check app bundle ID matches
- Ensure app is created in App Store Connect

### Logs and Debugging

- GitHub Actions logs: Go to Actions → Select workflow run → View logs
- Enable debug logging: Add secret `ACTIONS_STEP_DEBUG` = `true`
- For Fastlane issues: Check the detailed output in workflow logs

### Getting Help

- Fastlane docs: https://docs.fastlane.tools
- GitHub Actions docs: https://docs.github.com/en/actions
- Flutter CI/CD guide: https://docs.flutter.dev/deployment/cd

## 📝 Best Practices

1. **Never commit secrets** to the repository
2. **Test locally first** using Fastlane commands
3. **Use version tags** for releases consistently
4. **Monitor workflows** regularly for failures
5. **Keep dependencies updated** (Flutter, Fastlane, actions)
6. **Use staging tracks** (Internal/Beta) before production
7. **Enable notifications** for workflow failures

## 🔄 Updating the Workflows

To modify workflows:

1. Edit `.github/workflows/*.yml` files
2. Commit and push changes
3. Workflows update automatically

To modify Fastlane:

1. Edit `android/fastlane/Fastfile` or `ios/fastlane/Fastfile`
2. Test locally: `bundle exec fastlane [lane_name]`
3. Commit changes

## 📦 Manual Deployment

If you need to deploy manually:

### Android

```bash
cd android
bundle exec fastlane internal   # Deploy to internal track
bundle exec fastlane beta        # Deploy to beta track
bundle exec fastlane production  # Deploy to production
```

### iOS

```bash
cd ios
bundle exec fastlane beta        # Deploy to TestFlight
bundle exec fastlane release     # Deploy to App Store
```

## ✨ Next Steps

1. ✅ Complete the setup following this guide
2. ✅ Test CI workflow with a small commit
3. ✅ Test release workflow with a test tag
4. ✅ Monitor first deployment to internal/beta tracks
5. ✅ Set up Slack/Discord notifications (optional)
6. ✅ Configure branch protection rules
7. ✅ Document your release process

## 🎉 You're All Set!

Your CI/CD pipeline is now configured. Every push will trigger tests and builds, and every tag will trigger a release to both stores.

For questions or issues, refer to the troubleshooting section or check the workflow logs in GitHub Actions.
