extends GutTest

var state: Dictionary


func before_each():
	state = AdPacing.new_state()


func _events(n: int) -> void:
	for i in n:
		AdPacing.record_qualifying_event(state)


func test_first_ad_needs_three_events_and_180_active_seconds():
	_events(2)
	AdPacing.record_active_time(state, 600.0)
	assert_false(AdPacing.interstitial_eligible(state, 1000.0), "two events is too few")
	_events(1)
	assert_true(AdPacing.interstitial_eligible(state, 1000.0))


func test_first_ad_needs_active_time():
	_events(5)
	AdPacing.record_active_time(state, 179.0)
	assert_false(AdPacing.interstitial_eligible(state, 1000.0))
	AdPacing.record_active_time(state, 1.0)
	assert_true(AdPacing.interstitial_eligible(state, 1000.0))


func test_later_ads_need_events_wall_time_and_active_time():
	_events(3)
	AdPacing.record_active_time(state, 200.0)
	AdPacing.record_fullscreen_closed(state, 1000.0)
	_events(2)
	AdPacing.record_active_time(state, 150.0)
	assert_false(AdPacing.interstitial_eligible(state, 1179.0), "under 180 s since close")
	assert_true(AdPacing.interstitial_eligible(state, 1180.0))


func test_later_ads_need_two_events():
	_events(3)
	AdPacing.record_active_time(state, 200.0)
	AdPacing.record_fullscreen_closed(state, 1000.0)
	_events(1)
	AdPacing.record_active_time(state, 500.0)
	assert_false(AdPacing.interstitial_eligible(state, 5000.0))


func test_later_ads_need_120_active_seconds():
	_events(3)
	AdPacing.record_active_time(state, 200.0)
	AdPacing.record_fullscreen_closed(state, 1000.0)
	_events(4)
	AdPacing.record_active_time(state, 119.0)
	assert_false(AdPacing.interstitial_eligible(state, 9000.0))


func test_rewarded_display_resets_spacing():
	_events(3)
	AdPacing.record_active_time(state, 400.0)
	assert_true(AdPacing.interstitial_eligible(state, 1000.0))
	# A displayed rewarded ad closes: spacing restarts from here.
	AdPacing.record_fullscreen_closed(state, 1000.0)
	assert_false(AdPacing.interstitial_eligible(state, 1000.0))


func test_negative_active_time_ignored():
	AdPacing.record_active_time(state, -50.0)
	assert_eq(state["active_seconds_total"], 0.0)
