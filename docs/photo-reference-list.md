# Photo reference list

Updated: 19 October 2026  
Status: shot list for the art rebuild. No photos have been collected yet.

The game's district is built from procedural placeholder geometry. Making it look like Lagos needs real photographs of danfos, streets, people and surfaces. Image sites are blocked from the build environment, so these photos have to come from the team: taken in Lagos, or supplied with a licence that allows commercial use.

## How the photos are used

| Use | What it means | Rules |
| --- | --- | --- |
| **Reference** (R) | Artists and Claude look at it to model shapes, proportions, colours, clutter density and behaviour. Nothing from the photo ships. | Any angle or light. People and brands may appear, but are never copied into the game. |
| **Texture source** (T) | Pixels from the photo become a game texture (asphalt, wall paint, rust, fabric). | Shot by the team, so you own it. Straight-on, even light, no people, no logos or readable brand names. |
| **Measurement** (M) | A photo with a tape measure or known object in frame, plus the written number. | Used to size models and roads correctly. |

Real number plates, union and government marks, company logos, brand names and recognisable faces are reference only. The game uses invented versions (see `reports/Lagos danfo representation study.md` and `PRODUCT_SPEC.md`).

## How to shoot

**Everything:**
- Use a phone at full resolution (12 MP or more) with HDR off for texture shots. Don't use digital zoom; walk closer.
- Shoot more than you think you need. Five angles of one bus beat one perfect photo.
- Note the location (area and street) and time of day for each batch.

**Texture sources (T):**
- Hold the camera square to the surface, centred, filling the frame.
- Use overcast light or full shade. Avoid hard sun, shadows of people or poles, and flash.
- Include a scale reference in one extra frame: an A4 sheet, a ₦ note or a tape measure.
- For walls and ground, take a second frame stepped about half a frame sideways, so the texture can be tiled.

**People:**
- Ask before photographing anyone up close, and stop if anyone objects.
- Crowd and street shots for reference are fine at a distance.
- Never photograph children up close.

**Safety and permission:**
- Never stand in traffic or on expressway shoulders to get a shot. Shoot from pavements, footbridges, inside a bus, or a parked car.
- In motor parks, ask the park officials or union representatives first. Explain it is for a game, and leave if told to.
- Do not photograph police, military, government buildings or checkpoints. The game invents its own officials.
- Daylight only, unless you are with someone local for the night shots.

## Where the photos go

Put files in `art/reference/` named:

`<ID>_<area>_<YYYYMMDD>_<nn>.jpg`, for example `DAN-01_ojuelegba_20261102_03.jpg`.

- Keep originals elsewhere (phone or shared drive). Commit copies resized to **2048 px on the long edge, JPEG quality 85** (about 0.5 MB each). Texture sources (T) are the exception: commit those at full resolution.
- Add one row per file to `art/reference/register.csv`. The columns are: file, shot ID, area, date, photographer, permission or licence, identifiable people (yes/no), use (R/T/M) and notes.
- Photos can also be attached straight into a Claude session. Commit them afterwards so they are kept.
- Photos from someone else need written permission or a licence that allows commercial use (CC0 or CC BY). Record which in the register. CC BY-NC and CC BY-SA images can only be used as reference (R), never as texture sources.

## Priorities

| Priority | Needed for | Shot IDs | Approx. photos |
| --- | --- | --- | --- |
| **P0** | Fixing the look now: the danfo, one mainland street type, a bus stop, roadside trade, core textures | DAN, DET, INT-01–04, STP, STR, BLD, TRD, OVH, TEX, MEA | about 450 |
| **P1** | People and behaviour, other vehicles, interiors, signage, light and weather | PPL, VEH, INT-05–07, SGN, SKY | about 130 |
| **P2** | Other districts and landmarks for later content | LMK | about 60 |

**Start with this first batch of about 60 photos**, which would change the most:
- DAN-01: one classic danfo, all 8 angles.
- DET-01, DET-02, DET-03: 2 shots each.
- DET-08: 10 different slogans.
- STR-01: two streets, 4 shots each.
- STP-01: one stop.
- TRD-01: 3 shots.
- BLD-01: 3 buildings.
- OVH-01: 2 shots.
- TEX-01 and TEX-04: 3 surfaces each.
- MEA-01: one bus.

For the current test district, the best areas to shoot are Ojuelegba, Yaba, Surulere, Mushin and Oshodi: mainland, mixed shops and housing, bus stops, a motor park and a market.

## Shot list

### DAN — danfo exterior (P0)

Photograph at least **three different buses** for each body type. Shoot one clean-ish bus and one hard-worked one.

