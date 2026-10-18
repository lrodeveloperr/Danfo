# Build Danfo on Godot 4.7.2, Compatibility-First

Under the current free-tools rule, the best way to ship Danfo is **Godot 4.7.2 with GDScript and Jolt**. Android should use the **Compatibility (OpenGL ES 3) renderer** and iOS should use **Metal**. Ads come through the **Poing Studios AdMob plugin v5.1.0**, running AdMob bidding mediation behind Google's UMP consent SDK. Crashes and telemetry go to **Sentry 2.3.0** and **GameAnalytics 3.1.2**. Builds run on free GitHub Actions Linux runners, with a free-tier Mac lane for iOS. Everything is sized for a **3 GB phone with a Helio G85 and Mali-G52 GPU, held at a locked 30 fps, with a first download of 150 MB or less**. The repository spec is right about the engine, the physics foundation and the ad plugin, but three assumptions must change. First, the Mobile (Vulkan) renderer should not be the low-end baseline. Second, Godot cannot deliver "free resumable content downloads", because its Play export packs every asset at install time. Third, "pin later" now has concrete answers: for example, Play has required target API 36 since 31 August 2026, and only Godot 4.6.3 and newer meet that by default. Unity 6 does not fit the constraint as the user framed it. If the user relaxed it to "free unless revenue exceeds $200K a year", I would switch to **Unity 6.3 LTS now, before any game code exists**. Unity retires three risks that Godot cannot fix with plugin work: no Godot 4 3D mobile driving game has shipped, Godot's asset delivery is install-time only, and its ad bridges are community-maintained. Outside dates fix the release calendar: Play's 16 KB page-size block on updates (1 February 2027), Apple's iOS 27 SDK requirement (April 2027), and an expected but unannounced target-API-37 rule (around August 2027). The name needs work before any store listing, because a browser game called **Danfo Run** went viral in Lagos on 26 September 2026 and now leads searches for "danfo game". Figures tagged **[verify]** came from search summaries, third-party pages or the researchers' background knowledge, because primary sites were blocked from the research environment. Re-check those on the live official page before acting on them.

## Godot 4.7.2 stays the foundation, with three spec corrections

