extends "res://Scripts/Vehicle.gd"


var direction:Vector2
var going:=false
var at_home:=false
var returning:=false

onready var notifier := $VisibilityNotifier2D


func _ready() -> void:
	direction = Vector2(randf()*2-1,randf()).normalized()

func _process(delta: float) -> void:
	if not home.is_in_network:
		return
	if not at_home:
		rotation=direction.angle()
		translate(direction*2)
	if not notifier.is_on_screen() and not going:
		going=true
		yield(get_tree().create_timer(randi()%120+20),"timeout")
		var found_workers := randi()%20+5
		go_to_home()
		yield(self,"back_home")
		at_home=true
		visible=false
		Game.avaiable_workers+=found_workers
		Game.population+=found_workers
		Game.add_notification("found %s new workers"%found_workers,Color.yellow)
		yield(get_tree().create_timer(randi()%60+30),"timeout")
		visible=true
		going=false
		at_home=false


