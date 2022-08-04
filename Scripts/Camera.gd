extends Camera2D



func _physics_process(delta: float) -> void:
	
	var horizontal = Input.get_action_strength("Right")-Input.get_action_strength("Left")
	var vertical = Input.get_action_strength("Down")-Input.get_action_strength("Up")
	translate(Vector2(horizontal,vertical).normalized()*5)
	var MAX := 800
	var MIN :=-4500
	if (global_position.x < MIN):
		global_position.x = MIN
	elif (global_position.x > MAX):
		global_position.x = MAX

	if (global_position.y < MIN):
		global_position.y = MIN
	elif (global_position.y > MAX):
		global_position.y = MAX
