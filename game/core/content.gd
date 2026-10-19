class_name Content
extends RefCounted
## Static game content: buses, paints, horns, routes, courses and rivals.
## Names, slogans and liveries are original; slogans use common public phrases.

const BUS_MODELS := {
	"classic14": {
		"label": "Classic rear-engine danfo",
		# Proportions follow the classic flat-front, rear-engine minibus class.
		"length": 4.57, "width": 1.84, "height": 1.95, "wheelbase": 2.46,
		"seats": 14, # 2 front + 3 rows of 4
	},
}

const PAINTS := {
	"lagos_yellow": {"label": "Lagos yellow", "body": Color(0.95, 0.74, 0.05), "stripe": Color(0.06, 0.06, 0.06)},
	"sun_faded": {"label": "Sun-faded", "body": Color(0.88, 0.73, 0.32), "stripe": Color(0.15, 0.14, 0.12)},
	"fresh_coat": {"label": "Fresh coat", "body": Color(1.0, 0.8, 0.0), "stripe": Color(0.02, 0.02, 0.02)},
}

const HORNS := {
	"two_tone": {"label": "Two-tone", "tones": [415.0, 523.0], "pattern": [0.18, 0.06, 0.32]},
	"hoarse": {"label": "Hoarse", "tones": [311.0, 349.0], "pattern": [0.45]},
	"triple": {"label": "Triple tap", "tones": [466.0, 587.0], "pattern": [0.1, 0.05, 0.1, 0.05, 0.22]},
}

# Stop names are landmark-style descriptions, as Lagos stops are commonly named.
const STOP_NAMES := [
	"Garage", "Market Junction", "Under Bridge", "Filling Station", "Church Gate",
	"Mosque Road", "Mechanic Village", "School Road", "Pharmacy", "Big Tree",
	"Water Tank", "Old Cinema", "Hospital Gate", "Bank Corner", "Plank Market",
	"Second Gate",
]

const ROUTES := {
	"garage_loop": {
		"label": "Garage – Market – Under Bridge",
		"description": "Busy loop through the market side of the district.",
		"stops": ["Garage", "Market Junction", "Filling Station", "Under Bridge", "Church Gate", "Mechanic Village"],
		"journeys_target": 10,
		"duration_hint": "about 6 min",
		"demand": "High at the market, steady elsewhere",
	},
}

const COURSES := {
	"ring_road": {
		"label": "Ring Road Sprint",
		"description": "One lap of the district ring road. Wide corners, long straights.",
		"laps": 1,
		"loop": "outer",
	},
	"inner_loop": {
		"label": "Inner Loop",
		"description": "Two laps around the central blocks. Tight corners, plenty of contact.",
		"laps": 2,
		"loop": "inner",
	},
}

const DIFFICULTIES := {
	"easy": {"label": "Easy", "speed": 0.86, "corner": 0.88},
	"normal": {"label": "Normal", "speed": 0.95, "corner": 0.97},
	"hard": {"label": "Hard", "speed": 1.02, "corner": 1.04},
}

const RIVALS := {
	"mama_kemi": {
		"label": "Mama Kemi", "tactic": "gap_defender", "slogan": "SURU LERE",
		"paint": "sun_faded", "horn": "hoarse",
		"speed": 0.97, "corner": 0.96, "lane_bias": 0.0, "defend": 1.0, "brake_late": 0.0,
	},
	"ayo_late_brake": {
		"label": "Ayo Late-Brake", "tactic": "late_braker", "slogan": "NO KING AS GOD",
		"paint": "fresh_coat", "horn": "triple",
		"speed": 1.0, "corner": 1.0, "lane_bias": 1.2, "defend": 0.2, "brake_late": 1.0,
	},
	"chidi_corner": {
		"label": "Chidi Corner-Cutter", "tactic": "opportunist", "slogan": "TIME NA MONEY",
		"paint": "lagos_yellow", "horn": "two_tone",
		"speed": 0.99, "corner": 1.02, "lane_bias": -1.2, "defend": 0.4, "brake_late": 0.4,
	},
}
