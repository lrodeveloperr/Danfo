# Danfo — product specification

Updated: 18 October 2026  
Status: implementation handoff; no playable build, performance benchmark or human playtest is included.

This file defines the current product direction. The full evidence, references and earlier design discussion are in [docs/research-and-design.md](docs/research-and-design.md). If an older proposal in that document conflicts with this specification, this current specification governs. Do not silently change the two modes, menu scope, monetization or approved features.

## Player promise

Drive a personal danfo through Lagos, earn naira through racing or carrying passengers, pay off the bus, personalise it and build a reputation. Help players understand a substantial part of a driver's working life through actual journeys and their consequences.

Android and iOS; free entry; advertising-funded; local-first solo play. One shared bus/career, one earned currency in naira (₦), exactly two play modes: **Work** and **Race**.

## Minimal menus — clear keeps only

The user approved the 80–20 menu cuts on 18 October 2026. This section supersedes earlier menu/story/management proposals. Driving remains the main activity.

| Surface | Keep |
| --- | --- |
| Main menu | Selected bus, naira balance, ownership progress, dominant **Work** and **Race** buttons; small **My Bus** and **Settings** entries |
| Work selection | A concise service-route card with destinations, duration/demand cues and any applicable disclosed terms; Start/Resume |
| Race selection | A concise course/event card and current setup; Start/Rematch |
| Results | Saved earnings, applicable expenses, owner payment, take-home amount and ownership progress; Next/Replay/My Bus |
| My Bus | Selected bus, simple upgrades/named setups, paint/horn choices and compact ownership summary; bus selection when multiple buses are available |
| Settings | Controls, sound, subtitles and camera comfort |

Use one concise result breakdown to explain the driver's money. My Bus may expose a short agreement summary through Details; it does not contain detailed financial reports, transaction-history screens or a Career section. Preserve the underlying payment ledger and gameplay history internally for correct saves and ownership.

Remove family/household goals, owner/mechanic inboxes or message collections, paperwork/inspection management, biography/achievement browsers, story-reader menus and routine maintenance micromanagement. Do not reintroduce them as hidden expandable features. Brief ownership milestones can appear when earned; rivals and regular passengers establish their character during driving and stops.

Keep a few meaningful upgrade/setup choices instead of advanced tuning dashboards. No per-run repair/service checklist or repeated manual instalment confirmation. Apply the already disclosed played-shift rules automatically; this UI change adds no new cost or loan term. Existing earned/rewarded cosmetic items and entitlements remain supported with a compact preview/appearance choice; no ad placement or reward changes are authorised by these cuts.

The ordinary loop is choose Work or Race, drive, receive a saved result, optionally make one useful bus choice, then drive again. No management step or story reading is required before another drive.

## Work — passenger driving

Use a connected, freely navigable Lagos road network within the playable map. This is open-world passenger work, with normal location-appropriate traffic, roadside life, eligible boarding areas and passenger-service goals.

1. Choose an advertised service route/job with clear destinations, estimated duration, demand cues and fare/cost rules.
2. Collect eligible customers when seats are available. The advertised service determines suitable destinations; this is a danfo service rather than arbitrary taxi dispatch.
3. Choose viable streets between destinations. Suggested navigation is advisory and updates after a different turn; taking a valid alternative street does not automatically fail the job.
4. Serve requested drop-offs with advance visual/voice cues and forgiving stopping segments.
5. Complete the agreed job/shift, settle while stationary, then continue working or select another activity.

Pickups/drop-offs are interactions inside the ongoing world, not independent levels. Save position, heading, bus, job, passengers and destinations. All required destinations must remain reachable within installed playable content.

### People and boarding

Visible drivers belong in the player's/rival buses and nearby civilian traffic vehicles. Work includes the conductor and actual boarded passengers occupying researched seats.

- Stop stationary in a valid area, with the correct door side aligned and its approach clear.
- Open the appropriate sliding door; alighting passengers leave first.
- Reserve a free seat, approach the doorway, step/duck into the bus and transition naturally to that seat.
- Keep the same passenger identity/appearance through boarding, travel and departure.
- Close the door when clear before departure. Occupancy cannot exceed capacity.
- The conductor handles fares, change and routine destination calls automatically. The player drives and chooses stops.
- Keep boarding brisk, avoid per-passenger cutscenes and prevent indefinite blocked-path locks.
- Missing a stop offers a viable recovery path. Required tutorial/story pickups cannot be stolen by ambient rivals.
- Fare grants occur once per completed journey. Already completed fares survive interruption.

