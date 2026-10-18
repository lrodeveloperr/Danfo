# Mobile performance, vehicle physics, open-world streaming and the OSM city pipeline for "Danfo" (low-end and mid-range Android/iOS, October 2026)

Research method note (read first):
- Research date: 18 Oct 2026. The web-search budget ran out partway through. Several primary hosts could not be reached from the research environment: developer.arm.com, support.arm.com, docs.godotengine.org, godotengine.org, unity.com, docs.unity3d.com, developer.qualcomm.com, osmfoundation.org, wiki.openstreetmap.org, opendatacommons.org and renderdoc.org.
- I worked around this in three ways:
  - **Godot:** I read the docs source directly, from a sparse clone of `godotengine/godot-docs` and `godotengine/godot` at master commit `81ab961`, dated 16 Oct 2026. GitHub links below point to those exact files.
  - **Arm:** I used the `ArmDeveloperEcosystem/arm-learning-paths` repo (the source of learn.arm.com) and the Khronos Vulkan-Samples performance tutorials, which Arm originally wrote.
  - **Licence and engine code:** I took the ODbL 1.0 legal text from the SPDX copy, and I read the Jolt Physics source directly.
- Claims marked "(via search excerpt)" come from a search-engine summary of that page, not from a full read. Treat their exact wording with some caution.
- Anything without a source appears only under **Inferences** or **Gaps**.

---

## 1. GPU/CPU budgets for low-end Android at 30 fps and mid-range at 60 fps (draw calls, triangles, texture memory, overdraw, shadows/post-processing on tile-based GPUs)

### Takeaway
No vendor publishes a single triangle or texture budget. Arm makes **frame time** the primary budget and suggests draw-call ceilings of about **<500 per frame (OpenGL ES) and <1000 (Vulkan)**. For Mali-G52/G57-class phones, practitioners work far below that, at roughly 100–200 draws.

On tile-based GPUs the real costs are bandwidth and fragment work: render-target loads and stores, MSAA resolves, shadow-map depth passes, full-screen post-processing and alpha overdraw. Vertex count matters less, unless the geometry is dense in a small screen area.

