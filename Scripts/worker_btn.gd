extends Button

var base:Node2D



func _gui_input(event:InputEvent):
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("MouseL"):
			base.add_worker()
