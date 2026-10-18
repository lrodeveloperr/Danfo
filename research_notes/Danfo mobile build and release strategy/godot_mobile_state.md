# Godot 4 readiness for shipping a commercial 3D, ad-funded mobile game (Danfo), state as of 18 October 2026

How these notes were gathered (read this first): godotengine.org and docs.godotengine.org were blocked from this research environment, and the web-search budget ran out early in the session. Almost every finding below therefore comes from primary sources read directly:
- the source repository of the official website, `godotengine/godot-website` (commit d6a8d80, 16 Oct 2026), which holds the release pages, blog articles, `versions.yml` and the showcase;
- the `4.7` branch of `godotengine/godot-docs` (last commit 21 Sep 2026);
- engine source and class reference at the `4.7.2-stable` tag (read through raw.githubusercontent.com);
- the Godot Android library on Maven Central, which I downloaded and measured;
- clones of the plugin repositories, for tags, dates and READMEs.

Citations use the canonical public URL for each page. Where a fact comes from my own reading of source code or my own measurement, the note says so. Tag dates are git creator dates.

## Q1. Current stable version, version to pin, release dates, and the mobile-relevant changes in each 4.x release since 4.3

### Takeaway
As of 18 Oct 2026 the current stable release is **Godot 4.7.2**, released 18 Aug 2026; 4.7 itself was released 18 Jun 2026. **4.8 is at beta 1** (15 Oct 2026), and its stable release is estimated for Q4 2026. Pin **4.7.2** now, and plan to move to 4.8.x once its first maintenance release is out. 4.8 adds AccessKit screen-reader support on Android and iOS, decals in the Compatibility renderer, Swift Package Manager (SPM) support for iOS plugins, and Jolt 5.6.0. Since 4.3, the mobile story has improved substantially: Jolt became the default in 4.6, the Metal backend arrived in 4.4, ubershaders came in 4.4 and the shader baker in 4.5, 16 KB page support and edge-to-edge arrived in 4.5, and 4.5.2 and 4.6 brought a series of Vulkan Mobile crash fixes for Mali and Adreno GPUs.

