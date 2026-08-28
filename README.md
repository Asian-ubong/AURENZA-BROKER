# AURENZA BROKER

A comprehensive trading broker application with sandbox wallet management, challenges, and AI assistance. Multi-platform support (Web, Android, iOS).

```
AURENZA
   │
   └── BROKER
        │
        ├── 🟢 SANDBOX MODE (Active)
        │
        ├── 💰 $1,000,000 Virtual Treasury
        │
        ├── 🏦 Sandbox Wallet
        │   ├── Real-time balance tracking
        │   ├── Transaction ledger
        │   └── Daily allocation management
        │
        ├── 📋 Allocation Rules
        │   ├── $50 Minimum per request
        │   ├── $200 Maximum per request
        │   └── $200 Daily Limit
        │
        ├── 📊 Sandbox Ledger
        │   └── Complete transaction history
        │
        ├── 🔗 Broker Integrations (Demo)
        │   ├── Deriv Demo Connection
        │   └── MetaTrader 5 Demo Connection
        │
        └── 💵 Real Withdrawable: $0.00 (Disabled in Sandbox)
```

## Overview

**AURENZA BROKER** is a full-stack trading platform offering:
- 🔐 Secure authentication system
- 💰 Advanced wallet management with sandbox mode
- 🎯 Trading challenges and leaderboards
- 📈 Real-time market integration
- 🤖 AI-powered trading assistant
- ⚙️ Comprehensive admin panel
- 🌐 Multi-platform deployment (Web, Android, iOS)

---

## Project Status

### ✅ Completed Phases

#### Phase 1: Project Foundation
- [x] Flutter project structure initialized
- [x] Material Design 3 theme setup
- [x] Dark mode color scheme implemented
- [x] Project configuration finalized

#### Phase 2: Sandbox Dashboard UI & Logic (Current)
- [x] Dashboard UI with responsive design
- [x] Sandbox capital allocation system
- [x] Transaction ledger with history tracking
- [x] Broker connection cards (Deriv, MT5)
- [x] Navigation sidebar
- [x] Desktop/mobile adaptive layout
- [x] Validation logic for allocations
- [x] SnackBar notifications
- [x] State management with `setState()`

### 📋 Upcoming Phases

- [ ] **Phase 3:** Splash Screen & App Launch Animation
- [ ] **Phase 4:** Onboarding Flow & Tutorials
- [ ] **Phase 5:** Authentication System (Login/Register)
- [ ] **Phase 6:** Complete Wallet Implementation
- [ ] **Phase 7:** Challenge System
- [ ] **Phase 8:** Trading Integration (Deriv & MetaTrader APIs)
- [ ] **Phase 9:** AI Assistant
- [ ] **Phase 10:** Admin Panel
- [ ] **Phase 11:** Marketing Website
- [ ] **Phase 12:** Android Native Build
- [ ] **Phase 13:** iOS Native Build

---

## Features

### Current Implementation

#### 🟢 Sandbox Mode
- Virtual $1,000,000 trading capital
- Completely isolated test environment
- No real money involved
- Perfect for learning and testing

#### 💰 Wallet Management
- Real-time balance display
- Capital allocation requests
- Transaction history tracking
- Daily allocation limits enforcement

#### 📊 Dashboard
- Overview cards (Treasury, Balance, Daily Allocation, Withdrawable)
- Responsive grid layout
- Real-time metrics updates
- Clean, professional UI

#### 🔗 Broker Connections
- Deriv integration (demo)
- MetaTrader 5 integration (demo)
- Broker status indicators
- Connection lock interface

#### 📱 Responsive Design
- Desktop optimized (≥1000px width)
- Mobile first approach
- Adaptive components
- Touch-friendly controls

---

## Technical Stack

### Frontend
```
Framework:     Flutter (latest stable)
Language:      Dart
Design:        Material Design 3
State Mgmt:    setState() (local)
Theming:       Dark mode optimized
Responsiveness: Adaptive UI
```

### Architecture

```
lib/
├── main.dart                 # App entry point & main widgets
│   ├── AurenzaApp           # Root app configuration
│   ├── BrokerDashboard      # Dashboard stateful widget
│   ├── _BrokerDashboardState
│   │   ├── State variables
│   │   ├── Validation logic
│   │   ├── UI builders
│   │   └── Event handlers
│   ├── SandboxTransaction   # Data model
│   └── Sidebar              # Navigation component
```

### State Variables

