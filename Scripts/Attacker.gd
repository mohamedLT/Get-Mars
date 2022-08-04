extends "res://Scripts/Entity.gd"

var opponent:Node2D

signal killed_opponent

func attack():
	if is_instance_valid(opponent):
		dir = position.direction_to(opponent.position)	
		while is_instance_valid(opponent) and opponent.health>0 :
			rotation_degrees=0
			var tween = get_tree().create_tween()
			tween.tween_property(self,"rotation",sign(dir.x)*PI/4,0.7)
			tween.tween_property(self,"rotation",-sign(dir.x)*PI/8,0.3)
			yield(get_tree(),"physics_frame")
			yield(tween,"finished")
			opponent.take_damage()
		emit_signal("killed_opponent")

