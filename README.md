# ORANZO ADMIN

The ORANZO ADMIN master platform combines the customer trading experience with the administrative, finance, operations, risk, compliance, broker, AI, support, and audit control layers.

```text
ORANZO ADMIN
   │
   ├── CUSTOMER PLATFORM
   │   ├── Dashboard
   │   ├── Wallet
   │   ├── Sandbox
   │   ├── Markets
   │   ├── Trading
   │   ├── Investment Profit
   │   ├── Trade History
   │   ├── Trending AI
   │   ├── Security
   │   ├── Connected Brokers
   │   ├── Support
   │   └── Settings
   │
   └── ADMIN CONTROL
       ├── Overview
       ├── Users
       ├── KYC & Compliance
       ├── Finance
       ├── Trading Monitor
       ├── Investment Profit
       ├── Withdrawals
       ├── Risk & Security
       ├── Brokers
       ├── AI Center
       ├── Support
       ├── Roles & Permissions
       ├── Audit Logs
       ├── System Settings
       └── System Health
```

## Master architecture

ORANZO ADMIN keeps the normal customer screens while adding the ORANZO administrative control layer. Company funds and customer funds remain strictly separated.

```text
                         ORANZO ADMIN
                              │
          ┌───────────────────┼───────────────────┐
          │                   │                   │
          ▼                   ▼                   ▼
   CUSTOMER PLATFORM    ADMIN CONTROL        AI / ANALYTICS
          │                   │                   │
          └───────────────────┼───────────────────┘
                              ▼
                    SUPABASE / POSTGRES
                              │
             ┌────────────────┼────────────────┐
             ▼                ▼                ▼
          WALLETS          TRADING          AUDIT
             │                │                │
             ▼                ▼                ▼
       Company/User      Deriv + MT5       Ledger/Logs
```

## Wallet boundary

```text
COMPANY WALLET
      ≠
USER WALLET A
USER WALLET B
USER WALLET C
```

Every customer has an independently identified wallet. Withdrawal workflows must resolve the requesting user to that exact wallet and its eligible withdrawable balance.

## Current application capabilities

- Secure authentication foundation
- Responsive customer application shell
- Customer wallet and wallet snapshot integration
- Sandbox capital model
- Trading navigation foundation
- Investment profit module foundation
- Deriv and MetaTrader 5 integration architecture
- AI trending/market analysis foundation
- ORANZO ADMIN console foundation
- Admin finance monitoring
- Role-based admin access foundation
- Responsive desktop/tablet/mobile layouts

## Admin sections

1. Overview
2. Users
3. KYC & Compliance
4. Finance
5. Trading Monitor
6. Investment Profit
7. Withdrawals
8. Risk & Security
9. Brokers
10. AI Center
11. Support
12. Roles & Permissions
13. Audit Logs
14. System Settings
15. System Health

## Technology

- Flutter / Dart
- Material Design 3
- Supabase
- PostgreSQL
- Deriv integration architecture
- MetaTrader 5 integration architecture

## Repository

The GitHub repository remains `Asian-ubong/AURENZA-BROKER` for continuity of the existing project history. The application-facing platform name is now **ORANZO ADMIN**.

## Development

```bash
flutter pub get
flutter analyze
flutter test
flutter build web --release
flutter build apk --release
```