Stops include researched roadside waiting patches, market/junction points and bus parks; shelters/signs only where references support them. Each needs valid stopping geometry, waiting positions, clear door paths, destination data and readable cues.

## Race — defined competitive events

Use defined courses within the same Lagos geography: start/grid, allowed branches/checkpoints, finish and results.

- The active course contains only the player and competing danfos. No civilian moving/parked vehicles intrude into the racing line.
- Drivers remain visible; the player's conductor stays inside for identity/occasional commentary. No fare-paying customer load or pickups.
- Roadside people, vendors and scenery remain outside the course; no pedestrian path/spawner feeds the racing line.
- Racing is forceful: gap defence, squeezes, sideswipes, shoves, scrapes and recoverable hard contact.
- Match visible geometry and collision boundaries. Repeated contact must not cause sticking, clipping or explosive impulses.
- Immediate readable steering, controlled bus weight/lean, distinct impact/audio feedback and understandable recovery are release requirements.
- Rivals obey the same geometry/contact vulnerabilities. No winning-position teleportation, hidden retaliation power or deliberately forced loss to sell an ad.
- Use route-specific road proportions. Tight racing space does not mean narrowing every Lagos arterial/bridge into the same street.
- Sprint, circuit, personal time attack, elimination and conditions events are variations inside Race, not new primary modes.

Quick sprints around 90–180 seconds are a test range, not a validated preference. Longer events are elective. Preserve active work state through an explicit mode transition; unfinished customers/civilian spawners must not leak into Race or receive race-generated fares.

## Approved depth in the two modes

All seven additions below are included. Priority determines implementation order, not silent omission.

1. **Rivals with memory:** an initial cast with gap-defending, late-braking and opportunistic tactics; recognisable buses; saved recent encounters/results; brief contextual reactions and accessible rematches. Tactics must be visible in driving. Difficulty is selected before the event and remains stable through it.
2. **Regular passengers:** stable identities, appearances and valid route contexts; recognition and short authored stories advancing once through completed journeys. Dialogue yields to service cues. No calendar-attendance requirement or generative-AI service.
3. **Meaningful route choices:** readable alternatives where the researched road graph supports them. Race branches rejoin before required checkpoints; passenger navigation continues to every required destination.
4. **Informed work decisions:** job previews and useful demand cues; optional pickups trade available seats/time against later demand. Cues are authored game forecasts, not a live city-data claim.
5. **Viable bus setups:** clear trade-offs such as acceleration, steady cornering and forgiving braking. Offer a free preview on an existing Race route before committing earned currency; restore the old setup when cancelling. This is neither another mode nor an ad offer.
6. **Improvement feedback:** optional personal ghost plus one concise actionable post-race observation based on real sector/checkpoint timings. Compare compatible route/course, class, setup, conditions and physics versions; distinguish acquired skill from stronger upgrades.
7. **Visible bus history:** preserve ownership and selected race/service milestones on the same bus, with brief milestone feedback and earned original plates/mementos in the existing preview/cabin. Keep the underlying records through customisation, updates and later bus acquisition; no history-card collection or achievement browser is required.

## Bus ownership and driver life

Start with control of a clearly disclosed hire-purchase bus, with the initial deposit already saved in the character's story. Keep a short agreement summary, the current payment/remaining balance and progress towards full ownership.

Hire-purchase instalments reduce the purchase balance. An ordinary rental/delivery remittance buys continued use of someone else's bus and does not automatically earn ownership. Keep fuel, conductor pay, park/upkeep costs and owner payments distinct. Do not apply rental and purchase obligations as though they were universally the same contract.

The paid-off bus remains owned and usable. Its instalment obligation ends permanently. Real-world absence creates no arrears, interest, confiscation or lost ownership. Apply disclosed played-shift instalments without a separate manual-payment task.

Show applicable disclosed expenses and take-home earnings briefly in results, with details available in My Bus. New compulsory deductions and exact economy values remain decisions to settle explicitly before implementation. Do not copy historical interview prices as current real-world prices.

Keep the conductor as a skilled driving partner and regular customers as individuals within the driving experience. The shift account and ownership progress supply the core working-life context. Household goals, paperwork tasks and owner/mechanic story menus are removed. Racing prize income is a fictional game interpretation rather than a claim about ordinary danfo finance.

No dedicated 3D owner, mechanic, house, workshop interior, breakfast/rest area, walkable headquarters or transaction cinematic is required. Roadside stop/park geometry and normal driving characters remain.

## Lagos, assets and free production