| ID | Subject | Shots per bus | Use | Notes |
| --- | --- | --- | --- | --- |
| DAN-01 | Classic flat-front rear-engine danfo (VW Transporter-type) | 8: front, rear, both sides, all four 3/4 corners | R | Main game bus. Keep the camera at about 1.5 m height. |
| DAN-02 | Cab-over danfo (HiAce/Urvan-type) | 8, as above | R | Second body type. |
| DAN-03 | Long, high-roof 18-seater ("Hummer"-type) | 8, as above | R | Third body type. |
| DAN-04 | Korope (smaller yellow-and-black minibus) | 4 | R | Traffic variety. |
| DAN-05 | Danfo from above | 3 | R | From a footbridge. Shows the roof, any roof rack and the roof paint fade. |
| DAN-06 | Danfo in traffic, side by side with others | 6 | R | Shows how close they run, and lane use. |
| DAN-07 | Danfo with sliding door open, conductor in the doorway | 4 | R | From the pavement, at a stop. |
| DAN-08 | Danfo pulling in to a stop / leaving one | 4 | R | Shows the angle buses stop at and how close to the kerb. |

### DET — danfo details and wear (P0)

| ID | Subject | Shots | Use | Notes |
| --- | --- | --- | --- | --- |
| DET-01 | Black stripes: placement, width, how they wrap the front and rear | 6 | R, M | Measure stripe width and height from the ground. |
| DET-02 | Yellow paint: fresh, faded, chalky, repainted patches | 6 | R, T | Close, flat-on panels for texture. |
| DET-03 | Rust: sills, wheel arches, door bottoms, around windows | 8 | R, T | Close, flat-on. |
| DET-04 | Dents, scrapes and primer patches | 6 | R, T | |
| DET-05 | Mismatched replacement panels or doors | 3 | R | |
| DET-06 | Front: grille, lights, bumper, plate area, windscreen top strip | 4 | R | The plate is reference only; the game uses an invented plate. |
| DET-07 | Rear: lights, bumper, rear window lettering, engine lid | 4 | R | |
| DET-08 | Slogans and stickers: front strip, rear window, sides | 15 different buses | R | Record the exact text in the register notes. Lettering style matters more than the words. |
| DET-09 | Windscreen stickers and permits | 4 | R | Reference only; the game invents its own. |
| DET-10 | Wheels and tyres: rims, missing hubcaps, worn tyres | 4 | R, T | |
| DET-11 | Mirrors, door handles, sliding-door rail | 4 | R | |
| DET-12 | Roof racks, ladders, luggage on the roof | 3 | R | |
| DET-13 | Exhaust and smoke when pulling away | 3 | R | Video is better (see VID). |

### INT — danfo interior (P0 for 01–04, P1 for the rest)

| ID | Subject | Shots | Use | Notes |
| --- | --- | --- | --- | --- |
| INT-01 | View through the open sliding door into the seats | 3 | R | |
| INT-02 | Seat rows: benches, foam, covers, gaps between rows | 4 | R, M | Measure row spacing and bench width. |
| INT-03 | Front row: driver's seat and the two passenger seats beside it | 2 | R | |
| INT-04 | The conductor's place by the door | 2 | R | |
| INT-05 | Dashboard and driver's "shrine": stickers, rosaries, prayer cards, charms | 4 | R | Ask the driver first. |
| INT-06 | Ceiling, floor, window latches, door from inside | 4 | R | |
| INT-07 | View forward from a passenger seat while moving | 3 | R | For a possible in-bus camera. |

### VEH — other vehicles (P1)

| ID | Subject | Shots | Use | Notes |
| --- | --- | --- | --- | --- |
| VEH-01 | Keke (tricycle): sides, front, rear, passengers inside | 6 | R | |
| VEH-02 | Okada (motorcycle taxi) with rider and passenger | 6 | R | |
| VEH-03 | Typical private cars: old saloons, SUVs, battered and clean | 8 | R | The game invents its own makes; this is for shape and condition only. |
| VEH-04 | Trucks, tankers and trailers | 4 | R | |
| VEH-05 | Regulated buses (BRT, blue-and-white franchise buses) | 4 | R | Reference only; the game invents its own operator. |
| VEH-06 | Molue (where still running) | 2 | R | |
| VEH-07 | Broken-down vehicles at the roadside, cars under repair | 4 | R | |

### PPL — people and behaviour (P1, reference only)