The spec's constraint allows free tools only, no new paid plugins and no engine royalties. Godot is the only engine that meets it fully: it is MIT-licensed, has no revenue threshold and needs no licence activation in CI. **Godot 4.7.2 came out on 18 August 2026 and is the current stable release.** Its release notes report "no known incompatibilities" with 4.7.1 and encourage all users to upgrade ([Godot 4.7.2](https://godotengine.org/article/maintenance-release-godot-4-7-2/)). Under Godot's release policy, 4.7 and 4.6 are fully supported, 4.5 gets security and platform fixes only, and 4.8 is due in Q4 2026 ([Godot release policy](https://docs.godotengine.org/en/4.7/about/release_policy.html)). 4.8 reached beta 1 on 15 October 2026. It adds Jolt 5.6.0, decals in the Compatibility renderer and non-allocating physics queries ([4.8 beta 1](https://godotengine.org/article/dev-snapshot-godot-4-8-beta-1/)). The decision is therefore to pin 4.7.2 now. Keep **4.6.3 (20 May 2026)** as the fallback, because it is the oldest release that already targets API 36 ([Godot 4.6.3](https://godotengine.org/article/maintenance-release-godot-4-6-3/)). Move to 4.8 only after its first maintenance release.

The Godot Foundation's mobile record supports the choice and also shows where it stops. After Kamaeru and Rift Riff launched on mobile in December 2025, Foundation contractors fixed Vulkan API misuse and added driver workarounds. Both games' crash rates fell **from about 4% to under 1%** ([Godot mobile update, Apr 2026](https://godotengine.org/article/godot-mobile-update-apr-2026/)). Even so, the official sources the researchers read list **no shipped Godot 4 3D mobile driving or racing game**. The nearest 3D mobile reference is Hazard Days, a shooter ([Godot showcase entry](https://github.com/godotengine/godot-website/blob/master/collections/_showcase/hazard-days-extraction-shooter.md)). Danfo would be an early mover, and the Phase 0 device spike below exists to retire that risk before content production begins.

### The pinned stack

| Layer | Pin | Why |
|---|---|---|
| Engine and export templates | Godot **4.7.2-stable**. Fallback **4.6.3**. Re-evaluate at **4.8.1** | Newest supported stable release. Targets API 36 ([config.gradle @4.7.2](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/android/java/app/config.gradle)) |
| Language | GDScript | Smallest dependency surface. The spec's reason (C# mobile export is experimental) was not re-checked for 4.7 |
| Physics | Built-in Jolt (the default for new 3D projects since 4.6), plus a project-owned `RigidBody3D` bus controller | VehicleBody3D "has known issues and isn't designed to provide realistic 3D vehicle physics" ([VehicleBody3D reference](https://github.com/godotengine/godot/blob/4.7.2-stable/doc/classes/VehicleBody3D.xml)) |
| Android renderer | **Compatibility (GLES3)**, MSAA 2x, baked lightmaps | Godot's own recommendation for older and low-end mobile ([renderers docs](https://docs.godotengine.org/en/4.7/tutorials/rendering/renderers.html)) |
| iOS renderer | Mobile renderer on **Metal**, with the default A12 device floor and a deployment target of **iOS 16.0** | Metal has been the iOS default since 4.4. The docs list iOS 16 for Metal ([system requirements](https://docs.godotengine.org/en/4.7/about/system_requirements.html)) |
| Android toolchain | JDK 17, AGP 8.6.1, Kotlin 2.1.21, compileSdk/targetSdk **36**, minSdk **24**, NDK **29.0.14206865** for custom templates, Gradle build on, AAB output, **arm64-v8a + armeabi-v7a** | Matches the 4.7.2 Gradle config. NDK r28 and later align native libraries for 16 KB pages by default ([16 KB page sizes](https://developer.android.com/guide/practices/page-sizes)) |
| iOS toolchain | **Xcode 26.2 or later** now. **Xcode 27** before April 2027 | Apple's upload rules. The age-assurance APIs need 26.2 ([Apple age assurance](https://developer.apple.com/support/age-assurance/)) |
| Ads and consent | **poingstudios/godot-admob-plugin v5.1.0** (12–13 Sep 2026), using the Google SDK versions that tag declares, plus UMP | The only maintained Godot path that uses Google's preferred Next-Gen Android SDK and SPM on iOS ([Poing releases](https://github.com/poingstudios/godot-admob-plugin/releases)) |
| Crash reporting | **sentry-godot 2.3.0** (29 Sep 2026), plus Play vitals and Xcode Organizer | First-party Sentry GDExtension for Godot 4.5+ ([sentry-godot](https://github.com/getsentry/sentry-godot)) |
| Analytics and remote config | **GA-SDK-GODOT 3.1.2** (6 Oct 2026) | Vendor-maintained, with ad events and remote configs ([GameAnalytics Godot SDK](https://github.com/GameAnalytics/GA-SDK-GODOT)) |
| Tests | **GUT 9.7.1** | Targets Godot 4.7.x. gdUnit4 6.2.x lists support only up to 4.7.1 ([GUT](https://github.com/bitwes/Gut); [gdUnit4](https://github.com/godot-gdunit-labs/gdUnit4)) |
| Store automation | **fastlane 2.241.1** (15 Oct 2026), Ruby 3.2 or later | Actively maintained. Gradle Play Publisher is in maintenance mode ([fastlane version.rb](https://github.com/fastlane/fastlane/blob/master/fastlane/lib/fastlane/version.rb); [GPP](https://github.com/Triple-T/gradle-play-publisher)) |

### Which spec assumptions hold, change or are outdated

| Spec assumption (PRODUCT_SPEC.md and section 10 of research-and-design.md) | Verdict | Evidence |
|---|---|---|
| Godot 4 + GDScript as the free foundation | **Holds** | Pin 4.7.2 specifically, not "Godot 4" |
| Integrated Jolt under a custom controller with raycast suspension | **Holds; refine** | Jolt has been the default since 4.6. Use sphere shape-casts, and keep VehicleBody3D for prototypes only |
| "Mobile renderer; evaluate Compatibility for the lowest devices" | **Changes** | Make Compatibility the Android baseline. A Mobile build defaults to minSdk 29 and silently falls back to GLES3 anyway on devices without Vulkan 1.1 ([export_plugin.cpp](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/android/export/export_plugin.cpp)) |
| Poing AdMob plugin "as a candidate" for Godot 4.5+ | **Holds; now a pin** | v5.1.0 ships Android builds for Godot 4.5.0 through 4.7.2. Test-ad flows still need validating on both platforms |
| Engine, template and plugin versions "pinned after validation" | **Holds, but now time-critical** | The API 36 rule rules out anything older than 4.6.3. Pin at Phase 0, not after content |
| Target API level (not stated) | **Missing** | API 36 is mandatory since 31 Aug 2026. API 37 is expected around Aug 2027 ([target API](https://developer.android.com/google/play/requirements/target-sdk)) |
| "Free resumable content downloads" | **Outdated for Godot** | Godot's AAB export puts every asset in a single install-time pack. OBB support was removed in 4.7. The iOS exporter has no On-Demand Resources or Background Assets options |
| "No unmeasured download-size promise" | **Changes to a measured budget** | First download of 150 MB or less. The engine library alone measures 24 MB compressed per ABI |
| Stable 30 fps on the baseline, 60 fps where supported | **Holds** | Lock 30 fps on low and mid tiers. Offer 60 fps on high-tier phones |
| iOS packaging through the macOS/Xcode lane | **Holds** | Xcode 26 now and Xcode 27 from April 2027. Xcode Cloud includes 25 free hours a month |
| No new paid tools or plugins | **Holds for tools** | Store fees are unavoidable: Play's one-time $25 and Apple's $99 a year. Apple offers no fee waiver to individuals ([Apple fee waivers](https://developer.apple.com/help/account/membership/fee-waivers/)) |
| OSM attribution and database obligations | **Holds; now specific** | A shipped lane graph is an ODbL Derivative Database ([ODbL 1.0](https://opendatacommons.org/licenses/odbl/1-0/)) |
| Settings limited to controls, sound, subtitles and camera comfort | **Needs user approval** | Compliance needs four additions: a privacy-options entry, an in-app privacy-policy link, a report-ad path and a first-launch age screen |
| Ad pacing baseline | **Holds** | It matches Play's "after the score page" interstitial pattern **[verify]** and Apple guideline 2.5.18 |
| Rewards denominated in in-game "naira" | **Needs wording** | AdMob forbids real-money rewards **[verify]**. Label naira as fictional, with no cash value |

### Why Compatibility, not Mobile, is the Android baseline

Godot's documentation still recommends Compatibility for "older or low-end" mobile devices. It says the Mobile renderer can run on low-end hardware "but slower than Compatibility" ([Godot renderers](https://docs.godotengine.org/en/4.7/tutorials/rendering/renderers.html)). On Android, the Mobile renderer uses Vulkan only when a device advertises Vulkan 1.1. On every other device it silently falls back to OpenGL ES 3 ([Godot.kt @4.7.2](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/android/java/lib/src/org/godotengine/godot/Godot.kt)). A Mobile build therefore ships, and must be tested as, two renderers. That fallback does not catch devices that advertise Vulkan but have broken drivers. Nigeria's volume phones run the Mali-G52 MC2, which has documented Vulkan failures: pipeline-creation crashes on the Redmi 14C ([UnleashedRecomp-Android #122](https://github.com/SansNope/UnleashedRecomp-Android/issues/122)), and crashes with Vulkan plus MSAA reported by Unreal developers ([Epic forums](https://forums.unrealengine.com/t/artifacts-and-crashes-on-some-android-gpus-and-versions-when-vulkan-is-enabled/2536208)).

Compatibility has real costs. It gets none of 4.4's ubershaders or pipeline precompilation, and none of 4.5's shader baker, so a warm-up scene that draws every material once is the only defence against shader stutter ([pipeline compilations](https://github.com/godotengine/godot-docs/blob/master/tutorials/performance/pipeline_compilations.rst)). It has no FXAA or SMAA and no decals until 4.8. It computes lighting in sRGB and draws shadowed lights in multiple passes ([lights and shadows](https://github.com/godotengine/godot-docs/blob/master/tutorials/3d/lights_and_shadows.rst)). It renders lightmaps, but they must be baked on hardware that supports Godot's RenderingDevice, such as a desktop GPU.

The art direction should therefore rest on baked lightmaps, vertex colour, simple materials, MSAA 2x and blob shadows from day one. One 4.7 claim needs context: the statement that Vulkan Mobile "matches or even outperforms" Compatibility comes from an XR foveated-rendering benchmark, not from phones ([Godot 4.7](https://godotengine.org/releases/4.7/)).

On iOS, every supported device runs Metal well, so use the Mobile renderer. Set the renderer per OS through Godot's feature-tag project-setting overrides; whether that override applies cleanly at export is one of the Phase 0 checks. If keeping two renderers' lighting looking alike proves expensive, run Compatibility on both platforms. Compatibility does not auto-enable the A12 flag, so that would also bring the iPhone 8 and X back into range. A Mobile-renderer "High" tier on Android should wait for 4.8 and for real crash data.

The asset-delivery assumption fails for a structural reason. Godot 4.7.2 writes every AAB asset into one install-time asset pack. Its exporter has no fast-follow or on-demand options, it dropped OBB support in 4.7 beta 1, and its iOS exporter has no On-Demand Resources or Background Assets options ([export_plugin.cpp](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/android/export/export_plugin.cpp); [4.7 beta 1](https://godotengine.org/article/dev-snapshot-godot-4-7-beta-1/)). Apple has also deprecated On-Demand Resources as of iOS 27 ([Apple ODR limits](https://developer.apple.com/help/app-store-connect/reference/app-uploads/on-demand-resources-size-limits)).

The plan is therefore to launch one district and its race courses entirely as install-time content within the 150 MB budget. Before the second district ships, write a thin Play Asset Delivery on-demand plugin using Godot's v2 Android plugin architecture. Do not self-host downloadable content packs: Danfo has no backend, and Godot's docs warn that loading packs from outside the app is a security risk ([exporting packs](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_pcks.html)).

## Unity 6.3 LTS edges ahead only if the zero-cost rule relaxes

Unity Personal is free and royalty-free, and it has no per-install fee. It is capped at **$200,000 of revenue and funding over the last 12 months**. Above that cap, Unity Pro is mandatory, at **$2,310 per seat per year since 12 January 2026** **[verify]** ([Unity pricing changes](https://unity.com/products/pricing-updates); [80.lv](https://80.lv/articles/unity-announces-its-upcoming-2026-price-changes)). Unity cancelled the Runtime Fee on 12 September 2024 ([Unity blog](https://unity.com/blog/unity-is-canceling-the-runtime-fee)). It has since raised prices twice: Pro by 8% in January 2025 and by 5% in January 2026. In December 2025, an unconfirmed report described a revenue-linked "minimum commitment" for Enterprise customers ([Mobilegamer.biz](https://mobilegamer.biz/unity-risks-fresh-backlash-with-new-fee-demands-this-feels-like-blackmail/)).

The production choice would be **Unity 6.3 LTS**, released on 4 December 2025 and supported until December 2027 ([Unity 6.3 LTS](https://unity.com/blog/unity-6-3-lts-is-now-available)). Unity's non-LTS releases reached end of life within about three months in 2026. Unity 7 is due in beta in December 2026 and for release in early 2027, with a move from Mono to CoreCLR ([Game Developer](https://www.gamedeveloper.com/programming/unity-unveils-unity-7-roadmap-with-update-path-that-won-t-break-your-build)). That makes plugin and native ad-SDK migration a 2027 risk.

Unity's real advantages for Danfo are ecosystem depth on the problems Godot leaves to plugins:

- **Ads:** Google, AppLovin and Unity all ship first-party Unity ad plugins. These are the Google Mobile Ads plugin 11.6.0, MAX 8.6.6 and LevelPlay ([GMA Unity releases](https://github.com/googleads/googleads-mobile-unity/releases); [MAX Unity releases](https://github.com/AppLovin/AppLovin-MAX-Unity-Plugin/releases)).
- **Asset delivery:** Unity integrates Play Asset Delivery out of the box, including fast-follow and on-demand packs ([Unity on Android](https://developer.android.com/games/engines/unity/unity-on-android)).
- **Thermal management:** Google lists Unity, through Adaptive Performance, as supporting its ADPF thermal APIs. Godot is not on that list ([ADPF engine support](https://developer.android.com/games/optimize/adpf/game-engine-support)).
- **Crash and analytics:** Firebase Crashlytics, Analytics and Remote Config ship as first-party packages in the Firebase Unity SDK 14.0.0 ([firebase-unity-sdk](https://github.com/firebase/firebase-unity-sdk/blob/main/docs/readme.md)).
- **Market precedent:** Unity claims more than 70% of the top 1,000 mobile games. This is Unity's own figure ([Unity](https://unity.com/our-company)), and the engines behind the bus-sim leaders were not confirmed from primary sources.

Unity does not fix several things:

- **Low-end rendering:** its headline rendering feature, the GPU Resident Drawer, does not run on OpenGL ES, so the GLES phones that matter in Nigeria fall back to ordinary rendering ([Unity GRD docs](https://docs.unity.com/en-us/engine/6000.6/manual/analysis/graphics-performance-profiling/in-urp/reduce-draw-calls-urp/reduce-rendering-work-on-cpu/gpu-resident-drawer)).
- **Vehicle physics:** this stays custom work, because the well-known controllers are paid assets.
- **Low-end driver bugs:** these affect every engine. Unity's own GLES backend became the top crash bucket for one publisher's Mali users, at 34% of fatal users, until 6000.3.24f1 fixed it ([vkquality #16](https://github.com/android/vkquality/issues/16)).
- **CI:** Unity CI needs a `.ulf` licence file plus account credentials stored as secrets ([GameCI activation](https://game.ci/docs/github/activation/)).

| Area | Godot plan (current constraint) | Unity plan (if relaxed) |
|---|---|---|
| Engine | Godot 4.7.2 | Unity 6.3 LTS, then 6.7 LTS, then Unity 7 in 2027 |
| Minimum Android | API 24 (Android 7.0) | API 25 on 6.3; API 26 on 6.5 and later **[verify]** |
| Low-end renderer | Compatibility (GLES3) | URP Forward on GLES3/Vulkan (GPU Resident Drawer unusable on GLES) |
| Ads | Poing AdMob plugin (community, monthly releases) | First-party GMA, MAX or LevelPlay plugins |
| Asset delivery | Install-time only; custom PAD plugin needed | Addressables plus PAD fast-follow and on-demand |
| Thermal | About 100 lines of custom Android and iOS plugin code | Adaptive Performance |
| Crash and analytics | Sentry plus GameAnalytics | Firebase Crashlytics, Analytics and Remote Config |
| CI | No login; headless CLI export | GameCI with licence and credential secrets |
| AI-agent fit | Text scenes, plain GDScript, single-binary editor | C# (large training corpus), but YAML scenes with GUID references and editor-bound work |
| iOS privacy manifest | Hand-authored in Godot's export options | UnityFramework ships its own |
| Licence | MIT, no threshold | Free up to $200K revenue plus funding per 12 months, then $2,310 per seat per year **[verify]** |

**What would change if the user relaxed the constraint:** I would recommend Unity 6.3 LTS, and I would make the switch during Phase 0, while the repository still holds only a spec. Godot's ad, delivery and thermal gaps are each plugin-sized. Its lack of any shipped 3D mobile driving title is not, and Unity's maturity on low-end Android is the cheapest insurance against it.

Device targets, budgets, the consent stack, compliance, saves and the release plan below stay the same either way.

Two caveats temper the switch:

- **The $200K threshold rarely binds on revenue alone.** At the notes' illustrative Nigerian figure of $0.0006–0.012 ad revenue per daily active user, $200K a year needs roughly **46,000 to 910,000 daily players**. That is arithmetic on illustrative inputs, not a forecast.
- **Unity counts funding as well as revenue.** A pre-seed round like the $500K raised by the makers of Lagos Life ([Condia](https://thecondia.com/vatar-lagos-life-raises-500000-pre-seed)) would end Personal eligibility immediately. The user's "revenue exceeds $200K" wording is not Unity's test.

Unreal and the smaller engines lose under either version of the constraint:

- **Unreal Engine 5.8** charges 5% of gross revenue above $1M ([Unreal EULA](https://www.unrealengine.com/eula/unreal)). It is the last planned UE5 release ([Epic](https://www.unrealengine.com/news/unreal-engine-5-8-is-now-available)). It requires Android 8, a 64-bit CPU and OpenGL ES 3.2 or Vulkan 1.1 ([Epic Android requirements](https://dev.epicgames.com/documentation/en-us/unreal-engine/android-development-requirements-for-unreal-engine)), and its binary assets defeat text-based review.
- **Defold, Cocos, Bevy and Flax** all lack either the 3D maturity or the mobile track record of Godot.

## A 3 GB Helio G85 phone sets every budget

Nigeria is about **83–85% Android** by mobile page views; StatCounter's June 2026 split is 82.67% Android to 17.16% iOS ([StatCounter](https://gs.statcounter.com/os-market-share/mobile/nigeria)). **Android 10 or later covers at least 80.7%** of Nigerian Android page views ([StatCounter Android versions](https://gs.statcounter.com/android-version-market-share/mobile-tablet/nigeria)). Transsion's three brands (Tecno, Infinix and itel) hold about half the market. The 2025–26 volume models cluster on the **MediaTek Helio G81/G85 with a Mali-G52 MC2 GPU and 4 GB of physical RAM**, often sold as "4+4 GB" with storage-backed virtual RAM ([GSMArena Redmi 14C](https://www.gsmarena.com/redmi_14c_debuts_with_helio_g81_ultra_chipset_120_hz_lcd-news-64349.php); [TechCabal phone prices](https://techcabal.com/2026/05/28/cheapest-phones-in-nigeria-and-their-prices/)).

Omdia forecasts Africa's smartphone shipments to fall 26% in 2026, with the sub-$100 segment down 34% as memory costs climb ([Omdia](https://omdia.tech.informa.com/om146997/africas-smartphone-market-is-expected-to-decline-26-in-2026-following-the-first-contraction-in-three-years)). The installed base will therefore age rather than improve. All device and market figures here come from search snippets of StatCounter, GSMArena and similar pages **[verify]**.

| Tier | Representative devices | Settings | Frame rate |
|---|---|---|---|
| Floor (Low, must run) | Galaxy A06 (Helio G85), Redmi 14C/15C and Tecno Spark 40 4G (Helio G81), Infinix Hot 60i; Mali-G52 MC2; 3–4 GB | Compatibility, render scale about 0.7, blob shadows only, ≤12 physics-active traffic vehicles | 30 locked |
| Target (Mid) | Galaxy A07 4G (Helio G99, Mali-G57 MC2), Spark 40 5G (Dimensity 6400); 4–8 GB | Compatibility, render scale 0.8–1.0, one shadow cascade on the player bus only | 30 at higher quality, 60 optional |
| High | Dimensity 7020, Exynos 1330 (Mali-G68 MP2) and up; iPhone XR and newer | Full preset; MetalFX optional on iOS | 60, dropping to 30 under thermal stress |
| Stretch (best effort) | itel A50 and Redmi A5 (Unisoc T603/T7250), Helio G35/G37 (PowerVR GE8320); 2–3 GB, Android Go | Excluded from the Play device catalogue at launch; reconsider after soft-launch vitals | — |

Ship **both arm64-v8a and armeabi-v7a**. Android's compatibility rules "strongly recommend" a 32-bit-only userspace on devices with 2 GB to under 4 GB of memory ([Android 16 CDD](https://source.android.com/docs/compatibility/16/android-16-cdd)). The cheapest 3 GB phones may therefore be unable to install an arm64-only app. Because AAB delivery splits by ABI, the 32-bit library adds nothing to an arm64 user's download. Godot 4.7.2 still exports armeabi-v7a, but enables only arm64 by default ([export_plugin.cpp](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/android/export/export_plugin.cpp)). One developer reports 9–10% of their users on armeabi-v7a ([LiteRT #3926](https://github.com/google-ai-edge/LiteRT/issues/3926)).

Keep **minSdk 24**, Godot's default for a Compatibility project. It matches Bus Simulator Indonesia's Android 7.0 floor, and the play-time limits come from the RAM-based tiers rather than the OS version. On iOS, the default A12 floor drops the iPhone 8 and X. That costs the iOS 15.8 and 16.7 users, about 13% of Nigerian iOS page views and roughly 2% of all Nigerian mobile users ([StatCounter iOS versions](https://gs.statcounter.com/ios-version-market-share/all/nigeria)). That trade is worth the simpler Metal path.

### Budgets to enforce from the first build

| Budget | Low tier | Mid tier | High tier and iPhone |
|---|---|---|---|
| Sustained frame time, measured after minute 10 of a 30-minute run | P95 ≤ 33.3 ms, under 5% of frames over 34 ms | Same at 30 fps; P95 ≤ 16.7 ms at 60 fps | P95 ≤ 16.7 ms |
| GPU time | About 70% of the 33 ms frame, for thermal headroom | Same | — |
| Draw calls per frame | ≤ 150 | ≤ 300 | ≤ 300 |
| On-screen triangles | 100–200k | 300–500k | 300–500k |
| Process memory (resident) | ≤ 800 MB on 3 GB phones; ≤ 1.1 GB on 4 GB phones | ≤ 1.2 GB | — |
| GPU texture memory | ≤ 200 MB | Measure | Measure |
| Physics | Fixed 60 Hz with interpolation on every tier | Same | Same |
| Traffic | ≤ 12 physics-active cars plus 40–80 MultiMesh cars | ≤ 20 active | ≤ 20 active |
| Cold start to menu / menu to drivable | ≤ 15 s / ≤ 5 s on a Helio G85 | — | — |
| First download | ≤ 150 MB per device on Play (stretch goal 100 MB) | — | iOS ≤ 200 MB **[verify cellular-download prompt limit]** |
| Installed footprint | ≤ 400 MB including saves and caches | — | — |
| Crash and ANR rates (internal gate) | ≤ 0.5% crash and ≤ 0.25% ANR; no device model above 4% | Same | Same |

The draw-call, triangle, memory and load-time values are engineering proposals, not vendor figures. They sit well inside Arm's guidance of fewer than 500 draw calls per frame on OpenGL ES ([Arm draw-call guidance](https://support.arm.com/documentation/101897/0304/Optimizing-application-logic/Draw-call-batching-best-practices)) **[verify]**, because Godot's Mobile and Compatibility renderers do no automatic instancing. Android's games guidance says games use between a quarter and a half of physical RAM **[verify]**; the 800 MB cap takes the low end of that range because "4+4 GB" phones swap to slow storage.

The crash and ANR gates are set at half of Play's bad-behaviour thresholds: a 1.09% user-perceived crash rate, a 0.47% ANR rate, and 8% on any single phone model. Exceeding those can reduce store visibility and add a warning to the listing ([Android vitals](https://developer.android.com/topic/performance/vitals)). The 30-minute frame-time test follows Play's slow-session rule: a session is slow when more than 25% of its frames take longer than 50 ms, and Play says it "will start steering users away from games that cannot achieve 20 FPS" ([slow sessions](https://developer.android.com/google/play/vitals/slow-session)).

Download size is a first-order acquisition cost here:

- **Data is expensive.** Nigerians paid an average of **₦575 per GB** in 2025 ([TechCabal](https://techcabal.com/2026/02/09/how-nigerians-spent-%E2%82%A620-87billion-daily-on-data-in-2025/)), so every 100 MB costs a player about ₦58.
- **Larger downloads convert worse.** Google's own (2017) analysis found install conversion falls about 1% for every 6 MB, more steeply in emerging markets ([Google Play](https://medium.com/googleplaydev/shrinking-apks-growing-installs-5d3fcba23ce2)).
- **Godot's engine is a fixed cost.** The 4.7.2 arm64 library measures **71 MB uncompressed and 24 MB compressed** before any game content ([Maven Central artefact](https://repo1.maven.org/maven2/org/godotengine/godot/4.7.2.stable/)).
- **Genre peers bracket the target.** Bus Simulator Indonesia's roughly 460 MB is the genre's ceiling, not a target ([APKMirror](https://www.apkmirror.com/?p=8010707)). Dr. Driving reached an estimated 690 million installs at 11–14 MB ([AppGoblin](https://www.appgoblin.info/apps/com.ansangha.drdriving)) **[verify]**.

Build custom export templates in Phase 0. Use Godot's build profile, remove GodotPhysics3D (Jolt replaces it), CSG and other unused modules, and turn on link-time optimisation ([optimizing for size](https://docs.godotengine.org/en/4.7/engine_details/development/compiling/optimizing_for_size.html)). Measure before trading runtime speed for size with `optimize=size`. These are the same templates Sentry needs for readable native stack traces, so the effort serves two purposes.

### Rendering, physics and streaming architecture

On the rendering side:

- **Lighting:** bake lightmaps per city cell. Use at most one dynamic sun, with a real shadow only on the player's bus, and blob quads under every other vehicle and pedestrian.
- **Textures:** import opaque city textures as ETC2. ETC2 RGB uses 4 bits per pixel, half the size of Godot's fixed 4×4 ASTC, which suits 3 GB phones. Keep ASTC for the danfo livery, signage with alpha and UI. Google recommends ASTC first with ETC2 as the fallback ([Android texture guidance](https://developer.android.com/games/optimize/textures)).
- **Batching:** draw repeated props with MultiMesh plus visibility ranges, because automatic instancing works only in Forward+ ([optimizing 3D](https://github.com/godotengine/godot-docs/blob/master/tutorials/performance/optimizing_3d_performance.rst)).
- **Occlusion culling:** treat it as a profiling experiment, not a default. It costs CPU, and Godot notes that open scenes gain more from LOD.

For the city itself, stream **200–250 m cells** with `ResourceLoader.load_threaded_request`. Keep the playable map within single-precision limits: Godot's docs steer low-end mobile away from double precision and towards origin shifting ([large world coordinates](https://docs.godotengine.org/en/4.7/tutorials/physics/large_world_coordinates.html)). Shift the world back to the origin whenever the player drives more than 1–2 km from it.

Build the bus as a `RigidBody3D` of about 2,500–3,500 kg with four sphere shape-casts for suspension. Model tyre grip with piecewise-linear curves of the kind Jolt's own vehicle controller uses: peak lateral grip of 1.2 at about 3° of slip, falling to 1.0 ([Jolt WheeledVehicleController](https://github.com/jrouwe/JoltPhysics/blob/master/Jolt/Physics/Vehicle/WheeledVehicleController.h)). Give buses convex colliders. Resolve bus-to-bus contact with scripted, clamped shove impulses that have a per-pair cooldown, and turn on continuous collision detection for racers only. The spec's "sticking, clipping or explosive impulses" requirement depends on that discipline.

Godot physics "is **not** deterministic" ([physics introduction](https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html)). The spec's personal ghost must therefore record transforms, not replay inputs.

Traffic follows a lane graph derived from OpenStreetMap. The MIT-licensed Godot Road Generator produces lane paths automatically ([godot-road-generator](https://github.com/TheDuckCow/godot-road-generator)). Only nearby cars are physics-capable. Waiting crowds are vertex-animated MultiMesh instances, and only the two to six passengers actually boarding become skinned characters.

**Godot ships Android frame pacing (Swappy) on by default, but has no thermal or ADPF API in core.** A grep of the engine source found none ([Godot Android platform source](https://github.com/godotengine/godot/tree/master/platform/android)). Danfo therefore needs a small Android plugin that reads `getThermalHeadroom` no more than once every 10 seconds ([ADPF thermal](https://developer.android.com/games/optimize/adpf/thermal)), and an iOS counterpart for `thermalState`. Apple advises dropping from 60 to 30 fps at `.serious` ([Apple thermal state](https://developer.apple.com/documentation/foundation/processinfo/thermalstate-swift.enum/serious)). The quality governor steps down in a fixed order: render scale, then shadows and LOD distance, then ambient density, then frame rate. It never touches the physics rate.

The thermal headroom API exists only from Android 11 onward, so older devices fall back to frame-time telemetry. Nigeria's power grid collapsed several times in 2026 ([Guardian Nigeria](https://guardian.ng/news/national-grid-suffers-first-collapse-of-2026-generation-falls-to-zero/)), and battery is scarce, so the 30 fps lock is a player-welfare decision as much as a technical one.

**Device tiering** combines three signals: a static lookup of RAM and GPU name, a 10–15-second benchmark scene at first launch, and a manual override. **Controls** default to auto-accelerate with buttons or a slider, with tilt and an on-screen wheel as options. Players split between tilt and buttons, and dropping someone's preferred scheme loses them ([TouchArcade thread](https://toucharcade.com/community/threads/how-do-you-prefer-to-steer-in-a-car-game.173404/)). **Profiling** uses free tools: Arm Performance Studio 2026.5 now has an official Godot integration ([Arm Learning Path](https://learn.arm.com/learning-paths/mobile-graphics-and-gaming/godot_packages/)).

## AdMob bidding behind UMP and an age screen pays the bills

Danfo's mediation choice should follow integration risk, because no published comparison shows any mediator earning more in Nigeria. MAX ran 73.2% of top-200 ad-monetised games in March 2025, but the same analysis says "there is no public data" on overall share ([GameBiz Consulting](https://www.gamebizconsulting.com/newsletter/newsletter-may25)).

The **Poing Studios godot-admob-plugin v5.1.0** fits that test:

- It uses the GMA Next-Gen Android SDK, which Google made its preferred Android SDK on 6 July 2026 ([PPC Land](https://ppc.land/google-forces-android-developers-off-legacy-mobile-ads-sdk-by-2028/)) **[verify]**.
- It uses Swift Package Manager on iOS.
- It ships adapters for 19 mediation partners, UMP with a privacy-options form, impression-level revenue callbacks and an R8 code-shrinking switch ([Poing releases](https://github.com/poingstudios/godot-admob-plugin/releases)).
- Its main risk is that a single small team maintains it, so pin the version and re-test the plugin's template matrix on every Godot upgrade.

**AppLovin's official MAX Godot plugin is not a production path.** Its last release, 1.2.0, came on 24 April 2025 ([tags](https://github.com/AppLovin/AppLovin-MAX-Godot/tags)). Bugs about iOS initialisation and Xcode build failures on Godot 4.4 and 4.5 are still open ([issues](https://github.com/AppLovin/AppLovin-MAX-Godot/issues)). Its setup floats the SDK to the latest version and needs CocoaPods ([README](https://github.com/AppLovin/AppLovin-MAX-Godot/blob/master/README.md)). AppLovin's demand can still reach Danfo through its adapter inside AdMob mediation.

Start with **AdMob plus five or six bidders**: AppLovin, Unity Ads/ironSource, Mintegral, Pangle and Liftoff, plus one of Meta, InMobi or Moloco. Every adapter adds size and crash surface, so prune any network that wins under about 2–3% of impressions or shows up in crash clusters. Whether AppLovin bids, rather than only filling a waterfall, inside AdMob in October 2026 is unconfirmed **[verify]**. Poing's mediation guide sets three rules: wait for `MobileAds.initialize` to finish before loading so every bidder joins the first auction, set reward values with "Apply to all networks", and add every partner to AdMob's Privacy & messaging ad-partner lists ([Poing mediation guide](https://github.com/poingstudios/godot-admob-plugin/blob/master/docs/mediate/get_started.md)).

The runtime ad flow follows the spec's "one request in flight, grant exactly once" rule:

1. Run the UMP consent check at launch.
2. Initialise the ad SDK after the first frame, with Poing's background-thread optimisation left on ([Poing initialisation](https://github.com/poingstudios/godot-admob-plugin/blob/master/docs/optimize_initialization.md)).
3. Preload one interstitial and one rewarded ad.
4. At a results screen, show the interstitial only if it is already loaded and Danfo's pacing counters pass. Otherwise skip it silently.
5. Before showing a rewarded ad, write a pending-reward record with a transaction ID. Grant the reward once, on the earned-reward callback, and reconcile on the next launch if the app was killed mid-ad.
6. Give each ad load about 8–10 seconds, and retry failed loads with back-off.

Create no app-open, banner or rewarded-interstitial units. Grant rewards on the device rather than through server-side verification, because server verification needs the backend the spec rules out.

### Consent stack

**Consent goes through Google's UMP on both platforms.** AdMob has required a Google-certified, IAB-TCF consent management platform for personalised ads in the EEA and UK since 16 January 2024, and in Switzerland since 31 July 2024 ([AdMob Help](https://support.google.com/admob/answer/13554020?hl=en)) **[verify]**. TCF v2.3 strings became mandatory on 28 February 2026, and Google's own CMP writes them automatically ([IAB Europe](https://iabeurope.eu/all-you-need-to-know-about-the-transition-to-tcf-v2-3/)). Call UMP's `update()` on every launch ([UMP flow, Google doc mirrored in Poing repo](https://github.com/poingstudios/godot-admob-plugin/blob/master/docs/privacy/user_messaging_tools/get_started.md)), skip ads silently when offline, and never block play on the form.

On iOS, show UMP's IDFA explainer and then the system App Tracking Transparency (ATT) prompt after the first completed event, never at launch, and never with an incentive. Adjust measured **39% ATT opt-in among gaming users shown the prompt in Q1 2026** ([Adjust](https://www.adjust.com/blog/att-opt-in-rates-2025)). Apple guideline 5.1.2(i) forbids conditioning rewards on tracking ([App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)). Nigerian iPhones are a minority, but the UK and US diaspora are where ATT opt-ins pay.

### Age routing

Declare a **13+ target audience** in Play Console and stay out of Families. The Families Self-Certified Ads SDK programme "is currently not accepting new applicants" ([Play Console Help](https://support.google.com/googleplay/android-developer/answer/12955712?hl=en)) **[verify]**, so a child audience would strip most of the mediation stack.

Still ship a **neutral age screen** at first launch: a year-of-birth picker with no default and no hint about the required age. It only routes ad treatment:

- **Under 13:** child-directed treatment through Google's 2026 `AgeRestrictedTreatment` setting, which replaces the deprecated child-directed and under-age-of-consent tags ([GMA Unity releases](https://github.com/googleads/googleads-mobile-unity/releases)), with no UMP or ATT.
- **13–17:** non-personalised ads, because Nigeria's NDPA defines a child as anyone under 18 ([Mondaq](https://www.mondaq.com/nigeria/data-protection/1366934/the-nigerias-data-protection-act-2023-a-look-at-key-provisions)).
- **18 and over:** the normal UMP and ATT flow.

Store the age on the device only. That pattern matches the FTC's 25 February 2026 statement limiting enforcement when general-audience services collect age solely for verification. The amended COPPA rule became fully enforceable on 22 April 2026 ([Finnegan](https://www.finnegan.com/en/insights/articles/coppas-amended-rule-is-now-in-full-effect-what-operators-need-to-know.html); [Federal Register](https://www.federalregister.gov/documents/2025/04/22/2025-05904/childrens-online-privacy-protection-rule)).

Set `max_ad_content_rating` to T. Block gambling and betting ad categories at launch, even though betting advertisers are a meaningful source of Nigerian demand ([Games Industry Africa](https://gamesindustryafrica.com/2025/06/02/nigerian-developer-shares-mobile-revenue-strategy/)): the audience includes teenagers, and the fill cost can be measured later.

### Nigerian data protection

Nigeria's **GAID 2025 took effect on 19 September 2025** and applies to anyone who targets Nigerian data subjects, wherever they are based ([NDPC GAID](https://ndpc.gov.ng/wp-content/uploads/2025/07/NDP-ACT-GAID-2025-MARCH-20TH.pdf)) **[verify]**. The embedded ad SDKs collect advertising IDs and IP addresses on the publisher's behalf, so Danfo's publisher is likely a data controller even with no servers. Minimum compliance looks like this:

- **Privacy notice:** a public privacy policy that names the ad partners.
- **Consent:** a consent message for personalised ads that covers Nigeria, or non-personalised ads by default in Nigeria.
- **Registration:** monitoring Nigerian user counts against the NDPC registration thresholds.

The thresholds conflict between sources: secondary sources cite 200 data subjects in six months, while the GAID text refers to "a number set by the Commission" ([Mondaq GAID](https://www.mondaq.com/nigeria/data-protection/1684204/unlocking-gaid-2025-answers-to-all-your-burning-questions)). A Nigerian data-protection lawyer has to settle this.

### Policy fit and paperwork

The spec's pacing already follows the pattern Play explicitly allows: interstitials only on saved results screens, never at launch, mid-drive, on pause or on exit ([Play ads policy](https://support.google.com/googleplay/android-developer/answer/9857753)) **[verify]**. The rest is paperwork and four small UI items:

- **Apple guideline 2.5.18** requires apps with ads to let users "report any inappropriate or age-inappropriate ads".
- **Apple guideline 5.1.1(i)** requires a privacy-policy link inside the app as well as in App Store Connect ([App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)).
- **UMP** requires a privacy-options entry point when one applies **[verify]**.
- **Reward copy** must call naira a fictional in-game currency with no cash value, because AdMob prohibits real-world-value rewards ([AdMob rewarded policy](https://support.google.com/admob/answer/7313578)) **[verify]**.

These four items, plus the age screen, touch the spec's tightly governed Settings and onboarding scope, so they need the user's explicit approval.

**Host the privacy policy and `app-ads.txt` on a free GitHub Pages user site.** A `<user>.github.io` site is its own registrable domain; a project-page path will not work. AdMob's crawler behaviour on that domain must be confirmed **[verify]**.

**Data safety cannot say "no data collected".** The Google Mobile Ads SDK collects IP address, product interactions, diagnostics and device IDs ([Google data disclosure, Poing mirror](https://github.com/poingstudios/godot-admob-plugin/blob/master/docs/privacy/store_data_disclosure/google_play_data_disclosure.md)), and Sentry and GameAnalytics add their own entries. On iOS, Apple counts an ad SDK that combines data across apps as **tracking** "even if you don't use the SDK for these purposes" ([Apple app privacy details](https://developer.apple.com/app-store/app-privacy-details/)).

**Revenue expectations should stay modest.** The only Nigeria figure is a vendor's blended CPM of **$0.25–0.80** ([MonetizeMore](https://www.monetizemore.com/blog/how-much-ad-revenue-can-apps-generate/)) **[verify]**, and Carry1st found that many ad networks "aren't yet focused on targeting the African market" ([AppsFlyer case study](https://www.appsflyer.com/zh-hans/customers/carry1st/)). Diaspora and tier-1 players will be worth 10–30 times more per impression. In-world brand billboards, the model that funds Lagos Life, would be a material monetization change under the spec and need the user's approval.

## Free CI, tests and telemetry, with one Mac-shaped exception

| Stage | Trigger | Where it runs | What it does |
|---|---|---|---|
| Validate | Every push and pull request | GitHub Actions `ubuntu-latest` | Godot 4.7.2 headless import (catches broken references), GUT tests, asset-licence register check |
| Android debug build | Pull request | Linux | `godot --headless --export-debug` to an APK |
| Android release | Version tag | Linux | Export the AAB with custom templates; signing keys from `GODOT_ANDROID_KEYSTORE_RELEASE_*` secrets; 16 KB alignment checks; size-budget gate; Sentry symbol upload; fastlane `supply` to the internal track |
| iOS release | Version tag | Xcode Cloud (25 hours a month included) or Codemagic (500 free M2 minutes a month **[verify]**) | Godot exports the Xcode project on the Mac (`export_project_only`); fastlane `match`, `gym` and `pilot` to TestFlight, using an App Store Connect API key |
| Device smoke test | Nightly | Firebase Test Lab free tier (10 virtual and 5 physical runs a day **[verify]**) | Game Loop run of a scripted demo drive |
| Sustained performance | Each milestone | Physical device lab | 30-minute scripted route-plus-race loop, logging frame times and thermals |

For a private repository, GitHub Free includes **2,000 Linux minutes a month**. Beyond that, Linux costs $0.006 a minute and macOS $0.062, about ten times more, so run Mac jobs on release tags only ([GitHub Actions billing](https://docs.github.com/en/billing/concepts/product-billing/github-actions); [runner pricing](https://docs.github.com/en/billing/reference/actions-runner-pricing)). GitHub announced a fee for self-hosted runners for March 2026, then postponed it; current docs still list self-hosted runners as free.

Godot can export Android headlessly from the command line ([command line](https://docs.godotengine.org/en/4.7/tutorials/editor/command_line_tutorial.html)), and reads the release keystore from environment variables at export ([exporting for Android](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html)). The barichello/godot-ci image has a 4.7.2 tag, but it installs Android platform 33 and NDK r25 ([godot-ci Dockerfile](https://github.com/abarichello/godot-ci/blob/master/Dockerfile)), so add the API 36 platform in CI.

iOS still needs a Mac: Godot's docs require macOS with Xcode for iOS export ([exporting for iOS](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_ios.html)). **Xcode Cloud's 25 included compute hours** come with the Apple Developer Program ([Xcode Cloud](https://developer.apple.com/xcode-cloud/)). Its build scripts must live in `ci_scripts` beside the Xcode project. Whether the first Xcode Cloud workflow can be created without a Mac is unverified, so plan for one-time Mac access.

fastlane `supply` handles Play tracks and staged rollouts, but **the first AAB must be uploaded by hand** in Play Console ([fastlane supply](https://docs.fastlane.tools/actions/supply/)). On the free plan, Git LFS includes **10 GiB of storage and 10 GiB of bandwidth a month**, and CI checkouts count against that bandwidth ([Git LFS billing](https://docs.github.com/en/billing/concepts/product-billing/git-lfs)). Set a $0 budget, cache LFS objects in CI, keep raw `.blend` and audio masters out of the repository, and keep the spec's source and licence register as a CSV that CI enforces.

For AI-agent work, commit Godot's `.uid` files and re-save scenes in the pinned editor. 4.6 added unique node IDs to scene files ([UID changes](https://godotengine.org/article/uid-changes-coming-to-godot-4-4/); [Godot 4.6](https://godotengine.org/releases/4.6/)).

### Testing beyond CI

Testing has four layers on top of the CI stages:

- **Unit tests.** Pure-logic GUT tests cover fares, the economy, pacing counters and save migrations.
- **Replay tests.** Recorded touch inputs are replayed headless with `--fixed-fps`, and the test asserts game invariants within tolerances. Because physics is not deterministic, it never compares positions bit for bit.
- **Device lab.** The minimum set is a Galaxy A06, a Galaxy A07 4G, an itel A50 or Redmi A5 (to check the stretch tier and the device-catalogue exclusion) and an iPhone XR. Add a Redmi 14C, a PowerVR GE8320 phone and one Adreno 610/619 device when possible. These are hardware purchases, not tools.
- **Human playtests.** The spec requires repeated-session human testing, because automated checks are "not evidence of fun".

TestFlight allows 100 internal and 10,000 external testers. The first external build needs App Review ([TestFlight](https://developer.apple.com/testflight/)).

### Saves, crash reporting and analytics

Saves must survive power cuts and need no account:

- **Writes:** write to a temporary file, flush it, verify its SHA-256, keep two or three backup generations, then rename it into place ([FileAccess](https://docs.godotengine.org/en/stable/classes/class_fileaccess.html)).
- **Format:** use a versioned schema with step-by-step migrations, tested against golden saves from every shipped version.
- **Size:** keep save files well under 1 MB.

Free cloud backup needs no account:

- **Android:** setting Godot's `user_data_backup/allow` option turns on Auto Backup, which keeps up to 25 MB per app in the user's Google Drive and restores it automatically on reinstall ([Auto Backup](https://developer.android.com/identity/data/autobackup); [Godot Android export options](https://docs.godotengine.org/en/stable/classes/class_editorexportplatformandroid.html)). Verify with `bmgr` that Godot's `user://` directory is included.
- **iOS:** device backup covers app data. The official Godot iCloud plugin wraps the 1 MB iCloud key-value store if a sync option is wanted ([godot-ios-plugins](https://github.com/godot-sdk-integrations/godot-ios-plugins); [NSUbiquitousKeyValueStore](https://developer.apple.com/documentation/foundation/nsubiquitouskeyvaluestore)).
- **Moving between Android and iOS:** no backend-free first-party service does this. A checksummed transfer code that players can paste through WhatsApp is the zero-backend answer.

For crashes, use **Sentry for Godot 2.3.0**. Its official templates carry no debug information, so custom templates built with `debug_symbols=yes` are needed for readable native stacks ([Sentry readable stack traces](https://docs.sentry.io/platforms/godot/configuration/stack-traces/)). Sentry's free Developer plan reportedly covers 5,000 errors a month for one user ([struct.ai](https://blog.struct.ai/sentry-pricing-error-monitoring-2026/)) **[verify]**. Alongside it, Play vitals ingests Godot's official native symbols ([Godot mobile update](https://godotengine.org/article/godot-mobile-update-apr-2026/)). For analytics, **GameAnalytics** covers sessions, progression, ad events and remote configs on Godot 4.5 and later. Its free-tier terms were not checked **[verify]**. Remote config may tune ad pacing only inside the ranges the user has approved, because the spec reserves material monetization changes for the user.

## Store deadlines set the release calendar

| Date | Store or authority | Requirement | Danfo action | Status (18 Oct 2026) |
|---|---|---|---|---|
| 1 May 2024 | Apple | Approved reasons for required-reason APIs, including those in SDKs | Fill Godot's `privacy/*` export options; rely on the ad SDKs' own manifests | In force ([Apple upcoming requirements](https://developer.apple.com/news/upcoming-requirements/)) |
| 16 Jan 2024; 31 Jul 2024 | AdMob | Certified TCF consent platform for personalised ads in the EEA/UK, then Switzerland | UMP | In force **[verify]** |
| 17 Feb 2025 | Apple (EU) | Trader status declared, or the app is removed from EU storefronts | Exclude the EU at launch, or publish an address, phone and email as a trader ([Apple DSA](https://developer.apple.com/help/app-store-connect/manage-compliance-information/manage-european-union-digital-services-act-trader-requirements)) | In force |
| 19 Sep 2025 | Nigeria (NDPC) | GAID 2025 effective | Privacy policy, consent, under-18 handling, registration monitoring | In force **[verify, legal]** |
| 31 Jan 2026 | Apple | New age-rating questionnaire (4+, 9+, 13+, 16+, 18+) | Answer Advertising = yes and no loot boxes. Ads are allowed at 4+ but map to A12 in Brazil ([Apple age ratings](https://developer.apple.com/help/app-store-connect/reference/app-information/age-ratings-values-and-definitions)) | In force |
| 28 Feb 2026 | IAB Europe | TCF v2.3 mandatory | UMP writes it automatically | In force |
| 1 Mar 2026 | Play | Enforcement against excessive partial wake locks | Hold none; audit the SDKs | In force **[verify]** |
| 22 Apr 2026 | US FTC | Amended COPPA rule fully enforceable | 13+ audience plus neutral age screen | In force |
| 28 Apr 2026 | Apple | Builds must use Xcode 26 and the iOS 26 SDK | Xcode 26.2 or later | In force |
| 6 May, 4 Jun, 1 Jul 2026 | Apple and Play | Age assurance in Utah, Texas and Louisiana | Low exposure (no purchases, no accounts); consider Declared Age Range | In force ([Apple Texas notice](https://developer.apple.com/news/?id=sg176nne)) |
| 31 Aug 2026 (extensions to 1 Nov 2026) | Play | New apps and updates must target API 36 | Godot 4.7.2 default; handle forced edge-to-edge insets and predictive back | In force ([target API](https://developer.android.com/google/play/requirements/target-sdk); [Android 16 changes](https://developer.android.com/about/versions/16/behavior-changes-16)) |
| 9 Sep 2026 | Apple | Deployment target iOS 13 or later | iOS 16.0 | In force |
| 16 Oct 2026 | Apple | Guidelines revised (new 2.3.14 and 2.5.19) | No hidden or dormant features | In force ([Apple news](https://developer.apple.com/news/?id=92th7e5i)) |
| 1 Feb 2027 | Play | Updates without 16 KB page-size support are blocked | Alignment checks in CI on every AAB, including ad adapters | Upcoming ([16 KB page sizes](https://developer.android.com/guide/practices/page-sizes)) |
| Feb 2027 | Play | Store visibility starts to depend on memory, bitmap-memory and code-optimisation thresholds (games: 2.25 GB foreground on 4 GB phones) | Stay inside the memory budgets; enable R8 | Upcoming ([Android vitals](https://developer.android.com/topic/performance/vitals)) |
| April 2027 | Apple | Builds must use the iOS 27 SDK | Move CI to Xcode 27; confirm Godot and plugin support **[verify]** | Upcoming ([Apple news](https://developer.apple.com/news/?id=k1mtkt1k)) |
| iOS 27.2 | Apple (EU) | Alternative ATT prompt; mandatory in DE, FR, IT, PL and RO | Only relevant if Danfo ships in the EU | Upcoming ([Apple news](https://developer.apple.com/news/?id=idsft9ai)) |
| 2027 | Android | Developer verification goes global, including Nigeria | Play registers developers automatically; it matters for sideloaded stores such as Transsion's Palm Store | Upcoming ([developer verification](https://developer.android.com/developer-verification)) |
| ~Aug 2027 | Play | Target API 37 | Plan a Godot upgrade; `appCategory="game"` keeps the large-screen orientation exemption | **Unannounced [verify]** |
| No fixed date | Play | Data safety, "Contains ads", Advertising ID, target audience, IARC rating, privacy-policy URL, financial features = none | Complete before the first production release | **[verify on Play Console Help]** |
| No fixed date | Play | New personal accounts (created after 13 Nov 2023) need a closed test with 12 or more testers opted in for 14 consecutive days | Recruit 20–30 testers | **[verify]** ([Play Console Help 14151465](https://support.google.com/googleplay/android-developer/answer/14151465)) |

| Phase | Window (planning assumption) | Work | Exit gate |
|---|---|---|---|
| 0. Foundations and spikes | 20 Oct to 18 Dec 2026 | Open the accounts ($25 Play personal account; $99 a year Apple); run the name and trademark search; brief a privacy lawyer; publish the privacy site and `app-ads.txt`; pin the toolchain and build CI. Spikes: Compatibility versus Mobile renderer on the device lab; bus-feel prototype; Poing test ads, UMP and ATT on both OSes; measure the size of an empty 3D export, with and without custom templates; symbolicated test crash in Sentry; Auto Backup restore | Low tier holds the P95 frame-time budget for 30 minutes on a dense street; no renderer crashes across the lab; test interstitial and rewarded flows pass on Android and iOS; **final engine decision (any switch to Unity happens here or not at all)** |
| 1. Vertical slice | Jan to Apr 2027 | One connected district and two or three race courses, both modes, persistence and economy, test ads under the real pacing rules, device tiers, thermal governor, transfer code | Independent onboarding in both modes; low-tier budgets met; exactly-once grants proven |
| 2. Approved features and closed test | From about Q2 2027 | The spec's seven approved additions; Play closed test with 20–30 Nigerian testers for at least 14 days; external TestFlight; Play pre-launch reports | 12 or more testers opted in for 14 consecutive days; vitals under the internal gates; human repeated-session tests |
| 3. Nigeria soft launch | After Play grants production access (review usually takes 7 days or less **[verify]**) | Play production staged at 5%, 20%, 50%, then 100%; App Store 7-day phased release; Nigeria, optionally Ghana and Kenya; EU excluded | Crash and ANR gates hold over Play's 28-day window; ad show rate and rewarded opt-in measured |
| 4. Expansion and global | After the soft-launch gates | UK and US diaspora; a new district or content pack every 4–6 weeks through the on-demand delivery plugin; Game Center for Games-app visibility; Godot 4.8.x after 4.8.1; target API 37 | Sustained vitals; updates kept small for players on metered data |

Two dates cut across these phases. Any App Store upload after April 2027 needs the iOS 27 SDK. Any Play upload after roughly August 2027 will likely need target API 37. So whenever Phase 3 lands, the toolchain must already match the rules of that month.

**Release mechanics:**

- **App Store phased release** runs over seven days at 1%, 2%, 5%, 10%, 20%, 50% and 100% ([Apple phased release](https://developer.apple.com/help/app-store-connect/update-your-app/release-a-version-update-in-phases)).
- **Localization:** the App Store offers no Nigerian Pidgin, Yoruba, Hausa or Igbo localisation, and the Nigerian storefront defaults to English (U.K.). Pidgin belongs in the listing copy, not in a locale ([App Store localizations](https://developer.apple.com/help/app-store-connect/reference/app-store-localizations)).
- **In-app review prompts** need small native plugins on Godot, triggered after a good run and never from a button ([Play in-app review](https://developer.android.com/guide/playcore/in-app-review)).
- **Games app:** every App Store game appears automatically in Apple's iOS 26 Games app. Adding Game Center features and In-App Events raises a game's prominence there ([Apple Games app](https://developer.apple.com/games-app/)).

### Danfo Run already owns the "danfo game" search

**Danfo Run** started as *Lagos Run* and now lives at danforun.com. Opeyemi Adeniran, also spelled Adediran, a Berlin-based engineer who grew up in Ojuelegba, released it on X on 26 September 2026 ([TechCabal](https://techcabal.com/2026/09/29/how-a-berlin-based-developer-turned-lagos-traffic-into-a-viral-game/); [Techpoint](https://techpoint.africa/feature/adediran-opeyemi/)). He built it in four to five weeks with Claude and AI art tools ([UrbanGeekz](https://urbangeekz.com/2026/10/two-nigerian-developers-create-viral-lagos-inspired-games-using-ai/)).

In the game, players drive a yellow danfo, pick up and drop off passengers, dodge okadas, listen to a fictional radio station, upgrade the bus in a garage and compete on a live leaderboard. It has no ads, accounts or paid items. Player counts conflict: TechCabal reported more than 20,000 players in 48 hours, while l24news reported more than 140,000 in the first week ([l24news](https://www.l24news.com/2026/09/nigerian-developer-goes-viral-after.html)). Its roadmap adds Lagos Island and multiplayer, and its creator plans to "grow into a proper games studio" ([isakaba](https://www.isakaba.com/the-plan-is-to-grow-into-a-proper-games-studio/)).

"Danfo" was already crowded before that. Earlier uses include ChopUp's 2007 feature-phone *Danfo*, Maliyo's *Danfo Racer*, which went into early access in 2022, Pledge 51's *Danfo Reloaded II* and an itch.io *Danfo Driver* ([BusinessDay](https://businessday.ng/technology/article/how-nigerian-game-startups-are-turning-lagos-chaos-into-digital-hits/); [Games Industry Africa](https://gamesindustryafrica.com/2022/02/01/danfo-racer-shifts-gears-to-early-access/)). A generic Lagos word used by five or more games is a weak trademark and a losing search term. Danfo Run also overlaps directly with Danfo's Work mode.

Keep "Danfo" as the codename. Choose a distinctive, searchable store title before the Phase 2 listing locks it in, and check it against the Nigerian trademark registry, both stores and domain availability. Avoid anything that implies affiliation with Danfo Run.

Position the game on what a browser game cannot offer: offline play, contact racing in 3D, a bus the player owns, and native phone performance. Danfo Run's zero-download reach is the real competitive threat, and Danfo's own 150 MB download costs a player about ₦86. That makes size discipline a competitive weapon, not just a technical tidy-up.

## Where the notes disagree, and what to re-check

| Conflict | What the notes say | Stronger source | Resolution |
|---|---|---|---|
| Does an official AppLovin MAX Godot plugin exist, and what state is it in? | The Godot research note found "no official" MAX plugin, but it only probed exact repository names under the godot-sdk-integrations organisation. The engine note, working from search summaries, says AppLovin publishes one and calls the Godot gap "narrowed". The ads note read the repository directly: last release 1.2.0 on 24 Apr 2025, open iOS initialisation and Xcode build bugs on Godot 4.4/4.5, floating SDK version, CocoaPods required | **The ads note**, which read the tags, commits and issues directly | The plugin exists and is official, but it is unmaintained and not production-safe on iOS. Reach AppLovin demand through its AdMob mediation adapter |
| Play AAB base-module limit: 200 MB or 500 MB? | Google's App Bundle FAQ (fetched directly, updated 6 Oct 2026) says 500 MB, and the Play Console Help summary agrees. Unity docs and Unity forum users cite 150–200 MB. The PAD page says asset delivery is "aimed at" games over 200 MB, which is guidance, not a limit | **Google's FAQ** ([App Bundle FAQ](https://developer.android.com/guide/app-bundle/faq)) | Treat 500 MB as the hard limit. It is irrelevant to Danfo's 150 MB budget. Re-check Play Console Help article 9859372 |
| Which Godot versions target API 36? | The store note read each tag's Gradle config: 4.5 to 4.6.2 target 35; 4.6.3, 4.7 and 4.7.1 target 36. The Godot note confirms 36 for 4.7.2, and 4.6.3's release notes list an "Annual Android versions bump for 2026". The pipeline note guessed API 35 for CI, and the godot-ci image pins 33. Poing's "compileSdk 35+" is a plugin minimum, not a target | **Both source readings agree** ([config.gradle @4.6-stable](https://raw.githubusercontent.com/godotengine/godot/4.6-stable/platform/android/java/app/config.gradle)) | 4.6.3 (20 May 2026) and later target 36. Pin 4.7.2 and install platform 36 in CI |
| Unity's minimum Android version | Unity docs, via search summaries: API 23 on 6.0, API 25 (Android 7.1) on 6.3, API 26 (Android 8.0) on 6.5–6.7. The Google Mobile Ads Unity plugin's "API 24" is that plugin's own floor. The engine note also says Godot shares an "Android 8+" floor, which is wrong: Godot 4.7.2 defaults to minSdk 24 | Unity docs for the Unity figures **[verify]**; Godot source for Godot | Unity 6.3 LTS means Android 7.1, and the next LTS means Android 8.0. In practice the difference is small, because Android 10+ is already at least 80.7% of the Nigerian base |
| Are both ARM ABIs exported by default? | The engine note, citing 4.4 docs, says yes, and a blog claims 4.3 dropped ARMv7. The Godot note read the 4.7.2 source: only arm64 is on by default, and ARMv7 is still supported | **Source code** | Enable both ABIs explicitly |
| 16 KB page-size deadline | 1 Nov 2025, then an extension to 31 May 2026, and a vendor claim of 1 May 2026, against 1 Feb 2027 on Google's live page | **Google's live page** | Treat 1 Feb 2027 as a gate before launch |
| Memory budget on 3 GB phones | The device-market note's heuristic is 700–800 MB; the performance note proposes 0.9–1.2 GB. Neither figure is sourced | Neither | Use 800 MB, because "4+4 GB" phones swap to slow storage |
| Minimum iOS version for Godot's Metal renderer | Godot's code defaults to 15.0 (and warns about iOS 14+); its docs say iOS 16 | Unresolved | Set 16.0, which costs nothing on A12-and-newer devices |
| Poing v5.1.0 details | Dated 12 Sep (git tag) or 13 Sep (GitHub release). Release notes list SDKs 1.4.0 (Android) and 13.9.0 (iOS), while main-branch docs list 1.5.0 and 13.11.0. The stated minimum Godot version is 4.4 in one place and 4.5 in another | **The tagged release** | Pin the tag and use the SDK versions it declares |
| minSdk: 24 or 29? | The Godot note recommends 24 for Compatibility; the device note recommends 29 | Both are inferences | Use 24, and let the RAM-based tiers and device-catalogue exclusions limit reach |
| Godot crash rates after the 2026 fixes | The Godot note read "under 1%" in the official article source; the performance note could not confirm it | **The Godot note** | Cite the figure as official |
| NDPC registration threshold | Secondary sources say 200 data subjects in six months; the GAID text says "a number set by the Commission" | The primary text, read only via search **[verify]** | Ask a lawyer |
| Danfo Run player counts | 7,000 then 27,000; 20,000 in 48 hours; 140,000 in the first week | Unaudited either way | Tens of thousands at minimum. It went viral regardless |

| Re-check before acting | Figure used in this report | Where to confirm |
|---|---|---|
| Play closed-testing rule | 12 testers, 14 consecutive days, personal accounts created after 13 Nov 2023 | Play Console Help 14151465 |
| Play ads, Families and declarations policies; AdMob rewarded and interstitial rules | Standard requirements from background knowledge | Play Policy Center; AdMob Help 7313578, 6201362, 9363762 |
| `app-ads.txt` on a github.io user site | Assumed crawlable | AdMob's verification status after launch |
| Whether AppLovin bids inside AdMob mediation | Assumed available as a bidder | AdMob's "Choose ad sources" page |
| Unity licensing and minimums | $200K revenue plus funding; Pro at $2,310; API 25 and 26 floors | unity.com pricing page and legal terms; Unity system-requirements docs |
| Play asset-pack limits | 1.5 GB per pack, 4 GB install-time, 30 GB on-demand | Play Console Help 9859372 |
| Target API 37 date and exact iOS 27 SDK date | About Aug 2027; "April 2027" | Play Console Help 11926878; Apple news |
| Godot 4.7.x compatibility with Xcode 27 and the iOS 27 SDK | Unknown | Godot release notes; a test build |
| iOS cellular-download limit | 200 MB assumed | App Store Connect Help |
| Free tiers: Sentry, GameAnalytics, Firebase Test Lab, Codemagic | 5,000 errors; unknown; 10 virtual and 5 physical runs a day; 500 minutes | Each vendor's pricing page |
| NDPA and GAID duties, thresholds and fees | Conflicting | ndpc.gov.ng and a Nigerian data-protection lawyer |
| Nigerian device, OS and chipset shares; Nigerian eCPMs | StatCounter snippets; vendor blogs | StatCounter and GSMArena directly; real mediation data after soft launch |
| Empty Godot 3D AAB size and custom-template savings | Not measured | Phase 0 measurement |
| Auto Backup coverage of Godot's `user://` directory | Assumed | `adb shell bmgr backupnow` followed by a reinstall |
| Per-OS renderer override at export | Assumed workable | Phase 0 test export |

## Conclusion

The engine is not the binding constraint on Danfo. The binding constraint is a 3 GB, Mali-G52 phone whose owner pays about ₦58 for every 100 MB of download and charges it between grid failures. Every important decision here follows from that phone: the Compatibility renderer, 32-bit libraries, a 30 fps lock, a 150 MB first download, install-time content with a delivery plugin added later, and rewards granted on the device. That is why the plan barely changes between Godot and Unity, and why the engine choice can only be cheaply reversed during the next eight weeks, while the repository is still a spec.

The spec's monetization baseline already sits inside every store rule the researchers could read. The real compliance work is quieter: age routing under Nigeria's under-18 definition, four small privacy and reporting UI items, Data safety and privacy labels that admit what the ad SDKs collect, and a CI lane that tracks Apple's and Google's annual toolchain deadlines. The market lesson from Danfo Run is equally plain. Lagos players have shown they will flock to a free danfo game that costs them nothing to try. Danfo's advantage has to come from depth a browser cannot match, delivered in a download small enough that trying it still feels close to free.
