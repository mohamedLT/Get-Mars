extends Node2D


var speed = 100
var target:Vector2
var home : Node2D
var can_work:=true
var dir :=Vector2.ONE
var holding_items:=0
var movement_tween:SceneTreeTween
var rotation_tween:SceneTreeTween


onready var last_pos:Vector2=position



signal reached_target
signal back_home
signal done_moving



func _ready() -> void:
	z_index=20


func do_work():
	pass

func go_to_home():
	go_to(home.position)
	yield(self,"done_moving")
	emit_signal("back_home")

func go_to_target():
	go_to(target)
	yield(self,"done_moving")
	emit_signal("reached_target")


func go_to(pos:Vector2):
	can_work=false
	movement_tween = get_tree().create_tween()
	movement_tween.tween_property(self,"position",pos,position.distance_to(pos)*2/speed)
	rotation_tween = get_tree().create_tween().set_loops(0)
	rotation_tween.tween_property(self,"rotation",-PI/8,0.2)
	rotation_tween.tween_property(self,"rotation",PI/8,0.2)
	yield(movement_tween,"finished")
	can_work=true
	rotation_tween.stop()
	rotation_degrees=0
	emit_signal("done_moving")




func _process(delta: float) -> void:
	if position!=last_pos:
		dir = (position.direction_to(last_pos).normalized())