| Variable | Type | Purpose |
|----------|------|---------|
| `sandboxBalance` | `double` | Current virtual balance in USD |
| `dailyAllocated` | `double` | Amount allocated today |
| `treasury` | `const double` | Total virtual capital: $1,000,000 |
| `minimumAllocation` | `const double` | Min per request: $50 |
| `maximumAllocation` | `const double` | Max per request: $200 |
| `dailyLimit` | `const double` | Daily cap: $200 |
| `transactions` | `List<SandboxTransaction>` | Transaction history |
| `allocationController` | `TextEditingController` | User input field |

### Key Methods

| Method | Purpose |
|--------|---------|
| `requestAllocation()` | Process & validate capital allocation requests |
| `_showMessage(String)` | Display user feedback notifications |
| `_buildDashboard()` | Main layout structure |
| `_buildOverviewCards()` | Metric cards grid/column |
| `_buildAllocationSection()` | Input form & rules |
| `_buildBrokerConnections()` | Broker cards display |
| `_buildTransactions()` | Transaction ledger |

---

## Validation Rules

### Allocation Constraints
```
✓ Amount must be numeric and positive
✓ Minimum allocation: $50
✓ Maximum allocation per request: $200
✓ Daily maximum: $200 total
✓ Real withdrawals: DISABLED in sandbox
```

### Error Handling
- Invalid amount format detection
- Minimum threshold validation
- Maximum threshold validation
- Daily limit enforcement
- User-friendly error messages via SnackBar

---

## UI/UX Design

### Color Scheme
```
Primary Background:     #07111F  (Deep Navy)
Card Background:        #0B192B  (Navy Blue)
Primary Accent:         #2F80ED  (Bright Blue)
Secondary Accent:       #62AEFF  (Light Blue)
Success Indicator:      #42D392  (Green)
Muted Text:             #8FA5BD  (Gray-Blue)
Borders:                rgba(255, 255, 255, 0.06)
```

### Responsive Breakpoints
```
Mobile:   < 650px   (Single column layout)
Tablet:   650px - 999px (Single column with padding)
Desktop:  ≥ 1000px  (Sidebar + Main content)
```

### Components
- TopBar with logo and profile
- Status chip (Sandbox Mode indicator)
- Overview cards (4 metrics)
- Allocation input form
- Broker connection cards
- Transaction ledger
- Navigation sidebar (desktop)

---

## Getting Started

### Prerequisites
```
Flutter SDK:  Latest stable version
Dart:         2.19 or higher
OS:           macOS, Linux, or Windows
Android:      API level 21+ (for future mobile builds)
iOS:          iOS 11.0+ (for future mobile builds)
```

### Installation

```bash
# Clone the repository
git clone https://github.com/Asian-ubong/AURENZA-BROKER.git

# Navigate to project directory
cd AURENZA-BROKER

# Install dependencies
flutter pub get

# Run code analysis
flutter analyze

# Run tests
flutter test
```

### Running the Application

#### Web (Chrome)
```bash
flutter run -d chrome
```

#### Desktop (Windows)
```bash
flutter run -d windows
```

#### Desktop (macOS)
```bash
flutter run -d macos
```

#### Desktop (Linux)
```bash
flutter run -d linux
```

#### Mobile (Android)
```bash
flutter run -d android
```

#### Mobile (iOS)
```bash
flutter run -d ios
```

### Development Commands

```bash
# Clean build artifacts
flutter clean

# Get latest dependencies
flutter pub get

# Analyze code for issues
flutter analyze

# Run unit and widget tests
flutter test

# Run with hot reload
flutter run

# Run with specific device
flutter run -d <device-id>

# Build for production (web)
flutter build web --release

# Build for production (android)
flutter build apk --release

# Build for production (ios)
flutter build ios --release
```

---

## Project Structure

```
AURENZA-BROKER/
├── lib/
│   └── main.dart                    # Main application file
├── test/
│   └── widget_test.dart             # Widget tests (future)
├── pubspec.yaml                     # Project dependencies
├── pubspec.lock                     # Locked dependency versions
├── analysis_options.yaml            # Linter configuration
├── README.md                        # This file
└── .gitignore                       # Git ignore rules
```

---

## Development Roadmap

### Phase 3: Splash Screen (Next)
- [ ] App launch animation
- [ ] Branding display
- [ ] Loading indicators
- [ ] Transition to dashboard

### Phase 4: Onboarding
- [ ] Welcome screen
- [ ] Feature tours
- [ ] User preferences setup
- [ ] Terms & conditions

### Phase 5: Authentication
- [ ] User registration
- [ ] Email/password login
- [ ] Password recovery
- [ ] 2FA setup
- [ ] Session management

### Phase 6: Wallet
- [ ] Deposit methods
- [ ] Withdrawal requests
- [ ] Transaction history
- [ ] Balance notifications

