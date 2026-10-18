# Google Play and Apple App Store compliance for "Danfo" (free, ad-funded, offline-first 3D game, Nigeria-first), as of 18 October 2026, covering late 2026 to 2027

Research notes. Snapshot date: 18 Oct 2026. Every requirement below has an effective date and a source. Requirements that are **announced but not yet in effect** are marked **[UPCOMING]**. Requirements I could not confirm from a primary source are marked **[UNVERIFIED]** and listed under Gaps.

Method note for the report writer: this session's egress proxy **blocked** `support.google.com` (Play Console Help), `play.google.com` (Play policy centre), `android-developers.googleblog.com`, `godotengine.org`/`docs.godotengine.org`, `docs.unity.com`/`docs.unity3d.com`/`discussions.unity.com`. The web-search budget also ran out partway through. Play Console Help and Play policy content therefore comes only from search-engine summaries of those pages, or is listed as a Gap. `developer.android.com`, `developer.apple.com` and `raw.githubusercontent.com` (Godot source) were fetched directly.

---

## Consolidated dated timeline (both stores)

### Takeaway
The deadlines that bind Danfo are:
- **Play:** targetSdk 36 (in force since 31 Aug 2026), the 16 KB page-size block on updates (1 Feb 2027), memory and code-optimisation vitals enforcement (Feb 2027), and an expected targetSdk 37 requirement around Aug 2027 that Google has not yet announced.
- **Apple:** the iOS 26 SDK (in force since 28 Apr 2026), a minimum deployment target of iOS 13 (since 9 Sep 2026), and the iOS 27 SDK (from April 2027).
- **Both stores:** age-assurance obligations, which keep spreading by jurisdiction.