### Cited Findings
**Release timeline (official dates)**
- 4.3: 15 Aug 2024. 4.4: 3 Mar 2025. 4.4.1: 26 Mar 2025. 4.5: 15 Sep 2025. 4.5.1: 15 Oct 2025. 4.6: 26 Jan 2026. 4.6.1: 16 Feb 2026. 4.5.2: 19 Mar 2026. 4.6.2: 1 Apr 2026. 4.6.3: 20 May 2026. 4.7: 18 Jun 2026 (RC1 8 Jun, RC2 11 Jun, RC3 15 Jun). 4.7.1: 14 Jul 2026. 4.7.2: 18 Aug 2026. 4.8 dev1 to dev7 ran from 6 Jul to 29 Sep 2026, and 4.8 beta1 came out 15 Oct 2026 — [godot-website versions.yml](https://github.com/godotengine/godot-website/blob/master/_data/versions.yml); [Godot 4.7 release page](https://godotengine.org/releases/4.7/); [4.7.2 release](https://godotengine.org/article/maintenance-release-godot-4-7-2/).
- Date conflicts between sources:
  - A secondary news aggregator dated 4.7 stable to 19 June 2026. The official site says 18 June 2026, most likely a timezone or reporting difference — [cinevva (secondary)](https://app.cinevva.com/hi/news/2026-06-19-godot-4-7-released); contradicted by [versions.yml](https://github.com/godotengine/godot-website/blob/master/_data/versions.yml).
  - Phoronix dates 4.6 to 26 Jan 2026, and some outlets say 27 Jan. The official article is dated 26 Jan 2026 — [Phoronix](https://phoronix.com/news/Godot-4.6-Released); [Godot 4.6 release](https://godotengine.org/releases/4.6/).

**Support policy (Godot docs, 4.7 branch)**
- 4.8: "Q4 2026 (estimate)", in development.
- 4.7 and 4.6: supported, receiving bug and security fixes.
- 4.5: partial support, security and platform-support fixes only.
- 4.4: end of life, last update 4.4.1. 4.3: end of life, last update 4.3.
- Source: [Release policy](https://docs.godotengine.org/en/4.7/about/release_policy.html).

**4.7.x maintenance releases**
- 4.7.2 had 57 fixes from 39 contributors. It lists "no known incompatibilities with the previous Godot 4.7.1 release. We encourage all users to upgrade to 4.7.2" — [4.7.2](https://godotengine.org/article/maintenance-release-godot-4-7-2/).
- 4.7.1 had 78 fixes from 42 contributors, including two Android input fixes: soft-keyboard backspace, and an EditorSettings error when running the game — [4.7.1](https://godotengine.org/article/maintenance-release-godot-4-7-1/).

**4.3 (15 Aug 2024)**
- The Compatibility renderer is "now considered feature complete" and gained MSAA and LightmapGI.
- The release page says Compatibility is "which we recommend when targeting low-end devices and the Web platform at the moment".
- 2D physics interpolation was added.
- RenderingDevice gained an acyclic render graph.
- Resource loading became more reliable ("reducing the chance for edge cases causing deadlocks").
- Source: [Godot 4.3 release page](https://godotengine.org/releases/4.3/).
- The full iOS privacy-manifest export options also arrived in 4.3. My count of the class reference: 153 `privacy/*` export options in 4.3-stable, against 6 in 4.2.2-stable — [EditorExportPlatformIOS.xml @4.3-stable](https://github.com/godotengine/godot/blob/4.3-stable/platform/ios/doc_classes/EditorExportPlatformIOS.xml).

**4.4 (3 Mar 2025)**
- Jolt Physics was integrated as an experimental, opt-in engine.
- 3D physics interpolation was added. The release page says "Mobile games in particular benefit from this change, since you can now lower the tick rate without compromising on smoothness".
- **Ubershaders** were added to reduce shader-compilation stutter.
- A **Metal rendering backend** was added, initially "limited to Apple Silicon (ARM) devices", together with an optional MetalFX upscaler.
- **Rendering driver fallback**: Forward+ and Mobile now fall back automatically to Compatibility (OpenGL) when the device has no Vulkan, D3D12 or Metal.
- A per-material or forced **vertex shading** option was added, "to target lower-end devices".
- LightmapGI gained shadowmasks ("especially for mobile applications"), bicubic lightmap sampling and baking of transparent objects.
- Android: the **Swappy** frame-pacing library is applied automatically, JavaClassWrapper was fixed, AndroidFilePicker and themed icons were added, and the Android editor can now export.
- .NET became available on all Android ABIs.
- Source: [Godot 4.4 release page](https://godotengine.org/releases/4.4/).

**4.5 (15 Sep 2025)**
- **Shader baker**: an export option that pre-compiles shaders to SPIR-V, DXIL or MIL. The team measured a "20× decrease in load times" for the TPS demo on Metal and D3D12.
- **16 KB page support** "out of the box". The release page notes Google Play requires 16 KB support from 1 Nov 2025 for new apps that target Android 15.
- A new Android **edge-to-edge** export option.
- The Mobile renderer now explicitly uses **FP16** where the hardware supports it, for better frame pacing and lower power use.
- **SMAA 1x** was added.
- **Screen reader** support via AccessKit, experimental.
- **Script backtracing** in release builds, plus custom loggers.
- Improved build-profile detection for custom templates.
- On-device lightmap baking on Android.
- Source: [Godot 4.5 release page](https://godotengine.org/releases/4.5/).
- Godot 4.5 also added native debug symbols for the Android templates — [Mobile update, Apr 2026](https://godotengine.org/article/godot-mobile-update-apr-2026/).

**4.5.2 (19 Mar 2026)**
- A set of Vulkan Mobile crash fixes, written after the developers of Rift Riff, Kamaeru and Spooky Express shared Play Console stack traces. The release notes say: "If you have a game published on Google Play using Vulkan Mobile, **we strongly recommend upgrading to 4.5.2** or later".
- iOS Metal exports now default to A12 or newer devices.
- A workaround for an Adreno 5XX driver crash.
- All PowerVR devices were added to the OpenGL transform-feedback shader-cache ban list.
- An Android ANR at engine shutdown was fixed.
- The RenderingDevice pipeline cache is now saved when the app pauses.
- iOS loading of xcframework dynamic libraries was fixed.
- Source: [4.5.2](https://godotengine.org/article/maintenance-release-godot-4-5-2/).

**4.6 (26 Jan 2026)**
- **Jolt is the default physics engine for all new 3D projects**; existing projects keep their current setting.
- Mobile renderer: material debanding and better HDR precision.
- "Vulkan Mobile crash fixes for Mali and Adreno GPUs".
- Android Storage Access Framework support.
- scrcpy mirroring of the device from the editor.
- Gradle builds from the Android editor through the companion app GABE.
- Delta-encoded patch PCKs.
- Octahedral reflection and radiance probes ("work more reliably across a wider range of hardware").
- Better automatic LOD generation (component pruning).
- Support for the Tracy, Perfetto and Instruments tracing profilers.
- Unique node IDs, which are saved in scene files, so all scenes should be re-saved.
- Direct3D 12 became the Windows default.
- Source: [Godot 4.6 release page](https://godotengine.org/releases/4.6/).
- Android instrumented tests were added in 4.6. The Foundation reports it is limited by the Firebase Test Lab free tier in how many devices it can test — [Mobile update, Apr 2026](https://godotengine.org/article/godot-mobile-update-apr-2026/).

**4.6.2 and 4.6.3**
- 4.6.2 (1 Apr 2026) added iOS UIScene lifecycle events — [4.6.2](https://godotengine.org/article/maintenance-release-godot-4-6-2/).
- 4.6.3 (20 May 2026) included the "Annual Android versions bump for 2026", a fix for iOS one-click deploy with Xcode 26, and a fix for back navigation when targeting API level 36 — [4.6.3](https://godotengine.org/article/maintenance-release-godot-4-6-3/).

**4.7 (18 Jun 2026)**
- **GABE** (Godot Android Build Environment) is stable: AAB and APK Gradle builds on-device, including builds with plugins such as AdMob. GABE's own stable announcement was 2 Jun 2026.
- A built-in **VirtualJoystick** node with Fixed, Dynamic and Following modes.
- Android splash-screen settings in the export options.
- GDScript can implement Java interfaces through JavaClassWrapper.
- Perfetto is the default tracing tool for Android template builds.
- HDR output, including on iOS.
- SDL3 controller support on iOS.
- Clearcoat fixes ("a better fit for materials like car paint").
- Vulkan subsampled images. With these, "the Vulkan Mobile renderer matches or even outperforms our Compatibility renderer in a number of benchmarks" — in an XR / foveated-rendering context.
- Sources: [Godot 4.7 release page](https://godotengine.org/releases/4.7/); [GABE stable](https://godotengine.org/article/gabe-stable-release/).
- Smaller 4.7-cycle changes, by snapshot:
  - beta1: "Remove deprecated Google Play OBB support" — [4.7 beta 1](https://godotengine.org/article/dev-snapshot-godot-4-7-beta-1/).
  - dev2: plugins can declare Gradle platform dependencies — [4.7 dev 2](https://godotengine.org/article/dev-snapshot-godot-4-7-dev-2/).
  - beta2: the experimental warning was removed from "Use Gradle Build" — [beta 2](https://godotengine.org/article/dev-snapshot-godot-4-7-beta-2/).
  - beta3: "Fix reported crashes from the Play store" — [beta 3](https://godotengine.org/article/dev-snapshot-godot-4-7-beta-3/).
  - beta4: "Disable ubershaders on problematic Adreno compiler versions" — [beta 4](https://godotengine.org/article/dev-snapshot-godot-4-7-beta-4/).

**Android build configuration in 4.7.2** (from the `config.gradle` source)
- compileSdk 36, targetSdk 36, minSdk 24.
- Android Gradle Plugin 8.6.1, NDK 29.0.14206865, Java 17, Kotlin 2.1.21.
- Source: [config.gradle @4.7.2-stable](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/android/java/app/config.gradle).

**4.8 cycle**
- dev1 (6 Jul 2026): "Add SPM support for Apple Embedded plugins (.gdip)" and ASTC 6x6 compression profiles — [4.8 dev 1](https://godotengine.org/article/dev-snapshot-godot-4-8-dev-1/).
- dev7 (29 Sep 2026): "AccessKit for iOS and Android" (the iOS version cannot yet handle editable text fields) and "Export project as an Android Archive (AAR)" — [4.8 dev 7](https://godotengine.org/article/dev-snapshot-godot-4-8-dev-7/).
- beta1 (15 Oct 2026): feature freeze; Jolt 5.6.0; decal support in Compatibility; one-click Android SDK and Java setup; non-allocating physics queries; Android `OS.alert()` made blocking (a breaking change) — [4.8 beta 1](https://godotengine.org/article/dev-snapshot-godot-4-8-beta-1/).
- A secondary site says 4.8's .NET builds require .NET 10. I did not verify this in official text, and it does not matter for a GDScript project — [linuxcompatible (secondary)](https://www.linuxcompatible.org/story/godot-48-beta-1-released-feature-freeze-and-final-testing-begin/).

### Inferences
- **Pin Godot 4.7.2 (18 Aug 2026)** for production now. It is the newest supported stable release, and the maintainers explicitly tell users to upgrade to it. 4.6.3 is the fallback if a 4.7 regression appears.
- Do not ship on the 4.8 beta. Do evaluate 4.8 once 4.8.1 is out, probably late 2026 or early 2027, for:
  - mobile screen-reader support;
  - decals in Compatibility, which helps a GLES-first build;
  - SPM-based iOS plugins;
  - non-allocating raycasts for vehicles.
- Projects created before 4.6 kept GodotPhysics. A new Danfo project gets Jolt by default, which matches the spec.

### Gaps
- I could not read GitHub issue or pull-request threads, so I could not follow regressions open against 4.7.2 on mobile. The tracker is the [4.8 regression project](https://github.com/orgs/godotengine/projects/61).
- I did not confirm whether 4.7.3 is planned.

## Q2. Mobile renderer (Vulkan) vs Compatibility renderer (OpenGL ES 3) on low-end Android (Mali-G52/G57, PowerVR, Unisoc)

### Takeaway
The official docs still position **Compatibility as the renderer for "older or low-end" mobile** and Mobile for "newer or high-end" mobile. They also say Mobile runs on low-end hardware "but slower than Compatibility".

On Android, Godot uses Vulkan only on devices that advertise Vulkan 1.1. Every other device silently falls back to OpenGL ES 3 (on by default). So a Mobile-renderer build will **in practice also run as a Compatibility build** on part of Nigeria's low-end device base.

Driver robustness on Mali and Adreno improved materially in 4.5.2 and 4.6. Two shipped games' crash rates fell from about 4% to under 1%. No Godot-specific data was found for Unisoc or for Mali-G52/G57.

### Cited Findings
**What the docs recommend**
- The renderer table rates Mobile hardware "✔️ Yes (low-end)" for Compatibility and "✔️ Yes (high-end)" for Mobile. On "Runs on old and low-end hardware", Mobile gets "Yes, but slower than Compatibility". Rendering cost is "Low base cost, but high scaling cost" for Compatibility and "Medium base cost, and medium scaling cost" for Mobile.
- "Choose Compatibility if… you are developing for older mobile devices… you want the best performance possible on all devices and don't need advanced rendering features."
- Source: [Renderers docs (4.7)](https://docs.godotengine.org/en/4.7/tutorials/rendering/renderers.html).

**Minimum and recommended specs for exported projects**
- Compatibility needs OpenGL ES 3.0 (examples given: Adreno 306, Mali-T628 MP6) and Android 7.0.
- Mobile needs Vulkan 1.0 (examples given: Adreno 505, Mali-G71 MP2) and Android 9.0.
- RAM: 1 GB minimum.
- Recommended spec: Android 9.0, Snapdragon 845 / Exynos 9810, a Vulkan 1.2 or GLES 3.2 GPU (Adreno 630, Mali-G72 MP18), and 2 GB RAM.
- Source: [System requirements (4.7)](https://docs.godotengine.org/en/4.7/about/system_requirements.html).

**How the Android Vulkan check and fallback work**
- `meetsVulkanRequirements()` reports Vulkan as usable only if `FEATURE_VULKAN_HARDWARE_VERSION` is at least 0x401000 (Vulkan 1.1). Hardware level 1 is optional and only logs a warning. If Vulkan fails and no fallback is available, the app throws "missing vulkan requirements" — [Godot.kt @4.7.2](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/android/java/lib/src/org/godotengine/godot/Godot.kt) (source read by me).
- `rendering/rendering_device/fallback_to_opengl3` defaults to **true** and is implemented on Android — [ProjectSettings @4.7.2](https://github.com/godotengine/godot/blob/4.7.2-stable/doc/classes/ProjectSettings.xml).
- Since 4.4, when RenderingDevice is unsupported the engine falls back to Compatibility, and the project "may look different than the intended appearance" — [Renderers docs](https://docs.godotengine.org/en/4.7/tutorials/rendering/renderers.html).
- The Android exporter adds a `uses-feature` for Vulkan version 1.1 that is *required* only when that fallback is disabled — [export_plugin.cpp @4.7.2](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/android/export/export_plugin.cpp).

**Feature differences** (Compatibility / Mobile)
- Reflection probes: 2 per mesh / 8 per mesh.
- LightmapGI: Compatibility *renders* baked lightmaps, but "Baking requires hardware with RenderingDevice support"; Mobile supports it fully.
- MSAA 3D: supported in both.
- FXAA and SMAA: Mobile only.
- Decals: Mobile only (added to Compatibility in 4.8 beta).
- Particle trails: Mobile only.
- TAA, FSR2 and volumetric fog: Forward+ only.
- Source: [Renderers docs](https://docs.godotengine.org/en/4.7/tutorials/rendering/renderers.html); [4.8 beta 1](https://godotengine.org/article/dev-snapshot-godot-4-8-beta-1/).

**Stutter mitigation**
- Ubershaders and pipeline precompilation "only applies to the Forward+ and Mobile renderers, not Compatibility". The shader baker bakes only to the intermediate format (SPIR-V, DXIL, MIL), not to driver-specific pipelines — [Pipeline compilations docs](https://docs.godotengine.org/en/4.7/tutorials/performance/pipeline_compilations.html).

**Driver fixes and workarounds over time**
- Android "spans more than 12,000 different devices".
- After Kamaeru and Rift Riff launched on mobile in Dec 2025, Foundation contractors fixed Vulkan API misuse and added driver workarounds. Both games' crash rates went "from ~4% to less than 1%".
- Source: [Mobile update, Apr 2026](https://godotengine.org/article/godot-mobile-update-apr-2026/).
- Fix list by release:
  - 4.3 RC1: "Fix glsl shader for Android Mali-GXXx GPUs and Vulkan API 1.3.xxx" — [4.3 RC1](https://godotengine.org/article/release-candidate-godot-4-3-rc-1/).
  - 4.5.2: Adreno 5XX workaround; PowerVR added to the OpenGL transform-feedback shader-cache ban list — [4.5.2](https://godotengine.org/article/maintenance-release-godot-4-5-2/).
  - 4.6 RC1: "Fix MSAA crashing Mali GPUs when using subpasses" — [4.6 RC1](https://godotengine.org/article/release-candidate-godot-4-6-rc-1/).
  - 4.6 beta 2: OpenGL motion-vector UBO split to fix an Adreno crash — [4.6 beta 2](https://godotengine.org/article/dev-snapshot-godot-4-6-beta-2/).
  - 4.7 beta 4: ubershaders disabled on problematic Adreno compiler versions — [4.7 beta 4](https://godotengine.org/article/dev-snapshot-godot-4-7-beta-4/).
- Known issue at 4.7 RC3 (15 Jun 2026): "Adreno 660 devices running Vulkan have geometry errors when using LightmapGI (#120299)" — [4.7 RC3](https://godotengine.org/article/release-candidate-godot-4-7-rc-3/).

**Low-end tuning hooks**
- `rendering/shading/overrides/force_vertex_shading`: "Can be used to optimize performance on low-end mobile devices" — [ProjectSettings](https://github.com/godotengine/godot/blob/4.7.2-stable/doc/classes/ProjectSettings.xml).
- Mobile renderer FP16 (4.5) and debanding (4.6) — [4.5 release](https://godotengine.org/releases/4.5/); [4.6 release](https://godotengine.org/releases/4.6/).
- The Vulkan-beats-Compatibility benchmark claim in 4.7 refers to foveated rendering in XR. It is not a phone benchmark — [4.7 release page](https://godotengine.org/releases/4.7/).

### Inferences
- For a Nigeria-first audience, the Mobile + Vulkan choice in the spec is at odds with the docs' guidance for "older or low-end" mobile devices.
  - Many Android Go, Unisoc and PowerVR devices either do not advertise Vulkan 1.1 or run Android versions below 10. They will run the OpenGL fallback anyway, so lighting, materials and post-processing must be acceptable under Compatibility regardless of which renderer is chosen.
  - A credible alternative is **Compatibility as the primary renderer**, which gives the lowest base cost and the widest reach, with tuned visuals. In that case the art budget should rely on baked lightmaps (baked on a desktop GPU), vertex colours, unlit or simple materials and MSAA 2x, not on SMAA, decals or SSAO.
  - If Mobile is kept, QA must cover both paths: a Vulkan Mali-G52/G57 device and a device that forces the GLES fallback.
- Compatibility gets no ubershader or pipeline precompilation. Hitches when shaders first appear must instead be handled by warm-up scenes and the shader cache.
- This choice should be settled by an early device-lab spike, for example Tecno or Infinix on Helio G-series with Mali-G52 MC2, an Itel Unisoc SC9863A with PowerVR GE8322, and a Samsung A0x. Do not decide it from docs alone.

### Gaps
- I found no Godot-specific bug data or benchmarks for **Unisoc** SoCs or **Mali-G52/G57** in particular. The GitHub issue search was unavailable to this session, and search queries ran out.
- I found no independent frame-time comparison of Mobile vs Compatibility on budget phones.
- I found no data on what share of Nigerian devices advertise Vulkan 1.1.

## Q3. Android ABI support (armeabi-v7a), minimum Android/API level, baseline APK/AAB size and how to shrink it

### Takeaway
**armeabi-v7a (32-bit ARM) export is still supported in 4.7.2.** Only arm64-v8a is enabled by default, and the official template_release Android library ships arm32, arm64, x86 and x86_64 binaries.
- **Minimum API is 24 (Android 7.0).** A Gradle/AAB export that uses the Vulkan renderer defaults to **minSdk 29 (Android 10)** unless you override it. Target SDK is 36.
- The engine's own native library is large: about **71 MB uncompressed and about 24 MB compressed** for arm64 in 4.7.2, by my measurement.
- Custom export templates built with a build profile, `optimize=size_extra`, LTO and disabled modules are the documented way to shrink it.

### Cited Findings
**ABIs**
- 4.7.2 export options include `architectures/armeabi-v7a` ("arm32 binaries are included into exported project") as well as arm64-v8a, x86 and x86_64 — [EditorExportPlatformAndroid @4.7.2](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/android/doc_classes/EditorExportPlatformAndroid.xml).
- Only arm64-v8a is on by default: `const bool is_default = abi == "arm64-v8a";` — [export_plugin.cpp @4.7.2](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/android/export/export_plugin.cpp) (source read by me).
- The minimum spec for exported projects is "SoC with any 32-bit or 64-bit ARM or x86 CPU". The recommended spec is a 64-bit CPU — [System requirements](https://docs.godotengine.org/en/4.7/about/system_requirements.html).
- The Maven Central artifact `org.godotengine:godot:4.7.2.stable` contains `jni/armeabi-v7a`, `arm64-v8a`, `x86` and `x86_64` libraries — [Maven Central](https://repo1.maven.org/maven2/org/godotengine/godot/4.7.2.stable/). That artifact is the **templateRelease** variant: `PUBLISH_ARTIFACT_ID = 'godot'` maps to `components.templateRelease` — [publish-module.gradle @4.7.2](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/android/java/scripts/publish-module.gradle).

**Minimum and target API**
- In source: `DEFAULT_MIN_SDK_VERSION = 24`, `VULKAN_MIN_SDK_VERSION = 29` ("Minimum recommended sdk version for Vulkan 1.1 support"), `DEFAULT_TARGET_SDK_VERSION = 36`.
- In a Gradle build, if min_sdk is left empty, the exporter passes 29 when the project uses Vulkan and 24 otherwise.
- Values below 24 are rejected. A value below 29 with Vulkan triggers only a warning, and only when the OpenGL fallback is disabled.
- Source: [export_plugin.cpp @4.7.2](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/android/export/export_plugin.cpp) (source read by me).

**16 KB pages and edge-to-edge**
- 16 KB page support has been built in since 4.5 — [4.5 release](https://godotengine.org/releases/4.5/).
- `screen/edge_to_edge` is an export option. The developer must avoid occlusion by using `DisplayServer.get_display_safe_area()` and `get_display_cutouts()` — [EditorExportPlatformAndroid](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/android/doc_classes/EditorExportPlatformAndroid.xml).

**AAB**
- An AAB requires a Gradle build. The docs state "All new apps uploaded to Google Play after August 2021 must be an AAB" — [Exporting for Android](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_android.html); [Gradle builds](https://docs.godotengine.org/en/4.7/tutorials/export/android_gradle_build.html).
- The docs recommend JDK 17 — [Exporting for Android](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_android.html).

**Baseline size (my measurement of the 4.7.2 template_release library)**

| ABI | `libgodot_android.so` uncompressed | deflate-compressed |
|---|---|---|
| arm64-v8a | 71.11 MB | 24.02 MB |
| armeabi-v7a | 74.94 MB | 25.51 MB |
| x86_64 | 74.06 MB | not recorded |

- `libc++_shared.so` adds about 1–1.4 MB per ABI (about 0.45 MB compressed).
- The arm64 binary is already stripped (`file` reports "stripped").
- Source: [Maven Central 4.7.2 AAR](https://repo1.maven.org/maven2/org/godotengine/godot/4.7.2.stable/).
- `gradle_build/compress_native_libraries` defaults to off. The class reference says that for Play Store distribution "it's generally recommended to keep this option false", because compressed libraries must be extracted at startup — [EditorExportPlatformAndroid](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/android/doc_classes/EditorExportPlatformAndroid.xml).

**Shrinking**
- "Customize Engine Build Configuration" detects used classes; 4.5 also detects build options and the classes GDExtensions use.
- `optimize=size`, and the new `optimize=size_extra` from 4.5.
- `lto=full`, which needs 8 GB or more of RAM to link.
- `module_text_server_adv_enabled=no` together with `module_text_server_fb_enabled=yes`.
- Disabling the unused physics engine: `module_godot_physics_3d_enabled=no` when using Jolt.
- Disabling unused modules such as camera, CSG, BMP and others.
- `disable_3d` (about 15%) does not apply to Danfo, which needs 3D.
- Source: [Optimizing a build for size](https://docs.godotengine.org/en/4.7/engine_details/development/compiling/optimizing_for_size.html); [4.5 release](https://godotengine.org/releases/4.5/).

**R8 and ad SDKs**
- Godot's Android template sets `minifyEnabled false` by default. The Poing AdMob docs say the Next-Gen GMA SDK inflates DEX bytecode, and that Play Console can flag "App optimization is below our threshold: Obfuscation (10%)". The plugin offers `admob/general/android/enable_r8_optimization` — [Poing AdMob R8 doc](https://github.com/poingstudios/godot-admob-plugin/blob/main/docs/android_r8_obfuscation.md). This is the maintainer's claim; I have not verified the Play Console behaviour.

### Inferences
- With an AAB, Play serves per-ABI splits. Including armeabi-v7a therefore adds no download size for 64-bit users, while still reaching 32-bit-userspace Android Go devices. **Enable both arm64-v8a and armeabi-v7a.**
- The engine alone means roughly 24–26 MB of compressed download and about 72–76 MB of installed native code before any game assets, against which assets and the ad SDKs must be budgeted.
  - A custom size-optimised template with unused modules removed is likely needed to stay under small-download targets in Nigeria.
  - Building custom Android templates requires SCons and the Android NDK in CI. This is free, but it is operational overhead.
- To reach Android 7–9 devices with the Mobile renderer, **min_sdk must be set to 24 by hand**. Those devices will then run the GLES3 fallback.

### Gaps
- I did not measure the size of an empty Godot 4.7 3D project's APK or AAB, nor the savings from a custom template. Export templates are hosted on GitHub Releases, which this environment could not reach, and I found no official figure.
- I did not measure ARM performance on 32-bit (armeabi-v7a) Android Go devices.

## Q4. Google Play Asset Delivery, Apple On-Demand Resources / Background Assets, and handling large PCKs on mobile

### Takeaway
Godot uses Play Asset Delivery only in its simplest form: when exporting an AAB, it places the game's assets in a single **install-time asset pack** (`assetPackInstallTime`).
- **No fast-follow or on-demand packs** are supported in the engine, and OBB support was removed in 4.7.
- The iOS exporter has no export options for On-Demand Resources or Background Assets.
- Larger content can be shipped as extra or patch PCKs loaded at runtime, but the developer must download and host them.

### Cited Findings
- In 4.7.2, AAB exports write assets to `assetPackInstallTime/src/main/assets` (`AAB_ASSETS_DIRECTORY`), while APK exports use `src/main/assets` — [export_plugin.cpp @4.7.2](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/android/export/export_plugin.cpp).
- The Gradle template declares `assetPacks = [":assetPackInstallTime"]`, with `deliveryType = "install-time"` — [app/build.gradle](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/android/java/app/build.gradle); [assetPackInstallTime/build.gradle](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/android/java/app/assetPackInstallTime/build.gradle) (source read by me).
- "Platforms: Android: Remove deprecated Google Play OBB support" landed in 4.7 beta 1 — [4.7 beta 1](https://godotengine.org/article/dev-snapshot-godot-4-7-beta-1/).
- The 4.7.2 iOS exporter class reference has 0 matches for on-demand, ODR or "background assets" — [EditorExportPlatformIOS @4.7.2](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/ios/doc_classes/EditorExportPlatformIOS.xml) (my grep).
- PCK packs, patches and DLC are supported, and patch PCKs can be generated from the export dialog. The docs warn that loading PCKs from outside the app is a security risk, and suggest signing or encrypting them via `Crypto` — [Exporting packs, patches, and mods](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_pcks.html).
- 4.6 added delta encoding for patch PCKs — [4.6 release](https://godotengine.org/releases/4.6/).
- The `--export-pack` and `--export-patch` CLI options exist — [Command line tutorial](https://docs.godotengine.org/en/4.7/tutorials/editor/command_line_tutorial.html).

### Inferences
- For Danfo, the practical approach is a single AAB with everything delivered at install time. Use the size budget from Q3 and aggressive texture compression (ETC2/ASTC; 4.8 adds ASTC 6x6).
- Fast-follow or on-demand packs would need a custom Gradle build plus a hand-written Play Core / Asset Delivery plugin wrapper. This is feasible with the v2 plugin system, but no maintained plugin was verified.
- Danfo has no backend, so downloading extra PCKs would need static hosting, which is a cost and a constraint, and would weaken the offline-first design.

### Gaps
- I did not verify whether a community Godot 4 plugin exists for PAD fast-follow / on-demand or for iOS ODR; the search budget was exhausted.
- This session did not re-verify Google Play's current size limits for the base module and install-time packs; another researcher should confirm them.

## Q5. Open-world / large-scene features (threaded loading, occlusion culling on mobile, HLOD, MultiMesh, double precision, origin shifting)

### Takeaway
Godot 4.7 has every building block a mid-sized open city needs:
- threaded background resource loading;
- CPU-raster occlusion culling, which helps most on the Mobile renderer;
- visibility ranges (HLOD) and automatic mesh LOD;
- MultiMesh instancing.

Double precision needs custom-compiled editor and templates, and the docs say it "may not perform well on low-end mobile". For a city map of a few kilometres, single precision with origin shifting if needed is the documented low-end approach.

### Cited Findings
**Background loading**
- `ResourceLoader.load_threaded_request` / `load_threaded_get_status` / `load_threaded_get` load resources on background threads — [Background loading](https://docs.godotengine.org/en/4.7/tutorials/io/background_loading.html).
- 4.3 made resource loading "much more reliable overall" by reducing deadlock edge cases — [4.3 release](https://godotengine.org/releases/4.3/).

**Occlusion culling**
- It rasterizes occluders on the CPU using Embree.
- "The greatest performance benefits can be observed when using the Mobile renderer, as it does not feature a depth prepass".
- In scenes with few occlusion opportunities it "may not be worth the added setup and CPU usage".
- MultiMeshInstance3D, particles and CSG are not baked as occluders.
- Source: [Occlusion culling](https://docs.godotengine.org/en/4.7/tutorials/3d/occlusion_culling.html).
- The project setting `rendering/occlusion_culling/use_occlusion_culling` defaults to false — [ProjectSettings](https://github.com/godotengine/godot/blob/4.7.2-stable/doc/classes/ProjectSettings.xml).

**HLOD and LOD**
- Visibility ranges provide artist-controlled HLOD, with begin/end distances, hysteresis margins and fading — [Visibility ranges](https://docs.godotengine.org/en/4.7/tutorials/3d/visibility_ranges.html).
- 4.6 improved automatic LOD generation to "better preserve the shape" of multi-part meshes — [4.6 release](https://godotengine.org/releases/4.6/).

**Large world coordinates**
- Single-precision ranges the docs recommend as maximums: [4096; 8192] for a third-person 3D game, and [16384; 32768] for a top-down game.
- Double precision "requires recompiling the editor and all export template binaries" with `precision=double`, and comes with "a performance and memory usage penalty, especially on 32-bit CPUs".
- It "may not perform well on low-end mobile devices… On low-end platforms, an *origin shifting* approach can be used instead". The docs do not describe origin shifting in detail.
- Source: [Large world coordinates](https://docs.godotengine.org/en/4.7/tutorials/physics/large_world_coordinates.html).

**Physics interpolation and ticks**
- 3D physics interpolation (4.4) lets mobile games "lower the tick rate without compromising on smoothness" — [4.4 release](https://godotengine.org/releases/4.4/).
- `physics/common/physics_ticks_per_second` defaults to 60. At "very low tick rates (usually below 30), physics behavior can break down" — [ProjectSettings](https://github.com/godotengine/godot/blob/4.7.2-stable/doc/classes/ProjectSettings.xml).
- `physics/3d/run_on_separate_thread` defaults to false — [ProjectSettings](https://github.com/godotengine/godot/blob/4.7.2-stable/doc/classes/ProjectSettings.xml).

### Inferences
- Keep the playable Lagos map within about 4–8 km of the origin for a third-person driving camera. That avoids double precision entirely, which would also force custom templates and hurt the armeabi-v7a build. Origin shifting can be added if larger maps are needed.
- Traffic and pedestrian crowds should use MultiMesh or lightweight instancing plus visibility ranges.
- Districts can be streamed with `load_threaded_request`.
- Occlusion culling is worth a profiling test on dense street canyons, but it costs CPU on the weak cores of low-end phones.

### Gaps
- I found no measured figures for occlusion culling CPU cost on low-end ARM, nor any open-world Godot mobile case studies with numbers.
- I did not confirm whether Embree-based occlusion culling is enabled in the armeabi-v7a templates.

## Q6. Vehicle physics: VehicleBody3D limitations, Jolt behaviour for heavy vehicle contact, raycast-vehicle approaches

### Takeaway
VehicleBody3D is a basic raycast vehicle. Godot's own docs say it "has known issues and isn't designed to provide realistic 3D vehicle physics", and recommend a custom RigidBody3D integration for anything advanced. It works on the Jolt backend because it uses engine-agnostic raycasts. Jolt has been the default since 4.6 and is described as production-ready. Its documented differences (estimated contact impulses, ghost-collision mitigation, joint softness that is not supported) matter for contact-heavy minibus racing. Expect to write a custom raycast-suspension vehicle on RigidBody3D.

### Cited Findings
- The VehicleBody3D class description: "This class has known issues and isn't designed to provide realistic 3D vehicle physics. If you want advanced vehicle physics, you may have to write your own physics integration using CharacterBody3D or RigidBody3D." It also says the vehicle's origin sets the centre of gravity — [VehicleBody3D class ref @4.7.2](https://github.com/godotengine/godot/blob/4.7.2-stable/doc/classes/VehicleBody3D.xml).
- VehicleBody3D's wheel raycasts use `PhysicsDirectSpaceState3D::intersect_ray` inside `_body_state_changed`, so the implementation does not depend on the physics engine — [vehicle_body_3d.cpp @4.7.2](https://github.com/godotengine/godot/blob/4.7.2-stable/scene/3d/physics/vehicle_body_3d.cpp) (source read by me).
- Jolt is "fast, stable… powers AAA games like… Death Stranding 2" and is the default for new 3D projects from 4.6. This is the maintainers' claim — [4.6 release](https://godotengine.org/releases/4.6/).
- Documented Jolt differences from Godot Physics:
  - joint soft-limit properties are unsupported;
  - two ghost-collision mitigations exist: active edge detection, and "enhanced internal edge removal", which can be toggled;
  - "contact impulses… are estimated ahead of time";
  - kinematic bodies do not report contacts with static/kinematic bodies by default;
  - the ray-cast `face_index` is -1 by default.
  - Source: [Using Jolt Physics](https://docs.godotengine.org/en/4.7/tutorials/physics/using_jolt_physics.html).
- Jolt tuning defaults in 4.7.2:
  - velocity_steps 10, position_steps 2;
  - speculative_contact_distance 0.02 m;
  - CCD movement threshold 0.75, max penetration 0.25;
  - max_bodies 10240;
  - temporary memory buffer 32 MiB.
  - Source: [ProjectSettings @4.7.2](https://github.com/godotengine/godot/blob/4.7.2-stable/doc/classes/ProjectSettings.xml).
- 4.8 beta adds Jolt 5.6.0, non-allocating typed physics queries (`intersect_ray_into` with a reusable `PhysicsIntersectRayResult3D`) and `RigidBody3D.get_velocity_at_local_position()` — [4.8 beta 1](https://godotengine.org/article/dev-snapshot-godot-4-8-beta-1/).
- 4.7 clearcoat fixes are aimed at materials "like car paint" — [4.7 release](https://godotengine.org/releases/4.7/).

### Inferences
- Plan a custom raycast vehicle on RigidBody3D for both modes, using 4 to 6 rays or shape casts per bus, a simple tyre-force model and arcade assists. VehicleBody3D is fine for an early prototype only.
  - Use 4.7 now. Adopt the 4.8 non-allocating queries later to cut per-frame allocations from about 4 rays × N vehicles.
  - Each AI traffic vehicle should be cheaper, for example kinematic or path-following, so the physics body count stays within mobile CPU limits.
- For contact-heavy racing:
  - use convex hull or box compounds for buses, not trimesh;
  - use trimesh only for static roads, with enhanced internal edge removal on to avoid ghost bumps at road-segment seams;
  - tune CCD for high-speed impacts;
  - do not rely on exact contact impulses for damage or scoring.

### Gaps
- I could not verify community raycast-vehicle examples, the godot-jolt issue history on vehicle stability, or any mobile vehicle-physics benchmarks; the search budget ran out and GitHub issues were blocked.
- I did not confirm whether Jolt's native `VehicleConstraint` is exposed in Godot. I believe it is not, but this is unverified.

## Q7. Ad SDK integration ecosystem (Poing Studios AdMob, AppLovin MAX / LevelPlay, godot-sdk-integrations, writing thin native plugins)

### Takeaway
AdMob is well served by two actively maintained Godot 4 plugins.
- **Poing Studios godot-admob-plugin**: v5.1.0 on 12 Sep 2026, a nightly on 17 Oct 2026. It needs Godot 4.5+, works on Android and iOS, supports UMP, and has mediation adapters on both platforms, including AppLovin, ironSource, Unity Ads, Pangle, Mintegral, Meta and Liftoff/Vungle.
- **godot-sdk-integrations/godot-admob**: v7.0 on 27 May 2026.

The Godot Foundation now maintains the Play Billing, Play Games Services and StoreKit 2 plugins. I could not verify any standalone AppLovin MAX or Unity LevelPlay Godot 4 plugin, but both networks can be reached as AdMob mediation sources. Writing a thin native plugin is well documented for Android (v2 AAR plus EditorExportPlugin). On iOS it is harder: the docs page is marked outdated, and SPM support only arrives in 4.8.

### Cited Findings
**Poing Studios AdMob plugin**
- Release dates (git tag dates): v5.0.0 21 Jul 2026; v5.1.0 12 Sep 2026; v5.2.0-nightly 17 Oct 2026. The last commit, on 17 Oct 2026, adds an ApplicationPreferences API — [poingstudios/godot-admob-plugin](https://github.com/poingstudios/godot-admob-plugin).
- A Godot 3 branch is still maintained (v1.3.8-godot3, 20 Aug 2026) — [poingstudios/godot-admob-plugin](https://github.com/poingstudios/godot-admob-plugin).
- README claims:
  - "Godot 4.5.0+: Native support for Android and iOS with full 1:1 GDScript and C# parity";
  - "All Formats & Mediations";
  - "Editor Mock Ads";
  - "AI-Agent Ready". The repo contains an AGENTS.md file.
  - Source: [README](https://github.com/poingstudios/godot-admob-plugin/blob/main/README.md).
- Native SDKs: Android uses the Next-Gen SDK `com.google.android.libraries.ads.mobile.sdk:ads-mobile-sdk:1.5.0`. iOS uses GoogleMobileAds 13.11.0 and GoogleUserMessagingPlatform 3.1.0, both via their SPM package repositories.
- Requirements: minSdk 24, compileSdk 35 or higher, iOS 15 or higher.
- Native libraries are downloaded automatically through "AdMob Manager".
- Source: [docs/index.md](https://github.com/poingstudios/godot-admob-plugin/blob/main/docs/index.md).
- Mediation adapters exist for **both Android and iOS**: AppLovin, BidMachine, Chartboost, DT Exchange, i-mobile, InMobi, ironSource, LINE, maio, Meta, Mintegral, Moloco, myTarget, Pangle, PubMatic, Unity Ads and Vungle. The docs also cover Zucks and Vpon — [platforms/ and docs/mediate/](https://github.com/poingstudios/godot-admob-plugin/tree/main/docs/mediate).
- UMP consent API classes: `UserMessagingPlatform`, `ConsentInformation`, `ConsentForm`, `ConsentRequestParameters`, `ConsentDebugSettings`. There are also docs on GDPR/IAB and IDFA/ATT, and on SSV for rewarded ads — [docs/reference](https://github.com/poingstudios/godot-admob-plugin/tree/main/docs/reference/classes).

**godot-sdk-integrations/godot-admob** (community plugin, maintainer "Cengiz")
- Tags: v5.0 4 Aug 2025; v6.0 1 Feb 2026; v7.0 27 May 2026. Last commit 27 May 2026.
- Features: all formats, "Mediation support… up to 15 additional ad networks", UMP consent, ATT handling and node-based configuration.
- Source: [godot-sdk-integrations/godot-admob](https://github.com/godot-sdk-integrations/godot-admob).

**Foundation-maintained store plugins**
- The Foundation "has decided to begin improving and maintaining the core plugins such as Godot Google Play Billing, Godot Google Play Games Services, and Godot StoreKit 2". Other community plugins live under the same organisation — [Mobile update, Apr 2026](https://godotengine.org/article/godot-mobile-update-apr-2026/).
- Latest tags:
  - [godot-google-play-billing](https://github.com/godot-sdk-integrations/godot-google-play-billing): 3.3.0, 26 Jul 2026, Billing Library v9.1.0. There is also a later-dated 1.4.0 tag of 26 Sep 2026, probably a legacy-branch release.
  - [godot-play-game-services](https://github.com/godot-sdk-integrations/godot-play-game-services): v3.4.0, 20 Jul 2026.
  - [godot-storekit2](https://github.com/godot-sdk-integrations/godot-storekit2): v0.2, 18 Sep 2025, last commit 27 Apr 2026.
- No repository was found under the names godot-sdk-integrations/godot-applovin(-max), godot-levelplay, godot-ironsource, godot-unity-ads, godot-firebase or godot-play-asset-delivery. These were exact-name probes only (`git ls-remote`), not a full listing of the organisation.

**Writing native plugins**
- Android v2 plugin architecture (since 4.2):
  - an Android AAR library that depends on `org.godotengine:godot`, hosted on Maven Central;
  - Kotlin/Java methods annotated with `@UsedByGodot`;
  - signals declared through `getPluginSignals()`;
  - manifest meta-data `org.godotengine.plugin.v2.[PluginName]`;
  - packaged as an EditorExportPlugin;
  - a template repo is available (m4gr3d/Godot-Android-Plugin-Template), plus a GDExtension variant.
  - Source: [Android plugins docs](https://docs.godotengine.org/en/4.7/tutorials/platform/android/android_plugin.html).
- Plugins can declare Gradle platform dependencies from 4.7 — [4.7 dev 2](https://godotengine.org/article/dev-snapshot-godot-4-7-dev-2/).
- JavaClassWrapper and the AndroidRuntime plugin let GDScript call Android APIs without writing a plugin, and from 4.7 can implement Java interfaces — [4.7 release](https://godotengine.org/releases/4.7/); [4.4 release](https://godotengine.org/releases/4.4/).
- iOS plugins:
  - a `.gdip` config file plus a `.a` or `.xcframework` static library built against the Godot headers;
  - the config has `linked`/`embedded` framework lists, `capabilities` and `plist` keys;
  - the docs page carries the `article_outdated` flag.
  - Source: [iOS plugins docs](https://docs.godotengine.org/en/4.7/tutorials/platform/ios/ios_plugin.html).
- SPM for `.gdip` plugins arrives only in 4.8 — [4.8 dev 1](https://godotengine.org/article/dev-snapshot-godot-4-8-dev-1/).
- 4.5.2 fixed loading of iOS xcframework dynamic libraries — [4.5.2](https://godotengine.org/article/maintenance-release-godot-4-5-2/).

### Inferences
- The ad stack in the spec is fully achievable on Godot 4.7 with free tools: AdMob through the Poing plugin, plus bidding/mediation adapters from AppLovin, Liftoff, Mintegral, Pangle, Unity and ironSource for fill and eCPM in Nigeria.
- If AppLovin MAX or LevelPlay must be the *primary* mediator, plan a custom thin wrapper:
  - Android: about one Kotlin AAR with a handful of `@UsedByGodot` methods and signals. A few days' work for someone experienced, and well suited to AI-assisted development given the template.
  - iOS: an Objective-C++ static library plus `.gdip` until 4.8 adds SPM. This is harder and needs a Mac.
- Main ecosystem risks:
  - Each plugin has a single small maintainer team (bus factor).
  - Plugins must be updated in lockstep with Google SDK changes and Godot minor versions.
  - The R8 / obfuscation interaction noted in Q3.

### Gaps
- I could not verify the existence, maintenance or quality of any community AppLovin MAX or Unity LevelPlay plugin for Godot 4; the search budget was exhausted.
- Fill and eCPM quality of mediation in Nigeria is out of scope here.

## Q8. iOS export workflow (macOS/Xcode, CocoaPods/SPM, Xcode 26 / iOS 26 SDK, privacy manifest)

### Takeaway
Godot's iOS export produces an Xcode project and **requires macOS with Xcode**. Cross-compiling on Linux is documented but "not official".
- Metal has been the default iOS driver since 4.4, with A12-or-newer devices enforced by default since 4.5.2/4.6.
- The full privacy-manifest options (data types collected, required-reason APIs) have existed since 4.3.
- Godot has no native CocoaPods support; SPM support for plugins arrives in 4.8.
- 4.6.2 and 4.6.3 added UIScene lifecycle events and an Xcode 26 deploy fix.

### Cited Findings
**Requirements and setup**
- "You must export for iOS from a computer running macOS with Xcode installed." The App Store Team ID and bundle identifier are required.
- Provisioning profiles can be supplied through environment variables (`GODOT_IOS_PROVISIONING_PROFILE_UUID_DEBUG/RELEASE`), which suits CI.
- Source: [Exporting for iOS](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_ios.html).
- Cross-compiling for iOS on Linux is possible but "this is not official". It still needs the Xcode iOS SDK, downloaded with an Apple ID — [Cross-compiling for iOS on Linux](https://docs.godotengine.org/en/4.7/engine_details/development/compiling/cross-compiling_for_ios_on_linux.html).

**Graphics driver and device floor**
- `rendering/rendering_device/driver.ios` defaults to `metal`; `vulkan` via MoltenVK is the alternative — [ProjectSettings @4.7.2](https://github.com/godotengine/godot/blob/4.7.2-stable/doc/classes/ProjectSettings.xml).
- The `capabilities/performance_a12` export option limits installs to the iPhone XS/XR generation and newer — [EditorExportPlatformIOS @4.7.2](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/ios/doc_classes/EditorExportPlatformIOS.xml).
- It is auto-enabled for Forward+/Mobile since 4.5.2 and 4.6 beta 2 — [4.5.2](https://godotengine.org/article/maintenance-release-godot-4-5-2/).

**Minimum iOS version (sources disagree)**
- Source code: the default `min_ios_version` is "15.0", and validation warns "Metal renderer require iOS 14+" — [ios export_plugin.h/.cpp @4.7.2](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/ios/export/export_plugin.h).
- Docs: iOS 15.0 for Forward+/Mobile with Vulkan, and iOS 16.0 with Metal — [System requirements](https://docs.godotengine.org/en/4.7/about/system_requirements.html).
- The docs and the code disagree on the Metal minimum.

**Privacy manifest**
- 153 `privacy/*` export options, including `privacy/collected_data/advertising_data/{collected, linked_to_user, used_for_tracking, collection_purposes}` and `privacy/file_timestamp_access_reasons` (required-reason API) — [EditorExportPlatformIOS @4.7.2](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/ios/doc_classes/EditorExportPlatformIOS.xml).
- These were introduced in 4.3: 4.2.2 had 6 privacy options — [@4.3-stable](https://github.com/godotengine/godot/blob/4.3-stable/platform/ios/doc_classes/EditorExportPlatformIOS.xml).

**Xcode 26 and iOS lifecycle**
- 4.6.3: "Export: iOS: Fix one-click deploy with Xcode 26" — [4.6.3](https://godotengine.org/article/maintenance-release-godot-4-6-3/).
- 4.6.2: "iOS: Add UIScene lifecycle events" — [4.6.2](https://godotengine.org/article/maintenance-release-godot-4-6-2/).
- 4.6 beta 1: "SwiftUI lifecycle for Apple embedded platforms" — [4.6 beta 1](https://godotengine.org/article/dev-snapshot-godot-4-6-beta-1/).

**Dependencies, shader baker and other iOS features**
- CocoaPods and SPM: no CocoaPods handling appears in the iOS exporter or docs; my grep found no "Podfile" or "cocoapod" in the 4.7.2 iOS export source. SPM support for `.gdip` plugins is new in 4.8 dev1 — [4.8 dev 1](https://godotengine.org/article/dev-snapshot-godot-4-8-dev-1/).
- The Poing AdMob plugin references Google's SPM packages for its iOS SDKs — [Poing docs/index.md](https://github.com/poingstudios/godot-admob-plugin/blob/main/docs/index.md).
- The shader baker is an iOS export option (`shader_baker/enabled`) for Forward+/Mobile — [EditorExportPlatformIOS @4.7.2](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/ios/doc_classes/EditorExportPlatformIOS.xml).
- HDR output on iOS (4.7) and SDL3-based controller support on iOS (4.7) — [4.7 release](https://godotengine.org/releases/4.7/).

### Inferences
- iOS builds need a Mac, physical or rented (for example a macOS CI runner). This is the main point of friction with a "free tools only" policy: Godot and Xcode are free, but the Apple Developer Program fee and access to Mac hardware are unavoidable.
- Danfo's privacy-manifest entries for AdMob, UMP and ATT can be filled in Godot's export options. Third-party SDKs bring their own manifests.
- Use Metal with the A12 floor, which is the default. The Compatibility renderer would widen the iOS device range, but probably isn't worth it given iOS device-age distributions.

### Gaps
- I could not confirm Godot 4.7.2's compatibility with the iOS 26 SDK, or Apple's current minimum-SDK requirement for App Store uploads, from official text beyond the fixes listed above. This should be checked against Apple's upload requirements.
- I could not determine whether Godot exports already set the UIScene manifest entries Apple may require for apps built with newer SDKs.

## Q9. Shipped commercial 3D mobile games made with Godot 4 (especially driving), with performance or postmortem write-ups

### Takeaway
The official showcase lists several shipped mobile Godot titles: Rift Riff, Spooky Express, Kamaeru, Boxbound and Hazard Days. Hazard Days is a 3D mobile shooter. The Foundation's April 2026 mobile update contains real crash-rate data from two of these launches.
- I found **no shipped Godot 4 3D mobile driving or racing game** in official sources.
- The nearest racing example is Walaber's desktop arcade rally game, built with Godot 4.2.
- Danfo would be among the early commercial 3D mobile driving games on Godot 4, which is a pioneering-risk factor.

### Cited Findings
- Hazard Days Extraction Shooter (Skytec Games) is a 3D extraction shooter on Android and iOS, released July 2024. The listing does not state the Godot version — [Godot showcase entry (source)](https://github.com/godotengine/godot-website/blob/master/collections/_showcase/hazard-days-extraction-shooter.md).
- Other mobile titles in the showcase:
  - Rift Riff (May 2025; Windows, macOS, Linux, iOS, Android) — [showcase (source)](https://github.com/godotengine/godot-website/blob/master/collections/_showcase/rift-riff.md).
  - Spooky Express (Oct 2025; iOS and Android) — [showcase (source)](https://github.com/godotengine/godot-website/blob/master/collections/_showcase/spooky-express.md).
  - Boxbound: Package Puzzles (Apr 2025; includes a mini-game where you "drive the delivery truck") — [showcase (source)](https://github.com/godotengine/godot-website/blob/master/collections/_showcase/boxbound-package-puzzles.md).
  - Callbreak (the developer claims 100M+ players; a 2D card game) — [showcase (source)](https://github.com/godotengine/godot-website/blob/master/collections/_showcase/callbreak.md).
- Kamaeru (Humble Reeds) and Rift Riff launched on mobile stores in Dec 2025 and reported crash data. After the fixes, crash rates went from about 4% to under 1% — [Mobile update, Apr 2026](https://godotengine.org/article/godot-mobile-update-apr-2026/).
- Spin Hero (Goblinz Studio) is on Google Play and the App Store — [Mobile update, Apr 2026](https://godotengine.org/article/godot-mobile-update-apr-2026/).
- Godot community polls: "about 49% of Godot developers target mobile platforms" — [Mobile update, Apr 2026](https://godotengine.org/article/godot-mobile-update-apr-2026/).
- Parking Garage Rally Circuit (Walaber), "a delightfully retro arcade rally racing [game]… developed using Godot 4.2", on Steam (desktop) — [4.3 dev 4](https://godotengine.org/article/dev-snapshot-godot-4-3-dev-4/).

### Inferences
- The evidence supports Godot 4 for 2D and light-3D mobile games, with a growing record on store crash stability. It does not yet include a published, commercially proven 3D mobile driving game.
- Danfo should budget for engine-level investigation, such as GPU driver bugs, physics tuning and memory limits on 2 GB devices.
- It should also plan to share crash data with the Foundation (Play Console symbolication), as Kamaeru and Rift Riff did.

### Gaps
- I found no performance postmortems (FPS, memory, APK size, device coverage) for 3D Godot 4 mobile games, and no confirmation of which Godot version Hazard Days uses. Talks from GDC, GodotCon or GodotFest 2025–2026 could not be searched once the budget ran out.

## Q10. Headless/CLI export on Linux for CI (Android), and how text-based scenes and GDScript affect AI-assisted development and code review

### Takeaway
Android exports can be fully scripted on Linux: `godot --headless --export-release <preset> <path>` with `--install-android-build-template`, which suits free CI runners. iOS still needs a macOS runner. Godot's text formats are human-readable and VCS-friendly: `.tscn`, `.tres`, `.gd`, `.uid` files and `export_presets.cfg`. This suits AI coding agents well, with some churn hazards (UIDs, node IDs, one-line Object serialisation that 4.8 improves).

### Cited Findings
**CLI export**
- `--headless` enables headless mode.
- `--export-release <preset> <path>` exports "using the given preset… defined in export_presets.cfg"; `--export-debug`, `--export-pack` and `--export-patch` are also available.
- `--install-android-build-template` installs the Gradle template "in conjunction with --export-release or --export-debug".
- The docs give the example `godot --headless --path path_to_your_project --export-release my_export_preset_name game.exe`, and say `--headless` is required on platforms without a GPU for CI.
- `--lsp-port` and `--dap-port` serve the GDScript Language Server and Debug Adapter Protocol.
- Source: [Command line tutorial](https://docs.godotengine.org/en/4.7/tutorials/editor/command_line_tutorial.html).

**Toolchain**
- Android exports need the Android SDK and a JDK (17 recommended) — [Exporting for Android](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_android.html).
- 4.8 adds editor automation for setting up the Android SDK and Java — [4.8 beta 1](https://godotengine.org/article/dev-snapshot-godot-4-8-beta-1/).

**Text formats and version control**
- TSCN files "have the advantage of being mostly human-readable and easy for version control systems to manage" — [TSCN file format](https://docs.godotengine.org/en/4.7/engine_details/file_formats/tscn.html).
- 4.4 introduced `.uid` sidecar files. These "should not be added to .gitignore" and must be moved along with scripts — [UID changes in 4.4](https://godotengine.org/article/uid-changes-coming-to-godot-4-4/).
- 4.6 unique node IDs are saved in scene files, and users should re-save all scenes via "Upgrade Project Files" — [4.6 release](https://godotengine.org/releases/4.6/).
- 4.8 dev 2 split Object data that was previously "batched together on a single line" into a multi-line diff, because single-line serialisation made "parsing differences between file versions nearly impossible" — [4.8 dev 2](https://godotengine.org/article/dev-snapshot-godot-4-8-dev-2/).
- 4.8 adds an experimental symbol-renaming tool — [4.8 dev 7](https://godotengine.org/article/dev-snapshot-godot-4-8-dev-7/).
- 4.6 defines the GDExtension interface in JSON "to read, analyze, and work with the API automatically" — [4.6 release](https://godotengine.org/releases/4.6/).
- The Poing AdMob plugin ships an AGENTS.md and markets itself as "AI-Agent Ready" — a maintainer claim — [README](https://github.com/poingstudios/godot-admob-plugin/blob/main/README.md).

### Inferences
- **CI plan**: run Android AAB builds (a debug APK for each pull request, a release AAB on tags) on a free Linux runner with the pinned Godot 4.7.2 binary and export templates, the Android SDK and JDK 17. Run iOS on a macOS runner or locally.
- Keep `export_presets.cfg` under version control. Inject keystore and provisioning secrets through environment variables or CI secrets, never in the repository.
- **AI agents**: most scene and script changes can be generated and reviewed as plain text diffs. To reduce noise:
  - commit `.uid` files;
  - always re-save scenes in the pinned editor version;
  - avoid hand-editing `.tscn` sub-resource IDs;
  - run headless import and validation (`--headless --import`, test scenes) in CI to catch broken references.

### Gaps
- I found no official GDScript formatter or linter. The `.gdlintrc` in the Poing repo suggests the community uses gdtoolkit, which I did not verify. I also found no benchmark of AI-agent success rates on Godot projects.

## Q11. Crash reporting: Sentry Godot SDK and Firebase Crashlytics options

### Takeaway
**Sentry for Godot is official, built by Sentry's own getsentry organisation.** It is a GDExtension built on sentry-native; v2.3.0 was released 29 Sep 2026, and it supports Godot 4.5+, Android (including arm32) and iOS.
- Godot itself now gives you Android native debug symbols for Play Console (4.5+) and GDScript backtraces in release builds (4.5+).
- I found no maintained Godot plugin for **Firebase Crashlytics**. The main Firebase plugin covers other services.

### Cited Findings
- `getsentry/sentry-godot` releases: 2.0.0 26 Jun 2026; 2.0.1 29 Jun; 2.1.0 16 Jul; 2.1.1 3 Aug; 2.2.0 15 Sep; **2.3.0 29 Sep 2026**. The last commit was 16 Oct 2026.
- README:
  - "Built as a C++ GDExtension library using mature Sentry SDKs like sentry-native";
  - 1.x and 2.x releases need "Godot 4.5 or later";
  - platforms: Android arm64, arm32, x86_64 and x86_32; iOS device and simulator; Web from 1.4.0; C# from 2.0.0;
  - the feature list includes crash reports, script errors, hardware info, user feedback and attachments.
  - Source: [getsentry/sentry-godot](https://github.com/getsentry/sentry-godot).
- Godot 4.5: "Script backtracing… Even in 'Release' builds", which requires the "Always Track Call Stacks" setting, plus custom loggers to intercept errors — [4.5 release](https://godotengine.org/releases/4.5/).
- Android native debug symbols are provided for official templates for every release, with instructions for uploading them to the Play Console — [Mobile update, Apr 2026](https://godotengine.org/article/godot-mobile-update-apr-2026/); [Resolving crashes on Android](https://docs.godotengine.org/en/4.7/tutorials/platform/android/resolving_crashes_on_android.html).
- Perfetto is the default tracing tool for Android template builds (4.7) — [4.7 release](https://godotengine.org/releases/4.7/).
- GodotNuts/GodotFirebase's README lists Authentication, Database, Firestore, Functions and Storage, with no Crashlytics. Its last commit was 13 Sep 2026 — [GodotNuts/GodotFirebase](https://github.com/GodotNuts/GodotFirebase).

### Inferences
- **A free-tier stack:**
  - Play Console Android vitals with the uploaded Godot native symbols;
  - App Store Connect / Xcode Organizer crash logs;
  - optionally, Sentry's free developer tier if its event quotas fit.
- Sentry adds an SDK to the app and sends data off-device. It must be declared in the Play Data Safety form and the iOS privacy manifest, and gated by consent where required.
- Crashlytics would need a custom native plugin. It is not worth the effort when Play vitals, symbols and Sentry already cover the need.

### Gaps
- I did not verify Sentry's free-plan quotas and pricing in October 2026, or any community Crashlytics plugin for Godot 4; the search budget was exhausted.

## Synthesis: strengths, known gaps and risks of Godot 4.7.2 for Danfo

### Takeaway
Godot 4.7.2 is a viable, actively improving, royalty-free base for Danfo. The ad and crash-reporting needs are met by maintained plugins (Poing AdMob 5.1, Sentry Godot 2.3), and Android CI and export are scriptable on Linux. The main risks are specific to Danfo's scenario:
- low-end Android GPU drivers combined with the renderer choice;
- the engine's 24–26 MB compressed native-library baseline;
- vehicle physics that must be custom-built;
- no shipped 3D mobile driving reference title on Godot 4;
- iOS still needing a Mac.

### Cited Findings
- Strengths and risks are drawn from Q1–Q11 above. The key primary sources are the [4.7 release page](https://godotengine.org/releases/4.7/), the [Mobile update, Apr 2026](https://godotengine.org/article/godot-mobile-update-apr-2026/), the [renderers docs](https://docs.godotengine.org/en/4.7/tutorials/rendering/renderers.html), the [VehicleBody3D class reference](https://github.com/godotengine/godot/blob/4.7.2-stable/doc/classes/VehicleBody3D.xml), [Poing AdMob](https://github.com/poingstudios/godot-admob-plugin) and [Sentry Godot](https://github.com/getsentry/sentry-godot).

### Inferences
**Strengths (verified)**
- MIT licence, no royalties, and free tools for Android.
- Jolt is the default physics engine (4.6+).
- Shader stutter mitigation: ubershaders (4.4) and the shader baker (4.5).
- 16 KB pages, target API 36, AAB, edge-to-edge and a v2 plugin system.
- armeabi-v7a still supported.
- Automatic GLES fallback.
- Built-in VirtualJoystick (4.7).
- The Foundation is visibly investing in mobile: GPU crash fixes, store plugins, Android test infrastructure.
- Mature AdMob plugins with UMP and mediation.
- Official Sentry SDK.
- Text-based, AI-friendly project files.
- Linux headless export.

**Known gaps (verified)**
- Play Asset Delivery is install-time only; no fast-follow or on-demand packs, and no iOS ODR.
- No official AppLovin MAX or LevelPlay plugin (unverified whether any community one exists).
- No mobile screen reader until 4.8.
- iOS plugin docs are outdated, and SPM support only comes in 4.8.
- VehicleBody3D is not suitable for a production vehicle.
- Double precision needs custom builds and is discouraged on low-end mobile.
- The Compatibility renderer lacks SMAA/FXAA, SSAO/SSR, ubershaders and (before 4.8) decals.

**Risks for Danfo (inferred)**
1. GPU driver fragmentation in the Nigerian Android market (Mali-G52, PowerVR, Unisoc), with no Godot-specific data. This must be mitigated with an early device lab.
2. The renderer decision. Mobile/Vulkan forces minSdk 29 by default, and low-end devices fall back to GLES anyway, so either commit to Compatibility or QA both paths.
3. Download size on data-constrained networks: the engine baseline is about 24 MB compressed per ABI. Plan custom size-optimised templates.
4. Effort for custom vehicle physics and AI traffic, and its CPU cost on 4–8 small cores.
5. Plugin bus factor, and having to keep plugins in step with Godot and Google SDK upgrades.
6. iOS needs Mac access plus the Apple Developer Program fee, which sits uneasily with a "free tools" constraint.
7. Pioneering risk: no shipped Godot 4 3D mobile driving game exists to benchmark against.

**Recommended pin**
- Godot 4.7.2 stable (18 Aug 2026) now.
- Re-evaluate 4.8.x after its first maintenance release.
- Keep 4.6.3 as the known-good fallback.

### Gaps
- Several items could not be checked because the session's web-search budget ran out and the Godot websites and GitHub issue pages were blocked:
  - community AppLovin MAX / LevelPlay / PAD / Crashlytics plugins;
  - Unisoc and Mali-G52 issue data;
  - the size of an empty-project APK;
  - 3D mobile postmortems;
  - iOS 26 SDK upload requirements.
- These should be verified in a follow-up session with web access.