### Phase 7: Challenge System
- [ ] Challenge creation
- [ ] Leaderboard display
- [ ] Rewards tracking
- [ ] Challenge filtering

### Phase 8: Trading Integration
- [ ] Deriv API integration
- [ ] MetaTrader 5 integration
- [ ] Live price feeds
- [ ] Order management

### Phase 9: AI Assistant
- [ ] Chat interface
- [ ] Trading recommendations
- [ ] Market analysis
- [ ] Natural language processing

### Phase 10: Admin Panel
- [ ] User management
- [ ] Transaction monitoring
- [ ] System analytics
- [ ] Configuration controls

### Phase 11: Website
- [ ] Landing page
- [ ] Feature showcase
- [ ] Blog/documentation
- [ ] Contact forms

### Phase 12-13: Mobile Builds
- [ ] Android APK release
- [ ] iOS IPA release
- [ ] App store deployment
- [ ] Update management

---

## Contributing

Contributions are welcome! Please follow these steps:

1. **Fork** the repository
2. **Create** a feature branch
   ```bash
   git checkout -b feature/YourFeatureName
   ```
3. **Commit** your changes
   ```bash
   git commit -m 'Add detailed description of changes'
   ```
4. **Push** to your branch
   ```bash
   git push origin feature/YourFeatureName
   ```
5. **Open** a Pull Request with description of changes

### Code Style Guidelines
- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Run `flutter analyze` before committing
- Ensure all tests pass

---

## Testing

### Run Tests
```bash
flutter test
```

### Widget Testing
Tests for UI components and user interactions.

### Unit Testing
Tests for business logic and validation.

### Integration Testing
Tests for end-to-end user flows.

---

## Deployment

### Web Deployment
```bash
flutter build web --release
# Deploy the build/ directory to your hosting provider
```

### Android Deployment
```bash
flutter build apk --release
# Upload to Google Play Store
```

### iOS Deployment
```bash
flutter build ios --release
# Upload to Apple App Store
```

---

## Performance Optimization

### Current Implementation
- ✅ CustomScrollView with SliverList (efficient scrolling)
- ✅ Adaptive layout without unnecessary rebuilds
- ✅ Optimized theme data with Material 3
- ✅ Local state management (no external packages)

### Future Improvements
- [ ] Implement Provider for state management
- [ ] Add caching layer for API responses
- [ ] Optimize widget rebuild strategy
- [ ] Implement lazy loading for transactions
- [ ] Add pagination for large datasets

---

## Known Limitations (Sandbox Mode)

⚠️ **Current Status:**
- ❌ Deriv & MetaTrader connections are locked (demo only)
- ❌ Withdrawals are disabled ($0.00 shown)
- ❌ Real money cannot be deposited
- ❌ No persistent data (resets on app restart)
- ❌ No authentication system yet

These limitations are intentional for the sandbox/demo phase.

---

## Security Considerations

### Current Implementation
- ✅ Input validation for allocation amounts
- ✅ Daily limit enforcement
- ✅ Per-request maximum checks
- ✅ Error messages do not expose sensitive data

### Future Implementation
- [ ] API authentication & tokens
- [ ] Encrypted local storage
- [ ] SSL/TLS certificate pinning
- [ ] Rate limiting
- [ ] Two-factor authentication
- [ ] Audit logging

---

## Troubleshooting

### Common Issues

**Issue:** "flutter: command not found"
```bash
# Add Flutter to your PATH
export PATH="$PATH:/path/to/flutter/bin"
```

**Issue:** Dependency conflicts
```bash
flutter pub get --no-offline
flutter pub upgrade
```

**Issue:** Build errors on clean install
```bash
flutter clean
flutter pub get
flutter pub upgrade
flutter analyze
```

---

## License

[Add your license here - e.g., MIT, Apache 2.0, GPL]

---

## Contact & Support

For questions, feedback, or support:

📧 **Email:** supportdeveloperer@gmail.com

📱 **GitHub Issues:** [Open an issue](https://github.com/Asian-ubong/AURENZA-BROKER/issues)

💬 **Discussions:** [Start a discussion](https://github.com/Asian-ubong/AURENZA-BROKER/discussions)

---

## Changelog

### Version 0.1.0 (Current)
- ✅ Initial project foundation
- ✅ Sandbox dashboard UI
- ✅ Capital allocation system
- ✅ Transaction ledger
- ✅ Responsive design
- ✅ Material Design 3 theme

---

## Acknowledgments

Built with ❤️ using Flutter and Dart.

*Last updated: August 28, 2026*
