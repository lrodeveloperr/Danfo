# Danfo

A free Android and iOS danfo game set in Lagos, centred on **racing and carrying passengers**.

- **Work:** drive a connected city map with normal traffic, visible passenger boarding/drop-offs and a conductor handling fares.
- **Race:** compete against recurring rival danfos on defined, contact-heavy courses in the same Lagos setting.
- **One career:** earn naira, pay off a hire-purchase bus, personalise it and keep its history.
- **Clear keeps only:** Work and Race dominate. My Bus covers simple setups/customisation and ownership; Settings is secondary. A brief shift account explains the money. Household, paperwork, inbox, report and maintenance-management menus are removed.

## Start here

1. [PRODUCT_SPEC.md](PRODUCT_SPEC.md) — current product requirements and implementation boundaries.
2. [docs/research-and-design.md](docs/research-and-design.md) — full research, sources, evidence limits and earlier design discussion.
3. [reports/Danfo mobile build and release strategy.md](reports/Danfo%20mobile%20build%20and%20release%20strategy.md) — engine, devices, ads/consent, store compliance, pipeline and release research behind the Godot baseline.
4. [docs/photo-reference-list.md](docs/photo-reference-list.md) — every photo needed from Lagos to make the game look like Lagos, how to shoot it and where it goes (`art/reference/`).

The current product specification governs implementation when an earlier research proposal differs. Exactly two modes, all seven approved gameplay additions, free production components and the existing advertising baseline are retained. Material monetization changes require user approval.

## Status

Engine selected: Godot 4.7.2, pinned in PRODUCT_SPEC.md. `game/` holds a playable Phase 0 prototype: both modes, the career/economy, saves and the minimal menus in a procedural test district. It has not yet been exported to a phone, benchmarked on devices or playtested by people.

## Run the prototype

1. Install [Godot 4.7.2](https://godotengine.org/download/archive/4.7.2-stable/) (standard build).
2. Open `game/project.godot` and press F5.
3. Drive with W/A/S/D or the arrow keys (touch buttons on phones), H or Space for the horn, R to put the bus back on its wheels, Esc to pause.

**Work:** start a shift at the Garage, follow the arrow, and stop with the door to the kerb at a stop. People getting down leave first, then waiting passengers board, and the conductor collects each fare once. **Race:** three rival danfos with different tactics, two courses and three difficulties. Results show earnings, costs, the bus payment and take-home pay, then carry them into the shared career and save.

## Tests

```
cd game
godot --headless --import
godot --headless -s addons/gut/gut_cmdln.gd -gconfig=res://.gutconfig.json                  # unit tests
godot --headless --fixed-fps 60 -s addons/gut/gut_cmdln.gd -gdir=res://tests/smoke -gexit   # full races, a shift, app flow
```

Unit tests cover settlement and ownership, ad pacing, saves (corruption fallback and migration), the road network, the passenger manifest and race progress. Smoke tests drive whole races and a whole passenger shift on autopilot under Jolt physics, plus the app flow from race to results to reward. GitHub Actions runs both on every push that touches `game/`. `tests/tools/screenshot.gd` renders frames through the Compatibility renderer for visual checks.

## Not done yet

- Android/iOS export presets, signing and device runs (Phase 0 gates in PRODUCT_SPEC.md).
- The real AdMob plugin: ads are labelled placeholders behind the same pacing and exactly-once reward logic.
- Per-OS renderer override: the prototype uses Compatibility everywhere, including iOS.
- Mid-shift save and resume, upgrades/setups, regular passengers, route branches, ghosts and bus-history mementos.
- Original Blender models, recorded audio and the OFL Danfo typeface (current art and sound are procedural placeholders).
- Compliance screens awaiting approval (age screen, privacy options, report-an-ad).
- Economy values, which are placeholders pending your decision.

