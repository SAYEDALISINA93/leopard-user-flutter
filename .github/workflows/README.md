# .github/workflows/README.md

# GitHub Actions Workflows

This directory contains CI/CD workflows for the Leopard User Flutter app.

## Workflows

### 🧪 CI - Build & Test (`ci.yml`)

**Purpose:** Continuous Integration - ensures code quality and build integrity

**Triggers:**

- Push to `main` or `develop` branches
- Pull requests to `main` or `develop` branches

**Jobs:**

1. **Analyze & Test**

   - Verify code formatting
   - Run static analysis
   - Execute unit tests
   - Generate coverage reports

2. **Build Android**

   - Build release APK
   - Upload as artifact (7 days retention)

3. **Build iOS**
   - Build iOS (unsigned)
   - Upload as artifact (7 days retention)

**Duration:** ~10-15 minutes

---

### 🚀 CD - Release & Deploy (`release.yml`)

**Purpose:** Continuous Deployment - automates app store releases

**Triggers:**

- Git tags matching pattern `v*.*.*` (e.g., `v1.0.0+11`)
- Manual workflow dispatch

**Jobs:**

1. **Build & Release Android**

   - Build signed AAB
   - Build signed APK
   - Upload to Play Store Internal Track
   - Create GitHub release with artifacts

2. **Build & Release iOS**
   - Build signed IPA
   - Upload to TestFlight
   - Create GitHub release with artifacts

**Duration:** ~20-30 minutes

---

## Setup Required

Before workflows can run successfully, you must configure GitHub Secrets:

### Android Secrets (5)

- `KEYSTORE_BASE64`
- `KEYSTORE_PASSWORD`
- `KEY_ALIAS`
- `KEY_PASSWORD`
- `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`

### iOS Secrets (7)

- `IOS_CERTIFICATES_P12`
- `IOS_CERTIFICATES_PASSWORD`
- `IOS_PROVISIONING_PROFILE`
- `APPLE_ID`
- `APPLE_APP_SPECIFIC_PASSWORD`
- `ITC_TEAM_ID`
- `TEAM_ID`

**See:** [`CI_CD_SETUP_GUIDE.md`](../../CI_CD_SETUP_GUIDE.md) for detailed instructions

---

## Usage

### Running CI

CI runs automatically on every push/PR. No manual action needed.

### Triggering a Release

**Method 1: Git Tag**

```bash
git tag v1.0.0+12
git push origin v1.0.0+12
```

**Method 2: Manual Dispatch**

1. Go to Actions → "CD - Release & Deploy"
2. Click "Run workflow"
3. Enter version number
4. Click "Run workflow"

---

## Monitoring

- **View workflow runs:** [Actions Tab](../../actions)
- **Check artifacts:** Available in completed workflow runs
- **View releases:** [Releases Page](../../releases)

---

## Troubleshooting

If a workflow fails:

1. Click on the failed workflow run
2. Expand the failed job/step
3. Review error logs
4. Check the [Setup Guide](../../CI_CD_SETUP_GUIDE.md#troubleshooting)

Common issues:

- Missing or incorrect secrets
- Expired certificates
- Version conflicts
- Network timeouts

---

## Workflow Badges

Add to your README.md:

```markdown
![CI](https://github.com/SAYEDALISINA93/leopard-user-flutter/workflows/CI%20-%20Build%20%26%20Test/badge.svg)
![CD](https://github.com/SAYEDALISINA93/leopard-user-flutter/workflows/CD%20-%20Release%20%26%20Deploy/badge.svg)
```

---

## Maintenance

### Updating Flutter Version

Edit the `flutter-version` in both workflow files:

```yaml
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: "3.24.5" # Update this
```

### Updating Actions

Periodically update action versions:

- `actions/checkout@v4`
- `actions/setup-java@v4`
- `subosito/flutter-action@v2`
- etc.

---

## Security Notes

⚠️ **Never commit:**

- Keystores
- Certificates
- Provisioning profiles
- Service account JSON files
- Passwords or API keys

✅ **Always:**

- Use GitHub Secrets for sensitive data
- Rotate secrets periodically
- Use least-privilege access
- Monitor workflow logs for exposed secrets

---

For detailed setup instructions, see [`CI_CD_SETUP_GUIDE.md`](../../CI_CD_SETUP_GUIDE.md)
