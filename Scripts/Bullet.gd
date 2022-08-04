extends Sprite 


var target:Node2D

signal hit

func _ready():
	z_index=100
	scale = Vector2.ONE*0.3
	modulate = Color.red
	texture = preload("res://Sprites/Shape 1.png")
	while is_instance_valid(target) and position.distance_to(target.position)>10:
		position+=position.direction_to(target.position)*2
		yield(get_tree(),"physics_frame")
	emit_signal("hit")
	queue_free()
