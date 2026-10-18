# Nigeria (and West Africa / diaspora) Device, OS and Network Landscape for "Danfo", as of 18 Oct 2026

Method note: The research was done on 18 Oct 2026. StatCounter, GSMArena, TechCabal, Medium, 42matters, TelecomLead and Google Support pages could not be fetched directly from this environment because of DNS/proxy blocks. Figures from those sites come from search-engine snippets of the named pages. They are cited to the page URL, but they were not read in full. developer.android.com and GitHub were fetched directly. The shared web-search budget ran out before the last checks (the exact chipset-to-GPU mappings for some Unisoc/MediaTek parts and the US iOS share), so those are listed under Gaps. StatCounter measures share of web page views, not installed base or sales.

## 1. Android vs iOS share; Android version distribution; iOS version spread (Nigeria)

### Takeaway
Nigeria is roughly 83–85% Android and 15–17% iOS by mobile page views in 2026. Android versions are spread out: Android 13 leads at about 18%, Android 10–12 together still make up about 39%, and Android 14+15 make up about 24%. iOS has a long tail of devices stuck on old versions: about 8% on iOS 15.8 and about 5% on iOS 16.7.

### Cited Findings
- StatCounter, mobile only, June 2026: Android 82.67%, iOS 17.16%; Linux, Unknown, KaiOS and Windows are each under 0.1%. — [StatCounter mobile OS Nigeria](https://gs.statcounter.com/os-market-share/mobile/nigeria)
- StatCounter, mobile + tablet, April 2026: Android 84.89%, iOS 14.92%. — [StatCounter mobile+tablet OS Nigeria](https://gs.statcounter.com/os-market-share/mobile-tablet/nigeria)
- Jan–Sep 2026 average, citing StatCounter: Android 84.3%, iOS 15.6%. — [MobiLoud](https://www.mobiloud.com/blog/android-vs-ios-market-share/)
- StatCounter, all platforms, Sep 2026: Android 66.46%, Windows 16.91%, iOS 12.38%. Desktop is a minor share, so the web is mobile-first. — [StatCounter all-platform OS Nigeria](https://gs.statcounter.com/os-market-share/all/nigeria)
- Android versions, StatCounter mobile+tablet, July 2026: Android 13 17.85%, Android 12 16.44%, Android 11 13.14%, Android 14 12.15%, Android 15 11.63%, Android 10 9.5%. The snippet gave only the top six versions, so the shares of Android 16 and of Android 9 and older were not visible. — [StatCounter Android version Nigeria](https://gs.statcounter.com/android-version-market-share/mobile-tablet/nigeria)
- Android versions, June 2026 (mobile): Android 13 ~17.65%, Android 12 ~16.5%, Android 14 ~12.42%, Android 15 ~11.71%. These are stable month to month. — [StatCounter Android version Nigeria (mobile)](https://gs.statcounter.com/android-version-market-share/mobile/nigeria)
- iOS versions, July 2026 (all iOS devices, top six only): iOS 26.5 25.13%, iOS 18.7 13.14%, iOS 15.8 7.91%, iOS 26.2 5.51%, iOS 16.7 4.87%, iOS 26.3 4.53%. — [StatCounter iOS version Nigeria](https://gs.statcounter.com/ios-version-market-share/all/nigeria)
- iOS versions, June 2026 (iPhone only): iOS 26.5 18.74%, iOS 18.7 11.62%, iOS 15.8 7.93%. — [StatCounter iOS version Nigeria (iPhone)](https://gs.statcounter.com/ios-version-market-share/iphone/nigeria)
- For comparison, global iOS rose from 25.7% (Aug 2025) to 32.5% (Aug 2026) of mobile page views. Nigeria's iOS share is about half the global figure. — [MobiLoud / StatCounter-derived summary](https://www.mobiloud.com/blog/android-vs-ios-market-share/)

### Inferences
- Android 10 (API 29) or later covers at least about 80.7% of Nigerian Android page views (sum of Android 10–15 in July 2026). The true figure is higher, because Android 16 is also above that floor but its share was not visible. Raising the minimum to Android 11 or 12 would lose about another 9.5% or about 23% respectively. Recommendation: target minSdk 29 (Android 10). Consider API 26–28 only if the engine and the 32-bit/Go analysis (section 3) make it cheap.
- iOS: the iOS 15.8 share (about 8%) almost certainly comes from devices that cannot upgrade beyond iOS 15 (iPhone 6s/7/SE 1st generation, A9/A10 chips). The iOS 16.7 share (about 5%) maps to iPhone 8/X (A11). The iOS 18.7 share (about 13%) includes iPhone XS/XR (A12), which cannot run iOS 26. These device-to-OS mappings come from Apple's compatibility history and were not re-checked in this session. Implication: an iOS floor of iOS 16 / A11 keeps about 92% of Nigerian iOS page views, and an iOS 17/18 floor (A12+) drops roughly 13% more. The point releases visible for iOS 26 alone add up to at least about 35%.
- In absolute terms, iOS users in Nigeria are a minority (about 15%). They are disproportionately urban and higher-income, which matters for ad eCPM (see section 8).

### Gaps
- StatCounter's Android 16 share and the share of Android 9 and older for Nigeria were not visible in the snippets.
- No Google Play Console public data was found for the Nigeria-specific Android version split by installs, as opposed to page views. AppBrain Nigeria data was not found.
- StatCounter weights toward people who browse the web. Users of low-end Go devices who rarely browse are probably under-counted. This is an inference, not measured.

## 2. Device brands, models, chipsets, GPUs and RAM; common iPhones

### Takeaway
Transsion (Tecno, Infinix, itel) holds about half or more of Nigerian sales. The 2025–26 volume models (Tecno Spark 40, Infinix Hot 60i, Redmi 14C/15C, Samsung Galaxy A06) cluster on MediaTek Helio G81/G85 with a Mali-G52 MC2 GPU and 4 GB of physical RAM, often sold as "4+4 GB" extended RAM. One step up is Helio G99 or Dimensity 6xxx with Mali-G57 MC2 (Galaxy A07, Spark 40 5G). Below that is a large tail of Unisoc T603/T7250/SC9863A Android Go phones with 2–3 GB of RAM. The market is shrinking and getting more expensive in 2026 because of memory costs, so older phones will stay in use longer.

### Cited Findings
**Market structure and shares**
- StatCounter vendor share, Nigeria, Sep 2026 (mobile+tablet page views): Tecno ~20.4%, Samsung ~17.4%, Infinix ~16.8%, Apple ~15.7%, Xiaomi ~12.9%, itel ~4.8%. — [StatCounter vendor Nigeria](https://gs.statcounter.com/vendor-market-share/mobile-tablet-/nigeria/2010)
- StatCounter, Aug 2026 (mobile only): Apple ~17.9%, Tecno 17.3%, Samsung 16.3%, Infinix 15.1%, Xiaomi 7.7%, "Unknown" 11.6%. — [StatCounter mobile vendor Nigeria](https://gs.statcounter.com/vendor-market-share/mobile/nigeria)
- Feb 2026 (StatiSense citing StatCounter): Tecno 18.92%, Infinix 16.75%, Samsung 15.21%, Apple 14.06%, Xiaomi 8.06%, itel 4.66%, Oppo 4.25%, Huawei 3.19%, Vivo 1.37%, Nokia 0.73%. — [StatiSense on X](https://x.com/StatiSense/status/2034000432847110443)
- Feb 2025: Tecno 23.55%; the three Transsion brands combined 50.69% (StatCounter-based). — [Intelpoint](https://intelpoint.co/insights/tecno-has-the-highest-share-among-phone-brands-in-nigeria-at-23-55-as-of-february-2025/)
- Sales basis: Transsion owned 56% of Nigerian smartphone sales in Q1 2025, with Xiaomi second (the same outlet gives Xiaomi 26%). The underlying source is unclear, so treat this as indicative. — [Mobility.com.ng](https://mobility.com.ng/?p=394132)
- Canalys: Nigeria shipments fell 7% in Q1 2025 as households put food first; Transsion brands dominated and Xiaomi grew 32% (Egypt + Nigeria). — [BusinessDay](https://businessday.ng/technology/article/nigerias-smartphone-market-slumps-7-as-households-focus-on-food/). Nigeria then grew about 10% in Q2 2025. Across Africa in Q2 2025, Transsion shipped 9.7M units (51% share) and Samsung 3.4M (18%). — [Developing Telecoms](https://developingtelecoms.com/telecom-technology/telecom-devices-platforms/18536-africa-s-smartphone-market-grows-for-eighth-straight-quarter.html); [The Condia](https://thecondia.com/nigeria-smartphone-market-2025-trends/)
- Omdia, 2Q26: Africa shipments fell 7% YoY, the first decline in three years. Transsion was still number one with 8.3M units (47% share, −14% YoY), while Samsung grew 15%. Nigeria fell 11% as higher prices made buyers delay purchases. Omdia forecasts Africa down 26% in 2026, with the sub-$100 segment shrinking 34%. Memory makes up about 60% of the bill of materials (BOM) for phones under $400 and over 64% for phones under $99. — [Omdia](https://omdia.tech.informa.com/om146997/africas-smartphone-market-is-expected-to-decline-26-in-2026-following-the-first-contraction-in-three-years); [TelecomLead](https://telecomlead.com/smart-phone/africa-smartphone-shipments-to-fall-26-in-2026-as-prices-rise-and-sub-100-market-shrinks-34-127414?amp=1); [Connecting Africa](https://www.connectingafrica.com/digital-divide/africa-smartphone-market-set-for-sharp-2026-decline)
- Nigeria average smartphone selling price was $134 in Q1 2026 (+2% YoY; Omdia). Prices are forecast to rise by up to 30% in 2026, with the $80–$150 band most exposed. An analyst says vendors can no longer profitably make $75 phones. The URL title reports Q1 2026 market growth of 8%. — [TechCabal, 3 Jun 2026](https://techcabal.com/2026/06/03/nigerias-smartphone-market-grew-8-in-q1/); [The Condia](https://thecondia.com/nigeria-smartphone-prices-rise-h1-2026/)
- Most-searched phones in Nigeria in 2025 (Google search interest, not sales): iPhone 17 first, then Tecno Pop 10, Tecno Spark 40 and Infinix Note 50 Pro, among others. — [TechEconomy](https://www.techeconomy.ng/most-searched-smartphones-in-nigeria-for-2025)

**Typical 2024–26 volume models and their silicon**
- Tecno Spark 40 (4G): MediaTek Helio G81, 4/6/8 GB LPDDR4X. A 5G variant uses the Dimensity 6400 (6 nm) with 4/8 GB. — [GSMArena Spark 40 4G](https://www.gsmarena.com/tecno_spark_40_4g-13984.php); [GSMArena Spark 40 5G](https://www.gsmarena.com/tecno_spark_40_5g-14568.php). Nigerian retail price is ₦165,000 (4+4 GB / 128 GB, Konga) to ₦184,600 (8 GB / 256 GB), May 2026. — [TechCabal](https://techcabal.com/2026/05/28/cheapest-phones-in-nigeria-and-their-prices/)
- Infinix Hot 60i: Helio G81 Ultimate, 4 GB RAM. Infinix Hot 60 5G: Dimensity 7020, 6 GB. — [NanoReview Spark 40 vs Hot 60i](https://nanoreview.net/en/phone-compare/tecno-spark-40-vs-infinix-hot-60i); [NanoReview Spark 40 vs Hot 60 5G](https://nanoreview.net/en/phone-compare/tecno-spark-40-vs-infinix-hot-60-5g)
- Xiaomi Redmi 15C: Helio G81, 4/8 GB, 6000 mAh. — [GSMchoice](https://www.gsmchoice.com/en/compare/tecno-spark-40-vs-redmi-15c/). Redmi 14C: Helio G81 Ultra (12 nm, 2×Cortex-A75 at 2.0 GHz + 6×A55 at 1.8 GHz), Mali-G52 MC2. — [GSMArena](https://www.gsmarena.com/redmi_14c_debuts_with_helio_g81_ultra_chipset_120_hz_lcd-news-64349.php)
- Xiaomi Redmi A5 and itel City 100: Unisoc T7250, reported to be a rebadged T615. Sources disagree on the GPU: Mali-G57 MP1 or MC1 is the most common answer, and one low-quality source says IMG GE8320. AnTuTu 10 is about 258k, versus about 412k for the Helio G100. — [Comparena](https://www.comparena.info/chipset/unisoc-t7250/); [Inquisitive Universe](https://inquisitiveuniverse.com/2025/07/13/helio-g100-vs-unisoc-t7250-t615/)
- Samsung Galaxy A06: Helio G85 (12 nm), Mali-G52 MC2. Galaxy A07 (4G): Helio G99 (6 nm, Cortex-A76 cores, Mali-G57 MC2), with 6 years of OS updates. — [GSMArena A07](https://m.gsmarena.com/samsung_galaxy_a07_4g_unveiled_with_helio_g99_6_years_of_os_updates-news-69194.php); [91mobiles G85 vs Exynos 1330](https://www.91mobiles.com/processor/samsung-exynos-1330-vs-mediatek-helio-g85)
- The Exynos 1330 (reportedly in the Galaxy A17 5G and others) has a Mali-G68 MP2. — [91mobiles](https://www.91mobiles.com/processor/samsung-exynos-1330-vs-mediatek-helio-g85)
- itel A05s: Unisoc SC9863A1, 2 GB RAM, Android 12 (Go edition), about ₦81,990 (2023 device, still listed). — [NaijaTechGuide](https://www.naijatechguide.com/itel-a05s.html)
- itel A50: Unisoc T603 (12 nm octa-core), 2 or 3 GB RAM, 64 GB storage, Android 14 (Go edition), about ₦91,200–99,000. — [Mobility.com.ng](https://mobility.com.ng/itel-a50-price-specs/); [NaijaTechGuide](https://www.naijatechguide.com/itel-a50.html). TechCabal calls itel one of Nigeria's most popular brands because of price (A90, A80, A50C). — [TechCabal](https://techcabal.com/2025/05/29/the-best-itel-phone-in-nigeria-for-2025/)
- Entry prices for new phones in mid-2026: the cheapest new phone with a warranty starts at ₦90,750 (Tecno Pop 9 KL4, 3 GB + 64 GB); Pop 9 4 GB + 128 GB costs ₦117,150; POCO C71 3/64 GB costs ₦102,182 (Jumia flash sale). Phones under ₦70,000 from Instagram sellers and roadside markets are "almost always used". — [TechCabal](https://techcabal.com/2026/05/28/cheapest-phones-in-nigeria-and-their-prices/); [NaijaTechGuide](https://www.naijatechguide.com/best-budget-smartphones-in-nigeria-under-200000-naira.html)

**"Extended RAM"**
- Transsion's "MemFusion" virtual RAM uses storage as swap. The Infinix Note 11 Pro, for example, goes from 8 GB to 11 GB, and the Tecno POVA Neo can add up to 5 GB. It is slower than real RAM. Vendor claims are about faster app relaunch and multitasking, not frame rate. — [Mobility.com.ng](https://mobility.com.ng/infinix-note-11-pro-extended-ram); [HapaKenya](https://hapakenya.com/2021/11/15/infinix-note-11-pro-boosts-ram-capacity-to-11-gb-in-a-bid-to-enhance-customer-experience)

**iPhones (used market)**
- Lagos dealers import "London-used" iPhones from the UK and elsewhere. One example buyer paid ₦250,000 for a used iPhone 11. — [TechCabal](https://techcabal.com/?p=103123)
- An older (about 2022) piece says the bestselling iPhones in Nigeria are used iPhone 7 to X/XR models, not the 11 series and up. It is internally inconsistent. — [Mobility.com.ng](https://mobility.com.ng/?p=16120)
- Used iPhone 7 prices in Aug 2025 were about ₦90,000–145,000, depending on storage. — [AndroidPols](https://www.androidpols.com.ng/2025/08/how-much-is-iphone-7-august-2025-price.html)

### Inferences
- Proposed device tiers for Danfo (inferred from the above):
  - **Floor / "Low" preset (must run, 30 fps at reduced settings):** Helio G81/G85 class (2×A75 + 6×A55, 12 nm), Mali-G52 MC2, 3–4 GB physical RAM, Android 10+. This covers the Galaxy A06, Redmi 14C/15C, Spark 40 4G and Hot 60i, which are the current volume sellers. A minimum spec above this tier would exclude the core of the market.
  - **Stretch floor / "Potato" preset (best effort):** Unisoc T603/T606/T7250 (Mali-G57 MP1, single core), Helio G35/G37 (PowerVR GE8320), 2–3 GB RAM, Android Go. These are itel A-series and Redmi A-series phones. They may need much smaller draw distance, fewer AI vehicles and pedestrians, and low-resolution textures, or a "not supported" gate.
  - **Target / "Medium" preset:** Helio G99/G100 or Dimensity 6300/6400 (Mali-G57 MC2), 4–8 GB. Examples: Galaxy A07, Spark 40 5G.
  - **High:** Dimensity 7020, Exynos 1330 (Mali-G68 MP2) and above; iPhone 11 and newer.
- Treat "4+4 GB" marketing as 4 GB. Memory budgets must assume physical RAM only, and swapping to slow eMMC/UFS storage will hurt streaming. A practical budget is about 1.0–1.2 GB resident on a 4 GB device and about 700–800 MB on 3 GB devices. This is an engineering heuristic, not sourced.
- The market contraction and price rises forecast for 2026 suggest the 2023–25 installed base (G85/G88/G99, T606/T616) will stay in use through 2027. Do not assume the floor rises quickly.
- iOS floor: iPhone 8/X (A11, 2–3 GB) or XR (A12, 3 GB) is the realistic used-market floor in Nigeria. iPhone 6s/7 (A9/A10, 2 GB) are still present but can be excluded at about 8% of iOS share.

### Gaps
- No Nigeria-specific model-level sales ranking (top 10 SKUs by units) for 2025–26 was found. Counterpoint, IDC and Canalys country breakdowns are paywalled or were not found.
- Not verified in this session (search budget exhausted): the exact GPUs for Helio G88/G91/G100, Dimensity 6300/6400, Unisoc T603/T606/T616 and SC9863A, and the chipsets of the Tecno Pop 9/Pop 10, itel A80/A90 and Galaxy A16/A17. Commonly reported mappings (G91/G88 → Mali-G52 MC2; G100/Dimensity 6300/6400 → Mali-G57 MC2; T603/T606/T616 → Mali-G57 MP1; SC9863A → PowerVR GE8322) should be checked against GSMArena or the vendors before being used in a spec sheet.
- No data was found on iPhone model distribution in Nigeria (for example from a used-phone marketplace or a Mixpanel/Unity-type device report).

## 3. Android Go and 32-bit-only userspace

### Takeaway
Android Go phones with 2–3 GB of RAM are still sold new in Nigeria (itel A05s, itel A50), and Android's own compatibility rules push such devices toward a 32-bit-only userspace. No public Nigeria-specific ABI share exists. The best available developer estimate is that about 9–10% of an app's users are on armeabi-v7a, and the Nigerian share is probably higher.

### Cited Findings
- Android 16 Compatibility Definition: handheld devices with under 2 GB of memory available to the kernel and userspace MUST support only a single ABI (64-bit only or 32-bit only). Devices with 2 GB to under 4 GB are "strongly recommended" to run a 32-bit-only userspace. — [Android 16 CDD](https://source.android.com/docs/compatibility/16/android-16-cdd)
- Android Go supports both arm64-v8a and armeabi-v7a. — [Wikipedia: Android Go](https://en.wikipedia.org/wiki/Android_Go)
- Nigerian Go devices currently on sale include the itel A05s (SC9863A1, 2 GB, Android 12 Go) and the itel A50 (T603, 2/3 GB, Android 14 Go). — [NaijaTechGuide](https://www.naijatechguide.com/itel-a05s.html); [Mobility.com.ng](https://mobility.com.ng/itel-a50-price-specs/)
- A developer report on the LiteRT GitHub (Oct 2025) says "at least 9–10%" of their users are on the armeabi-v7a ABI. This is one app's population, not a Google statistic. — [LiteRT issue #3926](https://github.com/google-ai-edge/LiteRT/issues/3926)
- An unsourced 2024 claim says 15–20% of Android devices use ARMv7a. Treat it as unreliable. — [GeeLark glossary](https://www.geelark.com/glossary/arm-v7a/)
- Newer mid-range SoCs are dropping 32-bit support entirely. The Galaxy A25 5G cannot run 32-bit apps. — [Wikipedia: Galaxy A25 5G](https://en.wikipedia.org/wiki/Samsung_Galaxy_A25_5G)

### Inferences
- If Danfo ships arm64-only, it will very likely be unavailable on, or fail on, the 2–3 GB Go devices with 32-bit userspace, which are the itel A-series and similar cheapest new phones. Given the 9–10% global estimate and Nigeria's skew toward the low end, a Nigerian share of 10–20% of potential installs on armeabi-v7a is plausible but unmeasured.
- Those same devices (2–3 GB, Mali-G57 MP1 or PowerVR GE8322 class) are also the least able to run an open-world 3D game. A defensible plan is to ship arm64 plus armeabi-v7a if the engine supports it cheaply, and use Play device-catalog exclusions or a "potato" preset. Alternatively, accept losing the Go tier and measure the loss in Play Console's device catalog after a soft launch.
- Play Console's device catalog, plus pre-launch reports filtered to Nigeria, is the authoritative way to measure this before deciding.

### Gaps
- No AppBrain or Google public dataset gives the armeabi-v7a share by country. No public Play Console figure for Nigeria was found.
- It was not verified whether specific Nigerian Go SKUs (itel A50/A05s, Tecno Pop Go variants) actually ship a 32-bit-only userspace, or how Play filters arm64-only apps on them.

## 4. Vulkan prevalence and GPU driver quirks (Mali, PowerVR, Unisoc)

### Takeaway
Worldwide, about 91% of active Android devices report Vulkan (mostly 1.1), and OpenGL ES 3.2 is close to universal (98% of handhelds). However, the low-end Mali-G52/G57 and PowerVR GE8320 GPUs that dominate Nigeria have many documented driver problems on both Vulkan and GLES. Per-device backend selection plus a GLES 3.x fallback is needed, and testing must happen on physical Nigerian devices.

### Cited Findings
- Android dashboard (28 days ending 24 Nov 2025, API 23+), handheld devices: no Vulkan 7.37%, 1.0.3 3.86%, 1.1 62.09%, 1.3 26.01%, 1.4 0.67%. All devices: none 8.85%, 1.1 60.52%, 1.3 26.22%. OpenGL ES 3.2 on 98.24% of handhelds (GLES 2.0 0.49%). — [Android Developers dashboards](https://developer.android.com/about/dashboards)
- Android Vulkan Profile support among Vulkan-capable devices: AVP 2021 95.5%, AVP 2022 86.5%, AVP 2025 80.1%. — [Android Developers dashboards](https://developer.android.com/about/dashboards). Vulkanised 2026 (Google): AVP 2025 at 81.5%; Vulkan 1.1 has been required since Android 15; "most Android devices don't get driver updates". — [Vulkanised 2026, Ian Elliott](https://vulkan.org/user/pages/09.events/vulkanised-2026/1200-Ian-Elliot-Vulkan%20on%20Android.pptx.pdf)
- VkQuality issue (23 Sep 2026): for Mali-G57/G52/G68 on driver versions r32.x and r38.x, VkQuality 1.2.4 recommends GLES ("GLES_BECAUSE_OLD_DRIVER"). The reporter's devices had been stable on Vulkan (0–1 fatal crashes across about 1,700 users). After switching them to GLES they crashed in Unity's GLES backend (BufferGLES::IsBusy), which became the top crash bucket at about 34% of fatal users (297 users in 5 days). Unity fixed this in 6000.3.24f1 (UUM-150590). — [android/vkquality #16](https://github.com/android/vkquality/issues/16)
- Vulkan crashes on Samsung Galaxy A06 (Mali-G52 MC2) with Unity 2022.3.49f1 (AVPro Video plugin). — [AVPro issue #2186](https://github.com/RenderHeads/UnityPlugin-AVProVideo/issues/2186)
- Redmi 14C (Mali-G52 MC2): vkCreateGraphicsPipelines fails (-3), followed by SIGSEGV in libGLES_mali.so. — [UnleashedRecomp-Android #122](https://github.com/SansNope/UnleashedRecomp-Android/issues/122)
- Unreal developers report a 100% crash on Mali-G52/G72 (Redmi 10, Galaxy S9) with Vulkan + MSAA, and random Vulkan crashes on Mali-G52 with certain MediaTek and Unisoc chips. They disabled Vulkan on those devices. — [Unreal Engine forum](https://forums.unrealengine.com/t/artifacts-and-crashes-on-some-android-gpus-and-versions-when-vulkan-is-enabled/2536208)
- On a Unisoc T618 with Mali-G52 MP2, Vulkan does not work in the Azahar emulator. A commenter says MediaTek's G52 MC2 drivers behave better. — [Azahar #1944](https://github.com/azahar-emu/azahar/issues/1944)
- Vulkan initialization crashes appeared on Mali devices after Android 16 updates and were resolved by later system updates. — [Rive community](https://community.rive.app/c/bug-reports/unity-android-vulkan-rendering-crash-on-startup)
- PowerVR GE8320 (Helio G35/G37 and similar), Unity issues:
  - On a Nokia G20 (Helio G35), the URP camera does not render when shadows are on and overlay cameras are stacked, on both Vulkan and GLES3. Fixed in 2022.3.53f1. — [Unity Issue Tracker](https://issuetracker-mig.prd.it.unity3d.com/issues/camera-view-is-not-rendered-on-powervr-rogue-ge8320-gpus-if-shadows-are-enabled-in-urp-asset-and-camera-stack-contains-overlay-cameras)
  - Texture glitches, closed as "Won't Fix". — [Unity Issue Tracker](https://issuetracker.unity3d.com/issues/android-textures-glitch-when-building-on-some-powervr-ge8320-devices)
  - URP project crashes. — [Unity Issue Tracker](https://issuetracker-mig.prd.it.unity3d.com/issues/android-urp-project-crashes-when-built-on-a-device-with-powervr-rogue-ge8320-gpu)
  - An internal PowerVR shader-compiler error. — [Unity Issue Tracker](https://issuetracker.unity.com/issues/2981/artifacts-appear-when-instantiating-a-prefab-on-a-powervr-rogue-gpu-device)
  - A crash in the MediaTek driver (libGLESv2_mtk.so) "most often when we have many RenderTextures in use". — [Imagination forums](https://forums.imgtec.com/t/powervr-ge8320-driver-bug-crash/3831); [Imagination forums](https://forums.imgtec.com/t/powervr-rogue-ge8320-crashing/3967)

### Inferences
- Rendering design rules for the floor tier: avoid MSAA on Mali-G52 when using Vulkan; keep the number of render targets and overlay cameras small; avoid camera stacking on PowerVR; compile pipelines and shaders ahead of time with a small shader-variant count; and allow a server- or config-driven per-device-model or per-driver denylist for Vulkan vs GLES. This denylist must work offline-first with a bundled default.
- Do not blindly trust VkQuality's GLES recommendation for Mali r32/r38. Validate it with crash-free metrics per backend.
- The global "9% no Vulkan" figure probably understates Nigeria, because of PowerVR GE8320/GE8322 and old-driver Mali devices. A GLES 3.0/3.1 path remains mandatory.
- The physical test device lab should include at least: Galaxy A06 (G85/Mali-G52 MC2), Redmi 14C or 15C (G81), Tecno Spark 40 4G (G81), a Galaxy A07 or other G99 phone (Mali-G57 MC2), an itel A50 or Redmi A5 (Unisoc T603/T7250, Mali-G57 MP1), a Helio G35/G37 device (PowerVR GE8320), and an iPhone 8 or XR.

### Gaps
- Nigeria-specific Vulkan or GLES capability shares were not found. Google's dashboard is global only.
- Unisoc-specific Mali driver problems (T606/T616/T7250) were found only anecdotally. No IMG BXM (Dimensity 7020) quirk reports were found.

## 5. Mobile data cost, Wi-Fi availability, and download size vs install conversion

### Takeaway
Data is expensive relative to income and became about 50–65% dearer after the February 2025 tariff hike. 1 GB costs roughly ₦350–750 depending on the bundle. Home Wi-Fi (fibre) is almost non-existent at about 0.3 million FTTH subscriptions against about 157 million internet subscriptions. Google's own (2017) data shows install conversion falling about 1% per 6 MB, and more steeply in emerging markets. Download size is therefore a first-order acquisition lever.

### Cited Findings
- The NCC approved a 50% tariff increase on 20 Jan 2025, effective around 11 Feb 2025. It was the first since 2013. — [BusinessDay](https://businessday.ng/?p=949775); [TechCabal](https://techcabal.com/?p=151978)
- BusinessDay's survey of operator sites: the average 1 GB price across MTN, Airtel, Glo and 9mobile rose 65.22%, from ₦287.5 to ₦475. Airtel 1 GB went from ₦350 to ₦500 and MTN from ₦200 to ₦350. The NCC floor-based figure is ₦431.25; another outlet says ₦350 → ₦525. — [BusinessDay](https://businessday.ng/?p=949775); [Brandtimes](https://www.brandtimes.com.ng/?p=30424)
- MTN's 15 GB weekly bundle went from ₦2,000 to ₦6,000. MTN later apologised. MTN's 1.5 GB monthly plan (₦1,000) was replaced by 1.8 GB for ₦1,500. — [The Condia](https://thecondia.com/mtn-nigeria-data-price-hike-2025/); [Zikoko](https://www.zikoko.com/?p=339482). Airtel's cheapest monthly plan is 2 GB for ₦1,500. — [BusinessDay](https://businessday.ng/?p=949775)
- 2026 MTN bundles (consumer blogs, not official, prices conflict):
  - 2 GB / 30 days for ₦1,500 (about ₦750/GB) is the most consistently reported. — [EverTry](https://evertry.co/blog/mtn-data-plans-nigeria-guide/); [NaijaSabi](https://naijasabi.com.ng/mtn-data-plans-nigeria-2026/); [Ricki](https://www.ricki.app/blog/mtn-cheap-data-codes)
  - 1 GB daily ₦500; 1 GB 7-day ₦800. — [Gizmosum](https://gizmosum.com/mtn-cheapest-data-plan/); [Ricki](https://www.ricki.app/blog/mtn-cheap-data-codes)
  - 7 GB ₦3,500; 10 GB ₦4,500; 25 GB ₦8,500–9,000 (about ₦350–450/GB on larger bundles). — [NaijaSabi](https://naijasabi.com.ng/mtn-data-plans-nigeria-2026/); [NaijaTechGuide](https://www.naijatechguide.com/mtn-data-plans-in-nigeria-with-prices.html)
- Price sensitivity: national data usage fell from a record of about 1 million TB in Jan 2025 to 893,054.8 TB in Feb 2025 after the hike, then recovered. — [BusinessDay](https://businessday.ng/technology/article/nigerias-internet-usage-dips-slightly-after-50-tariff-hike/)
- No new 2026 tariff hike was found in this search.
- NCC 2026 figures:
  - Internet subscriptions 157.4M (May 2026, +11% YoY). — [TechEconomy](https://techeconomy.ng/nigeria-internet-subscriptions-rise-to-1574-million-as-broadband-penetration-hits-561-in-may)
  - Broadband penetration 57.4% (124.4M) in July 2026, up from 53.07% in January. — [TechEconomy](https://techeconomy.ng/nigerias-broadband-penetration-reaches-574-as-subscriptions-rise-to-1244-million)
  - Traffic 1.66M TB in July 2026, against 1.13M TB in July 2025. — [TechEconomy](https://techeconomy.ng/nigerias-broadband-penetration-reaches-574-as-subscriptions-rise-to-1244-million)
  - Telecom subscriptions about 188M. — [Brandcom](https://brandcom.ng/2026/06/29/telecom-subscription-in-nigeria-rises-to-188m-as-broadband-penetration-reaches-55-67/)
  - Active internet subscribers 153M. — [ThisDay, Apr 2026](https://www.thisdaylive.com/2026/04/09/broadband-penetration-improves-as-active-internet-subscribers-hits-153m/)
- Fixed fibre (FTTH) subscriptions were only 319,735 in Q2 2026 (+48.9% QoQ from 214,750). — [TechEconomy / NCC](https://techeconomy.ng/ncc-nigerias-ftth-subscriptions-surge-49-to-319735-in-q2-as-fibre-investment-gains-momentum)
- Google Play (2017, "Shrinking APKs, growing installs"): for apps under 100 MB, each +6 MB lowers install conversion by about 1%. The effect is stronger in emerging markets, and more than 50% of Indian and Indonesian Android users had no Wi-Fi access. — [Google Play / Medium](https://medium.com/googleplaydev/shrinking-apks-growing-installs-5d3fcba23ce2)
- A secondary summary puts the emerging-market effect at about 2.5%. That figure could not be confirmed against the original text. — [Phiture ASO Monthly](https://phiture.com/asostack/aso-monthly-19-november-2017-black-friday-in-the-stores-apk-size-vs-d17cb53dcd29/); [AppFollow](https://appfollow.io/glossary/app-size), which itself calls the data "older".
- Play Asset Delivery: aimed at games over 200 MB. Install-time packs count toward the listed size and need at least 2× their size in free disk space. Fast-follow and on-demand packs do not count toward the listed size. Google advises keeping install-time packs small so users are not forced to free space. — [Android Developers: Play Asset Delivery](https://developer.android.com/guide/playcore/asset-delivery)

### Inferences
- Rough cost to the player: a 150 MB download costs about ₦55–110 and a 500 MB download about ₦175–375 at 2026 bundle prices. A 1 GB game would use half to two-thirds of the most common ₦1,500 monthly bundle (2 GB), so large downloads compete directly with WhatsApp, TikTok and other daily use.
- About 10.5 GB per internet subscription per month, nationally (1.66M TB ÷ 157.4M). This is a rough figure: the months are mixed and many users hold several SIMs. A 500 MB+ install is about 5% of an average month's data.
- Suggested budgets (inference):
  - Play initial download (base plus install-time content) of 100–150 MB or less. This is the main "first session" content: one Lagos district plus the race intro.
  - Extra districts, vehicles and HD textures delivered as fast-follow/on-demand packs with explicit "download on Wi-Fi / download now (X MB)" prompts.
  - A hard ceiling of about 400–500 MB total installed for the full game on low tier. Bus Simulator Indonesia (about 460 MB, section 9) shows the genre's tolerance ceiling.
  - Ad SDK and mediation bloat counts toward the budget.
- Updates are a data-cost event as well. Keep patches small (delta-friendly asset bundles) and avoid forced updates for offline play.
- Wi-Fi cannot be assumed. Any "download on Wi-Fi" option must not block play.

### Gaps
- No Nigeria-specific Google Play data on install conversion vs size was found, and no post-2017 Google figure was found. No "lite" app case study specific to Nigeria (for example Facebook Lite share in Nigeria) was retrieved.
- No official MTN/Airtel/Glo price lists for Oct 2026 were retrieved. The naira–US$ exchange rate was not sourced in this session, so USD conversions are omitted.
- The 2025 cable.co.uk Nigeria average price per GB was not found. Older figures (USD 0.88 in 2021, and others) conflict and predate the hike.

## 6. Storage constraints and uninstall-for-space behaviour

### Takeaway
New entry phones in Nigeria ship with 64 GB, and 128 GB from about ₦117k. After the OS, WhatsApp media and other apps, free space on budget phones is tight. Globally, freeing storage is the number one reason people delete apps (32%), and uninstall rates are highest in emerging markets with cheap phones. No Nigeria-specific measurement of free storage was found.

### Cited Findings
- Entry models: Tecno Pop 9 (3 GB + 64 GB, ₦90,750), POCO C71 (3/64 GB), itel A50 (64 GB). 128 GB starts with the Pop 9 4/128 GB at ₦117,150. — [TechCabal](https://techcabal.com/2026/05/28/cheapest-phones-in-nigeria-and-their-prices/); [Mobility.com.ng](https://mobility.com.ng/itel-a50-price-specs/)
- Airship survey (11,000 respondents in 10 countries, including Brazil, Indonesia, South Africa and Thailand; 2023): 32% delete apps to free storage, the top reason, and 30% because of too many in-app ads. — [MarketingProfs](https://marketingprofs.com/charts/2023/49361/why-people-delete-apps-from-their-phones)
- India (SanDisk, 2018): 29% run out of space weekly and 62% at least every three months. In 2016, 83% said they had to delete apps for space. This data is old. — [TechRadar](https://www.techradar.com/news/limited-storage-on-phone-hinders-fewer-indian-users-in-2018)
- AppsFlyer data: uninstall rates are highest in emerging markets where low-cost phones dominate. About 3 in 10 installed apps are eventually uninstalled. — [Singular](https://www.singular.net/?p=8190); [CleverTap](https://clevertap.com/blog/uninstall-apps/)
- WARC: in regions of low-cost entry phones with limited storage, "uninstalling is an ever-present threat". — [WARC](https://www.warc.com/newsandopinion/news/mobile-apps-need-to-be-small-relevant/en-gb/37513)
- Install-time asset packs need at least 2× their size free at install or update time. — [Android Developers](https://developer.android.com/guide/playcore/asset-delivery)

### Inferences
- Total on-device footprint, including caches and save data, should stay at about 500 MB or less on low tier. A 64 GB phone with WhatsApp media typically has only single-digit GB free; this is anecdotal and not sourced. Peak free space needed during an update (about 2× the install-time packs) can block updates and push players to uninstall.
- Danfo should show its storage use, let players delete optional content packs in game (for example other districts or HD textures), and avoid caching large ad creatives indefinitely.
- "Too many ads" is nearly as strong an uninstall trigger as storage (30% vs 32%). Interstitial frequency must be conservative.

### Gaps
- No Nigerian survey of typical free storage or of uninstall reasons was found. Google Play Vitals "uninstall due to storage" data is not public.

## 7. Power, heat and battery

### Takeaway
Grid power in Nigeria is unreliable. Households get about 5–9 hours of grid supply per day in surveys from 2022–24, and the national grid collapsed several times in 2026. Phone battery is therefore a scarce resource, often recharged from generators. Low-end 12 nm Helio/Unisoc chips throttle heavily under sustained load; even the 6 nm G99 loses 20–35% in throttling tests. A 30 fps cap and a battery-saver mode are essential.

### Cited Findings
- The national grid collapsed on 23 Jan 2026, with generation falling to zero. Later collapses followed: "second time in less than five days, third in less than one month". — [The Guardian Nigeria](https://guardian.ng/news/national-grid-suffers-first-collapse-of-2026-generation-falls-to-zero/); [AllAfrica](https://allafrica.com/stories/202601280045.html)
- Further 2026 collapses were reported. — [Gazette Nigeria](https://gazettengr.com/nigerias-power-grid-collapses-second-time-in-24-hours/); [Business Front](https://businessfront.com/energy/news/nigeria-national-grid-collapse-2026/)
- Coverage reports near-monthly grid collapses in 2024 and two major ones in 2025. Generation typically runs at 4,000–5,000 MW against an estimated 30,000 MW needed. Attribution to a specific article among the 2026 collapse reports is uncertain. — [Business Front](https://businessfront.com/energy/news/nigeria-national-grid-collapse-2026/)
- NOIPolls: average daily power supply was 8.9 h in Nov 2023 and 4.7 h in Feb and Apr 2024. A separate poll title says 6 in 10 households got under 5 hours a day in a Q1 period. — [NOIPolls trend](https://noi-polls.com/post/yearlong-trend-analysis-shows-power-supply-to-nigerians-still-inadequate); [NOIPolls Q1](https://www.noi-polls.com/post/6-in-10-nigerian-households-received-less-than-5-hours-of-power-supply-daily-in-q1)
- An NBS/World Bank survey of about 22,110 households (date unclear): about 6.8 h of grid power per day plus about 4.1 h of generator use. Over 98% of Lagos households report electricity access, against 19.2% in Taraba. — [BusinessDay](https://businessday.ng/?p=430885). An academic study (2023) puts it at 6.6 h per day for grid-connected households. — [arXiv](https://arxiv.org/pdf/2302.08800v1)
- An industry report (Stears/Sterling, 2022) says households have 15–18 h of electricity per day, of which about 6.8 h is self-generated, and over 40% own generators. It is cited via secondary coverage, and attribution is uncertain. — [21st Century Chronicle](https://21stcenturychronicle.com/?p=44189)
- Throttling: in a CPU throttling test, a Helio G99 Infinix Note 12 Pro lost about 35% and a G99 Poco M5 about 20%. Helio G96 phones lost more than 40% and ran hotter. The G99 was limited to 30 fps in COD Mobile. — [MySmartPrice](https://www.mysmartprice.com/gear/?p=291144)
- Helio G99 runs Genshin and Honkai Star Rail "fine" only at low graphics with a 30 fps limit. — [Unbox PH](https://unbox.ph/gadget/aqua-s11-pro-gaming-test/)
- Typical batteries in volume phones: 5000–6000 mAh (Spark 40 5200 mAh, Redmi 15C 6000 mAh). — [GSMchoice](https://www.gsmchoice.com/en/compare/tecno-spark-40-vs-redmi-15c/)

### Inferences
- Lock the floor and target tiers to 30 fps (possibly 25–30 with dynamic resolution). Offer a "battery saver" preset at about 24–30 fps with lower resolution. Avoid sustained full-CPU AI and physics, and limit simultaneous AI vehicles and pedestrians by tier.
- Benchmark sustained performance (20–30 minute runs) on G81/G85 hardware rather than peak, because 12 nm G8x parts likely throttle more than the 6 nm G99. That is inferred from the G96 vs G99 data; no G85-specific test was found.
- Offline-first matters for power reasons too. During outages cell towers on backup power may degrade (not sourced), and players conserve battery and data. Do not require network for core loops or for saving progress.

### Gaps
- No sustained-performance or thermal test was found specifically for the Helio G81/G85/G88 or Unisoc T606/T7250 in games.
- No 2025–26 nationally representative figure for household grid supply hours was found. No data on how often Nigerians charge phones from generators or power banks was found.

## 8. Ad market: rewarded/interstitial eCPMs and fill in Nigeria/Africa vs tier-1

### Takeaway
Reliable, dated, Nigeria-specific rewarded and interstitial eCPM data is not publicly available. The best signals put typical Nigerian and African eCPMs at about US$0.25–1.00, with well-designed rewarded placements occasionally reaching about $4. Tier-1 rewarded eCPMs are about $15–40. One tier-1 rewarded view is therefore worth roughly 20–50 Nigerian ones. Fill in thin-demand markets is a known problem, so mediation with multiple networks is needed.

### Cited Findings
- Nigeria CPM range US$0.25–0.80, format unspecified, in a 2026 guide, against US $5–12, UK $4.5–10, India $0.40–1.50 and Brazil $0.80–2.20. Vendor blog; methodology not stated. — [MonetizeMore](https://www.monetizemore.com/blog/how-much-ad-revenue-can-apps-generate/)
- A Nigerian indie developer (June 2025) says average eCPMs in most African markets are $0.50–1. With a small Nigeria-only user base, they reached about $4 eCPM using rewarded-style mechanics (spin-to-win, episodic unlocks). They believe roulette-style features attract betting and gambling ad demand. This is self-reported. — [Games Industry Africa](https://gamesindustryafrica.com/2025/06/02/nigerian-developer-shares-mobile-revenue-strategy/)
- Tier-1 2025 rewarded video at $15–40 and interstitials at $5–15, with tier-2/3 at $3–10. These are attributed to AppLovin's 2025 publisher benchmarks, but the underlying AppLovin document was not found. — [Coinis](https://coinis.com/glossary/rewarded-video); [MonetizeMore AdMob playbook](https://www.monetizemore.com/blog/admob-monetization/)
- An AdMob-focused guide: tier-1 rewarded $15–30 and interstitial $5–8; global averages $8–18 rewarded and $2.50–5 interstitial. Vendor blog. — [Playwire](https://www.playwire.com/blog/admob-ecpm-benchmarks-what-publishers-should-expect)
- Business of Apps (2024): rewarded about $10.50 and interstitial about $4.80 eCPM, all geos blended. — [Liftoff, citing Business of Apps](https://liftoff.ai/blog/in-app-advertising-in-2026-a-complete-guide-for-mobile-marketers/)
- Appodeal (2022): US Android rewarded eCPM fell from $24.48 (Jan) to $18.36 (Dec). Old data; no Nigeria figures. — [GameDev Reports / Appodeal](https://gamedevreports.substack.com/p/appodeal-yearly-ecpm-report-2023)
- An undated AdMob country list gives Nigeria $0.35. Low reliability. — [SR Zone](https://www.thesrzone.com/2024/01/admob-ecpm-rates-by-country.html)
- 42matters: 65% of Nigerian game publishers on Google Play use in-app ads, against 74% globally. — [42matters](https://42matters.com/how-do-nigerian-mobile-game-developers-monetize-their-games)
- Fill: AdMob's own case study for a Pakistani developer cites "a lack of local advertisers, resulting in poor fill rates" before optimisation. This is an analogous emerging market, not Nigeria. — [AdMob case study](https://admob.google.co.in/home/resources/nibg-achieves-200-percent-increase-in-ecpm/)
- Third-party networks still take 34–42% of mobile ad revenue after bidding became standard, which supports mediation. — [Applixir](https://www.applixir.com/?p=3098)
- A Tenjin/CAS report has country-level rewarded data for Q1 2024, but African figures were not visible. — [Gamigion](https://www.gamigion.com/ad-monetization-in-mobile-games-benchmark-report-2025/)

### Inferences
- Plan the revenue model on about $0.30–1.00 rewarded eCPM for Nigeria and about $0.15–0.50 interstitial. These are estimates, to be replaced with real mediation data after soft launch. Revenue per Nigerian daily active user will be very low, so volume, retention and ad frequency (bounded by uninstall risk) drive the economics.
- Diaspora and tier-1 iOS installs (section 10) carry outsized value per impression. Even a few percent of DAU from the UK or US could be a material share of revenue.
- Betting and gambling advertisers are a significant Nigerian demand source. Decide the content policy (age rating, blocking gambling categories) deliberately, because blocking may lower fill and eCPM.
- Offline-first conflicts with ad fill. Pre-cache rewarded ads when online, design rewarded offers to tolerate "no ad available" gracefully, and never gate progression on an ad being available.

### Gaps
- There is no authoritative 2025–26 public dataset (AppLovin MAX, Unity LevelPlay, AdMob, Appodeal) with Nigeria-specific rewarded and interstitial eCPM or fill. This needs direct data from a mediation account manager or a soft-launch test.
- No data was found on ad load times or no-fill under Nigerian network conditions, or on Android vs iOS eCPM differences within Nigeria.

## 9. Gaming behaviour: popular games, driving/bus games, sizes, sessions

### Takeaway
Nigeria has about 46.5 million gamers, 90% of them on mobile, and about $300M in revenue (2024). The charts are led by football (Dream League Soccer), Free Fire, casual games, and naira-reward or betting-style games, plus Lagos-themed life simulators. A Lagos-life browser game reached more than 2 million players in days in October 2026, which shows strong local-theme pull and the appeal of zero-install play. The genre comparison, Bus Simulator Indonesia, is about 460 MB.

### Cited Findings
- Carry1st–Newzoo (2024 data): Nigeria has 46.5M gamers and $300M revenue, with 90% playing on smartphones. Africa has 349M gamers, 304M of them on mobile, and a market over $1.8B with mobile at about $1.6B. — [Outlook Respawn](https://respawn.outlookindia.com/amp/story/gaming/gaming-news/africas-gaming-revenue-surges-egypt-claims-the-top-spot); [GameDev Reports](https://gamedevreports.substack.com/p/newzoo-and-carry1st-african-gaming). Maliyo Games' 2025 report: 46.6M active players, 90% on mobile. — [Games Industry Africa, Nov 2025](https://gamesindustryafrica.com/2025/11/05/nigerias-gaming-market-surpasses-46-million-players-as-esports-gains-national-momentum/)
- Appfigures, Google Play Nigeria top free games (2026 snapshot, hourly chart): Dream League Soccer 2026 at number one, then Waje Special, Naija Life: Lagos Simulator and Football League 2026, with Free Fire, Candy Crush Saga and Ludo Naira also high. — [Appfigures](https://app.appfigures.com/top-apps/google-play/nigeria/games)
- An older 42matters snapshot (about 610 days old) shows Waje Casino-bet, Ludo Naira, Cryptomania and DLS 2025 leading. Its racing-category leader is Drive Zone: Car Simulator Game. — [42matters popular games Nigeria](https://42matters.com/most-popular-mobile-games-nigeria); [42matters racing Nigeria](https://42matters.com/most-popular-racing-games-nigeria)
- "Lagos Life" (Vatar), a Nigerian browser-based life simulator, has its own dashboard showing more than 2M total players, 145k concurrent players and 16.5M visits by 5 Oct 2026. These figures are unaudited. It is not on Google Play and needs no download. — [BrandSpur, 8 Oct 2026](https://brandspurng.com/2026/10/08/nigerian-made-lagos-life-game-attracts-over-1-million-players-after-launch/); [The Condia](https://thecondia.com/lagos-life-game/); [Arise TV](https://www.arise.tv/how-lagos-life-is-capturing-young-nigerians-online/)
- Other Nigerian browser games include "Lagos Run" (driving a danfo through Lagos traffic) and "Danfo Run". These are a direct thematic overlap, and possibly a naming conflict, for "Danfo". — [Techloy](https://www.techloy.com/lagos-life-nigerian-browser-games/); [WeeTracker](https://weetracker.com/?p=91086)
- "Naija Life: Lagos Simulator" on Google Play is by GreatCallie, a different product from Lagos Life. — [The Condia](https://thecondia.com/lagos-life-game/)
- Bus Simulator Indonesia (Maleo) v4.3.4 APK is about 461 MB with a minimum of Android 7.0. Later 4.4/4.5 builds are about 460–600 MB. APKMirror is a third-party mirror. — [APKMirror](https://www.apkmirror.com/?p=8010707)

### Inferences
- Lagos-themed content has strong pull (Lagos Life, Naija Life, Lagos Run). Danfo's theme is well-positioned, but competition on theme and name is emerging. A trademark and store-name check for "Danfo" is advisable.
- Lagos Life's virality as a zero-install browser game suggests a web or instant-play teaser could be an acquisition funnel that avoids the data and storage barrier.
- Chart leaders such as DLS and Free Fire are deliberately optimised for low-end devices. Danfo's floor tier should aim to match their device reach.
- Session patterns: no data was found. Given commuting in Lagos traffic, intermittent power and data budgets, design for short (3–8 minute) offline sessions with quick resume. This is an inference only.

### Gaps
- No data was found on session length or frequency for Nigerian mobile gamers.
- No current download sizes were found for DLS 2026, Free Fire, Drive Zone, Car Parking Multiplayer or Dr. Driving. No Play install counts were found for Naija Life: Lagos Simulator.
- No grossing charts for Nigeria were found beyond an old 42matters page.

## 10. Diaspora iPhone users (UK/US) as a secondary iOS audience

### Takeaway
The Nigerian-born diaspora is about 0.29M in the UK (2021/22 census) and about 0.45–0.48M in the US (2022–23), with more second-generation and Nigerian-identifying people beyond that. The UK is about 51–54% iOS, on recent iOS versions. This is a small but high-eCPM, iOS-heavy audience whose phones are far above the Nigerian floor.

### Cited Findings
- England and Wales 2021 Census: 270,768 residents born in Nigeria, up from 191,183 in 2011. — [ONS FOI](https://www.ons.gov.uk/aboutus/transparencyandgovernance/freedomofinformationfoi/ukresidentsborninnigeriaoridentifyasnigerian); [ONS FOI 2022/4711](https://cy.ons.gov.uk/aboutus/transparencyandgovernance/freedomofinformationfoi/2021censusstatisticsnigeriansintheuk). The UK-wide total including Scotland's 2022 census is 293,609. — [Wikipedia: British Nigerians](https://en.wikipedia.org/wiki/British_Nigerians)
- US: about 448.4k Nigerian-born immigrants in 2022 (MPI via Intelpoint), growing about 4.8% a year. A secondary source gives about 476k for 2023. — [Intelpoint](https://intelpoint.co/insights/the-population-of-nigerian-born-immigrants-in-the-us-increases-at-an-average-of-4-8-per-year/)
- UK mobile OS (StatCounter): iOS 51.43% and Android 48.55% (mobile, Aug 2026); iOS 53.92% (mobile+tablet, Jul 2026). — [StatCounter UK mobile](https://gs.statcounter.com/os-market-share/mobile/united-kingdom); [StatCounter UK mobile+tablet](https://gs.statcounter.com/os-market-share/mobile-tablet/united-kingdom)
- In the UK, iOS 26.5 alone was 68.79% of iOS usage in June 2026. — [StatCounter UK iOS version](https://gs.statcounter.com/ios-version-market-share/mobile-os/united-kingdom)

### Inferences
- An iOS build is justified less by Nigerian iOS share (about 15%) than by Nigerian high-income users plus the diaspora, whose rewarded eCPMs are an order of magnitude higher (section 8). Diaspora devices are recent, so iOS performance is not the constraint. The iOS minimum should be set by Nigerian used iPhones (iPhone 8/X/XR).
- Diaspora discovery will depend on cultural marketing (Nigerian social media and creators), not on store charts in the UK or US.
- The diaspora also includes Canada, Ireland and the Gulf states, which are not researched here.

### Gaps
- No US StatCounter iOS share was retrieved (search budget exhausted). No data was found on the device or OS mix of Nigerians specifically within the UK or US.
- No data was found on what share of a Nigerian-themed game's installs come from the diaspora (no case studies found).
