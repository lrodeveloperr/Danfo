# Engine alternatives to Godot for "Danfo" (3D mobile driving game): Unity 6, Unreal Engine 5, others (state as of 18 Oct 2026)

> **Method note for the report writer (read first).** Researched 18 Oct 2026. Every WebFetch call in this session failed with DNS errors (unity.com, discussions.unity.com, endoflife.date, gamefromscratch.com, unrealengine.com), and the session's shared web-search budget ran out near the end. So **every finding below comes from search-engine summaries of the cited pages, not from full reads of them.** Treat exact quotes and numbers as "reported by the cited page via search summary". Re-verify the decision-critical numbers on the primary pages before publishing: Unity's $200K threshold, Pro at $2,310, Unity 6.3/6.6/6.7 minimum Android API, UE 5% over $1M and the 3.5% rate, and the UE 5.8 mobile defaults. Dates in square brackets are the date of the fact or the source. "Background knowledge" marks material I did not re-verify this session; it sits only under Inferences or Gaps.

## 1. Unity licensing as of October 2026 (Personal threshold, splash, Pro/Enterprise prices, Runtime Fee, 2025–26 changes, royalties, over-threshold rules)

### Takeaway
Unity Personal is still free, with no royalty and no runtime/per-install fee. It is capped at **$200,000 in revenue plus funding over the last 12 months**, and from Unity 6 the "Made with Unity" splash screen is optional on Personal. Above the cap you must buy Unity Pro, which has cost **$2,310 per seat per year ($210/month) since 12 Jan 2026**. Unity cancelled the Runtime Fee on 12 Sep 2024. Unity's behaviour since then is the residual risk: two price rises in about 13 months, plus a reported (unconfirmed) revenue-linked "minimum commitment" for Enterprise in Dec 2025.

