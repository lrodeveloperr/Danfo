class_name Tuning
extends RefCounted
## Placeholder economy values in naira (₦). These are fictional game values chosen
## for pacing, not real-world prices; PRODUCT_SPEC.md leaves exact economy values
## to be settled explicitly before release.

# Hire-purchase agreement for the starting bus. The deposit is already saved in
# the character's story, so play starts with the balance outstanding.
const STARTING_NAIRA := 20_000
const STARTING_BUS_PRICE := 1_200_000
const STARTING_BUS_DEPOSIT := 300_000
# Disclosed share of each event's net earnings applied to the purchase balance.
const INSTALMENT_SHARE := 0.5

# Work fares: a completed journey pays a base fare plus a per-stop amount.
const FARE_BASE := 700
const FARE_PER_STOP := 300
# Work operating costs.
const FUEL_COST_PER_KM := 250
const CONDUCTOR_SHARE := 0.15
const PARK_LEVY_PER_SHIFT := 1_000

# Race prize by finishing position (index 0 = first place).
const RACE_PRIZES := [40_000, 25_000, 15_000, 8_000]

# Bounded history kept in the save.
const LEDGER_LIMIT := 300
const SETTLED_EVENT_LIMIT := 60
const GRANTED_REWARD_LIMIT := 120
