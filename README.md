# ArticlesApp

A modern iOS 18+ app built with **SwiftUI** that fetches and displays articles from a mock API.

---

## Requirements

| Tool | Version |
|------|---------|
| Xcode | 16.0+ |
| iOS Deployment Target | 18.0+ |
| CocoaPods | 1.14+ |
| Swift | 5.10+ |

---

## Setup Instructions

### 1. Clone / Download
Unzip the project folder, then open Terminal and `cd` into the project root:
```bash
cd ArticlesApp
```

### 2. Create Xcode Project
Open **Xcode → File → New → Project**
- Template: **App**
- Product Name: `ArticlesApp`
- Bundle ID: `com.dev.ArticlesApp`
- Interface: **SwiftUI**
- Language: **Swift**
- Testing: **None**
- Storage: **None**

Save it **inside** this folder so the `ArticlesApp/` source directory is alongside `ArticlesApp.xcodeproj`.

### 3. Add Source Files
Drag all folders from the provided `ArticlesApp/` source directory into your Xcode project:
```
ArticlesApp/
├── Models/
├── Provider/
├── Managers/
├── ViewControllers/
├── DI/
├── Assets.xcassets/
├── Info.plist
├── LaunchScreen.storyboard
├── AppDelegate.swift
└── ArticlesAppApp.swift
```
When prompted: ✅ **Copy items if needed** → ✅ **Create groups**

### 4. Install Pods
```bash
pod install
```

### 5. Open Workspace
```bash
open ArticlesApp.xcworkspace
```
> ⚠️ Always open `.xcworkspace`, NOT `.xcodeproj` after installing pods.

### 6. Build & Run
Select a simulator (iPhone 16 / iPad) → Press **⌘R**

---

## Project Architecture

```
ArticlesApp/
├── Models/
│   ├── Models/             → Article.swift (Codable struct)
│   └── ProviderProtocols/  → ArticleProviderProtocol.swift
├── Provider/
│   ├── Client/             → NetworkClient.swift, NetworkError.swift
│   └── Core/               → ArticleProvider.swift
├── Managers/
│   ├── Client/             → CacheManager, ReachabilityManager, Constants
│   └── Core/               → ArticleManager.swift
├── ViewControllers/
│   ├── Client/             → Router.swift, AlertHelper.swift
│   └── Core/
│       ├── ArticleListView.swift
│       ├── ArticleDetailView.swift
│       └── Cells/ArticleCardView.swift
├── DI/                     → AppAssembly.swift (Swinject)
├── AppDelegate.swift
└── ArticlesAppApp.swift
```

## Libraries Used

| Pod | Purpose |
|-----|---------|
| `Alamofire` | HTTP networking |
| `AlamofireNetworkActivityIndicator` | Status bar spinner |
| `Cache` | Disk + memory caching |
| `XCGLogger` | Structured logging |
| `Swinject` | Dependency injection |
| `ReachabilitySwift` | Network connectivity |
| `Kingfisher` | Async image loading |
| `FTLinearActivityIndicator` | Linear network indicator |
| `KMNavigationBarTransition` | Smooth nav bar transitions |
| `Loaf` | Toast notifications |

## API
`GET https://mocki.io/v1/50422b19-547f-41c0-b623-e82d886ad264`

## Features
- ✅ Article list with search
- ✅ Article detail with hero image
- ✅ Offline banner + cached fallback
- ✅ Pull-to-refresh
- ✅ Liquid Glass material effects (iOS 18+)
- ✅ iPad + iPhone adaptive layout
- ✅ Kingfisher image loading with placeholders
- ✅ Disk + memory cache (1 hour expiry)
- ✅ Swinject dependency injection
- ✅ XCGLogger throughout network layer