### Cited Findings
- **Personal threshold [current page, cited Oct 2026]:** Unity's pricing-updates page lists Personal for organizations with up to **$200,000 in revenue and funding**, with Pro required above that. It says the higher threshold took effect with Unity 6 on **17 Oct 2024**. — [Unity Pricing Changes](https://unity.com/products/pricing-updates)
- Several secondary sources say the $200K is measured over the **prior 12 months**. — [Capermint, 2026](https://www.capermint.com/blog/unity-game-development-cost/); [A+ Games Studio, 2026](https://aplusgamesstudio.com/blog/unity-pricing-2026)
- **Date conflict on the $200K start:** the pricing page says 17 Oct 2024 (Unity 6 launch). Tech Insider says the cap doubled from $100K in Jan 2025, and Unity's cancellation blog is summarised as dating pricing changes to 1 Jan 2025. Either way, the cap has been $200K since late 2024 or early 2025 and has not changed in 2026. — [Unity pricing page](https://unity.com/products/pricing-updates); [Tech Insider 2026](https://tech-insider.org/unity-vs-unreal-engine-2026/); [Unity blog, 12 Sep 2024](https://unity.com/blog/unity-is-canceling-the-runtime-fee)
- **Runtime Fee cancelled [12 Sep 2024]:** CEO Matt Bromberg's post cancelled the Runtime Fee for games customers, effective immediately. Personal stays free and its ceiling doubles from $100K to $200K. From **1 Jan 2025**, Pro rises **8%** and Enterprise **25%**; Enterprise is for companies with more than $25M in annual revenue and funding. Unity signalled that future price rises would come "in a more traditional way". — [Unity blog](https://unity.com/en/blog/unity-is-canceling-the-runtime-fee); [PocketGamer.biz](https://www.pocketgamer.biz/unity-cancels-infamous-runtime-fee/); [80.lv](https://80.lv/articles/unity-cancels-its-controversial-runtime-fee-policy/); [Mobilegamer.biz](https://mobilegamer.biz/unitys-runtime-fee-is-dead/)
- **2026 price rise [announced Nov 2025, effective 12 Jan 2026]:** Pro and Enterprise rose **5%**. Pro went from **$2,200 to $2,310 per seat per year** and from **$200 to $210 per month**. Existing subscribers pay the new price at their first renewal on or after 12 Jan 2026. Enterprise is quote-based. — [80.lv](https://80.lv/articles/unity-announces-its-upcoming-2026-price-changes); [CG Channel, Nov 2025](https://www.cgchannel.com/2025/11/price-of-paid-unity-subscriptions-to-rise-but-free-subs-extended/); [A+ Games Studio](https://aplusgamesstudio.com/blog/unity-pricing-2026)
- **Other 2025–26 terms changes:** from **Unity 6.3**, Havok Physics is no longer included with Pro or Enterprise. Unity Version Control on Unity's public cloud drops seat charges; Personal's three-seat cap becomes unlimited, which one secondary source dates to **1 Mar 2026**. — [80.lv](https://80.lv/articles/unity-announces-its-upcoming-2026-price-changes); [Unity pricing page](https://unity.com/products/pricing-updates); [A+ Games Studio](https://aplusgamesstudio.com/blog/unity-pricing-2026)
- **Splash screen:** Unity's support article says Personal users cannot remove the splash in Editor versions before Unity 6. **Unity 6 adds the option for Personal to disable or customize the "Made with Unity" splash** (Project Settings > Player > Splash Image > Show Splash Screen). The article's header still lists the feature under the discontinued "Plus" plan, which is a minor inconsistency. — [Unity Support article 212165803](https://support.unity.com/hc/en-us/articles/212165803)
- **Unconfirmed Enterprise "minimum commitment" [report dated 17 Dec 2025]:** Mobilegamer.biz, citing anonymous sources and a client email, reported a revenue-linked annual fee for Enterprise customers. It reportedly starts at **$250K** (revenue above $25M to $50M) and rises to **$2M** (revenue above $250M), with an alleged threat to revoke licences from teams that did not pay. One developer said: "This feels like blackmail." Unity had not commented at publication. — [Mobilegamer.biz](https://mobilegamer.biz/unity-risks-fresh-backlash-with-new-fee-demands-this-feels-like-blackmail/); [80.lv](https://80.lv/articles/unity-reportedly-rolls-out-annual-fee-for-enterprise-customers-starting-at-usd250k); [TechRaptor](https://techraptor.net/gaming/news/unity-new-enterprise-fee-report)

### Inferences
- **No royalties on Personal.** No source found describes any revenue share or per-install fee on Unity Personal after the Sep 2024 cancellation. The only cost trigger is crossing $200K in revenue plus funding, which forces Pro at **$2,310 per seat per year** (Oct 2026 price).
- **Fit with "free tools only, no royalties".** Unity Personal fits that wording for Danfo's likely early revenue: an ad-only game in a low-eCPM market will probably stay under $200K a year for a long time. It does not fit the spirit of the constraint. The licence is proprietary, its terms are unilaterally changeable (as 2023 showed), and success triggers a mandatory seat subscription. For a two-person team that is about $4,620 a year at 2026 prices, and prices have risen in 2025 and 2026.
- **The Enterprise fee doesn't touch Danfo** ($25M+ revenue tiers). It matters only as a trust signal about how Unity treats licensees.

### Gaps
- I could not open Unity's current Personal terms or EULA to confirm the exact over-threshold mechanics, such as any grace period, or whether "funding" includes grants. Verify on unity.com/legal.
- I found no source on any Unity Personal change announced at Unite 2026 (the Unite Seoul event of 21 Jul 2026 is covered only for the Unity 7 roadmap; see Q2).

## 2. Current Unity 6 versions/LTS and mobile-relevant features (URP, GPU Resident Drawer, Vulkan/GLES, Addressables + PAD, 16 KB pages, ARMv7, min OS)

### Takeaway
As of 18 Oct 2026, the production choices are **Unity 6.3 LTS** (released 4 Dec 2025, supported to Dec 2027) and **Unity 6.6** (Supported release, 1 Sep 2026). **6.7 LTS** is expected in late 2026 and **Unity 7** beta in Dec 2026. Minimum Android rose across Unity 6: **API 23 (6.0) → API 25 (6.3) → API 26 / Android 8.0 (6.5–6.7)**. iOS rose from 13 to **15**, and ARMv7 is still listed as supported. 16 KB page-size support has existed since early 2025 builds. The GPU Resident Drawer does **not** work on OpenGL ES, so its benefits skip the GLES-only low-end Android devices that matter in Nigeria.

### Cited Findings
- **Release timeline:**
  - Unity 6 (6.0 LTS) released globally **17 Oct 2024**. — [BusinessWire, 19 Sep 2024](https://www.businesswire.com/news/home/20240919183808/en/Unity-6-Will-Release-Globally-October-17-2024-Unity-Announces-at-Annual-Unite-Developer-Conference)
  - Unity 6.2 launched in **Aug 2025** with integrated AI in beta and Android XR additions. — [AlternativeTo, Aug 2025](https://alternativeto.net/news/2025/8/unity-6-2-launches-with-integrated-ai-in-beta-and-enhanced-android-xr-capabilities)
  - **Unity 6.3 LTS released 4 Dec 2025.** It is the first LTS since 6.0 LTS, supported until **Dec 2027**. — [Unity blog](https://unity.com/blog/unity-6-3-lts-is-now-available); [80.lv](https://80.lv/articles/unity-6-3-lts-released); [CG Channel, Dec 2025](https://www.cgchannel.com/2025/12/unity-6-3-lts-is-out-see-5-key-features-for-cg-artists/)
  - **Unity 6.4 released mid-March 2026** (forum post 17 Mar; other pages say 18 or 19 Mar). ECS became core and Project Auditor became built in. endoflife.date lists its security support as ended **17 Jun 2026**. — [CG Channel, Mar 2026](https://www.cgchannel.com/2026/03/unity-releases-unity-6-4-and-unity-studio/); [Darko Unity](https://darkounity.com/blog/unity-64-is-officially-live-today); [Unity Discussions](https://discussions.unity.com/t/unity-6-4-is-now-available/1713245); [endoflife.date](https://endoflife.date/unity)
  - **Unity 6.5 released 15 Jun 2026.** Its forum post now says it has reached end of life and asks users to "upgrade to Unity 6.6 or above". endoflife.date gives its support end as **31 Aug 2026** (latest build 6000.5.11f1). — [Unity Discussions](https://discussions.unity.com/t/unity-6-5-is-now-available/1723176); [endoflife.date](https://endoflife.date/unity)
  - **Unity 6.6 released 1 Sep 2026.** It is a Supported release, supported "until the next release, 6.7, arrives". Features include Content Directories, native Dictionary serialization, WebGPU out of experimental, and reload-scene-only Fast Enter Play Mode by default. — [Unity Discussions](https://discussions.unity.com/t/unity-6-6-is-now-available/1735357); [GameFromScratch](https://gamefromscratch.com/unity-6-6-released/); [GameDev.net](https://gamedev.net/news/5468-unity-66-released/)
  - **Unity 7:** announced at Unite Seoul (**21 Jul 2026**), with early beta in **Dec 2026** and final release in **early 2027**. Unity calls it a direct continuation of Unity 6. It moves from Mono to **CoreCLR**, with an experimental CoreCLR desktop player planned for 6.7. Sources disagree on the timing of **6.7 LTS**: one says late 2026, another says no ETA has been given. — [Game Developer](https://www.gamedeveloper.com/programming/unity-unveils-unity-7-roadmap-with-update-path-that-won-t-break-your-build); [Digital Production, 26 Nov 2025](https://digitalproduction.com/2025/11/26/unitys-2026-roadmap-coreclr-verified-packages-fewer-surprises/); [Ocean View Games](https://oceanviewgames.co.uk/technologies/unity-7); [makaka.org](https://makaka.org/unity-tutorials/best-version)
- **Minimum platform requirements by version (Unity docs):**
  - Unity 6.0: Android **6.0 (API 23)+**, CPU **ARMv7 with NEON or ARM64**; iOS/iPadOS **13+**, A8 SoC+, Metal. — [Unity 6.0 system requirements](https://docs.unity.com/en-us/engine/6000.0/manual/get-started/install-and-upgrade/getting-started-installing-unity/system-requirements). API 23 has been the minimum since Unity 2023.2. — [Unity Discussions](https://discussions.unity.com/t/unity-2023-2-increasing-the-minimum-supported-api-to-android-6-api-23/919490)
  - Unity 6.3: Android **7.1 (API 25)+**. — [Unity 6.3 system requirements](https://docs.unity3d.com/6000.3/Documentation/Manual/system-requirements.html)
  - Unity 6.5: Android **8.0 (API 26)+**; iOS/iPadOS **15+**, A8 SoC+, Metal, **Xcode 16+**. — [Unity 6.5 system requirements](https://docs.unity.com/en-us/engine/6000.5/manual/get-started/install-and-upgrade/getting-started-installing-unity/system-requirements)
  - Unity 6.6: Android API 26; graphics **OpenGL ES 3.1+ or Vulkan**; CPU "**ARMv7 with Neon Support (32-bit) or ARM64**". — [Unity 6.6 system requirements](https://docs.unity.com/en-us/engine/6000.6/manual/get-started/install-and-upgrade/getting-started-installing-unity/system-requirements)
  - Unity 6.7: "Android 8.0 (API level 26) and later". — [Unity 6.7 Android requirements](https://docs.unity.com/en-us/engine/6000.7/manual/platform-specific/android/introducing/requirements-and-compatibility)
  - No source found marking ARMv7 as deprecated in Unity 6.x (search summary).
- **16 KB memory pages (needed for Google Play apps targeting Android 15+ from 1 Nov 2025):** Unity says 16 KB support is available for 2021 Extended Support, 2022 LTS and Unity 6. A third-party write-up names **6000.0.38f1 (14 Feb 2025)** and 6000.1.0b5 (9 Feb 2025) as early builds with it. A community post says 6.2 and 6.3 are "fully supported". Outdated third-party native plugins can still fail the Play check; one example was an old Firestore plugin, and the Play Asset Delivery plugin has a GitHub issue about it. — [Unity Discussions (16 KB)](https://discussions.unity.com/t/android-unity-engine-support-for-16-kb-memory-page-sizes-android-15/1589588); [REALITY Tech note](https://note.com/reality_eng/n/n6280ed836577?hl=en); [Unity Discussions (Play 16 KB)](https://discussions.unity.com/t/google-play-16kb-page-size-requirements/1681037); [google/play-asset-delivery-unity issues](https://github.com/google/play-asset-delivery-unity/issues)
- **Addressables + Play Asset Delivery:** Unity's 6.3 manual documents PAD as "the asset splitting solution for the Android App Bundle (AAB)" format, available only for Google Play. The Addressables team recommends Unity's Addressables PAD sample over Google's plugin. Users on 6.3 LTS (6000.3.11f1) report the base module staying too large for Play's 150–200 MB base limit, for example "Total size of all bundles = 255.73 MB". — [Unity 6.3 PAD docs](https://docs.unity.com/en-us/engine/6000.3/manual/platform-specific/android/developing/application-size-restrictions/play-asset-delivery); [Unity Discussions (6.3 PAD issue)](https://discussions.unity.com/t/unity-6-3-lts-6000-3-11f1-addressables-for-android-failing-to-keep-base-module-compliant-to-google-play-150-mb-to-200-mb-limit/1715320); [Unity Discussions (PAD + Addressables)](https://discussions.unity.com/t/need-help-with-play-asset-delivery-and-addressable-for-android-in-unity-6/1648613)
- **GPU Resident Drawer (GRD):** it works on graphics APIs and platforms that support compute shaders, "**except OpenGL ES** and visionOS". The URP asset may contain only **Forward+ or Deferred+** renderers. On unsupported backends Unity "falls back to regular game object rendering". Android setup: BatchRendererGroup Variants set to Keep All, SRP Batcher on, GRD set to Instanced Drawing, rendering path Forward+. A forum commenter cited Google's dashboard (dated figure) as showing about 15% of devices without Vulkan. — [Unity 6.6 GRD docs](https://docs.unity.com/en-us/engine/6000.6/manual/analysis/graphics-performance-profiling/in-urp/reduce-draw-calls-urp/reduce-rendering-work-on-cpu/gpu-resident-drawer); [Unity 6.0 GRD docs](https://docs.unity3d.com/6000.0/Documentation/Manual/urp/gpu-resident-drawer.html); [Unity Discussions (GRD Android)](https://discussions.unity.com/t/unity-6-gpu-resident-drawer-gpu-occlusion-cullling-compatibility-with-android/1539448)

### Inferences
- **Version choice for Danfo.** Pick **6.3 LTS**, supported to Dec 2027, or move to **6.7 LTS** when it ships. Supported (non-LTS) releases reach end of life roughly quarterly, as 6.4 and 6.5 did within about 3 months, which is a churn burden for a solo developer.
- **Minimum Android version.** 6.3 LTS (API 25) and later (API 26) drop Android 6–7.0 devices. Godot 4 and Unreal (Android 8+) have similar floors, so this is probably not a differentiator for Nigeria in 2026. The decisive low-end factor is GPU and RAM, not OS version.
- **GRD and Forward+ are high-end features.** The headline Unity 6 rendering gains (GRD, GPU occlusion culling) need Vulkan, Forward+ and compute shaders. On the cheap GLES-only Android phones common in Nigeria, Danfo would run classic URP Forward with the SRP Batcher and static batching. That is still a mature, well-documented mobile path; this is background knowledge, not re-verified.
- **PAD for size.** Addressables + PAD is the most mature size-management path of the three engines for an open-world city. Expect real-world friction, as the 6.3 base-module reports show.

### Gaps
- Unity 6.1 release date: not retrieved (background knowledge says around Apr 2025, unverified).
- Unity 6.0 LTS end of support: not retrieved. Background knowledge suggests a 2-year LTS window, ending around Oct 2026 for non-Enterprise users; verify.
- The minimum iOS version for 6.6 and 6.7 is not confirmed; 6.5 says iOS 15+.
- Not retrieved: Unity 6 Vulkan device filtering (allow and deny lists for GLES fallback), and Unity's default Android graphics API order. The search budget was exhausted.
- I found no source on Unity's own low-end Android benchmark numbers for URP in 2026.
- Google Play's target-API deadline for 2026 (likely API 36 from 31 Aug 2026, from background knowledge) was not verified. That is the deadline that forces engine upgrades.

## 3. Empty-project and real-game APK/AAB sizes: Unity vs Godot vs Unreal

### Takeaway
No reliable, like-for-like 2026 measurement exists in the sources found. Approximate ranges: **Unity about 6–17 MB** for an empty Android build (an older but concrete measurement). **Godot 4 about 25–60 MB** for minimal exports, with arm64-only or custom templates smaller (blog estimates). **Unreal is several times larger:** about 42 MB tuned (UE4-era), and 150–300 MB or more is commonly reported for untuned UE5. Danfo should build empty and prototype projects in each engine with identical settings (arm64-only, stripping on) before quoting numbers.

### Cited Findings
- **Unity:** an empty project with a simple UI produced an APK of about **17 MB with default settings**, cut to about **6 MB** through build settings. The post is about 2 years old, so pre-Unity 6 or early Unity 6. Comparison blogs give about 30–50 MB for a minimal Unity project, without stating a method. — [BusyBytes](https://busybytes.com/blog/optimize-build-size-mobile-games-unity/); [Ocean View Games](https://oceanviewgames.co.uk/blog/posts/unity-vs-godot-vs-unreal-mobile-games); [Tech Insider](https://tech-insider.org/godot-vs-unity-2026/)
- **Godot 4:** blog estimates run from about 25 MB for a simple 2D game to about 30–60 MB for a minimal mobile export, with the Android template about 40 MB before stripping. Godot's docs say the APK by default contains both ARMv7 and ARMv8 libraries, "which increases its size significantly". Unticking armeabi-v7a, or compiling a feature-stripped custom template, reduces size. One lower-quality blog claims Godot 4.3 dropped the ARMv7 template, which conflicts with the 4.4 docs. — [Godot 4.4 docs: Exporting for Android](https://docs.godotengine.org/en/4.4/tutorials/export/exporting_for_android.html); [Tech Insider](https://tech-insider.org/unity-vs-unreal-vs-godot-2026/); [Bugnet blog (conflicting)](https://bugnet.io/blog/fix-godot-export-template-android-arm32-removed-4-3)
- **Unreal:**
  - A forum tester got an empty project to about **42 MB** with recommended settings, and about 37.6 MB after disabling plugins. This is UE4-era. — [Epic forums](https://forums.unrealengine.com/t/reducing-build-size-an-attempt-to-get-the-smallest-size-empty-project-packaged/121027)
  - A beginner's empty-map project came out around **250 MB**. — [Epic forums](https://forums.unrealengine.com/t/huge-apk-file-size-for-just-a-widget-in-an-empty-world/1164440)
  - 2026 comparison blogs put minimal UE5 mobile builds at about **150–300 MB**, or **250 MB to 1 GB+**. — [Ocean View Games](https://oceanviewgames.co.uk/blog/posts/unity-vs-godot-vs-unreal-mobile-games); [Tech Insider](https://tech-insider.org/unity-vs-unreal-vs-godot-2026/)
  - UE5 enables dead-code elimination and identical code folding by default. Further binary savings need specific SDK levels and manual opt-in. Epic recommends PAD or ChunkDownloader to split assets out of the binary. — [Epic: Reducing Android Binary Size](https://dev.epicgames.com/documentation/unreal-engine/reducing-android-binary-size-in-unreal-engine-projects?lang=en-US); [Georgy.dev](https://georgy.dev/posts/reducing-mobile-build-size/)
- **Defold**, for contrast: Android APKs under **5 MB** are reported as routine. — [Cinevva open-source engines 2026](https://app.cinevva.com/guides/open-source-game-engines-2026)
- **Caution on web-build numbers:** one guide's "empty build" figures (Unity about 8 MB, Godot about 9 MB gzipped) are WebGL, not Android. — [Cinevva web engines](https://app.cinevva.com/guides/web-game-engines-comparison)

### Inferences
- For Nigeria, where data is expensive and storage scarce, the engine baseline matters less than content: textures, audio and the city mesh. Unity and Godot are both viable for a base download under 100 MB. Unreal's larger floor plus shader caches makes that target much harder for a solo developer.
- Godot's armv7 default doubles the native libraries; ship arm64 plus armv7 only if analytics justify it. Unity can do the same per-ABI split via AAB.

### Gaps
- I found no credible 2025–26 measurement of real shipped 3D driving games by engine, such as Bus Simulator Indonesia's AAB size by ABI, or a Godot 4.5 or 4.6 measured empty arm64 APK.
- I found no measured UE 5.7 or 5.8 empty Android shipping build.

## 4. Unreal Engine 5: licensing, current version, mobile renderer on low-end Android, minimum specs, 32-bit drop, build size, solo-developer fit

### Takeaway
UE's licence is unchanged in its core: free, then **5% royalty on lifetime gross revenue above $1M per product** (since 2020). A **3.5%** rate has applied since 1 Jan 2025 for "Launch Everywhere with Epic" titles. **UE 5.8 (June 2026) is the last planned UE5 release**, and UE6 is targeted for early access around late 2027. UE needs **Android 8+, 64-bit ARM only, and GLES 3.2 or Vulkan 1.1**. UE 5.8 made multi-pass **deferred** the mobile default, aimed at higher-end hardware. For a solo, AI-agent-heavy developer targeting low-end Nigerian Android phones, UE is the weakest fit of the three.

### Cited Findings
- **Royalty:** Epic's EULA says royalties apply once a product generates more than **$1,000,000 USD gross revenue**, at **5%**. The $1M waiver was introduced in **May 2020**, retroactive to 1 Jan 2020. Worked example: $1.2M gross means 5% of $200K, which is **$10,000**. — [Unreal EULA](https://www.unrealengine.com/eula/unreal); [PC Gamer, 2020](https://www.pcgamer.com/unreal-engine-games-no-longer-owe-royalties-on-their-first-dollar1m-in-revenue/); [Road to VR, 2020](https://roadtovr.com/unreal-engine-royalty-free-first-1-million-revenue/); [300Mind, 2026](https://300mind.studio/blog/unreal-engine-licensing-royalties/)
- **3.5% "Launch Everywhere with Epic":**
  - Announced early **Oct 2024**, effective **1 Jan 2025**. It requires shipping on the Epic Games Store before or at the same time as other stores on the same platforms. The rate reverts to 5% if the game is on another PC or Android store but not on EGS for that platform.
  - Epic **temporarily waives the iOS simultaneous-EGS requirement**, with at least **four months' notice** if that changes.
  - Games sold on EGS pay no engine royalty on EGS sales, only the 12% store fee.
  - [GameFromScratch](https://gamefromscratch.com/unreal-engine-launch-everywhere-with-epic/); [MediaPost](https://www.mediapost.com/publications/article/399903/epic-games-gives-unreal-engine-developers-a-bigger.html); [Stevivor](https://stevivor.com/news/epic-games-will-drop-royalty-rates-for-games-with-simultaneous-launches); [Unreal EULA change log](https://www.unrealengine.com/eula-change-log/unreal)
- **No 2025–26 change to the $1M/5% core terms was found.** The 2024 seat-based Unreal Subscription applies to **non-game** companies with more than $1M revenue, not to games. — [Epic blog, 2024](https://www.unrealengine.com/en-US/blog/we-are-updating-unreal-engine-twinmotion-and-realitycapture-pricing-in-late-april)
- **Current version:** **UE 5.8**. Epic's announcement is dated **23 Jun 2026**; other sources say 17 or 18 Jun. The preview came out on 12 May 2026. Epic calls 5.8 "the last planned major Unreal Engine 5 release on our roadmap as we ramp up work on UE6". — [Epic news](https://www.unrealengine.com/news/unreal-engine-5-8-is-now-available); [Epic forums (preview)](https://forums.unrealengine.com/t/unreal-engine-5-8-preview/2721597); [Wikipedia: UE5](https://en.wikipedia.org/wiki/Unreal_Engine_5)
- **UE6 timeline:** unveiled at State of Unreal 2026. **Early access is targeted for late 2027** and full release about 12 months later, around 2028. — [Inven Global](https://www.invenglobal.com/articles/24950/next-gen-game-engine-unreal-engine-6-will-bring-a-shift-in-the-development-ecosystem); [Outlook Respawn](https://respawn.outlookindia.com/gaming/gaming-news/unreal-engine-6-ue5-uefn-merge-for-fortnite-creators-in-2026); [The Rookies](https://www.therookies.co/blog/headlines/state-of-unreal-2026-top-news-about-unreal-engine)
- **UE 5.8 mobile rendering:** multi-pass **deferred becomes the default across mobile platforms**, with forward as opt-in. 5.8 also adds targeted **FP16** shader use. The notes frame these gains as serving higher-end mobile hardware. Android items in 5.8 are mainly input, Turnkey and Unreal Remote on Android. Epic's older mobile-deferred docs list "relatively higher-end mobile hardware" as a drawback. — [UE 5.8 release notes](https://dev.epicgames.com/documentation/unreal-engine/unreal-engine-5-8-release-notes?lang=en-US); [Tom Looman: 5.8 performance](https://tomlooman.com/unreal-engine-5-8-performance-highlights/); [Epic: Mobile deferred shading](https://dev.epicgames.com/documentation/unreal-engine/using-the-mobile-deferred-shading-mode-in-unreal-engine?lang=en-US)
- **Pre-5.8 guidance (dated):** Mobile Forward was the recommended path; deferred was "usually unsuitable for anything below flagship tier". The desktop renderer on Android Vulkan is experimental and "not recommend[ed]… for shipped projects". 5.7 added experimental SMAA on mobile. — [Game-Ace](https://game-ace.com/blog/unreal-engine-for-mobile-games/); [Epic: Desktop renderer on mobile](https://dev.epicgames.com/documentation/en-us/unreal-engine/using-the-desktop-renderer-on-mobile-in-unreal-engine); [Tom Looman: 5.7](https://tomlooman.com/unreal-engine-5-7-performance-highlights/)
- **Device minimums (Epic Android requirements page):** **Android 8+**, **64-bit ARM CPU**, **OpenGL ES 3.2 or Vulkan 1.1 (Vulkan on Android 10+)**, Mali, Adreno, PowerVR or Xclipse GPUs. For 5.7, Epic recommends SDK 35 and NDK r27c. A tutorial says UE **5.7+ is needed to meet Play's target-API-35 rule**. — [Epic: Android development requirements](https://dev.epicgames.com/documentation/en-us/unreal-engine/android-development-requirements-for-unreal-engine); [Babaei.net UE 5.7 tutorial](https://www.babaei.net/blog/unreal-engine-android-packaging-apk-build-tutorial-meta-quest-htc-vive-standalone/)
- **32-bit drop:** Epic forum threads from the UE5 early-access era quote Epic saying UE5 supports **only 64-bit** Android. The current Android settings doc still shows a legacy "Store Version Offset (ARMv7)" field. — [Epic forums (ARMv7)](https://forums.unrealengine.com/t/on-ue5-is-it-possible-to-build-apk-for-android-arm7-32-bit-app/484482); [Epic forums (32-bit)](https://forums.unrealengine.com/t/ue5-android-32-bit-are-7-build/233850); [Epic: Android settings](https://dev.epicgames.com/documentation/unreal-engine/android-settings-in-the-unreal-engine-project-settings?lang=en-US)
- **Toolchain friction:** forum users report 5.7 Android packaging failures after upgrading from 5.4. One fix was NDK 27.2, JDK 21, and min and target SDK 34. — [Epic forums (5.7 Android setup)](https://forums.unrealengine.com/t/how-to-properly-setup-unreal-engine-5-7-to-export-for-android/2683128); [Epic forums (5.7 Android settings)](https://forums.unrealengine.com/t/ue-5-7-0-changes-in-android-settings-and-prerequisites-needed-for-quest/2675094)
- **Build size:** see Q3. Floor about 42 MB tuned (UE4-era); 150–300 MB or more typical for untuned UE5 per blogs.

### Inferences
- **Cost for Danfo:** effectively **$0 unless lifetime gross passes $1M**. That is a more generous threshold than Unity Personal's $200K a year, and UE has no seat fee. It does, however, break the "no engine royalties" constraint as literally worded once revenue passes $1M. Background knowledge says ad revenue counts as gross revenue under the UE EULA; this is not verified this session (see Gaps).
- **Low-end GPU cutoff:** the GLES 3.2 floor excludes some older or very cheap Android GPUs that Unity (GLES 3.1 in 6.6) and Godot's Compatibility renderer (GLES3) still reach. This is an inference from the stated minimums; I found no Nigeria device-share data here.
- **Engine lifecycle timing:** starting a multi-year UE5 project in late 2026 means building on the final UE5 minor version, with UE6 migration likely in 2028.
- **Solo-developer fit:** UE carries heavy editor and toolchain needs (large SDK and NDK pinning, multi-GB installs) and binary assets (see Q7). Its mobile path is optimised for high-end devices. Danfo's low-end, offline, ad-funded profile is close to the opposite of UE's mobile sweet spot.

### Gaps
- I could not open the EULA to confirm whether **advertising revenue** counts toward UE "gross revenue". Background knowledge says yes; verify before stating it.
- I found no UE 5.8 low-end Android benchmark, no explicit 5.8 forward-renderer fallback guidance for low-end devices, and no confirmation of UE's 16 KB page-size support version.
- I found no data on what share of Nigerian Android devices meet GLES 3.2 or Vulkan 1.1.

## 5. Ad mediation SDK support per engine (AdMob, AppLovin MAX, Unity LevelPlay/ironSource)

### Takeaway
**Unity has the strongest ad ecosystem.** Google, AppLovin and Unity itself (LevelPlay) all ship and maintain first-party Unity plugins, with frequent 2026 releases. **Unreal has an official AppLovin MAX plugin** (via Fab). Its built-in AdMob support historically lacked **rewarded** ads, and I found no official LevelPlay or AdMob Unreal plugin. **Godot now has an official AppLovin MAX plugin from AppLovin** (Godot 4.x), which is significant for Danfo's current Godot plan. AdMob and LevelPlay on Godot remain community or manual integrations.

### Cited Findings
- **Unity + AdMob:** Google maintains the **Google Mobile Ads Unity plugin** (googleads-mobile-unity). The newest release seen was **v11.6.0**, and the 10.x line ended at v10.7.0, dated January (relative dates on the page were inconsistent). — [GitHub releases](https://github.com/googleads/googleads-mobile-unity/releases); [Google: Unity quick start](https://developers.google.com/admob/unity/quick-start)
- **Unity + AppLovin MAX:** AppLovin's GitHub organisation hosts the **AppLovin-MAX-Unity-Plugin**. — [AppLovin GitHub](https://github.com/applovin)
- **Unity + LevelPlay (ironSource):** Unity ships LevelPlay as a Unity package (com.unity.services.levelplay), and it is documented in the Unity Manual. The 9.x line is current:
  - The **9.3.2 Unity package wraps the 9.6.0 Android and iOS SDKs** (Sep 2026).
  - **LevelPlay 9.6.1 (30 Sep 2026)** fixed a black-screen issue with apps built with **Xcode 27**.
  - [Unity Grow docs](https://docs.unity.com/en-us/grow/levelplay/sdk/unity/package-integration); [Unity Manual: Ads Mediation](https://docs.unity3d.com/6000.2/Documentation/Manual/com.unity.services.levelplay.html); [Unity Releases tracker](https://unityreleases.com/updates/products/unity-levelplay)
- **Unreal + AppLovin MAX (official):**
  - AppLovin publishes **AppLovin-MAX-Unreal**, an Android and iOS plugin with a UE5 demo, installed from **Fab**. It supports interstitials, rewarded ads, banners and MRECs from mediated networks via C++ or Blueprints.
  - "**Windows is currently unsupported as a development platform** due to Fab's file path limit restrictions."
  - [GitHub: AppLovin-MAX-Unreal](https://github.com/AppLovin/AppLovin-MAX-Unreal); [AppLovin Unreal docs](https://developers.applovin.com/en/unreal/overview/integration/); [Unreal Marketplace listing](https://unrealengine.com/marketplace/en-US/product/applovin-max)
- **Unreal + AdMob:**
  - A UE4-era Unreal Answers thread says the built-in Blueprint ad nodes cover **banner and interstitial but not rewarded**. — [Unreal Answers](https://answers.unrealengine.com/questions/914105/view.html)
  - Rewarded AdMob on UE relies on **commercial Fab plugins**. — [Fab: Admob Ads](https://www.fab.com/listings/1d79ab2a-0059-41c8-98bd-1f4f0630d311); [Fab: Alpha Ads AdMob](https://www.fab.com/listings/92fc9c1d-8f98-463c-aff5-20541ef677de)
  - An older unofficial open-source alternative also exists. — [GitHub: Flakky/unreal-applovin](https://github.com/Flakky/unreal-applovin)
- **Godot + AppLovin MAX:** **AppLovin-MAX-Godot** is published by AppLovin and documented on AppLovin/Axon's support site. It supports Godot 4.x only. The Godot Asset Library labels it "Support Level: community". A 2026 comparison blog says most mediation SDKs on Godot (AdMob, IronSource, AppLovin) need community plugins or manual Java/Obj-C integration. — [GitHub: AppLovin-MAX-Godot](https://github.com/AppLovin/AppLovin-MAX-Godot); [Axon/AppLovin Godot docs](https://support.axon.ai/en/max/godot/overview/integration); [Godot Asset Library](https://godotengine.org/asset-library/asset/2141); [Ocean View Games](https://oceanviewgames.co.uk/blog/posts/unity-vs-godot-vs-unreal-mobile-games)

### Inferences
- **Monetisation tooling:** in an ads-only business, Unity's first-party plugins from all three major mediators shorten integration and the ongoing SDK-update chores. Those chores include Play policy, iOS ATT/SKAdNetwork and Xcode bumps, as the LevelPlay 9.6.1 Xcode 27 fix shows. This is a real "best in class" argument for Unity.
- **Godot gap has narrowed:** the official MAX Godot plugin means Danfo on Godot can run rewarded and interstitial ads through MAX mediation, with AdMob as a mediated network, without a paid plugin. AdMob-direct and LevelPlay-direct remain community-maintained.
- **Unreal:** MAX is the only clean free path, and the Windows-host limitation is an unusual friction point.

### Gaps
- I found no official LevelPlay Unreal or LevelPlay Godot plugin, and no 2026 check of whether UE5's built-in AdMob gained rewarded support.
- I did not verify the latest release dates or versions of the MAX Unity, Unreal or Godot plugins.
- I found no data on mediation eCPMs for Nigeria by network; another researcher's scope.

## 6. Vehicle physics per engine without paid assets

### Takeaway
**Unity** has a built-in **WheelCollider** (PhysX-based) and several free, open-source controllers on GitHub, mostly hobby-grade. The well-known production controllers (NWH, Edy's, RCC) are paid assets, which the constraint excludes. **Unreal** ships **Chaos Vehicles**, plus the **Chaos Modular Vehicle System since UE 5.5**, built in and free. I found no mobile performance benchmarks for it. Neither engine gives a clearly better free vehicle story than Godot + Jolt. Arcade minibus handling with contact-heavy racing will be custom code in any engine.

### Cited Findings
- **Free Unity controllers:**
  - **Saarg/Arcade_Car_Physics**: arcade cars on WheelColliders, with a demo scene. Licence not confirmed in the summary. — [GitHub](https://github.com/Saarg/Arcade_Car_Physics)
  - **tommiseppanen/PrimeTyre**: an **MIT** WheelCollider replacement, still in development. — [GitHub](https://github.com/tommiseppanen/PrimeTyre)
  - **TLabAltoh/TLabVehiclePhysics**: an open-source WheelCollider with **Pacejka** tyre logic. — [GitHub](https://github.com/TLabAltoh/TLabVehiclePhysics)
  - **ilisescu03 Unity Car Controller** for Unity 6 and the Input System. — [GitHub](https://github.com/ilisescu03/Unity---Car-Controller)
  - **psuong/arcade-vehicle-controller**: ECS-based, **archived 19 Mar 2019**. — [GitHub](https://github.com/psuong/arcade-vehicle-controller)
  - A guide notes that WheelColliders are "tricky to tune but not inherently unstable". — [Saarg repo](https://github.com/Saarg/Arcade_Car_Physics)
- **Unity physics packaging change:** Havok Physics is no longer bundled with Pro or Enterprise from Unity 6.3. It is irrelevant to Personal users, who use built-in PhysX. — [80.lv](https://80.lv/articles/unity-announces-its-upcoming-2026-price-changes)
- **Unreal Chaos:** UE 5.5 introduced the **Chaos Modular Vehicle System** (modular engines, transmissions, suspension, wheels and aero). A community tutorial runs it on **Android** with touch controls and real-time destruction, but reports no frame rates in the summary. A low-quality desktop test showed Chaos at about **30 FPS** in a collision scenario that UE4.26 PhysX handled without drops. — [Epic forums tutorial](https://forums.unrealengine.com/t/community-tutorial-unreal-engine-5-5-chaos-modular-vehicle-on-android-real-time-vehicle-destruction-touch-controls/2351786); [Lilys AI summary (low-quality)](https://lilys.ai/notes/pt/unreal-engine-5-20251128/ue5-chaos-ue4-physx-performance)

### Inferences
- **Arcade handling usually means custom code.** For contact-heavy minibus racing on mobile, arcade handling is usually built on a custom raycast-suspension controller rather than a realistic wheel model. That holds in Unity (Rigidbody plus raycasts), Godot (RigidBody3D or VehicleBody3D plus Jolt) and Unreal alike. Engine choice therefore barely moves vehicle-physics effort when paid assets are banned.
- **Unity's real advantage is the paid ecosystem,** which is off the table under the constraint. Lifting the "no paid plugins" rule would make Unity's vehicle story markedly better: mature controllers for roughly tens of US dollars (background knowledge; prices not verified).
- **Chaos on low-end phones is unproven:** I found no evidence that it performs well there, which is a risk for traffic AI with many simulated vehicles. Most traffic cars should be kinematic in any engine.

### Gaps
- I found no mobile benchmarks (FPS or thermal) for Unity WheelCollider, Chaos Vehicles or Godot Jolt vehicles on low-end Android.
- I did not verify the licences of the Saarg and TLab repos.

## 7. CI/CD and licensing friction; suitability for AI coding agents

### Takeaway
**Unity CI works but carries licence friction.** Personal licences need a locally generated `.ulf` plus `UNITY_EMAIL`/`UNITY_PASSWORD` secrets (GameCI v4). The old manual-activation action is deprecated and personal licences can expire. Builds run headless via `-batchmode -quit -executeMethod` in Docker images with an Android module. **Unity is text-friendly** (Force Text YAML scenes, UnityYAMLMerge), and in 2026 has an **official MCP server and AI beta (May 2026)**. **Unreal's .uasset binaries** defeat text diff and merge and agent editing. **Godot's text .tscn/.tres plus a no-account CLI export** remains the most agent-friendly; this comparative point is inference.

### Cited Findings
- **GameCI personal-licence flow (v4 docs):** in Unity Hub, Preferences > Licenses > Add > "Get a free personal license" produces a `.ulf`. Store the licence plus `UNITY_EMAIL` and `UNITY_PASSWORD` as GitHub secrets. GameCI "does not acquire nor store" credentials. `UNITY_SERIAL` is only for paid plans. — [GameCI activation docs](https://game.ci/docs/github/activation/)
- The old **"Unity – Request Activation File" action is no longer maintained** and "should not be used". — [GitHub Marketplace](https://github.com/marketplace/actions/unity-request-activation-file)
- GameCI's headless-browser activation tool warns that "personal license will expire after some times", requiring re-activation. The repo is stale, last updated about 2,110 days before the search. — [GitHub: game-ci/unity-license-activate](https://github.com/game-ci/unity-license-activate)
- Third-party alternatives exist (RageAgainstThePixel, Buildalon) using username, password and an optional serial. — [Marketplace: activate-unity-license](https://github.com/marketplace/actions/activate-unity-license); [Marketplace: Buildalon](https://github.com/marketplace/actions/buildalon-activate-unity-license)
- **Headless builds:**
  - The standard CI pattern is `-batchmode -quit -executeMethod`, checking the exit code and build report. — [Unity build pipeline skill guide](https://claudeskills.info/skills/gamedev-skills/awesome-gamedev-agent-skills/unity-build-pipeline/)
  - Linux Docker builds of Unity use Xvfb with `-batchmode -nographics`. — [Edgegap docs](https://docs.edgegap.com/docs/tools-and-integrations/unity-server-in-docker)
  - A Gitea runner project publishes **Unity 6 images with Android support** (e.g. a 6000.0.35f1 Android tag). It notes that unity-builder's Docker-in-Docker is "not entirely stable" on Gitea (search summary of that project).
- **Text assets and merging:**
  - Unity's **Force Text** serialisation lets scenes and prefabs be stored as YAML. Converting a large project "can take a while and may even crash". — [Gist: Git and Unity](https://gist.github.com/Ikalou/197c414d62f45a1193fd)
  - **UnityYAMLMerge** handles scene and prefab merges, but YAML conflicts are "pretty much impossible to read" manually, so the advice is to split scenes into prefabs. — [7wolves: UnityYAMLMerge guide](https://7wolves.org/articles/unity-yaml-merge/); [Maroon wiki](https://github.com/GamesResearchTUG/Maroon/wiki/Merge-conflicts)
  - Unreal assets are **binary**: "classic text-based diff and merge tools give up". The workaround is using the Unreal Editor itself as the diff and merge tool. I found no official text serialisation for .uasset. — [Gist: Unreal Editor as diff tool](https://gist.github.com/Panakotta00/c90d1017b89b4853e8b97d13501b2e62)
- **AI agents and Unity:**
  - Unity's AI suite (Agentic Assistant, **AI Gateway**, **MCP Server**) went to **open beta for Unity 6 in May 2026**. It has Ask, Agent and Plan modes and connects to Claude Code or Cursor. The MCP server lives in `com.unity.ai.assistant`. — [Unity blog: MCP how-to](https://unity.com/blog/unity-ai-mcp-how-to-get-started); [Unity blog: MCP servers](https://unity.com/blog/mcp-servers-game-development); [Cinevva news, 4 May 2026](https://app.cinevva.com/news/2026-05-04-unity-ai-open-beta)
  - **Conflict:** a third-party guide (about Aug or Sep 2026) says the in-Editor MCP server was **deprecated** and the capability moved to a **Unity CLI** plus Unity Pipeline package, needing 6.0 LTS or later. Unity's own pages still describe the in-editor server. — [MCP Playground guide](https://mcpplaygroundonline.com/blog/unity-mcp-server-guide); [StraySpark 2026 comparison](https://www.strayspark.studio/blog/unity-mcp-server-vs-unreal-godot-blender-2026)
  - The community **CoplayDev "MCP for Unity"** is MIT-licensed and supports 2021.3 LTS to 6.x. — [ChatForest review](https://chatforest.com/reviews/unity-mcp-server/)

### Inferences
- **Unity CI cost:** Unity CI on GitHub Actions is feasible for free on Personal. The licensing step is an ongoing maintenance and secret-management cost that Godot does not have (no account, no activation). Unity Docker images are several GB, which is slow on free runners (background knowledge).
- **Agent-friendliness ranking (inference): Godot > Unity >> Unreal.**
  - Godot: plain-text scenes, GDScript, a small single-binary editor with `--headless --export-release`, no login.
  - Unity: C#, which LLMs know extremely well, plus YAML assets. Assets reference GUIDs in `.meta` files, so agents editing YAML by hand break references easily. Much work still happens in the GUI editor; MCP narrows this gap.
  - Unreal: C++ and Blueprints. Blueprints and assets are binary .uasset, with heavy editor dependence, multi-hour compiles and a 50–100+ GB toolchain (background knowledge).
- **C# breadth:** C# corpus breadth is a genuine Unity plus for AI agents. GDScript is a smaller corpus, and Godot 4 API changes since Godot 3 trip models up (background knowledge).

### Gaps
- I did not retrieve GameCI's current Android or Unity 6 image matrix, or Unity's official statement on Linux-editor Android build support. Background knowledge says the Linux editor supports Android builds; unverified this session.
- I found no source on an official Unreal MCP server or Epic AI-agent tooling in 2026.
- I did not confirm how often personal licences must be re-activated in CI in 2026.

## 8. Other engines: viability for 3D open-world mobile in 2026

### Takeaway
None of Defold, Cocos, Bevy, Stride, O3DE or Flax is a stronger choice than Godot for a solo, 3D, open-world, low-end-Android game in Oct 2026. **Cocos Creator** is the only one with a real 3D-mobile track record, mostly in China and mini-games. **Defold** is excellent for tiny 2D or light-3D mobile builds, but its 3D features are immature. **Bevy** ships to mobile "possible but not easy". **Flax** has official Android and iOS support but little mobile track record. I found nothing on O3DE mobile. Stride's mobile export was not confirmed.

### Cited Findings
- **Defold:** Lua-based, a mobile and web specialist; Android APKs **under 5 MB** reported as routine. **1.13.0 (Jun 2026)** dropped asm.js (Wasm-only web), and **1.13.1** added glTF morph targets and light components. Strongest for 2D, mobile and web. — [Cinevva open-source engines 2026](https://app.cinevva.com/guides/open-source-game-engines-2026); [Youngju.dev 2026 deep dive](https://www.youngju.dev/blog/culture/2026-05-16-open-source-game-engines-2026-godot-4-4-defold-bevy-gamemaker-phaser-construct-stride-pixijs-deep-dive.en)
- **Cocos Creator:** a cross-platform **3D** engine targeting iOS, Android, desktop, web and mini-game runtimes. One source says **Cocos 4 was announced on 4 Jan 2026 under plain MIT**, and another calls **3.8.8 the last 3.x release**. The licence was not confirmed from a primary source. — [AppRadar](https://appradar.com/blog/mobile-game-engines-development-platforms); [Cinevva](https://app.cinevva.com/guides/open-source-game-engines-2026)
- **Bevy (Rust, ECS):** the official site lists iOS and Android. A Sep 2025 GitHub discussion says shipping to mobile is "possible… but not easy", and a maintainer said mobile is unlikely to improve until more developers use it. A 2026 guide says the mobile ecosystem (touch, store integration) is "thinner than Unity's". Battery and frame-rate tuning (reactive update mode) went into the official mobile example in 0.15. — [bevy.org](https://bevy.org/); [GitHub discussion #20998](https://github.com/bevyengine/bevy/discussions/20998); [Rustify 2026](https://rustify.rs/articles/rust-bevy-game-engine-2026); [Rustunit, Jan 2025](https://rustunit.com/blog/2025/01-02-bevy-mobile-framerate/); [Bevy Cheat Book (old, 0.12)](https://bevy-cheatbook.github.io/platforms.html)
- **Flax Engine (C++/C#):** Android support was announced with Flax 1.0, covering C++, C#, visual scripting and a Vulkan renderer. **iOS was added in Flax 1.6 (2023)** via MoltenVK. Commits continued into 2026 (e.g. 30 Jun 2026). Flax's commercial licence has historically been a royalty above a revenue threshold (background knowledge, not verified). — [Flax 1.0 blog](https://flaxengine.com/blog/flax-1-0-released/); [Flax 1.6 release notes](https://docs.flaxengine.com/manual/release-notes/1_6/index.html); [Flax git](https://git.flaxengine.com/Flax/FlaxEngine)
- **Stride (C#, MIT):** described as a free, open-source 2D and 3D engine working toward 4.4. No search result confirmed current Android export. — [Youngju.dev](https://www.youngju.dev/blog/culture/2026-05-16-open-source-game-engines-2026-godot-4-4-defold-bevy-gamemaker-phaser-construct-stride-pixijs-deep-dive.en)

### Inferences
- **Cocos Creator** is the only credible "other" for a 3D mobile game. The likely costs are a smaller English-language community, TypeScript, weaker vehicle-physics options, and licence uncertainty around Cocos 4.
- **Defold** suits a 2.5D or top-down Danfo variant (very small APKs, an excellent low-end fit), but not a 3D open-world city.
- **Flax** has a royalty model (unverified) and a minimal mobile track record. **Bevy** lacks an editor, and its mobile support is immature. Both fail "best in class" for this project.

### Gaps
- I found no results on **O3DE** mobile status in 2026. Background knowledge says Android and iOS exist but are rarely used for shipped games; unverified.
- Not verified: Flax's current licence or royalty terms, Stride's Android and iOS status, and Cocos 4's licence and release status.

## 9. Market share: top mobile games, and mobile driving/bus games, by engine

### Takeaway
Unity's own claim is that it powers **more than 70% of the top 1,000 mobile games**: Sensor Tower and Apptopia data for Jan 2025 and Jun 2025, excluding China, broken down as **68% iOS / 71% Android**. No independent 2026 mobile engine-share dataset was found. For developers overall, the GDC 2026 survey shows **Unreal 42% vs Unity 30%** as primary engine, the first time Unreal has led, but that skews to AA/AAA. I found no reliable engine breakdown for mobile driving or bus sims; anecdotally the genre is overwhelmingly Unity.

### Cited Findings
- **Unity's claims:** "More than **70% of the top 1,000 mobile games** are made with Unity". The footnote cites Apptopia, App Annie and Sensor Tower, and defines "top" by blended Google Play and App Store MAU for **Jan 2025**. A newer page cites a **Jun 2025** ranking (excluding China), with **68% of iOS and 71% of Android** games. Another Unity page claims more than 60% of App Store best-sellers. — [Unity: Our company](https://unity.com/our-company); [Unity for mobile](https://create.unity.com/mobile-game-development-with-unity-pro)
- **GDC 2026 State of the Game Industry:**
  - **42%** of developers name Unreal as their primary engine and **30%** name Unity, the first time one has pulled ahead.
  - Unreal is at **59%** of AA and **47%** of AAA developers, while **54%** of developers at older indie studios still use Unity.
  - **Godot is at 11% among newer indie developers.** That figure may come from a different "engines you use" question.
  - The sample is people in development roles, not shipped games.
  - [GDC article](https://gdconf.com/article/gdc-2026-state-of-the-game-industry-reveals-impact-of-layoffs-generative-ai-and-more/); [Wizus Labs](https://wizuslabs.com/blog/unity-vs-alternatives-2026/); [Outlook Respawn](https://respawn.outlookindia.com/gaming/gaming-originals/2026-gdc-survey-exposes-workforce-strain-and-technological-shifts)
- **Steam (not mobile; secondary aggregator citing VGI):** Unity made **51% of 2024 Steam releases**, while Unreal earned **31% of Steam revenue**. Godot is at **7.1%** of scanned Steam games in 2025, up from 0.9% in 2020. — [VoxBooster (aggregator)](https://voxbooster.com/blog/game-engine-statistics-2026/); [Levvvel (aggregator)](https://levvvel.com/statistics/game-engine-market-share/)
- **Weak or unsourced figures to avoid:** "Unity about 48% of mobile market share"; "Cocos 20% of the mobile market"; "42% of global mobile engine market". These come from market-research blogs without primary data. — [VoxBooster](https://voxbooster.com/blog/game-engine-statistics-2026/); [Levvvel](https://levvvel.com/statistics/game-engine-market-share/)
- **Driving and bus genre:**
  - A promotional guide says **Car Parking Multiplayer** is built on Unity; this is low quality and not a developer statement. — [360works guide](https://joshuazabbix.360works.com/dominate-the-digital-road-car-parking-multiplayer-on-consoles-the-definitive-guide)
  - **Bus Simulator Indonesia's** engine was not confirmed by any result.
  - Commercial Unity "bus simulator" source templates are sold, which indicates the genre's Unity orientation. — [Gumroad bus template](https://crescentstudios.gumroad.com/l/Realistic-Bus-Simulator-Unity-Source-Code)
  - Sensor Tower's *State of Gaming 2026* summary covers revenue and genres, not engines. — [GameDevReports summary](https://gamedevreports.substack.com/p/sensor-tower-state-of-gaming-2026)

### Inferences
- **Mobile versus overall share:** on mobile, especially among mid-core and hyper-casual driving sims from emerging-market studios, Unity remains the de facto standard. The GDC "Unreal leads" headline reflects console and PC studios and should not be read as mobile share.
- **Proven path for this genre:** this is the strongest non-technical argument for Unity for Danfo. Hiring help, tutorials, ad-SDK testing and device-compatibility knowledge all assume Unity.

### Gaps
- I found no independent (non-Unity) 2025–26 mobile engine-share data.
- Gamalytic covers Steam only; I found no mobile equivalent.
- I found no engine identification for the top Google Play driving or bus titles in Nigeria.

## 10. Trust and business risk: Unity 2023 Runtime Fee and resolution, Godot Foundation funding, long-term risk

### Takeaway
Unity's Sep 2023 Runtime Fee was withdrawn in Sep 2024. Since then Unity has raised prices twice: +8% Pro and +25% Enterprise on 1 Jan 2025, and +5% on 12 Jan 2026. A revenue-linked Enterprise "minimum commitment" was also reported (unconfirmed) in Dec 2025. Unity's past behaviour shows it is willing to change commercial terms unilaterally. Godot is MIT-licensed and cannot be "re-priced". Its funding is modest but growing: about **€35K a month** in the Development Fund as of 2026, with new corporate sponsors in Apr and Jun 2026. Unreal's terms have been stable since 2020, but UE5 is at end of line (UE6 around 2027–28).

### Cited Findings
- **2023 Runtime Fee episode:** developers switched off Unity ads in protest ("boycott… to force a Runtime Fee reversal") in Sep 2023. — [Mobilegamer.biz, 2023](https://mobilegamer.biz/unity-boycott-begins-as-devs-switch-off-ads-to-force-a-runtime-fee-reversal/)
- **Resolution, 12 Sep 2024:** Unity cancelled the fee "for games customers"; see Q1 for the price changes. — [Unity blog](https://unity.com/blog/unity-is-canceling-the-runtime-fee); [PocketGamer.biz](https://www.pocketgamer.biz/unity-cancels-infamous-runtime-fee/)
- **Post-cancellation pricing:** +5% from 12 Jan 2026 (Pro to $2,310 a year). The Enterprise minimum-commitment report from 17 Dec 2025 is unconfirmed. — [80.lv](https://80.lv/articles/unity-announces-its-upcoming-2026-price-changes); [Mobilegamer.biz](https://mobilegamer.biz/unity-risks-fresh-backlash-with-new-fee-demands-this-feels-like-blackmail/)
- **Godot Foundation:**
  - The Foundation is a Dutch non-profit ("Stichting Godot"). The **Godot Development Fund** shows about **€35,469 a month, 1,838 members and 23 sponsors**, plus €239,709 in one-time donations "this year". Another snapshot shows about €35,314 a month and 1,823 members. — [Godot Development Fund](https://fund.godotengine.org/); [Godot Foundation](https://godot.foundation/); [Foundation: how donations are tracked, 7 Jan 2025](https://godot.foundation/2025/01/07/how-we-calculate-donations/)
  - **Mega Crit** (*Slay the Spire 2*) moved up to Corporate Platinum, about €36K a year, in **Apr 2026**. — [GamingOnLinux, Apr 2026](https://www.gamingonlinux.com/2026/04/godot-gets-a-funding-boost-from-slay-the-spire-2-devs-mega-crit/)
  - **Battlefield Studios** (EA) joined at the same level in **Jun 2026**; that article cites €31,114 a month at the time. — [GamingOnLinux, Jun 2026](https://www.gamingonlinux.com/2026/06/battlefield-studios-begin-sponsoring-godot-engine-development/)
  - **Dated (2024):** 10 contractors cost about $40K a month. — [Godot funding breakdown](https://godotengine.org/article/funding-breakdown-and-hiring-process/)
- **Unreal lifecycle:** UE 5.8 is the last planned UE5 release; UE6 early access is targeted for late 2027 and full release around 2028. — [Epic news](https://www.unrealengine.com/news/unreal-engine-5-8-is-now-available); [Inven Global](https://www.invenglobal.com/articles/24950/next-gen-game-engine-unreal-engine-6-will-bring-a-shift-in-the-development-ecosystem)
- **Unity lifecycle:** Unity 7 beta Dec 2026, release early 2027, framed as an in-place upgrade from Unity 6 ("zero rebuilding"). The Mono to CoreCLR switch is the main migration risk for plugins and native ad SDKs. — [Game Developer](https://www.gamedeveloper.com/programming/unity-unveils-unity-7-roadmap-with-update-path-that-won-t-break-your-build); [Ocean View Games](https://oceanviewgames.co.uk/blog/posts/unity-path-to-coreclr)

### Inferences
- **Overall fit for Danfo (inference, Oct 2026):**

  | Dimension | Godot 4 + Jolt (current spec) | Unity 6.3 LTS / 6.7 LTS | Unreal 5.8 |
  |---|---|---|---|
  | Licence cost | $0, MIT, no thresholds | $0 up to $200K revenue plus funding a year; then $2,310 per seat per year (2026) | $0 up to $1M lifetime gross per product; then 5% (3.5% with simultaneous EGS) |
  | Meets "free tools, no royalties" | Fully | Literally yes (no royalty), but a forced subscription on success and a proprietary EULA | No above $1M gross |
  | Low-end Android reach | GLES3 Compatibility renderer; ARMv7 and arm64 (per 4.4 docs) | Android 7.1 (6.3) or 8.0 (6.5+); GLES 3.1+ or Vulkan; ARMv7 still supported | Android 8+, arm64 only, GLES 3.2 or Vulkan 1.1; 5.8 deferred default aimed at higher-end devices |
  | Empty build size | About 25–60 MB (blogs) | About 6–17 MB (older measurement) | About 42 MB tuned (UE4-era) to 150–300 MB or more |
  | Ad mediation | Official MAX plugin (AppLovin); AdMob and LevelPlay via community | First-party AdMob, MAX and LevelPlay plugins, all actively maintained in 2026 | Official MAX (Fab; no Windows dev host); AdMob rewarded only via paid plugins |
  | Free vehicle physics | VehicleBody3D, Jolt, custom raycast | WheelCollider (PhysX) plus hobby-grade OSS controllers | Chaos Vehicles and Modular Vehicles (no mobile benchmarks) |
  | CI / licence friction | None | `.ulf` plus credentials in CI; personal licences can expire | Heavy toolchain; no licence activation |
  | AI-agent friendliness | Best: text scenes, CLI export | Good: C#, YAML, official MCP (beta, status in flux) | Poor: binary .uasset, editor-bound |
  | Genre and market precedent | Few shipped 3D mobile driving hits | Dominant (more than 70% of top 1,000 mobile games, per Unity's claim) | Rare on low-end mobile |
  | Vendor risk | Donation-funded (about €35K a month) | Repeated unilateral pricing changes, 2023–2026 | Stable terms; UE6 transition around 2027–28 |
- **"Best in class" for this specific game:** if the free-tools constraint is relaxed to "free unless successful", **Unity 6 LTS** is the strongest technical and ecosystem choice for a 3D mobile driving game. It wins on smaller builds, first-party ad SDKs, the most mobile-driving precedent, PAD and Addressables, and C# for AI agents. The price is a proprietary licence, CI licence friction, $2,310 per seat per year after $200K, and documented vendor-trust risk. **Unreal is not best in class for low-end Android with a solo developer.** **Godot remains the only option fully meeting the stated constraint**, and its gap on ads has narrowed with AppLovin's official MAX plugin.

### Gaps
- I found no Godot Foundation 2026 budget or runway report.
- I found no independent analysis of Unity's financial health in 2026 (revenue or layoffs) affecting long-term engine risk; this was not searched due to budget.
