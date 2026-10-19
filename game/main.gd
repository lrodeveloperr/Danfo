extends Node
## Entry scene. App owns screen flow; this node is only the root it builds under.


func _ready() -> void:
	App.boot(self)
