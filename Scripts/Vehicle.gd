extends "Entity.gd"


func _ready() -> void:
	._ready()
	speed=250

func go_to(pos:Vector2):
	can_work=false
	look_at(pos)
	rotation_tween = get_tree().create_tween()
	movement_tween = get_tree().create_tween()
	movement_tween.tween_property(self,"position",pos,position.distance_to(pos)*2/speed)
	yield(movement_tween,"finished")
	can_work=true
	rotation_tween.stop()
	emit_signal("done_moving")