Build a stable researched road graph, junction relationships and landmark order. Work uses connected streets; Race defines courses over the same city foundation. Actual launch coverage remains a content-planning decision; the twelve-area research framework is not a promise to finish twelve districts first.

Use original modular district-specific buildings/frontages/props, compatible variations, sounds and character rigs. Validate assembled layouts for road clearance, stop approaches and sightlines. Keep accepted geography stable across sessions; variety comes from useful routes, rivals, time/weather and demand rather than random landmark movement.

Use original or appropriately cleared assets, fictional business graphics and a source/licence register. Do not copy proprietary map imagery or 3D assets. OSM-derived data requires the applicable attribution and database obligations.

The researched free-stack recommendation is Godot 4/GDScript, a custom bus controller over the integrated rigid-body/Jolt foundation, Blender, Krita, Audacity and cleared/CC0 materials. Android/iOS export, renderer and ad-plugin integration must be validated and pinned before large content expansion. No new paid tools, packs, commissions, plugins or engine royalties. No measured claim that this stack is optimal or that a phone-performance target has passed.

Reuse the bus model for menus and driving. Scale meshes/animations/visual detail with distance while keeping gameplay geometry and state consistent. Test modest Android devices and target iPhones over longer sessions. No inherited 5 MB micro-game cap and no unmeasured download-size promise.

## Advertising — preserve the existing baseline

Ads only; no IAP, premium currency, paid cosmetics, subscription, paid season, paid ad removal or banners. The user must approve material monetization changes. The following is the retained starting proposal, not an empirically optimised schedule.

| Rule | Baseline |
| --- | --- |
| Eligible automatic-ad location | Completed qualifying event results, after the outcome/base earnings are visible and saved |
| First automatic ad | At least three completed qualifying events and 180 seconds of active play |
| Later automatic ads | At least two qualifying events, 180 seconds since the last displayed full-screen ad closed, and 120 active-play seconds since that ad |
| Qualifying event | A real race finish or a fully completed passenger shift |
| Shared schedule | One full-screen history across both modes, restarts and backgrounding |
| Rewarded display | Suppresses the automatic interstitial at that result and resets shared spacing |
| Excluded triggers | Driving, individual stops/fares, menus, garage, pause, launch, quitting/resetting and returning from background |
| No inventory/offline/failure | Continue without an ad wall, substitute wait or retry spam |

Active time excludes menus, idle time and ad viewing; required service animations count. A menu visit, street change or passenger transfer is not another completed event.

At most one relevant optional rewarded offer per result. Preserve the documented candidate placements:

- race_bonus: one extra amount equal to eligible base race currency.
- shift_bonus: one extra amount equal to eligible completed-shift base fares.
- garage_sample: one previewed, named permanent decorative item.
- cosmetic_trial: the selected appearance for the next three started races.

The item and trial placements are alternatives to evaluate, not simultaneous offers to show everywhere. The garage has no automatic ads. Declining never revokes base earnings. No rewarded competitive rescue changes a lost race into a win.

Save base progress first; one ad request in flight; grant exactly once; recover from no-fill/cancellation/delayed callbacks. Bonuses exclude prior bonuses and unrelated transfers. Apply expenses and owner payments once, without changing result, record or vehicle class.

## Persistence and quality gates

Persist stable bus/contract/transaction IDs, naira, payment ledger, ownership, equipped/preview setup, cosmetics/history, open-world location/job/passengers/seat reservations, story/rival memory, records/comparison metadata, preferences and shared ad history.

Acceptance includes:

- Independent playable onboarding in either mode; no compulsory play of the other.
- Route connectivity, reachable drop-offs, valid stop approaches, realistic capacity and interruption-safe boarding.
- Fair race geometry/contact, stable recovery, course validity and actor separation between modes.
- All approved features visible and stateful without additional top-level modes/menu bloat.
- Exactly-once fares, payments, milestones, purchases with earned currency and ad rewards.
- Offline installed solo content, reliable resume and no own-account/backend requirement.
- Android/iOS integrated device validation, appropriate visual profiles, audio/subtitle usability and saved controls.
- Human repeated-session tests for enjoyment, recognition, mastery and reasons to return. Automated validation is not evidence of fun.

Implementation sequence: validate bus feel/onboarding and one connected test district with both modes; integrate persistence/economy/test ads; develop the approved rival/passenger/route/setup/feedback/history features; then expand validated content. This sequence does not authorise removing approved scope.

Unresolved values include final city coverage, exact bus references/capacity, tuned handling/economy, final renderer/plugin versions, measured device budgets and tested ad pacing. Label assumptions and unperformed checks accurately.