### Cited Findings
**Frame budgets**
- 60 fps means each frame must finish in under 16.66 ms; 30 fps gives 33.33 ms — [Unity mobile optimization tips (via search excerpt)](https://unity.com/how-to/mobile-game-optimization-tips-part-2).
- Arm's GPU Best Practices guide (rev 3.4, 2025) treats frame time as the key budget. It treats triangle count, memory bandwidth and processing cycles as secondary budgets for locating bottlenecks — [Arm GPU Best Practices Developer Guide rev 3.4 (via search excerpt)](https://documentation-service.arm.com/static/67a62b17091bfc3e0a947695).

**Draw-call budgets**
- Arm's guide advises fewer than **500 draw calls per frame for OpenGL ES** and fewer than **1000 for Vulkan**. It recommends batching objects that share render state — [Arm GPU Best Practices: Draw call batching (via search excerpt)](https://support.arm.com/documentation/101897/0304/Optimizing-application-logic/Draw-call-batching-best-practices).
- An older Arm blog says there is "no hard-and-fast rule" but recommends "no more than a few hundred draw calls per frame" (old, Midgard-era guidance) — [Arm blog, Mali Performance 5 (via search excerpt)](https://developer.arm.com/community/arm-community-blogs/b/mobile-graphics-and-gaming-blog/posts/mali-performance-5-an-application-s-performance-responsibilities).
- A third-party rule of thumb: under **100–150 draw calls** for mid-range devices, and fewer for budget hardware. This is not an official Unity figure — [GameDev.net tutorial (via search excerpt)](https://gamedev.net/tutorials/programming/why-your-unity-game-starts-lagging-on-mobile-and-how-to-fix-it-1-r6169).
- Unity forum veterans dispute that any fixed draw-call target applies to every project — [Unity forum (via search excerpt)](https://forum.unity.com/threads/which-should-i-optimize-batches-or-draw-calls.1227081/).
- Godot says OpenGL/OpenGL ES driver overhead per command is high ("Nearly every API command in OpenGL requires a certain amount of validation"). The goal is to "reduce these instructions to a bare minimum and group together similar objects" — [Godot docs, GPU optimization](https://github.com/godotengine/godot-docs/blob/master/tutorials/performance/gpu_optimization.rst).

**Vertices and tile-based rendering**
- Godot on tile-based GPUs: tile-based rendering "takes a toll on vertex performance". It also "struggles when there are small objects with a lot of geometry within a small portion of the screen". The guidance is "don't worry about vertex count on mobile, but avoid concentration of vertices in small parts of the screen" and use LOD for small, distant vehicles and NPCs. Skinning, morphs and vertex-lit objects add vertex cost — [Godot docs, GPU optimization](https://github.com/godotengine/godot-docs/blob/master/tutorials/performance/gpu_optimization.rst).
- Mali specifics (third-party compilation that cites Arm docs):
  - The effective tile size is **16×16 px**.
  - Forward Pixel Kill (FPK) commonly fails on small triangles; "an early ZS test is always more energy-efficient".
  - On Valhall, depth sampling with a reference or comparison value (shadow maps) costs **2×**.
  - Mali-G52/G76 run 8-thread warps and Valhall runs 16.
  - [azhirnov/cpu-gpu-arch Mali guide](https://github.com/azhirnov/cpu-gpu-arch/blob/main/gpu/ARM-Mali_Guide.md)

**Overdraw and transparency**
- Transparency is "particularly bad for fill rate", especially where transparent objects overlap. "In many situations, rendering more complex opaque geometry can end up being faster than using transparency." Fill rate is "very expensive" on mobile — [Godot docs, GPU optimization](https://github.com/godotengine/godot-docs/blob/master/tutorials/performance/gpu_optimization.rst).
- Godot's **Mobile renderer has no depth prepass** "for performance reasons", so it benefits most from occlusion culling to cut shading overdraw. Forward+ does run a depth prepass — [Godot docs, Occlusion culling](https://github.com/godotengine/godot-docs/blob/master/tutorials/3d/occlusion_culling.rst).
- Godot transparent objects are drawn back to front and are not material-sorted. The advice is to split only the transparent part of a mesh into its own surface — [Godot docs, Optimizing 3D performance](https://github.com/godotengine/godot-docs/blob/master/tutorials/performance/optimizing_3d_performance.rst).

**Bandwidth costs on tile-based GPUs (measured)**
- **Render-pass load/store** (Mali-G76): the bandwidth cost of loading or storing an uncompressed attachment is `width × height × bpp/8 × FPS`. That is about **575 MiB/s** for 2220×1080 RGBA8 at 60 fps. Using `LOAD_OP_CLEAR` instead of LOAD cut reads by **600 MiB/s**, and not storing depth cut writes by **555 MiB/s** — [Khronos Vulkan-Samples, render_passes](https://github.com/KhronosGroup/Vulkan-Samples/blob/main/samples/performance/render_passes/README.adoc). The samples date from about 2019–2020, but the tile-memory principles still apply.
- **MSAA**:
  - 4× MSAA resolved in tile memory with transient attachments cost only about **3% extra bandwidth**.
  - A separate resolve pass added about **5 GB/s**. At about **100 mW per GB/s** of DDR traffic, that is roughly **500 mW, or 20% of a ~2.5 W device power budget**.
  - [Vulkan-Samples, msaa](https://github.com/KhronosGroup/Vulkan-Samples/blob/main/samples/performance/msaa/README.adoc)
- **Subpasses and multipass** (on-chip G-buffer): about **55% fewer tiles and 55% less bandwidth** on Mali-G76 — [Vulkan-Samples, subpasses](https://github.com/KhronosGroup/Vulkan-Samples/blob/main/samples/performance/subpasses/README.adoc).
- **AFBC framebuffer compression**: up to 50% claimed, with about **33%** measured (788 → 528.6 MiB/s) — [Vulkan-Samples, afbc](https://github.com/KhronosGroup/Vulkan-Samples/blob/main/samples/performance/afbc/README.adoc).
- **Surface pre-rotation**: if the app does not pre-rotate in landscape, the compositor's rotation raised Mali-G72 read/write stalls from **12%/7% to 22%/17%** — [Vulkan-Samples, surface_rotation](https://github.com/KhronosGroup/Vulkan-Samples/blob/main/samples/performance/surface_rotation/README.adoc).
- **Shader precision**: `mediump`/FP16 "has long been used as a critical optimization for performance and bandwidth" on mobile GPUs — [Vulkan-Samples, 16bit_arithmetic](https://github.com/KhronosGroup/Vulkan-Samples/blob/main/samples/performance/16bit_arithmetic/README.adoc).

**Textures**
- Texture filtering "may account for up to half of total GPU energy consumption". Bilinear filtering with 2× anisotropic often beats trilinear with 1×, and anisotropic levels above 2× are "extremely costly". Mipmaps add **33%** memory. A 1024² diffuse texture may pair with 512² roughness or metal maps — [Android Developers, Texture optimization](https://developer.android.com/games/optimize/textures).

**Shadows and post-processing**
- Godot: "Reducing the size of shadowmaps can increase performance". The best shadow optimization is to "turn shadows off for as many lights and objects as possible". Post-processing and shadows are "expensive in terms of fragment shading" — [Godot docs, GPU optimization](https://github.com/godotengine/godot-docs/blob/master/tutorials/performance/gpu_optimization.rst).
- Godot's Compatibility renderer draws shadowed lights **multi-pass**, and they render in sRGB space, so light energy may need retuning — [Godot docs, Lights and shadows](https://github.com/godotengine/godot-docs/blob/master/tutorials/3d/lights_and_shadows.rst).
- Shadow-map draws often have poor **Vertex Memory Efficiency**, because interleaved vertex buffers fetch colour and normal data the depth pass never uses. Arm GPUs read whole **64-byte cache lines**. Split position into its own stream and diagnose with Frame Advisor — [Arm Learning Path, Optimizing vertex efficiency](https://learn.arm.com/learning-paths/mobile-graphics-and-gaming/optimizing-vertex-efficiency/) ([source](https://github.com/ArmDeveloperEcosystem/arm-learning-paths/tree/main/content/learning-paths/mobile-graphics-and-gaming/optimizing-vertex-efficiency)).

**Adreno**
- Adreno bins the frame into tiles in on-chip GMEM. LRZ (low-resolution Z, Adreno 5xx and later) rejects hidden geometry during binning.
- LRZ is disabled when a fragment shader writes depth, when Vulkan secondary command buffers are used, or in direct-rendering cases.
- Front-to-back submission is still recommended.
- Issuing many queries on a binned surface can push command-processor overhead to **20–40%**, versus 4–6% in direct mode.
- [Qualcomm Adreno GPU guide (via search excerpt)](https://developer.qualcomm.com/sites/default/files/docs/adreno-gpu/snapdragon-game-toolkit/gdg/gpu/gpu.html); [Adreno FAQ (via search excerpt)](https://developer.qualcomm.com/sites/default/files/docs/adreno-gpu/snapdragon-game-toolkit/gdg/gpu/faq.html)

**Godot renderer choice for low-end Android**
- Compatibility has a "low base rendering cost but a high scaling cost". Mobile has medium costs for both. Mobile "can run on old and low-end hardware but slower than Compatibility".
- Feature limits:
  - Compatibility uses RGBA8 LDR, supports no FXAA or SMAA, and has no compute.
  - Mobile uses RGB10A2, supports FXAA, SMAA and compositor effects, and does not support SSAO.
  - [Godot docs, Overview of renderers](https://github.com/godotengine/godot-docs/blob/master/tutorials/rendering/renderers.rst)
- Godot's `rendering_method` reference: "Mobile … does not scale as well to large scenes with many elements". Compatibility is "Low-end renderer designed for older devices", and its lighting is computed on non-linear sRGB data — [Godot ProjectSettings reference](https://github.com/godotengine/godot/blob/master/doc/classes/ProjectSettings.xml).
- On Android, Mobile uses Vulkan only and Compatibility uses OpenGL ES 3.0 only — [Godot ProjectSettings reference](https://github.com/godotengine/godot/blob/master/doc/classes/ProjectSettings.xml).

**Godot's 2026 mobile stability work**
- The April 2026 mobile update reports Vulkan API fixes and broken-driver workarounds. These came from two shipped games (Rift Riff and Kamaeru), whose user-perceived crash rates were about 4% on Google Play.
- Secondary reposts give a post-fix rate of "under 1%". I could not confirm that figure from the official page.
- [Godot blog, Mobile update Apr 2026 (via search excerpt)](https://godotengine.org/article/godot-mobile-update-apr-2026/); [Ziva.sh summary (via search excerpt)](https://ziva.sh/blogs/godot-mobile)
- Godot 4.5.2 added a workaround for an Adreno 5xx driver crash and urged Vulkan Mobile games on Google Play to upgrade — [Godot 4.5.2 RC1 (via search excerpt)](https://godotengine.org/article/release-candidate-godot-4-5-2-rc-1/).
- **Google Play thresholds**: bad-behaviour limits are a **1.09%** user-perceived crash rate overall and **8%** per phone model, and an ANR rate of **0.47%** overall and **8%** per phone model. Exceeding them can reduce Play visibility and add a store-listing warning — [Android vitals](https://developer.android.com/topic/performance/vitals).

### Inferences
- **Draw calls** for Danfo (on Mali-G52/G57 MC1–MC2, Helio G85/G99 and Unisoc T606):
  - Aim for **≤150 draws and roughly 100–200k on-screen triangles at 30 fps** in the low tier.
  - Aim for **≤300 draws and roughly 300–500k triangles at 60 fps** in the mid tier.
  - These sit well inside Arm's 500/1000 ceilings, because Godot's Mobile and Compatibility renderers have **no automatic instancing** (see Q2), and GDScript leaves less CPU headroom.
  - The triangle figures are my estimates. No vendor source gives triangle budgets; measure with `RenderingServer.get_rendering_info()` and Streamline.
- **Texture memory**: budget about **150–250 MB of GPU texture memory on 3 GB phones**, carved out of the overall ¼–½-of-RAM process budget (see Q8). This is an inference, not a vendor figure.
- **Post-processing and frame budget on the low tier**: no SSAO and no bloom, which avoids extra full-screen passes that cost bandwidth on tile-based GPUs. Use MSAA 2×/4× only on Vulkan or Mobile, where the resolve stays in tile memory. Keep the 3D render scale at about 0.7–0.8 of a ~720p-equivalent target. Aim to keep total GPU time at about 70% of the 33 ms budget, leaving thermal headroom.
- **Which Godot renderer**: Compatibility is the safer default for the lowest tier, given the driver-quality problems on low-end Vulkan devices and its lower base cost. However, the Compatibility renderer gets **none** of Godot's 4.4+ pipeline precompilation, ubershaders or shader baker (see Q10). A **dual-renderer build**, with Mobile on good Vulkan drivers and a fallback to Compatibility, is worth prototyping.

### Gaps
- I could not read the full Arm GPU Best Practices guide (the host was unreachable). Its "Triangle density" section, and any per-frame vertex or triangle numbers, remain unverified.
- I found no official Unity e-book figures for batches or triangles. The often-quoted "target ~65% of the frame budget to leave thermal headroom" Unity guidance could not be verified.
- I found no published per-SoC benchmarks for the Mali-G52/G57 class running Godot Mobile versus Compatibility. A secondary blog claimed Compatibility is often the only acceptable backend on Adreno 610 and Mali-G52 because of Vulkan driver quality. I could not attribute that claim reliably, so treat it as a hypothesis to test on real devices.

---

## 2. Texture compression, baked vs dynamic lighting, fake/blob shadows, LOD/HLOD/impostors, occlusion culling, instancing/MultiMesh, dynamic resolution

### Takeaway
Ship ASTC with an ETC2 fallback. Bake lighting into lightmaps and use one dynamic sun at most, with small or no shadow maps and blob or decal shadows under vehicles and pedestrians.

Because Godot's Mobile and Compatibility renderers do not auto-instance, use **MultiMesh plus visibility ranges (HLOD)** aggressively. Large, open city streets gain more from LOD and visibility ranges than from occlusion culling. Use a render-scale slider (bilinear on Mobile/Compatibility, MetalFX on iOS), driven by thermal state.

### Cited Findings
**Texture compression**
- Android device support: ETC2 on **>90%** of active devices and ASTC on **>75%**. Google recommends "ASTC as the primary format … ETC2 as a fallback". Play Asset Delivery's *Texture Compression Format Targeting* ships only the best format per device — [Android Developers, Textures](https://developer.android.com/games/optimize/textures). The page is undated, so the percentages may be older.
- Godot's `import_etc2_astc` setting imports **ETC2** for lower-quality textures and normal maps, and **ASTC at a fixed 4×4 block size** for high-quality textures — [Godot ProjectSettings reference](https://github.com/godotengine/godot/blob/master/doc/classes/ProjectSettings.xml).
- Conflict: Godot's GPU optimization doc says "most Android devices do not support texture compression of textures with transparency (only opaque)" — [Godot docs](https://github.com/godotengine/godot-docs/blob/master/tutorials/performance/gpu_optimization.rst). This is contradicted by Android's own page, which says ETC2 adds 8-bit and 1-bit alpha on GLES 3.0+ devices — [Android Developers](https://developer.android.com/games/optimize/textures). The Godot sentence looks like outdated ETC1-era guidance.
- Unity lists ASTC as preferred and ETC2 as the GLES 3.0 baseline, and recommends Play texture-compression targeting — [Unity Manual, texture formats by platform (via search excerpt)](https://docs.unity3d.com/Manual/texture-choose-format-by-platform.html).

**Baked vs dynamic lighting**
- Godot: baked lightmaps "work fine on low-end PCs and mobile devices, as they consume almost no resources at runtime". Baking both direct and indirect light gives "best performance" with blurrier sun shadows. Lightmaps occupy UV2 — [Godot docs, Using LightmapGI](https://github.com/godotengine/godot-docs/blob/master/tutorials/3d/global_illumination/using_lightmap_gi.rst).
- Godot recommends baked lighting "especially for mobile". It suggests setting lights to **Static** and keeping one **Dynamic DirectionalLight3D**, so dynamic objects still receive sun shadows — [Godot docs, Optimizing 3D performance](https://github.com/godotengine/godot-docs/blob/master/tutorials/performance/optimizing_3d_performance.rst).
- The Compatibility renderer can *render* LightmapGI, but **baking requires RenderingDevice-capable hardware**. Mobile supports LightmapGI fully — [Godot docs, Renderers](https://github.com/godotengine/godot-docs/blob/master/tutorials/rendering/renderers.rst).
- Light limits: Mobile allows 8 omni + 8 spot lights per mesh and 256 + 256 per view; these cannot be changed. Compatibility allows 8 + 8 per mesh by default — [Godot docs, Lights and shadows](https://github.com/godotengine/godot-docs/blob/master/tutorials/3d/lights_and_shadows.rst).

**Instancing and batching**
- Godot 4 **automatic instancing works only in Forward+**, for MeshInstance3D nodes sharing a mesh and an opaque or alpha-tested material. It is "not available in the Mobile or Compatibility renderers". For many identical objects use **MultiMesh**, which "can draw thousands of objects at low cost" — [Godot docs, Optimizing 3D performance](https://github.com/godotengine/godot-docs/blob/master/tutorials/performance/optimizing_3d_performance.rst).
- MultiMesh caveats:
  - It draws thousands of instances in one draw call, but is culled as **one object**. Instances spread far apart all render, so split MultiMeshes spatially.
  - The per-object light limit applies to the whole MultiMesh.
  - Blend shapes are ignored.
  - [Godot class reference, MultiMesh](https://github.com/godotengine/godot/blob/master/doc/classes/MultiMesh.xml)
- Unity 6 GPU Resident Drawer: it uses BatchRendererGroup to GPU-instance MeshRenderers automatically, and works only on graphics APIs that support compute shaders (otherwise it falls back). It lengthens builds because all BRG variants are kept, and is "most effective" in large scenes with many shared meshes. The doc suggests disabling static batching — [Unity Graphics repo, GPU Resident Drawer doc (HDRP version)](https://github.com/Unity-Technologies/Graphics/blob/master/Packages/com.unity.render-pipelines.high-definition/Documentation~/gpu-resident-drawer.md).
- Unity batching options are the SRP Batcher, GPU instancing and static batching, and Unity calls batching "vital on mobile" — [Unity mobile tips (via search excerpt)](https://unity.com/how-to/mobile-game-optimization-tips-part-2).

**LOD, HLOD and impostors**
- Godot offers three LOD tools: automatic mesh LOD on import, per-node **visibility ranges**, and distance fade on lights and decals — [Godot docs, Optimizing 3D performance](https://github.com/godotengine/godot-docs/blob/master/tutorials/performance/optimizing_3d_performance.rst).
- Visibility ranges work on any GeometryInstance3D, including MultiMeshInstance3D and Sprite3D impostors.
  - **HLOD** comes from *Visibility Parent*: one merged MultiMesh can stand in for several houses at a distance.
  - Fade modes *Self* and *Dependencies* force transparency and cost performance. *Disabled* (hysteresis) is fastest.
  - Use **dithering** rather than alpha for cross-fades.
  - Strip normal maps from distant materials ("especially costly on mobile").
  - [Godot docs, Visibility ranges](https://github.com/godotengine/godot-docs/blob/master/tutorials/3d/visibility_ranges.rst)
- Mesh LOD threshold: `rendering/mesh_lod/lod_change/threshold_pixels` (default 1.0). Raise it for performance — [Godot ProjectSettings reference](https://github.com/godotengine/godot/blob/master/doc/classes/ProjectSettings.xml).

**Occlusion culling**
- Godot's occlusion culling "has a cost on the CPU". "Large open scenes with few or no objects blocking the view will generally not benefit much". Such scenes "benefit more from mesh LOD and visibility ranges" — [Godot ProjectSettings reference](https://github.com/godotengine/godot/blob/master/doc/classes/ProjectSettings.xml).
- Godot's occluders are rasterized on the CPU into a low-resolution buffer. The Mobile renderer gains the most from them because it lacks a depth prepass — [Godot docs, Occlusion culling](https://github.com/godotengine/godot-docs/blob/master/tutorials/3d/occlusion_culling.rst).

**Dynamic resolution**
- Godot `scaling_3d/scale` below 1.0 undersamples 3D. **FSR 1.0 works only in Forward+**; Mobile and Compatibility fall back to bilinear. On very low-end GPUs "the added cost of FSR may not be worth it". iOS has `mode.ios` overrides for **MetalFX spatial and temporal** — [Godot ProjectSettings reference](https://github.com/godotengine/godot/blob/master/doc/classes/ProjectSettings.xml); [Godot docs, Resolution scaling](https://github.com/godotengine/godot-docs/blob/master/tutorials/3d/resolution_scaling.rst).
- Arm ASR (Accuracy Super Resolution) is a mobile-optimized temporal upscaler derived from AMD FSR 2.2.2.
  - It ships as an Unreal plugin, with a Unity plugin "coming soon", and as a **generic library** for other engines.
  - It offers Quality, Balanced and Performance presets, and Arm pitches it as a way to "prevent thermal throttling".
  - [Arm Learning Path, Arm ASR](https://learn.arm.com/learning-paths/mobile-graphics-and-gaming/get-started-with-arm-asr/)
- Android Game Mode's OEM "WindowManager backbuffer resize" intervention can cut **up to 30% of GPU** and 10% of system power — [Android Developers, Game Mode interventions (via search excerpt)](https://developer.android.com/games/optimize/adpf/gamemode/gamemode-interventions).
- Godot also supports Variable Rate Shading via `rendering/vrs/mode` "on supported hardware" — [Godot ProjectSettings reference](https://github.com/godotengine/godot/blob/master/doc/classes/ProjectSettings.xml).

### Inferences
- **ASTC vs ETC2 memory**: Godot's ASTC is fixed at 4×4, which is 8 bits per pixel, while ETC2 RGB is 4 bpp. On memory-starved 3 GB phones, ETC2 for opaque city textures can therefore be **half the size** of Godot's ASTC.
  - Use ASTC 4×4 only for hero assets: the danfo livery, UI atlases and alpha signage.
  - All target Mali GPUs (G52/G57) support ASTC LDR. This comes from general knowledge of the Mali product line; verify in the device catalogue.
- **Fake and blob shadows**:
  - Use a projected `Decal` or an unlit, alpha-blended dark quad under each danfo, car and pedestrian. Fade it with distance.
  - Restrict the real DirectionalLight3D shadow to the player bus only, or turn it off on the low tier.
  - This avoids the 2× depth-compare sampling cost and the extra shadow-map vertex pass. It is standard practice, but I found no 2023–2026 primary source quantifying it for Godot.
- **City blocks**:
  - Merge each block's static meshes per chunk, sharing a material and a trim-sheet or atlas.
  - Use MultiMesh for repeated props such as poles, kiosks, generators, signboards and parked cars.
  - Give each chunk a far-LOD "block impostor" (a merged low-poly shell) through visibility ranges.

### Gaps
- I found no primary 2023–2026 source with measured blob-shadow versus shadow-map costs on Mali.
- I found no Godot-specific impostor (octahedral billboard) tool documentation; community add-ons were not verified.
- The Unity URP GPU Resident Drawer requirements (Forward+ path, Vulkan vs GLES on mobile) were not verified from URP docs, because they were unreachable.

---

## 3. Thermal and frame pacing (ADPF thermal/hint APIs, Game Mode API, Swappy, iOS ProMotion/thermal, sustained testing); does Godot or Unity expose these?

### Takeaway
On Android:
- Use **Swappy**, which Godot ships enabled by default.
- Use the **ADPF Thermal API** (`getThermalHeadroom`). Poll it no more often than every 10 s, and scale quality or frame rate before throttling hits.
- Declare **Game Mode** support.

On iOS, react to `ProcessInfo.thermalState`. Apple explicitly suggests dropping from 60 to 30 fps at `.serious`.

Unity exposes all of this via Adaptive Performance and "Optimized Frame Pacing". **Godot exposes Swappy only.** Godot has no thermal, Performance Hint or Game Mode API in core (verified in source on 16 Oct 2026), so Danfo would need a small Android plugin and an iOS plugin.

### Cited Findings
**ADPF Thermal API**
- `PowerManager.getThermalHeadroom(forecastSeconds)` arrived in **Android 11 (API 30)**, with the NDK `AThermal_getThermalHeadroom` in API 31.
  - It returns 0.0 for no throttling and 1.0 for `THERMAL_STATUS_SEVERE`.
  - **Do not call it more than once every 10 seconds**, or it returns NaN. A first reading of NaN or 0 means the device does not support it.
- Heuristic thresholds:
  - **>0.85**: possibly light throttling. Watch and reduce if possible.
  - **>0.95**: possibly moderate. Reduce workload.
  - **>1.0**: possibly severe. Reduce immediately.
- You can register a thermal-status listener, but validate it with the headroom value.
- Recommended actions: reduce frame rate or fidelity, move work to smaller cores, and record thermal state in telemetry.
- [Android Developers, ADPF Thermal API](https://developer.android.com/games/optimize/adpf/thermal)

**Other ADPF features**
- The Performance Hint API needs Android 12+. A Google case study says the Thermal API is supported on most devices from Android 11 — [Android Developers, UNISOC ADPF story (via search excerpt)](https://developer.android.com/stories/games/unisoc-adpf).
- ADPF also includes Fixed Performance Mode, which pins clocks for benchmarking, and Power Efficiency Mode, available in Android 15 via `PerformanceHintManager.Session#setPreferPowerEfficiency` — [Android Developers, ADPF overview](https://developer.android.com/games/optimize/adpf).
- Engine support lists **Unity** (Adaptive Performance Android provider from 2021.3, package in Unity 6), **Unreal** (ADPF plugin, UE 4.25+) and **Cocos** (Thermal from 3.8.2, Hint from 3.8.3). **Godot is not listed** — [Android Developers, ADPF game engine support](https://developer.android.com/games/optimize/adpf/game-engine-support).

**Unity**
- Unity's Adaptive Performance Android provider (5.1) wraps `getThermalHeadroom`, `getCurrentThermalStatus`, `createHintSession` and `reportActualWorkDuration`. The "Basic" provider lacks thermal support.
- *Auto Game Mode* sets 30 fps in battery-saver mode and the display maximum in performance mode — [Unity Adaptive Performance Android provider 5.1 (via search excerpt)](https://docs.unity3d.com/Packages/com.unity.adaptiveperformance.google.android@5.1/manual/index.html); [Unity Basic provider (via search excerpt)](https://docs.unity.cn/Manual/adaptive-performance/basic-provider.html).

**Game Mode API**
- The game reads PERFORMANCE or BATTERY mode via `GameManager`. To declare support, set `appCategory="game"` and add a game-mode config XML.
- OEM interventions (backbuffer resize, ANGLE, **FPS throttling** on Android 13+) apply unless the game implements or opts out of Game Mode — [Android Developers, Game Mode API and interventions (via search excerpt)](https://developer.android.com/games/gamemode/gamemode-api).

**Swappy (Android Frame Pacing)**
- Swappy fixes uneven 30 fps presentation on 60 Hz panels (e.g., 49/16/33 ms frames), queue-stuffing latency, and Choreographer quirks.
- It uses `EGL_ANDROID_presentation_time`/`VK_GOOGLE_display_timing` and fences.
- It selects the refresh rate closest to the target. On 60+90 Hz panels the options are 90/60/45/30; on 60/90/120 Hz panels they are 120/90/60/45/40/30.
- Case study: *Mir 2* cut slow sessions **from 40% to 10%**.
- Unity has it built in as **Optimized Frame Pacing** (2019.2+).
- [Android Developers, Frame pacing](https://developer.android.com/games/sdk/frame-pacing)
- **Godot ships Swappy**: `display/window/frame_pacing/android/enable_frame_pacing` defaults to **true** ("Highly recommended").
  - `swappy_mode` defaults to `auto_fps_auto_pipeline`. That mode may "downgrade the max FPS until it finds a value that can be maintained" (e.g., a game swinging between 40 and 60 fps will settle at 30), and it disables pipelining when frames take under ~8 ms.
  - `Engine.max_fps` sets the target.
  - [Godot ProjectSettings reference](https://github.com/godotengine/godot/blob/master/doc/classes/ProjectSettings.xml)
  - Official CI downloads Swappy into Android builds — [Godot android_builds.yml](https://github.com/godotengine/godot/blob/master/.github/workflows/android_builds.yml); [platform/android/detect.py](https://github.com/godotengine/godot/blob/master/platform/android/detect.py).
- **Godot has no thermal or ADPF API** in core or the Android platform layer. A grep for `thermal`, `PerformanceHint`, `getThermalHeadroom` and `GameManager` over `platform/android`, `platform/ios` and `drivers/apple_embedded` at master `81ab961` (16 Oct 2026) found nothing. The OS, Engine and RenderingServer class docs contain no thermal methods — [Godot source tree](https://github.com/godotengine/godot/tree/master/platform/android). An earlier Godot × The Forge collaboration listed "Add Android Thermal API support" as planned work — [GameFromScratch (via search excerpt)](https://gamefromscratch.com/?p=28768).
- Godot on iOS reports a 60 Hz refresh rate when **Low Power Mode** is on — [Godot display_server_ios.mm](https://github.com/godotengine/godot/blob/master/platform/ios/display_server_ios.mm).

**iOS**
- Apple's `ProcessInfo.ThermalState.serious` advice: "Reduce the target framerate from 60 FPS to 30 FPS"; "Reduce the level of detail … fewer particles or lower-resolution textures"; and defer I/O. At `.critical`, reduce CPU, GPU and I/O "to the minimum level required for user interaction" — [Apple docs, ThermalState.serious](https://developer.apple.com/documentation/foundation/processinfo/thermalstate-swift.enum/serious); [ThermalState.critical](https://developer.apple.com/documentation/foundation/processinfo/thermalstate-swift.enum/critical).
- ProMotion:
  - Low Power Mode caps ProMotion at 60 Hz.
  - iPhones need `CADisableMinimumFrameDurationOnPhone` in Info.plist for rates above 60 Hz.
  - `CAMetalDisplayLink` (iOS 17+) offers finer pacing control.
  - [WWDC21 session 10147](https://developer.apple.com/wwdc21/10147); details from a secondary guide [axiom-display-performance (via search excerpt)](https://skills.cat/skills/charleswiltgen/axiom/axiom-display-performance). This is a lower-quality source; verify against Apple docs.

**Sustained-performance criteria**
- Android vitals defines a **slow session** as one where **>25% of frames are slow**. A frame is slow if it is not presented within **50 ms** of the previous frame (20 fps).
  - A second metric uses **34 ms** (30 fps).
  - Monitoring starts **after one minute** of play.
  - "Play will start steering users away from games that cannot achieve 20 FPS on their phones."
  - [Android Developers, Slow sessions](https://developer.android.com/google/play/vitals/slow-session)

### Inferences
- **Sustained-performance test method** for Danfo:
  - Run a scripted 30-minute loop on each tier device: the passenger route plus one race, at fixed brightness, roughly 25 °C ambient, a charged battery with no charger attached, and airplane mode on.
  - Log frame times (Swappy stats or Perfetto), thermal headroom every 10 s, CPU/GPU clocks and battery temperature.
  - Pass criteria: P95 frame time ≤ 33.3 ms (low tier) or ≤ 16.7 ms (mid tier) **after minute 10**, with less than 5% slow frames by the 34 ms vitals definition.
  - This method is derived from the vitals and ADPF guidance above, not taken from a single source.
- **Godot integration plan**:
  - Write a ~100-line Android plugin (Kotlin, Godot Android plugin v2) that exposes `getThermalHeadroom(10)` and `getCurrentThermalStatus` to GDScript.
  - Write a matching iOS plugin that reads `ProcessInfo.thermalState`.
  - Drive a quality governor in GDScript: render scale first, then shadow and LOD distances, then traffic and pedestrian density, then 60→30 fps. Never touch physics rate.
- **Default frame-rate setup**: cap the low tier at 30 fps (`Engine.max_fps = 30`) and keep `swappy_mode` on auto-pipeline. On mid-tier phones with 90/120 Hz panels, offer 60 fps, and fall back to 45 or 30 when headroom exceeds 0.85.

### Gaps
- I did not verify the Android Performance Hint API's real-world gains on Helio and Unisoc.
- I found no community Godot ADPF plugin; search was exhausted before I could look.
- Apple's own ProMotion article (the `optimizing-promotion-refresh-rates…` JSON) failed to download. ProMotion specifics rest on the WWDC21 page plus a secondary guide.
- The Android Game State API was not covered.

---

## 4. Quality tiers: auto-detecting device tier at first launch, and keeping gameplay/physics identical across tiers

### Takeaway
Combine three signals:
1. A static lookup: RAM, GPU name, SoC or model, and Android Media Performance Class where available.
2. A short first-launch GPU benchmark scene, run for about 10–15 s.
3. Runtime telemetry with thermal back-off.

Always provide a manual override.

Keep simulation identical across tiers. Use a fixed physics tick (60 Hz) decoupled from rendering with physics interpolation. Scale only cosmetic systems: render scale, shadows, LOD distances, ambient-traffic and pedestrian density, and particles.

### Cited Findings
- **Android Media Performance Class** (Jetpack Core Performance) reports a device's MPC level from build info or Google Play services. The levels are forward-compatible and can be mapped to experience tiers. Lower or undefined levels map to the stripped-down tier — [Android Developers, Performance class](https://developer.android.com/topic/performance/performance-class); [Android Developers Blog 2022](https://android-developers.googleblog.com/2022/03/using-performance-class-to-optimize.html).
- **Godot device-detection APIs**:
  - `OS.get_model_name()` (Android and iOS).
  - `OS.get_processor_name()` (Android API 31+ only).
  - `OS.get_memory_info()["physical"]` for usable RAM.
  - `RenderingServer.get_video_adapter_name()` and `get_video_adapter_vendor()`.
  - `RenderingServer.get_video_adapter_type()`, with Godot's own advice to "provide users with a way to manually override graphics settings".
  - `RenderingServer.get_current_rendering_method()` to detect a renderer fallback.
  - [Godot class reference, OS](https://github.com/godotengine/godot/blob/master/doc/classes/OS.xml); [RenderingServer](https://github.com/godotengine/godot/blob/master/doc/classes/RenderingServer.xml); [ProjectSettings](https://github.com/godotengine/godot/blob/master/doc/classes/ProjectSettings.xml)
- **Physics determinism across frame rates in Godot**:
  - The physics tick defaults to **60/s**.
  - "At very low tick rates (usually below 30), physics behavior can break down."
  - "Racing games may benefit from increasing the tick rate above the default 60."
  - `max_physics_steps_per_frame` (default **8**) caps catch-up to avoid a spiral of death. Raise it if the tick rate rises.
  - Enable **physics interpolation** when the tick and refresh rates differ.
  - [Godot ProjectSettings reference](https://github.com/godotengine/godot/blob/master/doc/classes/ProjectSettings.xml)
  - Interpolation is enabled in Project Settings. Move objects in `_physics_process()` and call `reset_physics_interpolation()` after teleports — [Godot docs, Physics interpolation quick start](https://github.com/godotengine/godot-docs/blob/master/tutorials/physics/interpolation/physics_interpolation_quick_start_guide.rst).
- **Jolt cross-platform determinism** requires consistent floating-point settings (precise FP mode, FP contraction off, FTZ/DAZ consistency) — [Jolt Physics Architecture.md](https://github.com/jrouwe/JoltPhysics/blob/master/Docs/Architecture.md).
- **Unity**: Adaptive Performance provides runtime scalers through Quality Settings, driven by thermal and performance state — [Android Developers, ADPF Thermal (Unity section)](https://developer.android.com/games/optimize/adpf/thermal).

### Inferences
- **Proposed tier table**, to validate on devices:
  - **Low**: ≤3 GB RAM, or Mali-G52 MC1/MC2, Unisoc T606 (Mali-G57 MP1), or PowerVR GE8320. Compatibility or Mobile renderer, 30 fps, render scale about 0.7, no real-time shadows (blob only), traffic ≤12 active vehicles, pedestrians as MultiMesh VAT.
  - **Mid**: 4–6 GB RAM and Mali-G57 MC2 (Helio G99), Adreno 610/619 or better. 30 fps at higher quality, or 60 fps. Render scale 0.8–1.0. One shadow cascade on the player bus only.
  - **High**: MPC ≥ 12, or Adreno 7xx / Mali-G7xx / Immortalis class.
  - The benchmark should render a representative danfo-park scene for 10 s with the low preset, read average GPU frame time, and promote or demote one tier. Save the result, and re-run after a GPU driver or app update.
- **Gameplay invariants** that must not vary by tier:
  - Physics tick (60 Hz), vehicle collider shapes, tyre and grip curves, AI racer count and logic rate, and race checkpoints.
  - Only *ambient* traffic and pedestrian density may scale. Spawn logic must guarantee a minimum number of boarding passengers so economy pacing is equal across tiers.
  - Contact racing must never depend on render frame rate, so all forces and impulses run in `_physics_process`.
- **Run physics at 60 Hz even on 30 fps tiers.** That means 2 physics steps per rendered frame, which costs CPU. Profile Jolt plus GDScript per tick on a Helio G85.
  - If the tick is too costly, 50 Hz with interpolation is a fallback.
  - Do not go below 30 Hz, per Godot's warning.
  - Godot's docs favour higher, not lower, tick rates for racing games.

### Gaps
- I found no published first-launch benchmark methodology from a top mobile racing studio (Gameloft, Codemasters/EA, NaturalMotion) in 2023–2026.
- Unity's `SystemInfo`-based tiering guidance was not retrieved.

---

## 5. Profiling tools (all free)

### Takeaway
The free stack is enough:
- **Arm Performance Studio 2026.5** (Streamline, Performance Advisor, Frame Advisor, Mali Offline Compiler, RenderDoc for Arm GPUs). It now has an **official Godot integration extension**.
- **Perfetto** and system traces.
- **AGI 3.3.3**, though Google now points to **Android Performance Analyzer (APA)**, in public beta, as the recommended tool.
- **Snapdragon Profiler** for Adreno.
- **Xcode Instruments and the Metal debugger** for iOS.
- Godot's built-in profiler, monitors and pipeline-compilation counters.

### Cited Findings
**Arm Performance Studio**
- "All features of Arm Performance Studio are available free of charge without any additional license."
- It bundles **Streamline + Performance Advisor**, **Frame Advisor** (captures a problem frame and gives geometry metrics), the **Mali Offline Compiler** (`malioc`, shader cost per Mali generation) and **RenderDoc for Arm GPUs**.
- The current version cited is **2026.5** (Mali Offline Compiler v2026.5.0, Streamline 9.9).
- [Arm Learning Paths, Arm Performance Studio install guide](https://learn.arm.com/install-guides/ams/) ([source](https://github.com/ArmDeveloperEcosystem/arm-learning-paths/blob/main/content/install-guides/ams.md))
- **Godot integration**: the "Arm Performance Studio Integration" extension, from the Godot Asset Library, works with Godot 4.3+. In GDScript it provides `PerformanceStudio.new()`, `marker()`, `marker_color()`, "Region Start/End" markers that appear in Performance Advisor's frame-rate charts, per-thread channels, and custom counters for Streamline — [Arm Learning Path, Profile Android game performance in Godot](https://learn.arm.com/learning-paths/mobile-graphics-and-gaming/godot_packages/) ([source](https://github.com/ArmDeveloperEcosystem/arm-learning-paths/tree/main/content/learning-paths/mobile-graphics-and-gaming/godot_packages)).
- Performance Advisor and Frame Advisor support Android devices only. Streamline 2025.4 added a "Mali Timeline" for GPU scheduling — [Arm blog, What is Arm Performance Studio (via search excerpt)](https://developer.arm.com/community/arm-community-blogs/b/mobile-graphics-and-gaming-blog/posts/what-is-arm-performance-studio); [RidgeRun wiki (via search excerpt)](https://developer.ridgerun.com/wiki/index.php/NXP_i.MX95/Tools/Arm_Performance_Studio).

**Android GPU Inspector and APA**
- AGI **3.3.3** (2025 build) supports system profiling with GPU counters on **Adreno, Mali and PowerVR**, and frame profiling for both Vulkan and GLES.
- The AGI page now carries a banner: "**Android Performance Analyzer is the new recommended tool for profiling games**", in public beta, with its own System and Frame Profiler.
- [Android Developers, AGI](https://developer.android.com/agi)

**Perfetto and Android memory tooling**
- Android's game memory docs use **Perfetto SQL** queries.
- `ProfilingManager` (Android 15, API 35) can capture heap and system traces at runtime, including on a `TRIGGER_TYPE_ANOMALY` when memory-limiter thresholds are crossed.
- [Android Developers, Monitor memory usage](https://developer.android.com/games/optimize/memory-monitoring)
- Godot master has a build option `profiler=perfetto` for Android. It is enabled by default in debug, non-store builds when the Perfetto SDK is present — [Godot platform/android/detect.py](https://github.com/godotengine/godot/blob/master/platform/android/detect.py). This comes from the build script only; I did not check user-facing docs.

**Godot built-in tools**
- `RenderingServer.get_rendering_info()` returns draw calls and other statistics (3D only, available after 2 frames) — [Godot class reference](https://github.com/godotengine/godot/blob/master/doc/classes/RenderingServer.xml).
- The debugger has pipeline-compilation monitors (Canvas, Mesh, Surface, Draw, Specialization) for finding shader stutter — [Godot docs, Pipeline compilations](https://github.com/godotengine/godot-docs/blob/master/tutorials/performance/pipeline_compilations.rst).
- Godot 4.5 Android export templates include native debug symbols for crash diagnosis — [Godot mobile update Apr 2026 (via search excerpt)](https://godotengine.org/article/godot-mobile-update-apr-2026/).

### Inferences
- **Recommended workflow**:
  1. Use the Godot monitors and the Arm extension markers ("Region Start Oshodi") to find hotspots by area.
  2. Run Streamline + Performance Advisor on a Mali-G52/G57 device for CPU vs GPU boundness and bandwidth.
  3. Use Frame Advisor or RenderDoc for overdraw and draw-call inspection.
  4. Run `malioc` on exported shaders.
  5. Use Perfetto for frame pacing and thermals.
  6. Use Snapdragon Profiler on one Adreno 610/619 device.
  7. Use Xcode Instruments (Game Performance template) and the Metal debugger on the oldest supported iPhone.

### Gaps
- I did not retrieve details for Snapdragon Profiler's 2026 version or licence, or for Xcode Instruments and the Metal debugger templates (hosts unreachable or search exhausted).
- I did not check RenderDoc's Android GLES support statement directly; renderdoc.org was unreachable.

---

## 6. Vehicle physics for arcade-sim minibuses, contact racing and mobile touch controls

### Takeaway
Use a **raycast (or shape-cast) suspension on a RigidBody3D** with your own simple grip curves, not "realistic" wheel colliders. Godot's built-in VehicleBody3D is a Bullet-derived raycast vehicle that Godot itself flags as having "known issues".

Run at a **fixed 60 Hz**. Jolt is "stable at 60 Hz with 1 collision step". Use Jolt (the default for new projects since Godot 4.6) with tuned speculative-contact and penetration settings.

For touch:
- Offer **auto-accelerate**, with left/right buttons or a slider as the default.
- Offer tilt as an option.
- Add brake/drift and boost buttons.
- Add steering assists: lane magnetism, auto-countersteer and anti-rollover limits.

### Cited Findings
**Godot VehicleBody3D**
- It "is based on the raycast vehicle system commonly found in physics engines". Each wheel is a VehicleWheel3D, and the node is controlled by `engine_force`, `brake` and `steering`.
- The body origin is the **centre of gravity**: "keep it low".
- "This class has known issues and isn't designed to provide realistic 3D vehicle physics. If you want advanced vehicle physics, you may have to write your own physics integration using CharacterBody3D or RigidBody3D."
- [Godot class reference, VehicleBody3D](https://github.com/godotengine/godot/blob/master/doc/classes/VehicleBody3D.xml)
- The implementation casts rays via `PhysicsDirectSpaceState3D.intersect_ray` and carries comments referencing Bullet, so it is engine-side and independent of the physics backend — [Godot vehicle_body_3d.cpp](https://github.com/godotengine/godot/blob/master/scene/3d/physics/vehicle_body_3d.cpp).

**VehicleWheel3D tuning guidance**
- `wheel_friction_slip`: "best to set this to 1.0 when starting out". Lower the rear for drift.
- `suspension_stiffness` (N/mm): **<50 off-road, 50–100 race car, ~200 F1**.
- `damping_compression`: about **0.3 normal car, 0.5 race car**.
- `wheel_roll_influence`: 1.0 resists body roll; 0.0 is "prone to rolling over".
- [Godot class reference, VehicleWheel3D](https://github.com/godotengine/godot/blob/master/doc/classes/VehicleWheel3D.xml)

**Jolt in Godot**
- Godot 4.6 (January 2026) made Jolt the default 3D physics engine for **new** projects, after it was experimental from 4.4. Existing projects keep their setting — [Godot 4.6 release page (via search excerpt)](https://godotengine.org/releases/4.6/).
- The class reference describes Jolt as "generally faster and more reliable than GodotPhysics3D" — [Godot ProjectSettings reference](https://github.com/godotengine/godot/blob/master/doc/classes/ProjectSettings.xml).
- Jolt tuning knobs in Godot:
  - `speculative_contact_distance` = **0.02 m**. It prevents tunnelling; set too high it causes ghost collisions.
  - `penetration_slop` = **0.02 m**.
  - `velocity_steps` = **10**; at least 2 is needed for friction.
  - `position_steps` = **2**.
  - `use_enhanced_internal_edge_removal` = **true**. It reduces ghost collisions on internal edges of a single body, not between separate bodies.
  - [Godot ProjectSettings reference](https://github.com/godotengine/godot/blob/master/doc/classes/ProjectSettings.xml)
- Jolt's general guidance: "the system is stable when running at **60 Hz with 1 collision step**".
  - The **LinearCast** motion quality (CCD) prevents fast bodies tunnelling. It "steals time", so the object briefly looks slower on impact.
  - Velocity and position solver iterations correct drift.
  - [Jolt Architecture.md](https://github.com/jrouwe/JoltPhysics/blob/master/Docs/Architecture.md)

**Jolt's own vehicle model** (reference design; not exposed to GDScript)
- Jolt has a `VehicleConstraint` with `WheeledVehicleController`, and wheel collision testers using a **ray, a sphere cast or a cylinder cast**. The ray and sphere testers default to an 80° max slope.
- It supports anti-roll bars and limited-slip differentials (`mDifferentialLimitedSlipRatio` = 1.4).
- It has `mMaxPitchRollAngle`, which keeps "the car from getting upside down".
- Tyre friction uses **piecewise-linear curves**, not Pacejka:
  - Longitudinal friction vs slip ratio: (0, 0) → (**0.06, 1.2**) → (0.2, 1.0).
  - Lateral friction vs slip angle: (0°, 0) → (**3°, 1.2**) → (20°, 1.0).
- [Jolt WheeledVehicleController.h](https://github.com/jrouwe/JoltPhysics/blob/master/Jolt/Physics/Vehicle/WheeledVehicleController.h) / [.cpp](https://github.com/jrouwe/JoltPhysics/blob/master/Jolt/Physics/Vehicle/WheeledVehicleController.cpp); [VehicleCollisionTester.h](https://github.com/jrouwe/JoltPhysics/blob/master/Jolt/Physics/Vehicle/VehicleCollisionTester.h); [VehicleConstraint.h](https://github.com/jrouwe/JoltPhysics/blob/master/Jolt/Physics/Vehicle/VehicleConstraint.h)
- Godot compiles Jolt's vehicle sources (they are listed in `modules/jolt_physics/SCsub`), but the module exposes no VehicleConstraint node. Using it would need a C++ module or GDExtension — [Godot modules/jolt_physics/SCsub](https://github.com/godotengine/godot/blob/master/modules/jolt_physics/SCsub). This is inferred from the source tree: there are no other references to VehicleConstraint.

**Tyre models**
- Pacejka models are used in racing games because they are "reasonably accurate, easy to program, and solve quickly". The formula diverges at low speed, because velocity sits in the denominator, so it needs a guard — [Wikipedia, Hans B. Pacejka (via search excerpt)](https://en.wikipedia.org/wiki/Hans_B._Pacejka).
- Developers report using a "simplified" Pacejka with slip angle as the main lateral input, holding camber and load constant — [GameDev.net thread (via search excerpt; old)](https://gamedev.net/forums/topic/462784-simplified-pacejka-magic-formula/).
- PAC89 is still used when simplicity and speed matter more than precision — [Vortex Studio docs (via search excerpt)](https://vortexstudio.atlassian.net/wiki/spaces/VSD2504/pages/4070350345).

**Raycast-suspension pitfalls and examples**
- Springs that never settle once damping is added — [Godot forums (via search excerpt)](https://godotforums.org/d/23177-raycast-vehicle-suspension-not-stabilizing).
- Suspension "incredibly bouncy at low framerates (<30fps)": apply forces, not impulses, and account for delta — [Roblox DevForum (via search excerpt)](https://devforum.roblox.com/t/raycast-vehicle-movement/3640420).
- A community arcade-car project — [RacingGodot thread](https://forum.godotengine.org/t/racinggodot-arcade-car-physics-for-the-godot/131039).
- **Kenney Starter Kit Racing** (Godot 4.6, MIT code with CC0 assets) has arcade-like vehicle controls, GridMap track tiles, and a swappable car or motorcycle model with named wheel nodes — [GitHub KenneyNL/Starter-Kit-Racing](https://github.com/KenneyNL/Starter-Kit-Racing).

**Touch controls in top mobile racers**
- *Asphalt 9/Legends* offers **TouchDrive**, where the player swipes to pick a route and the game steers, and **tilt**. Both use **auto-acceleration**, with on-screen Drift and Nitro buttons. There is also a two-button accessibility mode — [Pocket Gamer](https://www.pocketgamer.com/asphalt-9-legends/asphalt-9s-stripped-back-controls-are-the-best-way-to-play-the-game-heres-five-r/); [TouchArcade 2018](https://toucharcade.com/2018/06/19/asphalt-9-legends-wants-to-make-insane-driving-as-easy-as-possible/); [Family Gaming Database](https://www.familygamingdatabase.com/accessibility/Asphalt+9+Legends).
  - Critics found TouchDrive "better" but "less fun", and called tilt "no graceful way to steer".
- *GRID Autosport* (iOS) offers tilt, arrow buttons and wheel touch modes, with optional auto-acceleration on Rookie and Pro difficulty — [Feral Interactive support](https://support.feralinteractive.com/en/mac-linux-games/gridautosport/faqs/ios_control_methods).
- On touch, throttle is "all or nothing", with no partial input, which hurts sim racers such as Assetto Corsa Mobile — [The Race](https://www.the-race.com/gaming/is-there-room-for-a-realistic-mobile-racing-game.md).
- Player preference is split between tilt and buttons. Poor tilt implementations push players to buttons — [TouchArcade forum](https://toucharcade.com/community/threads/how-do-you-prefer-to-steer-in-a-car-game.173404/).

### Inferences
**Recommended Danfo vehicle architecture**
- **Body**: a `RigidBody3D` with mass about 2,500–3,500 kg for a loaded minibus, with the centre of mass set low and forward via `center_of_mass`.
- **Suspension**: 4 `ShapeCast3D` sphere casts (or RayCast3D) for suspension, using Hooke's law plus damping. Sphere casts behave better on kerbs and potholes, as Jolt's own cast-sphere tester design suggests.
- **Tyre forces**: lateral grip from a **Jolt-style piecewise-linear curve** of slip angle (peak about 1.2 at 3–6°, falling to about 1.0). Longitudinal force from a simple slip-ratio curve, or arcade torque without wheel spin. Clamp combined forces with a friction circle. This avoids Pacejka's low-speed divergence and parameter fiddliness.
- **Tick rate**: all forces in `_physics_process` at 60 Hz.
- **VehicleBody3D**: acceptable for prototyping only.

**Contact racing without explosions or sticking** (inferred; no primary source found)
- Use simple convex colliders: a box or capsule hull per bus. Never use trimesh for vehicles.
- Keep vehicle masses within about 1:3 of each other.
- Set inter-vehicle friction low (about 0.1–0.2) with low bounce, so sideswipes slide instead of locking.
- Detect bus-to-bus contacts (`body_entered` / `get_contact_count` with `contact_monitor`), then apply a **scripted, clamped lateral "shove" impulse** scaled by relative velocity, with a per-pair cooldown, rather than relying only on solver impulses.
- Cap angular velocity and roll (an anti-rollover torque or a `mMaxPitchRollAngle`-style cone).
- Enable LinearCast/CCD only on racers.
- Keep Jolt's speculative distance at about 0.02–0.05 m.

**Assists for touch control**
- Speed-sensitive steering, where maximum steer angle shrinks with speed.
- Auto-countersteer or yaw damping.
- Optional "lane magnetism" toward the lane spline in passenger mode.
- Automatic braking assist before stops.
- Collision forgiveness: brief invulnerability to flips after big hits.
- Rubber-band AI only in races.

**Default control scheme**
- Auto-accelerate, left/right steer zones or a steer slider, a brake/reverse button and a horn button.
- Tilt and a virtual wheel as options.
- In passenger mode, a "stop at bus stop" auto-brake prompt.

### Gaps
- I could not retrieve the "Making Custom Car Physics in Unity" (Very Very Valet / Toyful Games) talk or article, or any GDC Vault racing-physics talks. Search was exhausted and GDC Vault was unreachable.
- I found no primary source on vehicle-vehicle contact stabilisation for arcade "contact racing" (e.g., Burnout or Wreckfest postmortems).
- I found no published control-scheme usage statistics from Asphalt, Real Racing or CSR.

---

## 7. Traffic and pedestrian AI at scale on mobile

### Takeaway
Use a **lane graph** derived from the road network, with directed lane splines, connectors at junctions and stop or yield rules. Move near cars as spline-following kinematic agents (not full rigid-body vehicles) and far cars as cheap abstract tokens or MultiMesh instances.

Use simulation LOD and schedule-ahead traffic, as GDC's "Cities at Scale" describes. Draw pedestrians with **vertex-animation textures on MultiMesh**, with reduced animation rates at a distance.

### Cited Findings
- GDC AI Summit, "Cities at Scale: Simulating Street Life on a Budget": it schedules traffic flow "for a short period into the future" rather than simulating every frame, and ties that to spawning, LOD, pathfinding and player interaction — [GDC Vault abstract (via search excerpt)](https://gdcvault.com/play/1027576/AI-Summit-Cities-at-Scale).
- Lanes are usually represented as low-detail polylines. A Frenet-frame lane model built from road axes enables lane changes and merges — [Lane model paper, CAVW 2015 (via search excerpt)](https://graphics.cs.uh.edu/wp-content/uploads/papers/2015/2015-CAVW-LaneModel.pdf).
- Lane networks must capture lane counts, intersections, merges and ramps, and can be built from polyline GIS data — [Wilkie et al., UNC (via search excerpt)](https://gamma.cs.unc.edu/RoadNetwork/wilkie_TVCG.pdf).
- A survey covers multi-level-of-detail traffic simulation — [Traffic simulation survey, CGF 2019 (via search excerpt)](https://graphics.cs.uh.edu/wp-content/uploads/papers/2019/2019-CGF-TrafficSimSurvey.pdf).
- **Godot Road Generator** (MIT, Godot 4.4+, GDScript-only):
  - Cross-section-based procedural road meshes with lane counts, shoulders and lane transitions.
  - Procedural and prefab intersections.
  - **Auto-generated AI lane paths** (`RoadLane`) and a `RoadLaneAgent` helper for agents following roads across segments.
  - Runtime procedural functions, glTF export of road sections, Terrain3D integration, and custom-mesh support.
  - It is used in shipped indie games (Wheel Steal).
  - [GitHub TheDuckCow/godot-road-generator](https://github.com/TheDuckCow/godot-road-generator)
- **Pedestrian animation cost (Godot)**:
  - "Skinning and morphing can be expensive on some platforms". Reduce polycount, limit animated models on screen, and **lower animation rate for distant or occluded meshes**.
  - Use `VisibleOnScreenEnabler3D` and `VisibleOnScreenNotifier3D` to pause off-screen work.
  - [Godot docs, Optimizing 3D performance](https://github.com/godotengine/godot-docs/blob/master/tutorials/performance/optimizing_3d_performance.rst)
- Godot's official tutorial animates "thousands of animated objects, even on low-end hardware" via a vertex-shader animation on **MultiMeshInstance3D**, following ABZU's technique. The page is flagged `article_outdated` — [Godot docs, Animating thousands of fish](https://github.com/godotengine/godot-docs/blob/master/tutorials/performance/vertex_animation/animating_thousands_of_fish.rst).
- **Vertex Animation Textures (VAT)** bake skeletal animation into textures for GPU playback, avoiding per-character CPU skinning — [SideFX talk, VAT for Crowds](https://www.sidefx.com/learn/talks/vertex-animation-textures-for-crowds/).
- A vendor claims instanced VAT crowds went from 200 to 550 FPS. This is an unverified marketing figure — [Fab listing](https://www.fab.com/listings/9becdda1-31fd-423a-a55e-d1ac2251f5ba).

### Inferences
**Proposed Danfo traffic architecture**
- **Data**: an OSM-derived lane graph stored as compact arrays: lane ID, Bézier or polyline points, length, speed limit, successor lanes, and junction conflict groups.
- **Simulation tiers**:
  - **Tier A**, within about 60–80 m and in view: an `AnimatableBody3D` or `CharacterBody3D` following a spline, with IDM-style (Intelligent Driver Model) car-following and gap acceptance at junctions. It switches to a full `RigidBody3D` only on collision with the player, then reverts.
  - **Tier B**, at 80–250 m: positions advanced along lanes at 5–10 Hz and rendered via a per-chunk MultiMesh.
  - **Tier C**, off-screen or far: abstract counts per lane segment, spawned and despawned at the edges of the camera's influence.
- **Budget**: about 10–20 Tier A vehicles plus 40–80 Tier B instances on the low tier.
- **Pedestrians and boarding**:
  - Bus-stop crowds as VAT-animated MultiMesh: idle, walk and wave clips baked in Blender.
  - Only the 2–6 passengers actively boarding become skinned `CharacterBody3D` or animated meshes.
  - Animation updates at 15 Hz beyond about 30 m.
- **Lagos character**: hawkers and "agberos" (touts) can be static or VAT loops.

### Gaps
- I could not read the full "Cities at Scale" talk (GDC Vault access).
- I found no mobile-specific benchmarks for VAT versus skinned crowds on Mali.
- I did not find shipped-game postmortems (e.g., GTA mobile ports, *Bus Simulator* series) describing traffic LOD on Android.

---

## 8. Open-world streaming on mobile (chunks/cells, async loading, memory caps and the low-memory killer, floating-point precision and origin shifting)

### Takeaway
Stream the city in fixed grid cells, for example 200–250 m. Use Godot's threaded `ResourceLoader` with a 3×3 to 5×5 ring of resident cells, and finish adding cells to the scene on the main thread in time-sliced batches.

Keep the whole process within about ¼–½ of physical RAM. Handle `onTrimMemory`, and log `ApplicationExitInfo` (including Android 17's new memory-limiter kills).

Use **single-precision floats plus origin shifting**. Godot's docs explicitly steer low-end platforms away from double-precision "large world coordinates".

### Cited Findings
- Godot: "Build large worlds in tiles loaded on demand". Floating-point error causes rendering and physics bugs. The alternatives to large world coordinates are orienting the world around the player or periodically shifting the origin back near (0, 0, 0) — [Godot docs, Optimizing 3D performance](https://github.com/godotengine/godot-docs/blob/master/tutorials/performance/optimizing_3d_performance.rst).
- Godot's **large world coordinates** (a double-precision build):
  - They carry a "performance and memory usage penalty, especially on 32-bit CPUs" and are "tailored towards mid-range/high-end desktop".
  - Origin shifting is the route for low-end platforms. It adds game-logic complexity, especially in multiplayer.
  - Shaders stay single-precision.
  - Medium-scale worlds usually do not need large world coordinates.
  - [Godot docs, Large world coordinates (via search excerpt)](https://docs.godotengine.org/en/stable/tutorials/physics/large_world_coordinates.html)
- Godot threaded loading: `ResourceLoader.load_threaded_request(path)`, then poll `load_threaded_get_status(path, progress)`, then `load_threaded_get(path)`. The final call blocks if loading is unfinished. The example instantiates and calls `add_child` from the main thread — [Godot docs, Background loading](https://github.com/godotengine/godot-docs/blob/master/tutorials/io/background_loading.rst).
- Mesh pipelines compile when a mesh loads, and "background-thread loading reduces stutter". Surface pipelines compile when objects are first added to the tree — [Godot docs, Pipeline compilations](https://github.com/godotengine/godot-docs/blob/master/tutorials/performance/pipeline_compilations.rst).
- **Android memory**:
  - Games "often use between ¼ and ½ of the physical RAM". zRAM size also matters.
  - `onTrimMemory` "is often the only warning", and has high latency relative to the low-memory killer.
  - The **Memory Advice API (beta)** predicts impending low-memory kills with higher precision and recall.
  - [Android Developers, Manage memory effectively in games (via search excerpt; the page returned 404 when fetched on 18 Oct 2026 and may have moved)](https://developer.android.com/games/optimize/memory-allocation)
- `ApplicationExitInfo` via `getHistoricalProcessExitReasons()`:
  - `REASON_LOW_MEMORY` means the process was killed by the low-memory killer.
  - New **`REASON_MEMORY_LIMITER` (Android 17, API 37)** means the process exceeded its cgroup limit (RssAnon + VmSwap), "even if there's ample physical memory remaining".
  - Some engines do not forward `TRIM_MEMORY_UI_HIDDEN`/`BACKGROUND`, so handle them on a background thread.
  - [Android Developers, Monitor memory usage](https://developer.android.com/games/optimize/memory-monitoring)
- `OS.get_memory_info()` returns "physical", "free" and related fields at runtime, for adaptive cache sizing — [Godot class reference, OS](https://github.com/godotengine/godot/blob/master/doc/classes/OS.xml).

### Inferences
**Float32 precision at Lagos scale**
- Precision steps are 2⁻²³ × magnitude: about **0.5 mm at 4 km** and about **1 mm at 8 km** from the origin.
- A Lagos map spanning, say, Ikeja to Lagos Island (about 15–20 km) would reach about 2 mm steps. That causes visible vertex jitter on close-up interiors and suspension jitter.
- **Recentre the world whenever the player is more than about 1–2 km from the origin**: shift all cells, agents and physics bodies in one physics tick.
- Calls to `reset_physics_interpolation()` are needed on every shifted interpolated node, per Godot's teleport guidance.

**Cell design**
- Each cell is a pre-baked `.scn`/`.res` containing:
  - Merged static meshes with lightmaps.
  - MultiMesh props.
  - Collision built from simplified boxes and heightfield, not trimesh where possible.
  - A lane-graph slice.
  - A far impostor.
- Load ring: the player's cell plus neighbours in the direction of travel. Prefetch with velocity look-ahead, which at 80 km/h is about 22 m/s.
- On 3 GB devices, target a total process RSS of about 0.9–1.2 GB. That leaves about 300–400 MB for resident cells (meshes and textures), which in turn sets cell size and texture budgets.

**Memory resilience**
- Handle `onTrimMemory` through a small Android plugin: drop far-cell caches and audio banks.
- Save progress frequently: passenger-run state is cheap to serialise.
- Log `ApplicationExitInfo` reasons to analytics on the next launch.

### Gaps
- I found no published mobile open-world streaming postmortem for 2023–2026 (e.g., Genshin Impact or Tower of Fantasy tech talks) within the search budget.
- Godot-specific open-source chunk-streaming frameworks were not evaluated.
- The Memory Advice API's 2026 status (still beta, or deprecated?) was not confirmed.

---

## 9. Building a recognisable Lagos from OpenStreetMap with free tools (blosm, BlenderGIS, OSM2World, procedural roads, ODbL, modular kits)

### Takeaway
A free pipeline exists:
- Use the **blosm free tier** or **BlenderGIS** to import OSM footprints, heights, roads and ~30 m terrain into Blender.
- Or use **OSM2World** (glTF output, LOD, 250+ tags) for bulk building shells.
- Generate drivable roads and AI lanes with the **Godot Road Generator**, or with your own road-mesh script fed by OSM centrelines.
- Dress the result with a hand-made **modular kit**: Lagos shopfront facades, kiosks, BRT shelters, danfo parks, overhead wires and signage.

Legally:
- Rendered 3D city models and screenshots are **Produced Works** that need an ODbL notice.
- Any OSM-derived **database** you ship, such as a road or lane graph file or a POI table, is a **Derivative Database**. It must be offered under ODbL, or you must publish the method or alteration file.

### Cited Findings
**Blender add-ons**
- **blosm, free base version** (GPL):
  - OSM buildings without textures, using height and floor-count tags, with complex building parts and many roof shapes.
  - Terrain at about 30 m resolution.
  - Rivers, lakes, forests and vegetation as polygons.
  - **Roads, paths and railways as curves with width**.
  - Buildings and roads projected onto terrain.
  - GPX import.
- **blosm Premium/Pro** adds:
  - Textured buildings with UVs, tileable facade textures and lit-window materials.
  - Forests and individual trees as 3D objects.
  - Custom facade textures and satellite or web-map imagery on terrain.
  - Texture baking for 3D Tiles.
  - [GitHub vvoovv/blosm](https://github.com/vvoovv/blosm)
- Premium was listed at **$17.80** on Gumroad. That figure comes from an older OSM wiki page; verify the current price — [OSM wiki, Blender-osm (via search excerpt)](https://wiki.openstreetmap.org/wiki/Blender-osm).
- **BlenderGIS**:
  - Imports OSM XML and queries OSM for buildings and roads.
  - Imports GeoTIFF DEMs and fetches **SRTM** elevation. Since 2022, OpenTopography requires a free API key.
  - Displays web basemaps and georeferences the scene.
  - Builds Delaunay terrain meshes and drops objects onto terrain.
  - Requires Blender 2.83 or later. The README states neither its maintenance status nor the latest supported Blender version.
  - [GitHub domlysz/BlenderGIS](https://github.com/domlysz/BlenderGIS)

**OSM2World**
- An open-source converter that outputs **glTF/glb**, OBJ and POV-Ray. It supports PBR materials (normal, ORM and displacement maps), multiple **LOD** levels, and "over 250 OSM keys and tags".
- Since 2025 it can load custom glTF models for specific object types.
- It needs **Java 17+**.
- A State of the Map 2026 talk covers improved glTF support, 3D tiles and a JVM/browser library interface.
- [osm2world.org](https://osm2world.org/); [OSM2World 0.3.0 release](https://osm2world.org/blog/2022/12/27/release-0.3.0/); [SotM 2026 session](https://2026.stateofthemap.org/sessions/XQUCJM)

**Procedural roads and lanes**
- Godot Road Generator (MIT, Godot 4.4+):
  - Lane-count transitions, procedural intersections and auto AI lanes.
  - **Runtime-available functions for procedural use**, which suit a pipeline that feeds OSM centrelines and `lanes=` tags.
  - Edge "decoration curves" for instancing props along roadsides.
  - Trim-sheet materials.
  - glTF export.
  - [GitHub TheDuckCow/godot-road-generator](https://github.com/TheDuckCow/godot-road-generator)

**ODbL 1.0 legal text** (from the SPDX copy of the licence)
- **Produced Work**: "a work (such as an image, audiovisual material, text, or sounds) resulting from using the whole or a Substantial part of the Contents…"
- **Derivative Database**: "any translation, adaptation, arrangement, modification, or any other alteration of the Database or of a Substantial part of the Contents", including extracting a Substantial part into a new database.
- **4.3 Notice**: if you Publicly Use a Produced Work, you must include a notice "reasonably calculated to make any Person that uses, views… or is otherwise exposed to the Produced Work aware that Content was obtained from the Database… and that it is available under this License". The example text is "Contains information from DATABASE NAME, which is made available here under the Open Database License (ODbL)."
- **4.4 Share alike**: any Derivative Database you Publicly Use must be under ODbL or a compatible licence. Section **4.4c** adds that a Derivative Database is deemed Publicly Used "if a Produced Work created from the Derivative Database is Publicly Used".
- **4.5b**: creating a Produced Work "does not create a Derivative Database".
- **4.5c**: internal use is not public.
- **4.6**: if you Publicly Use a Derivative Database, *or a Produced Work from a Derivative Database*, you must offer recipients either "the entire Derivative Database" or "a file containing all of the alterations… or the method of making the alterations… (such as an algorithm)". It must be free of charge if distributed over the internet.
- **"Publicly"** means use by persons other than you or entities under your control.
- **"Substantial"** is judged by quantity or quality, and repeated systematic extraction of insubstantial parts can add up to Substantial.
- [ODbL 1.0 (opendatacommons.org)](https://opendatacommons.org/licenses/odbl/1-0/); text retrieved from [SPDX license-list-data ODbL-1.0.txt](https://github.com/spdx/license-list-data/blob/main/text/ODbL-1.0.txt)

**OSMF guidance**
- A game built on OSM is usually a Produced Work. Attribution is "only necessary when a Produced Work is used Publicly". The process of creating a Produced Work need not be revealed "beyond the Derivative Database" — [OSMF Licence and Legal FAQ (via search excerpt)](https://osmfoundation.org/wiki/Licence_and_Legal_FAQ); [OSMF Attribution guideline (via search excerpt)](https://osmfoundation.org/wiki/Attribution); [OSM wiki, ODbL Use Cases (via search excerpt)](https://wiki.openstreetmap.org/wiki/Open_Data_License/Use_Cases).
- The guideline says the legal text prevails where they disagree.
- A Chinese GIS book claims games may use "any license". That omits the attribution requirement and is less reliable — [Practical GIS excerpt (via search excerpt)](https://m.imarket.qq.com/read/1036701096/37).

### Inferences
**Licensing obligations for Danfo** (needs legal review)
1. Show "© OpenStreetMap contributors" with an ODbL link in the credits, store listing and loading-screen footer.
2. The **processed road and lane graph** and any OSM-derived POI data, whether shipped in the APK or used to make the city, are a Derivative Database. Publish that dataset, or the conversion scripts as the 4.6(b) "method", publicly under ODbL, for example in a GitHub repo.
3. The game code, art, 3D models and kit assets stay under Danfo's own licence (4.5b).
4. Hand-edited fixes to OSM geometry, such as corrected lane counts, are themselves "alterations". Consider contributing them back to OSM.

**Lagos-specific pipeline**
1. Extract a bounding box with the Overpass API, or a Geofabrik Nigeria PBF clipped with osmium. These tools were not researched here.
2. Clean the data in JOSM or QGIS: simplify, merge dual carriageways, fix lane tags.
3. Generate the lane graph and road meshes. Real Lagos roads are curvy and junction-heavy, so expect manual cleanup at roundabouts and BRT corridors.
4. Generate building shells from footprints with OSM2World or blosm free.
5. Replace street-front facades with modular kit pieces: 2–4 m wide bays, corrugated roofs and signage atlases, made in Blender and Krita.
6. Bake lightmaps per cell in Godot.
7. Export to cells.

**Assets**: Lagos-specific signage and shopfronts must be original or CC0. Do not copy real trademarks or brands onto buildings without care.

### Gaps
- I could not access OSMF's "Produced Work – Guideline" or "Substantial – Guideline" pages directly. I found no OSMF ruling specifically on games that ship a navigable road graph.
- OSM data completeness for Lagos (building heights and `lanes` tags) was not assessed.
- I did not verify blosm's 2026 pricing or Blender 4.x/5.x compatibility, or BlenderGIS's maintenance status.

---

## 10. Load times and shader-compilation stutter on mobile, plus mitigations

### Takeaway
On Godot's **Vulkan Mobile** renderer, use 4.4+ ubershaders and load-time pipeline precompilation, the 4.5+ **Shader Baker** export option and the on-disk **pipeline cache** (enabled by default). Show every material, effect and feature during loading screens, and change rendering features only behind a loading screen.

On **Compatibility (GLES3)** none of this applies. Use the old trick of rendering every material once during the loading screen.

Measure stutter with Godot's pipeline-compilation monitors.

### Cited Findings
- **Godot 4.4 changes**:
  - Before 4.4, pipelines compiled when an object first became visible, causing first-playthrough stutter.
  - 4.4 added **ubershaders**, which use specialization constants: one general pipeline is precompiled and optimized variants build in the background.
  - It also added **automatic precompilation at load** for the shaders, meshes and features the RenderingServer sees during loading, on multiple background threads.
  - Loading new shaders or meshes mid-game, or enabling MSAA or VoxelGI mid-game, still triggers compilation.
  - [Godot docs, Reducing stutter from shader (pipeline) compilations](https://github.com/godotengine/godot-docs/blob/master/tutorials/performance/pipeline_compilations.rst)
- **This applies only to Forward+ and Mobile, "not Compatibility"**. For Compatibility, the advice is to preload materials, shaders and particles by "displaying them in the view frustum for at least one frame during level loading" — [same source](https://github.com/godotengine/godot-docs/blob/master/tutorials/performance/pipeline_compilations.rst).
- Godot recommends rendering every needed feature early in loading, even off-screen (behind a ColorRect or in an off-window SubViewport). Change rendering features only from settings screens paired with loading screens. Keep a hidden instance of dynamically spawned effects in the scene — [same source](https://github.com/godotengine/godot-docs/blob/master/tutorials/performance/pipeline_compilations.rst).
- Features detected on first use include: MSAA level, ReflectionProbe, **LightmapGI lightmaps**, 16/32-bit shadow depth, omni shadow modes, motion vectors and others — [same source](https://github.com/godotengine/godot-docs/blob/master/tutorials/performance/pipeline_compilations.rst).
- **Shader Baker (Godot 4.5+)**:
  - It is opt-in per export preset. It bakes the intermediate SPIR-V into the PCK, skipping shader compilation. It does **not** bake driver-specific pipelines.
  - It is **Vulkan-only on Android** and unsupported for Compatibility.
  - The PCK grows by a few MB and exports take longer.
  - [same source](https://github.com/godotengine/godot-docs/blob/master/tutorials/performance/pipeline_compilations.rst)
- **Pipeline cache**:
  - `rendering/rendering_device/pipeline_cache/enable` defaults to **true**, saving to disk.
  - `save_chunk_size_mb` defaults to **3.0**.
  - Disable it, and clear the driver cache, to simulate a first launch.
  - Driver updates usually clear driver caches.
  - [Godot ProjectSettings reference](https://github.com/godotengine/godot/blob/master/doc/classes/ProjectSettings.xml); [Godot docs, Pipeline compilations](https://github.com/godotengine/godot-docs/blob/master/tutorials/performance/pipeline_compilations.rst)
- Vulkan pipeline cache effect (Mali, older sample): re-creating Sponza's pipelines took **24.4 ms with the cache vs 50.4 ms without** — [Khronos Vulkan-Samples, pipeline_cache](https://github.com/KhronosGroup/Vulkan-Samples/blob/main/samples/performance/pipeline_cache/README.adoc).
- Godot debugger monitors split compilations into Canvas, Mesh, Surface, Draw and Specialization. "Draw" compilations should not happen with ubershaders and should be reported as bugs. Specialization compiles happen in the background and lower frame rate without stutter — [Godot docs, Pipeline compilations](https://github.com/godotengine/godot-docs/blob/master/tutorials/performance/pipeline_compilations.rst).
- Unity's GPU Resident Drawer requires keeping all BatchRendererGroup shader variants ("Keep All"), which lengthens builds — [Unity Graphics repo, GPU Resident Drawer](https://github.com/Unity-Technologies/Graphics/blob/master/Packages/com.unity.render-pipelines.high-definition/Documentation~/gpu-resident-drawer.md).

### Inferences
**Load-time practice for Danfo**
- Keep the material count tiny: one city trim-sheet material per facade family, one vehicle material, one road material, and a few VAT and particle shaders.
- Use no runtime-toggled rendering features. Fix the MSAA, shadow and lightmap settings per tier at startup, then show a "warm-up" scene that draws every material and shadow mode once.
- Enable Shader Baker on the Vulkan build.
- For Compatibility on the low tier, the warm-up scene is the only defence, so keep the shader-variant count minimal.
- Use threaded cell loading (Q8) to keep load spikes off the main thread.
- Target a cold start under about 10–15 s on Helio G85 to the main menu, and under 5 s to the first drivable state from the menu. These are proposed targets, not sourced benchmarks.
- Ship the base APK/AAB small and deliver city cells as Play Asset Delivery packs (fast-follow or on-demand), plus Play texture-compression targeting. This connects to the release-strategy research.

### Gaps
- I found no measured first-launch shader-compile times for Godot 4.5–4.7 on Mali-G52/G57.
- Unity 6 PSO tracing and warm-up (`GraphicsStateCollection`) was not researched; Unity docs were unreachable.
- Apple Metal binary archives and pipeline caching on iOS were not researched.

---

## Cross-cutting version context (for the report writer)

- **Godot release timeline**:
  - Godot **4.6** shipped in about January 2026. Jolt became the default for new 3D projects, and 4.6.3 is a later maintenance release — [Godot 4.6 release page (via search excerpt)](https://godotengine.org/releases/4.6/); [GameDev.net 4.6.3 (via search excerpt)](https://gamedev.net/news/3473-maintenance-release-godot-463/).
  - Godot **4.7** shipped in about June 2026. It added HDR output, AreaLight3D, a stable Godot Android Build Environment, and reportedly **Vulkan subsampled images in the Mobile renderer**. **4.7.1** followed with fixes, including Android touchscreen issues — [Linuxiac (via search excerpt)](https://linuxiac.com/godot-4-7-open-source-game-engine-released-with-linux-wayland-hdr-support/); [80.lv (via search excerpt)](https://80.lv/articles/godot-4-7-has-been-released); [Warp2Search (via search excerpt)](https://www.warp2search.net/story/godot-471-released-quick-stability-patch-fixes-rendering-and-platform-bugs/).
  - The 4.7 claims come from secondary news sites; verify them against the official release notes.
- **Godot master** (16 Oct 2026) still defaults `rendering_method.mobile` to `"mobile"` (Vulkan). Projects targeting low-end devices must choose Compatibility explicitly — [Godot ProjectSettings reference](https://github.com/godotengine/godot/blob/master/doc/classes/ProjectSettings.xml).
- **Older guidance flagged**:
  - The Khronos/Arm Vulkan best-practice samples date from 2019–2020 (Mali-G72/G76 measurements). Their bandwidth principles still apply, but the absolute numbers come from older hardware.
  - The Arm "few hundred draw calls" blog is from the Midgard era.
  - The Godot "fish" VAT tutorial is flagged outdated.
  - Godot's "Android devices don't compress alpha textures" line predates ETC2 ubiquity.
