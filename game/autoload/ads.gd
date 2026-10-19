extends Node
## Ad service facade. The production provider will be the Poing Studios AdMob
## plugin (PRODUCT_SPEC.md baseline); until it is integrated, a placeholder
## provider shows a labelled full-screen card so the result flow, pacing and
## exactly-once reward handling can be exercised end to end.

signal interstitial_closed
signal rewarded_finished(txn: String, earned: bool)

var _showing := false


func is_busy() -> bool:
	return _showing


func interstitial_ready() -> bool:
	return not _showing


func rewarded_ready() -> bool:
	return not _showing


func show_interstitial() -> void:
	if _showing:
		return
	_showing = true
	if _headless():
		_finish_interstitial()
		return
	var card := _card("Advertisement placeholder", "Real ads arrive with the AdMob integration.")
	var close := Button.new()
	close.text = "Close"
	close.custom_minimum_size = Vector2(220, 64)
	close.pressed.connect(func():
		card.queue_free()
		_finish_interstitial())
	card.get_node("Panel/Box").add_child(close)


func show_rewarded(txn: String) -> void:
	if _showing:
		return
	_showing = true
	if _headless():
		_finish_rewarded(txn, true)
		return
	var card := _card("Rewarded ad placeholder", "Watching to the end earns the offered bonus.")
	var box: VBoxContainer = card.get_node("Panel/Box")
	var finish := Button.new()
	finish.text = "Finish ad (earn bonus)"
	finish.custom_minimum_size = Vector2(300, 64)
	finish.pressed.connect(func():
		card.queue_free()
		_finish_rewarded(txn, true))
	var skip := Button.new()
	skip.text = "Skip (no bonus)"
	skip.custom_minimum_size = Vector2(300, 56)
	skip.pressed.connect(func():
		card.queue_free()
		_finish_rewarded(txn, false))
	box.add_child(finish)
	box.add_child(skip)


## Completion signals are always emitted on a later frame, so callers that
## show an ad and then await its signal can never miss a fast callback.
func _finish_interstitial() -> void:
	_showing = false
	interstitial_closed.emit.call_deferred()


func _finish_rewarded(txn: String, earned: bool) -> void:
	_showing = false
	rewarded_finished.emit.call_deferred(txn, earned)


func _headless() -> bool:
	return DisplayServer.get_name() == "headless"


func _card(title: String, body: String) -> CanvasLayer:
	var layer := CanvasLayer.new()
	layer.layer = 100
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.92)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(shade)
	var panel := CenterContainer.new()
	panel.name = "Panel"
	panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(panel)
	var box := VBoxContainer.new()
	box.name = "Box"
	box.add_theme_constant_override("separation", 18)
	panel.add_child(box)
	var heading := Label.new()
	heading.text = title
	heading.add_theme_font_size_override("font_size", 34)
	box.add_child(heading)
	var text := Label.new()
	text.text = body
	box.add_child(text)
	get_tree().root.add_child(layer)
	return layer