| ID | Subject | Shots | Use | Notes |
| --- | --- | --- | --- | --- |
| PPL-01 | Conductor calling destinations, hanging from the door, collecting fares | 6 | R | Video is better. |
| PPL-02 | Passengers boarding and getting down | 6 | R | |
| PPL-03 | Crowd waiting at a bus stop: how they stand, where | 4 | R | From a distance. |
| PPL-04 | Hawkers in traffic with goods on their heads | 6 | R | |
| PPL-05 | Traders under umbrellas or at tables | 4 | R | |
| PPL-06 | Okada riders waiting at a junction | 2 | R | |
| PPL-07 | Mechanics and vulcanizers at work | 3 | R | |
| PPL-08 | Clothing variety: work clothes, traditional wear, school uniforms (from a distance) | 6 | R | Colour and silhouette reference for the crowds. |

### STP — bus stops and parks (P0)

| ID | Subject | Shots | Use | Notes |
| --- | --- | --- | --- | --- |
| STP-01 | Ordinary roadside stop: the waiting patch, kerb, any sign | 3 stops × 4 | R, M | Measure the kerb height and the pavement width. |
| STP-02 | Under-bridge stop (Ojuelegba or Oshodi type) | 6 | R | Pillars, traders underneath, buses loading. |
| STP-03 | Motor park: rows of danfos, loading bays, shelters, union desks | 8 | R | Ask permission first. |
| STP-04 | Market-edge stop where trade spills onto the road | 4 | R | |
| STP-05 | Bus stop signs and shelters (where they exist) | 3 | R | |

### STR — streets and roads (P0)

| ID | Subject | Shots | Use | Notes |
| --- | --- | --- | --- | --- |
| STR-01 | A typical mainland street, looking along it, at driver eye height | 4 streets × 4 | R | The single most important reference: how much is going on at once. |
| STR-02 | The same streets from a footbridge or first-floor window | 4 | R | Layout, density, roofs. |
| STR-03 | Main road or expressway: lanes, median, BRT lane, barriers | 6 | R | |
| STR-04 | Junction: corners, how vehicles queue, traders at corners | 4 | R | |
| STR-05 | Go-slow traffic jam | 4 | R | |
| STR-06 | Road edges breaking up into sand and laterite | 4 | R, T | |
| STR-07 | Potholes, patches, puddles | 6 | R, T | Flat-on from above for texture. |
| STR-08 | Gutters and drains: open, slabbed, blocked with litter | 4 | R, T | |
| STR-09 | Kerbs and medians, including painted kerbs | 4 | R, M | Measure the height. |
| STR-10 | Footbridge: stairs, deck, banners | 4 | R | |
| STR-11 | Flyover from below and from the side | 4 | R | |

### BLD — buildings (P0)

| ID | Subject | Shots | Use | Notes |
| --- | --- | --- | --- | --- |
| BLD-01 | Shop-house front: shops below, flats above | 6 buildings | R | Straight-on and at 3/4. |
| BLD-02 | Face-me-I-face-you house from the street | 3 | R | |
| BLD-03 | Compound wall and gate, including painted warnings | 4 | R | |
| BLD-04 | Unfinished building: columns, rebar, block walls | 3 | R | |
| BLD-05 | Windows with burglar bars, balconies with washing | 4 | R | |
| BLD-06 | Roofs from above: rusty corrugated sheets, water tanks, satellite dishes | 4 | R, T | From a footbridge or upper floor. |
| BLD-07 | Wall surfaces: painted plaster in several colours, faded, mildew streaks, bare block | 10 | T | Flat-on, even light, two overlapping frames each. |
| BLD-08 | Storey height and shop frontage width | 3 | M | Measure one typical building. |

### TRD — roadside trade and clutter (P0)

| ID | Subject | Shots | Use | Notes |
| --- | --- | --- | --- | --- |
| TRD-01 | Umbrella stalls: umbrella colours, tables, goods | 6 | R | Brand logos on umbrellas are reference only. |
| TRD-02 | Wooden kiosks | 4 | R | |
| TRD-03 | Container shops | 4 | R | |
| TRD-04 | Tables of goods: phone accessories, food, drinks | 4 | R | |
| TRD-05 | Vulcanizer setup: tyre stacks, compressor | 3 | R | |
| TRD-06 | Generators outside shops, with cables | 3 | R | |
| TRD-07 | Refuse heaps and litter | 3 | R, T | |
| TRD-08 | Market interior and market edge | 6 | R | |
| TRD-09 | Food spots: buka fronts, suya stands, roasted corn | 4 | R | |

### SGN — signs and lettering (P1)

| ID | Subject | Shots | Use | Notes |
| --- | --- | --- | --- | --- |
| SGN-01 | Hand-painted shop signs | 15 | R | Lettering style and colours. The game invents business names. |
| SGN-02 | Painted wall warnings ("This house is not for sale", "Post no bill") | 6 | R | |
| SGN-03 | Billboards and roadside adverts | 6 | R | Reference only; the game invents brands. |
| SGN-04 | Street-name signs and road signs | 4 | R | |
| SGN-05 | Banners on footbridges and poles | 3 | R | |