### Cited Findings
| Date | Store | Requirement | Status (18 Oct 2026) |
|---|---|---|---|
| 1 May 2024 | Apple | Approved reasons required for required-reason APIs (incl. in third-party SDKs) to upload new/updated apps | In force — [Apple Upcoming requirements](https://developer.apple.com/news/upcoming-requirements/) |
| 16 Oct 2024 / 17 Feb 2025 | Apple | DSA trader status required to submit updates (EU) / apps without trader status removed from EU storefronts | In force — [Apple Upcoming requirements](https://developer.apple.com/news/upcoming-requirements/) |
| Sep 2025 | Play | New titles cannot publish with Play Games Services v1 SDK/APIs | In force — [PGS deprecation](https://developer.android.com/games/pgs/deprecation) |
| 31 Jan 2026 | Apple | Answer the new age-rating questionnaire or app updates are interrupted | In force — [Apple Upcoming requirements](https://developer.apple.com/news/upcoming-requirements/) |
| 24 Feb 2026 | Apple | Users in Australia, Brazil and Singapore are blocked from downloading 18+ apps unless confirmed adult | In force — [Apple news 24 Feb 2026](https://developer.apple.com/news/?id=f5zj08ey) |
| 1 Mar 2026 | Play | Excessive partial wake lock enforcement (store-listing warning / discovery exclusion) begins rolling out | In force — [Android Developers Blog, Mar 2026](https://android-developers.googleblog.com/2026/03/battery-technical-quality-enforcement.html) (via search summary) |
| 17 Mar 2026 | Play | Play Age Signals API returns signals for Brazil users (Digital ECA) | In force — [Play Age Signals](https://developer.android.com/google/play/age-signals/overview) |
| 28 Apr 2026 | Apple | Uploads must be built with Xcode 26+ and the iOS 26 SDK | In force — [Apple Upcoming requirements](https://developer.apple.com/news/upcoming-requirements/) |
| 6 May 2026 / 1 Jul 2026 | Apple | Age categories shared through the Declared Age Range API for new Apple Accounts in Utah / Louisiana | In force — [Apple news 24 Feb 2026](https://developer.apple.com/news/?id=f5zj08ey) |
| 28 May / 4 Jun 2026 | Play / Apple | Texas SB 2420 age assurance live (after the injunction was lifted) | In force — [Play Age Signals](https://developer.android.com/google/play/age-signals/overview); [Apple news 3 Jun 2026](https://developer.apple.com/news/?id=sg176nne) |
| 18 Jun 2026 | Apple | Australia's 15+ rating retired (loot boxes etc. move to 16+); Vietnam gets region-specific ratings | In force — [Apple news 21 May 2026](https://developer.apple.com/news/?id=yrrb45pw) |
| 15 Jun 2026 / Sep 2026 | Play | PGS SDK v25.0.0 removes v1 APIs; Google Sign-In for Android API no longer supported | In force — [PGS deprecation](https://developer.android.com/games/pgs/deprecation) |
| 31 Aug 2026 (extension to 1 Nov 2026) | Play | New apps and updates must target API 36 (Android 16); existing apps must target ≥35 to stay visible to new users on newer OS | In force — [Target API (developer.android.com)](https://developer.android.com/google/play/requirements/target-sdk) |
| 9 Sep 2026 | Apple | iOS/iPadOS apps uploaded must target iOS 13 or later | In force — [Apple Upcoming requirements](https://developer.apple.com/news/upcoming-requirements/) |
| 30 Sep 2026 | Android (all certified devices) | Developer verification enforced for installs from participating stores in Brazil, Indonesia, Singapore and Thailand | In force — [Android developer verification](https://developer.android.com/developer-verification) |
| 16 Oct 2026 | Apple | App Review Guidelines revised (new 2.3.14 creative assets, 2.5.19 hidden features) | In force — [Apple news 16 Oct 2026](https://developer.apple.com/news/?id=92th7e5i) |
| iOS 27.2 (date TBA) | Apple | Alternative ATT prompt in the EU; mandatory in DE, FR, IT, PL, RO | **[UPCOMING]** — [Apple news 16 Sep 2026](https://developer.apple.com/news/?id=idsft9ai) |
| 1 Feb 2027 | Play | App updates that don't support 16 KB page sizes can't be released | **[UPCOMING]** — [Support 16 KB page sizes](https://developer.android.com/guide/practices/page-sizes) |
| Feb 2027 | Play | Store visibility impact begins for exceeding memory, bitmap-memory or code-optimisation thresholds | **[UPCOMING]** — [Android vitals](https://developer.android.com/topic/performance/vitals) |
| April 2027 | Apple | Uploads must be built with the iOS 27 / iPadOS 27 SDK or later | **[UPCOMING]** — [Apple news 9 Sep 2026](https://developer.apple.com/news/?id=k1mtkt1k) |
| May or June 2027 | Play | PGS v1 traffic blocked / v1 SDK removed (the page gives both months) | **[UPCOMING]** — [PGS deprecation](https://developer.android.com/games/pgs/deprecation) |
| 2027 | Android | Developer verification expands globally to all apps on certified devices (would include Nigeria) | **[UPCOMING]** — [Android developer verification](https://developer.android.com/developer-verification) |
| ~Aug 2027 | Play | targetSdk 37 (Android 17) expected for new apps and updates | **[UPCOMING, NOT OFFICIALLY ANNOUNCED]** — only a secondary source says so (see Target API section) |

### Inferences
- A Danfo launch in late 2026 to early 2027 must ship with targetSdk 36, 16 KB-aligned native libraries and the iOS 26 SDK. Any update after April 2027 needs the iOS 27 SDK. Plan to move to targetSdk 37 in summer 2027.
- Any build plan that uses Godot or Unity versions frozen before mid-2026 will miss Play's targetSdk 36 rule (see engine notes in the Target API section).

### Gaps
- No primary Google source was found that confirms the targetSdk 37 / Aug 2027 date. Google usually publishes it in Play Console Help (answer 11926878) and policy announcements, and those were blocked.
- The exact day in April 2027 for the iOS 27 SDK requirement is not given; Apple says only "Starting April 2027".

---

## Google Play: target API level and minSdk

### Takeaway
Since **31 Aug 2026**, new apps and updates must target **API 36 (Android 16)**; extensions to 1 Nov 2026 were available. Existing apps must target ≥ API 35 to remain discoverable on newer Android versions. API 37 is widely expected for Aug 2027 but Google has not announced it on developer.android.com.

### Cited Findings
- "Starting August 31, 2026": new apps and app updates must target **Android 16 (API 36) or higher**. Wear OS / Automotive must target API 35; TV / XR must target API 34. Existing apps must target **API 35+** to "remain available to new users on devices running Android OS higher than your app's target API level." An extension to **November 1, 2026** could be requested. Page last updated 2026-10-16. — [developer.android.com: Target API level requirements](https://developer.android.com/google/play/requirements/target-sdk)
- Apps targeting API 34 or lower are only available on devices running an OS version the same as or lower than the target. — [developer.android.com: Target API](https://developer.android.com/google/play/requirements/target-sdk)
- The developer.android.com target-SDK page does not mention API 37 or any 2027 deadline. — [developer.android.com: Target API](https://developer.android.com/google/play/requirements/target-sdk)
- A secondary source says Google Play will require API 37 for new apps and updates in **August 2027**. This is unconfirmed by Google. — search summary citing [buildmvpfast.com](https://www.buildmvpfast.com/blog/android-17-adaptive-resizability-mandate-2026) / [ecorpit.com](https://ecorpit.com/android-17-targetsdk-37-adaptive-layout-migration-2026/); the annual pattern is noted by [testerscommunity.com](https://www.testerscommunity.com/blog/update-your-target-api-level-by-august-31-2026)
- **Godot engine versions:**
  - Godot **4.5-stable, 4.6-stable, 4.6.1 and 4.6.2** ship `targetSdk: 35`, `compileSdk: 35`, `minSdk: 24`, NDK 28.1.13356709, AGP 8.6.1. — [Godot 4.6-stable config.gradle](https://raw.githubusercontent.com/godotengine/godot/4.6-stable/platform/android/java/app/config.gradle); [4.5-stable](https://raw.githubusercontent.com/godotengine/godot/4.5-stable/platform/android/java/app/config.gradle)
  - Godot **4.6.3-stable, 4.7-stable and 4.7.1-stable** ship `targetSdk: 36`, `compileSdk: 36`, `minSdk: 24`, NDK 29.0.14206865. Godot master is also at 36. — [Godot 4.7-stable config.gradle](https://raw.githubusercontent.com/godotengine/godot/4.7-stable/platform/android/java/app/config.gradle); [master](https://raw.githubusercontent.com/godotengine/godot/master/platform/android/java/app/config.gradle)
  - The Godot export plugin exposes `gradle_build/target_sdk` and `gradle_build/min_sdk` overrides. AAB export requires `gradle_build/use_gradle_build`. — [Godot 4.7 export_plugin.cpp](https://raw.githubusercontent.com/godotengine/godot/4.7-stable/platform/android/export/export_plugin.cpp) (lines ~2116, 2194–2203)
  - Godot docs: "All new apps uploaded to Google Play after August 2021 must be an AAB… To export an AAB file you need to set up" a Gradle build. — [godot-docs exporting_for_android.rst](https://raw.githubusercontent.com/godotengine/godot-docs/master/tutorials/export/exporting_for_android.rst)
- **minSdk floors in Google libraries:** In-App Review needs Android 5.0 (API 21)+ — [In-app review](https://developer.android.com/guide/playcore/in-app-review). Play Integrity API standard/classic requests need API 23 (library v1.4.0+) — [Play Integrity overview](https://developer.android.com/google/play/integrity/overview). Developer verification applies to certified devices on Android 7+ — [Developer verification FAQ](https://developer.android.com/developer-verification/guides/faq).

### Inferences
- If Danfo stays on Godot, it must use **Godot ≥ 4.6.3 (or 4.7.x)** to get targetSdk 36 by default, or override `target_sdk` with a Gradle build on older 4.x. Godot's default minSdk 24 (Android 7.0) suits Nigeria's low-end device base and lines up with Play Integrity (23) and developer verification (Android 7+).
- Raising targetSdk to 37 in 2027 brings in the Android 17 behaviour changes. For a game whose manifest declares `appCategory="game"`, the large-screen resizability change does not apply (see next section).

### Gaps
- Unity 6's support for target API 36/37 could not be checked: Unity docs were blocked.
- Release dates for Godot 4.6.3 and 4.7 were not retrieved; GitHub API access was not enabled.
- Play's extension-request process (Play Console form) could not be checked.

---

## Google Play: 16 KB memory page size

### Takeaway
All apps with native code that target Android 15+ must ship 16 KB-aligned `.so` files. The live Google page says non-compliant **updates are blocked from 1 Feb 2027**; earlier dates (1 Nov 2025, then an extension to 31 May 2026) appear superseded. Both Godot (NDK r28+ builds) and Unity 6 support 16 KB.

### Cited Findings
- Scope: apps "targeting Android 15 (API level 35) and higher, on 64-bit devices" that use native code, meaning C/C++, NDK, or third-party native libraries/SDKs, "direct or indirect". Pure Java/Kotlin apps already support 16 KB. — [Support 16 KB page sizes](https://developer.android.com/guide/practices/page-sizes)
- "**Starting February 1, 2027**, if your app updates don't support 16 KB memory page sizes, you won't be able to release these updates." — [Support 16 KB page sizes](https://developer.android.com/guide/practices/page-sizes)
- Conflicting earlier dates:
  - The original May 2025 announcement set **1 Nov 2025** for new apps and updates, with extensions to **31 May 2026** confirmed in Google's developer community. Live docs no longer show either date. — search summary of [testerbee.com](https://testerbee.com/blog/16-kb-page-size-on-google-play-find-the-failing-so)
  - Some forum and vendor posts claim a **1 May 2026** block. — [Pushwoosh help](https://help.pushwoosh.com/hc/en-us/articles/31409797287453-Android-16KB-Page-Size-Support); this contradicts the official page.
- Toolchain:
  - **AGP 8.5.1+** for 16 KB zip alignment of uncompressed libs.
  - **NDK r28+** compiles 16 KB-aligned by default. NDK r27 and lower need `-Wl,-z,max-page-size=16384`. Prebuilt `.so` files must be recompiled.
  - — [Support 16 KB page sizes](https://developer.android.com/guide/practices/page-sizes)
- Verification methods:
  - Android Studio APK Analyzer (Alignment column) and lint
  - `check_elf_alignment.sh` (reports ALIGNED/UNALIGNED for arm64-v8a)
  - `llvm-objdump -p lib.so | grep LOAD` (expect `align 2**14`)
  - `zipalign -v -c -P 16 4 app.apk`
  - `bundletool dump config --bundle=app.aab | grep alignment` → `PAGE_ALIGNMENT_16K`
  - the 16 KB emulator system image ("Google APIs Experimental 16 KB Page Size ARM 64 v8a")
  - the "Boot with 16KB page size" developer option on some Pixels
  - `adb shell getconf PAGE_SIZE` → 16384
  - Play Console shows a compatibility warning.
  - — [Support 16 KB page sizes](https://developer.android.com/guide/practices/page-sizes)
- Developers report that Play Console names the offending bundle and `.so` files under "memory page size" details. Often the culprit is an outdated third-party plugin. — search summary of [testerbee.com](https://testerbee.com/blog/16-kb-page-size-on-google-play-find-the-failing-so)
- "Unity has 16 KB page support for Unity 2021, 2022 and Unity 6." — [Unity on Android (developer.android.com)](https://developer.android.com/games/engines/unity/unity-on-android)
- Godot 4.5–4.6.2 export templates are built with NDK 28.1.13356709 and 4.6.3/4.7 with NDK 29.0.14206865. — [Godot config.gradle 4.6-stable](https://raw.githubusercontent.com/godotengine/godot/4.6-stable/platform/android/java/app/config.gradle); [4.7-stable](https://raw.githubusercontent.com/godotengine/godot/4.7-stable/platform/android/java/app/config.gradle)

### Inferences
- Because Godot 4.5+ templates are built with NDK r28+, which is 16 KB-aligned by default per Google, the engine's own `.so` files should be compliant. **Ad SDK native libraries and mediation adapters** (AdMob, AppLovin, Unity Ads, IronSource, etc.) and any GDExtension are the main risk. Danfo should run `check_elf_alignment.sh` and `bundletool` checks in CI on every release AAB.
- The 1 Feb 2027 date sits close to a likely early-2027 launch window. Treat 16 KB compliance as a launch gate, not a later fix.

### Gaps
- No primary Google announcement was found for the Feb 2027 date change; the Android Developers Blog was blocked.
- Exact minimum Unity patch versions with 16 KB support could not be verified; Unity sites were blocked. Prior knowledge, **[UNVERIFIED]**: 2021.3.48f1, 2022.3.56f1, 6000.0.38f1.

---

## Google Play: Android 15/16/17 behaviour changes that affect games

### Takeaway
- **Edge-to-edge:** applies when targeting 35, and the opt-out is gone when targeting 36. Danfo must handle insets and cutouts for its HUD.
- **Predictive back:** on by default when targeting 36; `onBackPressed`/KEYCODE_BACK are no longer delivered, so pause-menu back handling must migrate.
- **Large-screen orientation/resizability:** ignored when targeting 36 (opt-out allowed) and 37 (no developer opt-out). Games that declare `android:appCategory="game"` are **exempt**, and Godot sets this by default.

### Cited Findings
- **Android 15 (target 35):**
  - "Apps are edge-to-edge by default on devices running Android 15 if the app is targeting Android 15."
  - `layoutInDisplayCutoutMode` is interpreted as `ALWAYS` for non-floating windows.
  - `Configuration` no longer excludes system bars.
  - Audio focus requires being the top app or running a foreground service.
  - TLS 1.0/1.1 restricted.
  - `Random.ints()` sequence changes (relevant to seeded procedural generation).
  - — [Android 15 behavior changes](https://developer.android.com/about/versions/15/behavior-changes-15)
- **Android 16 (target 36):**
  - "`R.attr#windowOptOutEdgeToEdgeEnforcement` is deprecated and disabled, and your app can't opt-out of going edge-to-edge."
  - Predictive back system animations are on by default, and "`onBackPressed` is not called and `KeyEvent.KEYCODE_BACK` is not dispatched anymore." A temporary opt-out is `android:enableOnBackInvokedCallback="false"`.
  - "orientation, resizability, and aspect ratio restrictions no longer apply on displays with smallest width >= 600dp". Exempt: "Games (based on the `android:appCategory` flag)". A temporary opt-out property `android.window.PROPERTY_COMPAT_ALLOW_RESTRICTED_RESIZABILITY` "won't apply when targeting API level 37."
  - At most one missed `scheduleAtFixedRate` execution runs on resume.
  - Local network permission is being phased in (matters only for LAN multiplayer).
  - — [Android 16 behavior changes](https://developer.android.com/about/versions/16/behavior-changes-16)
- **Android 17 (target 37):** `screenOrientation`, `resizeableActivity`, `minAspectRatio`, `maxAspectRatio`, `setRequestedOrientation()` are ignored on sw>600dp. The developer opt-out is removed. Exemptions remain for "Games (based on the `android:appCategory` flag)", user opt-in in device aspect-ratio settings, and screens below sw600dp. — [Android 17: restrictions ignored](https://developer.android.com/about/versions/17/changes/ff-restrictions-ignored); also [Android 17 release notes](https://developer.android.com/about/versions/17/release-notes)
- **Godot defaults:**
  - The export option `package/app_category` defaults to `APP_CATEGORY_GAME`, and the exporter writes both `android:appCategory` and `android:isGame` from it.
  - `screen/immersive_mode` defaults to **true** and `screen/edge_to_edge` to **false**.
  - — [Godot 4.7 export_plugin.cpp](https://raw.githubusercontent.com/godotengine/godot/4.7-stable/platform/android/export/export_plugin.cpp) (lines ~1259–1300, 2240, 2262–2263)

### Inferences
- With Godot's default `appCategory=game`, Danfo keeps its locked landscape orientation on tablets and foldables under both target 36 and 37. A Unity build should confirm that the generated manifest carries `android:appCategory="game"`.
- Immersive full-screen hides the system bars, but with target 36 the window is still edge-to-edge. HUD elements such as the minimap, fare UI and ad close buttons must respect display-cutout and gesture insets.
- Back-button pause menus must use `OnBackPressedCallback`/`OnBackInvokedCallback` paths. Check how the engine version maps Android back to its input event under target 36.

### Gaps
- It was not verified whether Godot 4.6.3/4.7 and Unity 6 handle predictive back natively when targeting 36.
- No official Android 17 stable release date was retrieved.

---

## Google Play: app size limits, Play Asset Delivery (PAD), OBB, Play Feature Delivery

### Takeaway
Google's current developer docs give a **500 MB compressed base-module limit** and a **4 GB cumulative per-device download** limit for AABs. PAD lets games go beyond the base limit. Per Play Console Help (seen via search summary only), the limits are 1.5 GB per pack, 4 GB cumulative install-time and 30 GB cumulative fast-follow + on-demand, with a maximum of 100 packs. OBB expansion files are not supported for AABs.

### Cited Findings
- "The maximum compressed download size for a base module generated from an AAB is **500 MB**… Google Play checks that the maximum cumulative total compressed download size that any individual device receives is not over **4 GB**." (page updated 2026-10-06) — [App Bundle FAQ](https://developer.android.com/guide/app-bundle/faq)
- "Google Play does not support expansion files for AABs… use Play delivery services such as Play Asset Delivery or Play Feature Delivery to exceed the 500 MB size limit or… third-party content delivery networks." — [App Bundle FAQ](https://developer.android.com/guide/app-bundle/faq)
- Play Console Help (search summary, not fetched):
  - base and feature modules **500 MB**
  - **1.5 GB per asset pack**
  - **4 GB** cumulative install-time
  - **30 GB** cumulative on-demand + fast-follow
  - total maximum compressed download **34 GB**
  - max **100 asset packs**
  - Secondary sources and Unity docs still cite **200 MB** for the base, possibly a legacy or non-split figure.
  - — [Play Console Help 9859372](https://support.google.com/googleplay/android-developer/answer/9859372?hl=en) via search; [Unity docs: Google Play delivery requirements](https://docs.unity.com/en-us/engine/6000.6/manual/platform-specific/android/building-and-delivering/distribution/google-play)
- Install-time packs need "at least two times the size of all the asset packs" of free disk space to install or update. Fast-follow and on-demand packs need only "a few hundred extra MBs". With Texture Compression Format Targeting, "download limits apply separately to each unique texture format." — [Play Asset Delivery](https://developer.android.com/guide/playcore/asset-delivery)
- Unity integrates PAD (AssetBundles into AAB, runtime API). — [Unity on Android](https://developer.android.com/games/engines/unity/unity-on-android)
- Godot 4.7's Android export plugin has no asset-pack, install-time, fast-follow or on-demand options; a grep of the source found none. — [Godot 4.7 export_plugin.cpp](https://raw.githubusercontent.com/godotengine/godot/4.7-stable/platform/android/export/export_plugin.cpp)

### Inferences
- With a city map of a few hundred MB, Danfo can likely fit a **≤500 MB base** without PAD on Play. On low-storage Nigerian devices, a smaller first download is still better: core loop in the base, districts as fast-follow or on-demand packs.
- Unity supports PAD out of the box. Godot needs a custom Gradle build plus a third-party or self-written PAD plugin, or its own CDN download of `.pck` files. That is a real engine-selection factor.
- Install-time packs double the disk space needed during updates. Prefer fast-follow for bulk map data.

### Gaps
- The Play Console Help size page could not be fetched (blocked), so the 1.5 GB/4 GB/30 GB/100-pack figures are not primary-verified this session.
- No retrieved source dates the base-limit change from 200 MB to 500 MB.
- Google's app-size versus install-conversion data was not retrieved, because search was exhausted. Background, **[UNVERIFIED]**: Google's widely cited 2017 Play analysis of roughly 1% lower install conversion per 6 MB of size, with stronger effects in emerging markets.
- Play Feature Delivery specifics (on-demand code modules) were not researched separately.

---

## Google Play: new personal developer accounts (testing requirement, identity, D-U-N-S, Android developer verification, fee)

### Takeaway
A personal Play developer account created after 13 Nov 2023 must run a **closed test with ≥12 opted-in testers for 14 continuous days** before applying for production. Google then reviews the application. Organisations need a **D-U-N-S number**, which can take up to 28 days. The registration fee is **US$25**. Android-wide developer verification went live on **30 Sep 2026** in four countries and goes **global in 2027**. Play developers are registered automatically, but identity must be verified.

### Cited Findings
- Personal accounts created after **13 Nov 2023** need a closed test with **≥12 testers** opted in for **14 consecutive days** before applying for production access. Organisation accounts are not subject to this. The minimum was cut from 20 to 12 on **11 Dec 2024**, and the rule was unchanged as of 2026. One source cites Play Console Help answer 14151465 as checked on 14 Aug 2026. Google reviews the production application, which usually takes ≤7 days. — search summary of third-party guides: [ontest.app](https://ontest.app/blog/google-play-12-testers-14-days-requirement-explained), [primetestlab.com](https://primetestlab.com/blog/google-play-changed-20-to-12-testers), [testerscommunity.com](https://www.testerscommunity.com/google-play-closed-testing), [Medium](https://medium.com/@kefayatkhadem/google-play-closed-testing-in-2026-the-full-path-from-12-testers-to-production-access-1f48b7833671). Sources disagree on whether the clock resets if testers drop below 12.
- The Android Developer Console charges a $25 Full Distribution fee, "similar to Play's **$25 registration fee**." — [Developer verification FAQ](https://developer.android.com/developer-verification/guides/faq)
- D-U-N-S "is required if you are registering as an **organization**… The process can take up to 28 days." Organisations must also verify their website via Google Search Console. — [Developer verification FAQ](https://developer.android.com/developer-verification/guides/faq); [Developer verification guides](https://developer.android.com/developer-verification/guides)
- **Android developer verification:**
  - Timeline: June 2026 system service; August 2026 limited-distribution accounts and the "advanced flow" for power users; "**September 30, 2026**: Protections begin for all users who install apps from participating stores in **Brazil, Indonesia, Singapore, and Thailand** on certified devices running Android 7+"; "Verification capability will be expanded globally for all apps on certified Android devices in **2027**."
  - "Google Play automatically registers 99% of apps."
  - — [Android developer verification](https://developer.android.com/developer-verification)
- Participating stores: Google Play, HONOR App Market, OPPO App Market, Samsung Galaxy Store, **Transsion Palm Store**, vivo V-Appstore, Xiaomi GetApps. "You will automatically be registered if you distribute your app through Google Play." — [Developer verification guides](https://developer.android.com/developer-verification/guides)
- Limited distribution accounts allow "up to 20 specific devices… at no cost and without ID verification". The advanced flow is a one-time setup with a one-day wait, after which unverified installs are allowed for 7 days or indefinitely. ADB is unaffected. — [Developer verification FAQ](https://developer.android.com/developer-verification/guides/faq)

### Inferences
- **Schedule the 14-day closed test into the launch plan.** In practice it adds 3–4 weeks: recruiting 12+ real testers, 14 days of opt-in, then Google's review. Danfo can use Nigerian friends and family or a community, plus the closed test for vitals, pre-launch reports and 16 KB checks.
- If the developer forms a company (organisation account), the 12-tester rule does not apply, but D-U-N-S and website verification add up to about 4 weeks.
- Nigeria is not in the first enforcement wave. From the 2027 global rollout, any APK side-distributed outside Play (for example via Transsion's Palm Store, which matters in Nigeria) must come from a verified developer. Play distribution itself is covered automatically.

### Gaps
- The text of Play Console Help 14151465 and the personal-account identity and device verification requirements (government ID, Android device verification in the Play Console mobile app) could not be fetched; the site was blocked.
- It is unclear whether Google changed the 12/14 rule after Aug 2026.

---

## Google Play: required declarations (Data safety, Ads, Target audience, IARC, privacy policy, account deletion, financial features)

### Takeaway
Play Console's App content declarations (Data safety, contains-ads, target audience and content, IARC rating questionnaire, privacy policy URL) are mandatory for every app. **None of the official Play policy pages could be fetched in this session**, so most of this section is in Gaps. Account deletion applies only if the app lets users create accounts; financial features would be "none".

### Cited Findings
- Play Age Signals API (beta):
  - Returns signals for Brazil (Digital ECA) from **17 Mar 2026**, and for Texas users who created accounts after **28 May 2026** (SB 2420).
  - Terms forbid using it for "advertising, marketing, user profiling, or analytics."
  - "No data is collected by the Play Age Signals client library"; developers remain responsible for Data safety answers.
  - — [Play Age Signals overview](https://developer.android.com/google/play/age-signals/overview)

### Inferences
- With ads SDKs (AAID, IP, device identifiers, ad interaction data), Danfo's **Data safety form will not be "no data collected"**. It must disclose what the ad and mediation SDKs collect and share, even though the game has no backend.
- The game has no accounts, so the account-deletion requirement should not apply. The Data safety form still asks whether users can request deletion of collected data.
- If the target audience in Play Console includes under-13s, Families policy obligations apply (self-certified ads SDKs, restrictions on ad formats and identifiers). Targeting **13+** reduces this, but a cartoonish city-driving game may still be judged "appealing to children".

### Gaps
**[UNVERIFIED]** background, not checked this session because play.google.com and support.google.com were blocked. Verify at the [Play policy center](https://play.google.com/about/developer-content-policy/) and in Play Console Help:
- (a) A privacy policy URL is required for apps that handle user data, and for any app whose target audience includes children.
- (b) The "Contains ads" declaration is required, and the store shows a "Contains ads" label.
- (c) The IARC questionnaire is mandatory, and unrated apps can be removed.
- (d) The Families Self-Certified Ads SDK program applies when children are in the target audience.
- (e) Ads policy: no unexpected interstitials (for example at app launch or mid-gameplay), and full-screen interstitials must be closable (the Better Ads-aligned rule that they must be dismissible after 15 seconds).
- (f) Rewarded ads must be opt-in.
- (g) The financial features declaration has been required of all apps since 2023, and "none" is a valid answer.
- (h) Account deletion has been required since Dec 2023 only for apps that allow account creation.

---

## Google Play: Android vitals thresholds, store visibility, pre-launch reports

### Takeaway
Core bad-behaviour thresholds:
- **User-perceived crash rate:** 1.09% overall, 8% per phone model
- **User-perceived ANR rate:** 0.47% overall, 8% per phone model
- **Excessive partial wake locks:** 5% of sessions, enforced from **1 Mar 2026**

**[UPCOMING] Feb 2027:** memory, bitmap-memory and code-optimisation thresholds start affecting visibility. Games get higher memory ceilings. Exceeding thresholds can reduce discovery and add a warning on the store listing.

### Cited Findings
- Thresholds (28-day window):
  - user-perceived crash rate **1.09%** overall, **8%** per phone model (4% per watch)
  - user-perceived ANR rate **0.47%** overall, **8%** per phone model (5% per watch)
  - excessive battery usage **1%** (shown for overall and watch)
  - excessive partial wake locks **5%**
  - — [Android vitals](https://developer.android.com/topic/performance/vitals) (updated 2026-10-09)
- "If your app or game exceeds a bad behavior threshold, Play may reduce the visibility of your title… Play may also show users a warning on your store listing." Assessment uses the last 28 days. Emerging crash/ANR issues affecting devices for over 7 days are flagged, giving **21 days** to fix them. — [Android vitals](https://developer.android.com/topic/performance/vitals)
- **[UPCOMING] February 2027:** apps exceeding thresholds for memory usage, bitmap memory usage or code optimisation "may see store visibility impact." Game memory thresholds (foreground / services / background):
  - 4 GB RAM: **2.25 GB / 2.00 GB / 2.00 GB** (apps: 2.00 / 1.00 / 1.00)
  - 16 GB RAM: **5.00 / 3.50 / 3.50 GB**
  - Games with >50 MB DEX need ≥25% optimisation/obfuscation/shrinking.
  - The page's table formatting was flattened, so verify the exact cells.
  - — [Android vitals](https://developer.android.com/topic/performance/vitals)
- **Wake locks:** Play began rolling out the wake-lock "technical quality treatments" on **1 Mar 2026**. Bad behaviour means a non-exempt partial wake lock held ≥2 h (screen off) in >5% of sessions over 28 days. Consequences include store-listing warnings and "exclusion from discovery surfaces such as recommendations." Audio playback and user-initiated transfers can be exempt. — [Android Developers Blog, Mar 2026](https://android-developers.googleblog.com/2026/03/battery-technical-quality-enforcement.html); [Sep 2025 guide](https://android-developers.googleblog.com/2025/09/guide-to-excessive-wake-lock-usage.html) (both via search summary; blog domain blocked for direct fetch)

### Inferences
- A 3D open-city game on 2–4 GB Nigerian Android phones is at real risk on **ANR (0.47%)** and on the **Feb 2027 memory threshold** (about 2.25 GB foreground on 4 GB devices; devices under 4 GB were not shown in the extract). Budget memory well below this and stream map chunks.
- Ad SDKs are a common source of ANRs and crashes. Initialise them off the main thread, and test mediation adapters on low-end devices in the closed test.
- An offline game should not hold partial wake locks at all. Audit ad and analytics SDKs for them.

### Gaps
- Thresholds for devices with less than 4 GB RAM were not retrieved; the table may not cover them.
- Pre-launch report details (Firebase Test Lab devices, accessibility and security warnings, robo crawler) could not be fetched; Play Console Help was blocked.
- "Excessive wakeups" has no threshold in core vitals. It is listed only under "All other vitals".

---

## Google Play: Play Integrity API and Play Games Services v2

### Takeaway
Play Integrity is optional for an offline ad-funded game. It is free with a default quota of 10,000 requests per day and mostly matters for anti-tamper of rewarded-ad grants. PGS v2 is **not required**, but v1 is dead for new titles, and Google Sign-In for Android was removed in Sep 2026. PGS v2 gives automatic platform identity, achievements, leaderboards, cloud save (3 MB per save) and Recall. Some features are tied to Google's "Level Up" programme.

### Cited Findings
- Play Integrity:
  - Verdicts cover app integrity (`PLAY_RECOGNIZED`), account licensing, and device integrity (BASIC/DEVICE/STRONG).
  - Optional signals: app access risk, Play Protect, recent device activity, deviceRecall (beta).
  - Standard requests take a few hundred ms with automatic replay protection; classic requests take a few seconds and need a nonce.
  - Default quota is "up to **10,000** total requests per day across all installs", and an increase can be requested. Minimum Android 6.0 (API 23).
  - — [Play Integrity overview](https://developer.android.com/google/play/integrity/overview)
- PGS:
  - "Integrate your games with Play Games Services to get instant access to these features." The platform identity "automatically recognizes the player when the game starts."
  - Level Up mechanics (leagues, quests, achievements, streaks) are "restricted to titles enrolled in the Level Up program".
  - PGS "does not serve as a primary system for inventory management or game-state preservation."
  - Features include Play Points and Play Games Sidekick (overlay with Gemini tips).
  - — [PGS overview](https://developer.android.com/games/pgs/overview)
- PGS deprecation:
  - After Sep 2025, "Google Play prevents publishing new titles that use the v1 SDK and APIs."
  - `play-services-games` v25.0.0 (15 Jun 2026) removes v1 APIs.
  - "Since September 2026, the Google Sign-In for Android API is no longer supported."
  - v1 traffic blocked **May 2027** (timeline table) / SDK removed **June 2027** (bullet). The page is inconsistent.
  - Unity plugin v0.10.15 deprecated 17 Sep 2025.
  - — [PGS deprecation schedule](https://developer.android.com/games/pgs/deprecation)
- Saved Games: binary blob max **3 MB**, cover image **800 KB**, works offline and syncs later, "not charged", must be enabled in Play Console. "You can use any cloud save solution of your choice", but "your game must still meet the Level Up requirement to implement cloud save." — [PGS Saved Games](https://developer.android.com/games/pgs/savedgames)
- Google Play Games on PC:
  - Available in 120+ countries (since 13 Jul 2023), and in-game ads can be monetised on PC. — [Play Games on PC overview](https://developer.android.com/games/playgames/overview)
  - Recommends x86-64 native libraries, replacing multi-touch gestures with mouse/keyboard input, and marking hardware features `required="false"`. — [PC compatibility](https://developer.android.com/games/playgames/pc-compatibility)

### Inferences
- For an offline game with no account, **PGS v2 Saved Games** is a cheap way to give Android players cloud backup of local saves without running a backend. Treat it as optional.
- Rewarded-ad reward granting is client-side. Play Integrity cannot fully protect it without a server; using it client-side only is weak. It probably isn't worth it at launch.
- If Danfo stays out of PC, avoid relying on any automatic PC opt-in. Check the Play Console PC settings.

### Gaps
- The Level Up programme's requirements and deadlines were not fetched.
- Whether Google now lists mobile games on PC by default (opt-out) was not verified.
- The Recall API was not detailed.
- Play Integrity pricing above the quota was not stated.

---

## Google Play: release mechanics (tracks, staged rollouts, pre-registration, custom listings, In-App Updates/Review, PC)

### Takeaway
Standard Play mechanics apply: internal, closed and open testing tracks, staged rollouts, pre-registration, country-targeted custom store listings, and the In-App Updates and In-App Review APIs. Only the In-App Review rules were verified this session.

### Cited Findings
- In-App Review needs Android 5.0+ and Play Core 1.8.0+. "Google Play enforces a time-bound quota", so repeated calls within "less than a month" may show nothing. Don't trigger it from a button, don't ask "Do you like the app?" beforehand, and don't overlay or modify the card. Closed-track feedback is private. — [In-app reviews](https://developer.android.com/guide/playcore/in-app-review)

### Inferences
- Suggested sequence: internal track for smoke tests, then the mandatory closed track (12+ testers, 14 days), then production with a staged rollout (for example 5% → 20% → 50% → 100%) gated on vitals. Optionally use a Nigeria-specific custom store listing with local-language copy.

### Gaps
- Pre-registration rules (rewards, duration), staged-rollout percentages and halting, custom store listing limits, In-App Updates (flexible vs immediate, priority), and pre-launch report specifics were all **not verified**. The relevant pages are on support.google.com, which was blocked, and search was exhausted.

---

## Apple: SDK and Xcode minimums

### Takeaway
Since **28 Apr 2026**, uploads must be built with **Xcode 26+ / the iOS 26 SDK**. Since **9 Sep 2026**, apps must target **iOS 13+**. **[UPCOMING]** From **April 2027**, uploads need the **iOS 27 SDK**, and Xcode 27 RC has been available since 9 Sep 2026. Age-assurance APIs need the iOS 26.2 SDK / Xcode 26.2.

### Cited Findings
- "Apps uploaded to App Store Connect must be built with Xcode 26 or later using an SDK for iOS 26…" — since **28 Apr 2026**. "iOS and iPadOS apps uploaded to App Store Connect must target iOS 13 or later" — since **9 Sep 2026**. — [Apple Upcoming requirements](https://developer.apple.com/news/upcoming-requirements/)
- "**Starting April 2027**, apps and games uploaded to App Store Connect need to meet the following minimum requirements: iOS and iPadOS apps must be built with the iOS 27 & iPadOS 27 SDK or later." Games with social media capabilities must indicate them in App Store Connect (Time Allowances). — [Apple news, 9 Sep 2026](https://developer.apple.com/news/?id=k1mtkt1k)
- "To enable all the technologies… to comply with regional age assurance requirements, you must build your app against the iOS 26.2 and iPadOS 26.2 SDKs, or later, with Xcode 26.2 (17C52) or later." — [Apple age assurance Q&A](https://developer.apple.com/support/age-assurance/)

### Inferences
- Engine choice must produce Xcode 26 projects now and Xcode 27 projects by April 2027. Both Godot and Unity export Xcode projects, so the engine version must support the then-current Xcode/SDK. A Mac with current Xcode, or a CI Mac runner, is required.

### Gaps
- The exact April 2027 day is not given.
- Godot and Unity Xcode 26/27 compatibility was not verified; engine sites were blocked.

---

## Apple: privacy manifests, required-reason APIs, SDK signatures, App Privacy labels, ATT

### Takeaway
Since **1 May 2024**, uploads must declare approved reasons for required-reason APIs, including those in SDKs. Listed "commonly used" SDKs must ship privacy manifests and signatures; the list includes **UnityFramework** but not Google Mobile Ads or AppLovin. App Privacy labels must include ad-SDK collection. Ad tracking needs ATT consent, and rewards cannot be conditioned on it. **[UPCOMING]** An EU alternative ATT prompt arrives with iOS 27.2.

### Cited Findings
- "Since May 1, 2024: Approved reasons for APIs… including third-party SDKs, to upload a new or updated app." — [Apple Upcoming requirements](https://developer.apple.com/news/upcoming-requirements/)
- "You must include the privacy manifest for any SDK listed below when you submit new apps… or… an app update that adds one of the listed SDKs… Signatures are also required… where the listed SDKs are used as binary dependencies." The list includes **UnityFramework**, several Firebase modules (Core, Crashlytics, Messaging, RemoteConfig…), FBSDK modules, GoogleUtilities and GoogleDataTransport. It does **not** list Google Mobile Ads or AppLovin by name. — [Apple third-party SDK requirements](https://developer.apple.com/support/third-party-SDK-requirements/)
- App Privacy details must cover "the practices of third-party partners whose code you integrate", including "advertising networks". Placing an SDK that combines your app's data with other apps' data for ads counts as **tracking** "even if you don't use the SDK for these purposes". A privacy policy URL is required. Answers can be updated without a new build. — [Apple App privacy details](https://developer.apple.com/app-store/app-privacy-details/)
- Guideline 5.1.2(i): "You must receive explicit permission from users via the App Tracking Transparency APIs to track their activity… Your app may not require users to enable system functionalities (such as… tracking) in order to… receive monetary or other compensation." Guideline 5.1.1(i): privacy policy link required in App Store Connect **and** inside the app, naming third parties such as ad networks. — [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- **[UPCOMING]** "Beginning with iOS 27.2… option to use an alternative version of the App Tracking Transparency system prompt in the EU… only the alternative version… available for apps distributed in Germany, France, Italy, Poland, and Romania." — [Apple news, 16 Sep 2026](https://developer.apple.com/news/?id=idsft9ai)

### Inferences
- A Unity build automatically brings in UnityFramework's privacy manifest. A Godot build must hand-author `PrivacyInfo.xcprivacy` for engine API use such as file timestamps, UserDefaults and disk space. Ad SDK vendors ship their own manifests.
- Rewarded ads must still grant rewards when ATT is denied, serving non-personalised ads in that case.

### Gaps
- The full current required-reason API categories list was not re-fetched.
- Whether Godot ships a `PrivacyInfo.xcprivacy` in its iOS export template was not verified.

---

## Apple: age ratings and regional age-assurance laws

### Takeaway
Apple's ratings are now **4+, 9+, 13+, 16+, 18+**, and questionnaire answers were due **31 Jan 2026**. "Advertising" is a questionnaire capability that is permitted at **4+**, but in **Brazil** it maps to **A12**. Age-assurance rules now apply in Texas (4 Jun 2026), Utah (6 May 2026) and Louisiana (1 Jul 2026), plus 18+ download blocks in Australia, Brazil and Singapore (24 Feb 2026). They mostly bite on 18+ apps, apps with accounts and purchases, and "significant updates" for minors. An ads-only, no-loot-box game rated 9+ or 13+ has light obligations, but should still handle Declared Age Range for ad personalisation where legally required.

### Cited Findings
- New tiers: 4+, 9+, 13+, 16+, 18+. Apple re-rated apps automatically. "Provide responses to the updated age rating questions… by January 31, 2026, to avoid an interruption when submitting your app updates." — [Apple Upcoming requirements](https://developer.apple.com/news/upcoming-requirements/); [9to5Mac, Jul 2025](https://9to5mac.com/2025/07/24/apple-notifies-developers-of-new-app-store-age-rating-system/)
- Questionnaire sections:
  - In-App Controls (Parental Controls, Age Assurance)
  - Capabilities (Unrestricted Web Access, UGC, Social Media, Messaging, **Advertising**)
  - Mature Themes
  - Medical
  - Sexuality
  - Violence (Cartoon, Realistic, Guns)
  - Chance-Based (Gambling, Simulated Gambling, Contests, Loot Boxes)
- How these map to ratings:
  - Advertising is allowed at **4+**.
  - Infrequent cartoon violence or guns → **9+**.
  - Infrequent realistic violence / frequent cartoon violence → **13+**.
  - Brazil self-ratings: **A12 includes Advertising**; loot boxes → A18.
  - Korea's "All" tier includes advertising.
- — [Apple age ratings values and definitions](https://developer.apple.com/help/app-store-connect/reference/app-information/age-ratings-values-and-definitions)
- Australia, Brazil, Singapore: from **24 Feb 2026**, Apple blocks downloads of **18+** apps unless the user is confirmed adult. In Brazil, apps declaring loot boxes become 18+. Utah (new accounts from **6 May 2026**) and Louisiana (from **1 Jul 2026**): age categories are shared via the Declared Age Range API. New signals and the Significant Change API (PermissionKit) cover parental consent for "significant app updates". — [Apple news, 24 Feb 2026](https://developer.apple.com/news/?id=f5zj08ey)
- Texas SB 2420: a court ruling lifted the injunction. From **4 Jun 2026**, new Texas Apple Accounts are subject to "age assurance and parent or guardian consent… for downloads, Apple In-App Purchases, and significant changes". Parents can revoke consent. Developers should implement the Declared Age Range API, the Significant Change API, the StoreKit age rating property, and the consent-revocation server notification. — [Apple news, 3 Jun 2026](https://developer.apple.com/news/?id=sg176nne); the earlier injunction is noted in [Apple news 23 Dec 2025](https://developer.apple.com/news/?id=8jzbigf4) (headline only)
- "In those regions, you must check the age of the people using your app." The developer decides what counts as a "significant app update" under applicable law, and "the child must be prevented from accessing the significant update" until consent. — [Apple age assurance Q&A](https://developer.apple.com/support/age-assurance/)
- Australia's 15+ rating was retired on **18 Jun 2026**: unrestricted web, medical info and loot boxes move to 16+. Vietnam now has region-specific 00+/12+/16+/18+ ratings. — [Apple news, 21 May 2026](https://developer.apple.com/news/?id=yrrb45pw)
- Other 2026 rating updates (headlines only): social-media questions added to the questionnaire (9 Jul 2026); Republic of Korea age ratings (12 Aug 2026). — [Apple news index](https://developer.apple.com/news/)
- Google equivalent: Play Age Signals API (beta) for Brazil from 17 Mar 2026 and for Texas accounts created after 28 May 2026. — [Play Age Signals](https://developer.android.com/google/play/age-signals/overview)

### Inferences
- If Danfo answers Advertising = yes, cartoon violence infrequent or none, no loot boxes, no UGC and no chat, its global rating should be about **4+ or 9+**; it is **A12 in Brazil** because of ads. Avoid loot-box-style randomised rewards from rewarded ads, which would push it to 16+ in Australia and 18+ in Brazil.
- Danfo has no IAP and no accounts. Its US-state exposure is mainly downloads, which Apple handles, and "significant updates" for minor users. Nigeria, the primary market, has no store-level age law in the retrieved sources.
- Ad networks need age signals to avoid personalised ads to minors. Wiring Declared Age Range (iOS) and Play Age Signals (Android) into ad-request configuration is prudent, but the Play terms forbid using Age Signals for advertising purposes beyond age-appropriate compliance, so check how it can be used.

### Gaps
- The exact ad-related obligations for apps used by minors under the Texas, Utah and Louisiana laws were not found.
- The rating values for Vietnam were truncated.

---

## Apple: app size, cellular limit, On-Demand Resources deprecation, Background Assets / Apple-hosted asset packs

### Takeaway
iOS apps may be up to **4 GB uncompressed**, with executable `__TEXT` up to 500 MB. **On-Demand Resources are deprecated as of iOS 27**; Apple recommends Background Assets. **Apple-hosted asset packs** allow up to **200 GB** total and **200 packs** per app record. The cellular download limit could not be verified.

### Cited Findings
- iOS 9.0+: **4 GB** maximum uncompressed app size; **500 MB** maximum for total `__TEXT` sections. "You can use Background Assets to host larger assets outside the build." — [Apple maximum build file sizes](https://developer.apple.com/help/app-store-connect/reference/app-uploads/maximum-build-file-sizes)
- Apple-hosted asset packs: total **200 GB** per app record (sum of the largest version of each pack) and a maximum of **200** packs, shared across platforms. The product page "Up to" size includes essential packs. — [Apple-hosted asset pack size limits](https://developer.apple.com/help/app-store-connect/reference/app-uploads/apple-hosted-asset-pack-size-limits)
- "On-demand resources has been deprecated on Apple platforms as of iOS 27, iPadOS 27, tvOS 27, and visionOS 27, and support will be removed in future releases. Migrating to Background Assets is recommended." ODR limits (iOS 18+): 4 GB app bundle, 8 GB per pack, 70 GB hosted. — [Apple ODR size limits](https://developer.apple.com/help/app-store-connect/reference/app-uploads/on-demand-resources-size-limits)
- A secondary analysis notes that no ODR removal date is set, and that Background Assets keeps packs until the app removes them. — [blakecrosley.com](https://blakecrosley.com/blog/on-demand-resources-deprecated-background-assets)

### Inferences
- A city map of a few hundred MB fits inside the 4 GB bundle limit. For a lean first download, use Apple-hosted asset packs through Background Assets rather than ODR, which is deprecated. Unity and Godot do not natively wrap Background Assets (unverified), so expect native plugin work.

### Gaps
- The current **cellular download limit** could not be verified. Background, **[UNVERIFIED]**: a 200 MB default prompt since iOS 13, user-configurable.
- The minimum iOS version for Apple-hosted asset packs (believed iOS 26) was not confirmed.
- App Thinning specifics were not re-fetched.

---

## Apple: Accessibility Nutrition Labels

### Takeaway
They are **voluntary for now**. Apple says they will become mandatory for new apps and updates "over time", with "ample time" given, but has announced no date.

### Cited Findings
- "Providing these labels will be voluntary to start… over time, you'll be required to share accessibility support details to submit new apps and app updates." Labels cover VoiceOver, Voice Control, Larger Text, Dark Interface, Differentiate Without Color Alone, Sufficient Contrast, Reduced Motion, Captions and Audio Descriptions. To claim a label, users must be able to "complete all of the common tasks of your app using that feature." — [Apple Accessibility Nutrition Labels overview](https://developer.apple.com/help/app-store-connect/manage-app-accessibility/overview-of-accessibility-nutrition-labels)

### Inferences
- Danfo can leave all labels unclaimed at launch. Cheap wins such as Captions for dialogue and a Reduced Motion option could be claimed later.

### Gaps
- No mandatory date has been announced, and games-specific guidance was not visible in the fetched portion.

---

## Apple: EU Digital Services Act trader status

### Takeaway
Since **17 Feb 2025**, apps in the EU need a trader declaration or they are removed from EU storefronts. An individual developer who is a trader (an ad-funded app is a listed factor) must publicly display an **address or P.O. Box, phone and email** on EU product pages. The alternatives are to declare non-trader if genuinely non-commercial, or to **exclude EU storefronts**.

### Cited Findings
- Since **16 Oct 2024**, trader status is required to submit updates in the EU. Since **17 Feb 2025**, apps without it "will be removed from the App Store in the European Union." — [Apple Upcoming requirements](https://developer.apple.com/news/upcoming-requirements/)
- Factors that indicate trader status include revenue from "a paid or ad-sponsored app", VAT registration and commercial practices. A hobbyist with no intention to commercialise "may not be considered a trader."
- Individual traders display "Address or P.O. Box, phone number, and email address". A P.O. Box needs proof of association, and phone and email are verified by 2FA. Traders must also provide documents verifying name and address.
- Non-traders give no contact info, and EU consumers are told that consumer-protection rights don't apply.
- Distributing outside the EU only means "you're not acting as a trader."
- — [Apple DSA trader requirements](https://developer.apple.com/help/app-store-connect/manage-compliance-information/manage-european-union-digital-services-act-trader-requirements)

### Inferences
- Danfo is ad-funded, so the developer would likely be a trader in the EU. Because the primary market is Nigeria, **leaving out the 27 EU storefronts** avoids publishing a personal address and phone. Alternatively, use a P.O. Box or virtual business address and a dedicated phone number.

### Gaps
- Google Play's equivalent (the DSA trader declaration in Play Console, with contact details shown in the EU) could not be verified because Play Help was blocked.

---

## Apple: App Review Guidelines for ads, minimum functionality and games; TestFlight

### Takeaway
- **Interstitials:** must be clearly labelled as ads, use no trickery, and have visible close or skip buttons large enough to dismiss easily.
- **Ad reporting:** apps with ads **must let users report inappropriate ads** (2.5.18).
- **Rewarded ads:** explicitly allowed (3.2.2(x)).
- **Ad-centric design:** apps "designed predominantly for the display of ads" are rejected (3.2.2(iii)).
- **TestFlight:** external testing needs Beta App Review for the first build, with up to 10,000 external testers.

### Cited Findings
- **2.5.18:**
  - "Ads displayed in an app must be appropriate for the app's age rating, allow the user to see all information used to target them for that ad (without requiring the user to leave the app)…"
  - "Interstitial ads or ads that interrupt or block the user experience must clearly indicate that they are an ad, must not manipulate or trick users into tapping into them, and must provide easily accessible and visible close/skip buttons large enough for people to easily dismiss the ad."
  - "Apps that contain ads must also include the ability for users to report any inappropriate or age-inappropriate ads."
  - — [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- **3.2.2(iii):** unacceptable — "Artificially increasing the number of impressions or click-throughs of ads, as well as apps that are designed predominantly for the display of ads." **3.2.2(x):** "Apps may otherwise incentivize users to take specific actions within apps (such as by completing a level or watching an ad)." — [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- **4.2:** apps must provide "lasting entertainment value or adequate utility". **2.3.8:** metadata (screenshots, icons) must meet **4+** even if the app is rated higher. **1.1.2:** game "Enemies" "cannot solely target a specific race, culture, real government, corporation, or any other real entity." — [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- **1.3 / 5.1.4:** Kids Category apps "should not include third-party analytics or third-party advertising". Apps outside the Kids Category can't imply in metadata that children are the main audience. — [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- 16 Oct 2026 update:
  - new **2.3.14** on creative assets
  - new **2.5.19** on hidden, dormant or undocumented features
  - 1.2 clarifications
  - Guideline 5 now covers trafficking and exploitation
  - — [Apple news, 16 Oct 2026](https://developer.apple.com/news/?id=92th7e5i)
- Earlier revisions (headlines only): 13 Nov 2025 (mini apps, creator apps, age restriction mechanisms); 6 Feb 2026; 8 Jun 2026. — [Apple news index](https://developer.apple.com/news/)
- TestFlight:
  - up to **100** internal testers and **10,000** external testers
  - 100 builds, up to 30 devices per tester
  - The first build for external testing must be "approved by App Review for TestFlight". Builds are "automatically sent for review once they're added to a group".
  - Public links are supported.
  - — [Apple TestFlight](https://developer.apple.com/testflight/)

### Inferences
- Danfo needs an in-game **"report this ad"** path. Many ad SDKs provide AdChoices or feedback UI, but App Review may expect a visible mechanism.
- Ad cadence must not make the game "predominantly for the display of ads". Keep interstitials at natural breaks such as the end of a route.
- Real Lagos institutions (LASTMA, police, real bus companies) should not be portrayed as "enemies" under 1.1.2.

### Gaps
- TestFlight build expiry (90 days) was not shown on the page.
- The texts of the 6 Feb and 8 Jun 2026 guideline revisions were not fetched.

---

## Apple: Game Center, iCloud and the Games app

### Takeaway
Game Center is optional. If used, it requires the entitlement and App Store Connect configuration (since Aug 2023). All App Store games **automatically appear** in the iOS 26 **Games app**. Initialising Game Center adds social recommendations and the Top Played chart, and Game Center features plus In-App Events give more prominent placement.

### Cited Findings
- "New apps and updates offering Game Center features must include the Game Center entitlement and have Game Center configured in App Store Connect" (since 16 Aug 2023). — [Apple Upcoming requirements](https://developer.apple.com/news/upcoming-requirements/)
- "Games that are available on the App Store will automatically appear on the Games app including in search results, the Library tab, and the Continue Playing section." The Games app is preinstalled on iOS/iPadOS/macOS 26. "With initialization, players are automatically signed in to their Game Center account… This lets your game appear in social recommendations… as well as in a new Top Played chart." "Games that include Game Center features and In-App Events are prominently displayed across the Games app." — [Apple Games app for developers](https://developer.apple.com/games-app/)
- Game Center features: leaderboards, achievements, challenges, multiplayer activities. In-App Events can appear on the Home tab, the game page and search. — [Apple Games app](https://developer.apple.com/games-app/); [Apple Games](https://developer.apple.com/games/)
- Guidelines 4.5.3 and 4.5.5: don't exploit Player IDs or display them to third parties. — [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

### Inferences
- Low-cost visibility win: initialise Game Center, add a few achievements and a leaderboard (for example most fares in a day), and run In-App Events such as a festive-season route. This raises Games-app presence at no backend cost.
- iCloud (CloudKit or key-value store) could mirror PGS Saved Games for iOS cloud backup without a backend.

### Gaps
- No specific App Store requirements for iCloud use in games were retrieved.
- The Game Center rules for showing the access point or dashboard were not fetched.

---

## Account costs and fee waivers (both stores)

### Takeaway
Apple charges **US$99/year**, and fee waivers are **not available to individuals**; they are only for nonprofits, accredited educational institutions and government entities. Google Play charges a **one-time US$25** registration fee.

### Cited Findings
- "The Apple Developer Program is 99 USD per membership year. Prices may vary by region." Individuals must use their legal name, which is "displayed as the seller name of your apps on the App Store". Organisations need a legal entity, a **D-U-N-S Number** and a functional website. — [Apple Developer Program enrollment](https://developer.apple.com/programs/enroll/)
- Fee-waiver eligibility: "nonprofit organization, accredited educational institution, or government entity" and "Not be an individual, sole proprietor, or single-person business"; must not sell digital goods. — [Apple fee waivers](https://developer.apple.com/help/account/membership/fee-waivers/)
- Play: "Play's $25 registration fee". — [Android developer verification FAQ](https://developer.android.com/developer-verification/guides/faq)

### Inferences
- An individual developer's legal name appears publicly as seller on the App Store and, if a trader, in the EU DSA listing. Forming an organisation (for example a Nigerian limited company with a D-U-N-S number) would show a brand name and skip Play's 12-tester rule, at the cost of several weeks of setup.

### Gaps
- Whether Apple's 99 USD fee is priced in NGN locally in Nigeria was not checked.
- The Play Console's accepted payment methods for Nigeria were not checked.
