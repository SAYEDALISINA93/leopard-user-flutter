# CI/CD Quick Reference

## 🚀 Quick Deploy Commands

### Create a Release

```bash
# 1. Update version in pubspec.yaml
# version: 1.0.0+12

# 2. Commit changes
git add .
git commit -m "chore: bump version to 1.0.0+12"

# 3. Create and push tag
git tag v1.0.0+12
git push origin main
git push origin v1.0.0+12
```

### Manual Deploy (Local)

**Android:**

```bash
# Build AAB
flutter build appbundle --release

# Deploy to Play Store
cd android
bundle exec fastlane internal    # Internal testing
bundle exec fastlane beta         # Beta testing
bundle exec fastlane production   # Production release
```

**iOS:**

```bash
# Build IPA
flutter build ipa --release

# Deploy to TestFlight/App Store
cd ios
bundle exec fastlane beta         # TestFlight
bundle exec fastlane release      # App Store
```

## 📋 Required GitHub Secrets

### Android (5 secrets)

- `KEYSTORE_BASE64`
- `KEYSTORE_PASSWORD`
- `KEY_ALIAS`
- `KEY_PASSWORD`
- `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`

### iOS (7 secrets)

- `IOS_CERTIFICATES_P12`
- `IOS_CERTIFICATES_PASSWORD`
- `IOS_PROVISIONING_PROFILE`
- `APPLE_ID`
- `APPLE_APP_SPECIFIC_PASSWORD`
- `ITC_TEAM_ID`
- `TEAM_ID`

## 🔧 Common Commands

### Setup

```bash
# Install Fastlane dependencies
cd android && bundle install
cd ../ios && bundle install
```

### Encode Files for GitHub Secrets

```bash
# Keystore
cat android/app/upload-keystore.jks | base64 > keystore_base64.txt

# iOS Certificate
cat Certificates.p12 | base64 > ios_certificates_base64.txt

# Provisioning Profile
cat profile.mobileprovision | base64 > ios_provisioning_base64.txt
```

### Version Management

```bash
# Check current version
grep "version:" pubspec.yaml

# Update version (manually edit pubspec.yaml)
# version: 1.0.0+12
```

## 🎯 Workflow Status

Check status at: `https://github.com/SAYEDALISINA93/leopard-user-flutter/actions`

### CI Workflow

- **Triggers:** Push/PR to main or develop
- **Runs:** Tests, analysis, builds
- **Duration:** ~10-15 minutes

### CD Workflow

- **Triggers:** Git tags (v*.*.\*)
- **Runs:** Build, sign, deploy to stores
- **Duration:** ~20-30 minutes

## 🐛 Quick Troubleshooting

| Issue                   | Solution                                        |
| ----------------------- | ----------------------------------------------- |
| Build fails             | Check Flutter version in workflow matches local |
| Keystore error          | Verify base64 encoding is correct               |
| iOS signing fails       | Check certificate expiration date               |
| Play Store upload fails | Verify service account permissions              |
| TestFlight fails        | Check app-specific password                     |

## 📞 Support Links

- **GitHub Actions:** https://github.com/SAYEDALISINA93/leopard-user-flutter/actions
- **Play Console:** https://play.google.com/console
- **App Store Connect:** https://appstoreconnect.apple.com
- **Fastlane Docs:** https://docs.fastlane.tools

## ⚡ Pro Tips

1. Always test locally before pushing tags
2. Use internal/beta tracks for testing
3. Keep secrets secure and rotate regularly
4. Monitor workflow runs for failures
5. Document version changes in releases