### OVH — overhead (P0)

| ID | Subject | Shots | Use | Notes |
| --- | --- | --- | --- | --- |
| OVH-01 | Electricity poles: concrete and wooden, leaning, with crossarms | 4 | R | |
| OVH-02 | Wire tangles, service drops to buildings, transformers | 4 | R | |
| OVH-03 | Streetlights | 2 | R | |

### SKY — light and weather (P1)

| ID | Subject | Shots | Use | Notes |
| --- | --- | --- | --- | --- |
| SKY-01 | Harmattan haze: a long street view with distance fading | 3 | R | December to February. |
| SKY-02 | Clear bright day: the same street | 3 | R | |
| SKY-03 | Overcast and just after rain: wet roads, puddles | 4 | R | |
| SKY-04 | Evening: low sun, shop lights coming on | 3 | R | |
| SKY-05 | Night: generator-lit shops, headlights, dark stretches | 4 | R | Only with a local companion. |

### TEX — texture sources (P0, all T)

Shoot these flat-on, in even light, with no people, logos or readable text, as two overlapping frames each, plus one frame with a scale reference.

| ID | Surface | Variants |
| --- | --- | --- |
| TEX-01 | Asphalt | Newer dark asphalt; old grey worn asphalt; patched asphalt |
| TEX-02 | Road edge | Sand; laterite; asphalt breaking into sand |
| TEX-03 | Pavement | Concrete slabs; interlocking pavers; cracked concrete |
| TEX-04 | Walls | Painted plaster in 5 colours; faded paint; mildew streaks; bare sandcrete block |
| TEX-05 | Roofing | Rusty corrugated sheet; newer zinc sheet |
| TEX-06 | Metal | Container wall; rusty steel; painted steel gate |
| TEX-07 | Danfo body | Yellow paint (good and faded); black stripe; rust panel |
| TEX-08 | Wood | Kiosk planks; market table |
| TEX-09 | Fabric | Umbrella fabric; tarpaulin; sacks |
| TEX-10 | Tyre tread and sidewall | |
| TEX-11 | Ground | Packed laterite; dusty open ground; grass verge |

### MEA — measurements (P0)

Write each number in the register notes next to its photo.

| ID | What to measure |
| --- | --- |
| MEA-01 | One danfo of each body type: length, width, height, wheelbase, ground clearance, sliding-door opening (width and height), step height |
| MEA-02 | Seat layout: number of rows, seats per row, row spacing, aisle (if any) |
| MEA-03 | Stripe heights and widths (DET-01) |
| MEA-04 | One typical street: total road width, lane width, pavement width, kerb height, gutter width |
| MEA-05 | One typical building: storey height, shop opening width and height, frontage width |
| MEA-06 | A footbridge: deck height above the road, stair width |

### LMK — districts and landmarks (P2)

These are for later content beyond the test district. Use the research dossier's area list (`docs/research-and-design.md`, section 5).

| ID | Area | Shots | Notes |
| --- | --- | --- | --- |
| LMK-01 | Ojuelegba: bridge, junction, under-bridge trade | 10 | |
| LMK-02 | Oshodi: interchange, terminals, overpasses | 10 | |
| LMK-03 | Third Mainland Bridge: approaches, the bridge, lagoon views | 8 | From a vehicle. Never stop on the bridge. |
| LMK-04 | CMS and Marina: commercial streets beside the water | 8 | |
| LMK-05 | Lekki and Ikoyi: the contrasting newer Lagos | 8 | |
| LMK-06 | Apapa: port roads, trucks and tankers | 8 | From a safe distance. |
| LMK-07 | Idumota and Balogun: dense market streets | 8 | |

### VID — short video clips (optional, high value)

Photos miss motion. Clips of 10–30 seconds on a phone help most for:

| ID | Subject |
| --- | --- |
| VID-01 | A danfo pulling in, loading and leaving a stop, from the pavement |
| VID-02 | A conductor calling destinations and collecting fares |
| VID-03 | A ride from inside a danfo: the driver's view of traffic |
| VID-04 | Go-slow traffic with hawkers moving between vehicles |
| VID-05 | Danfo exhaust smoke and the sliding door opening and closing |

Video files are large, so keep them on a shared drive and link them in the register instead of committing them.

## When photos arrive

Each batch can feed the build straight away:

1. **DAN, DET and MEA:** remodel the danfo with correct proportions, stripes, wear and details.
2. **STR, STP, BLD, TRD and OVH:** rebuild street width, density and clutter to match what is actually there.
3. **TEX:** replace the procedural colours with photo-based materials, sized within the mobile texture budget.
4. **PPL and SGN:** improve the crowds and passengers, and the invented signs and lettering.
