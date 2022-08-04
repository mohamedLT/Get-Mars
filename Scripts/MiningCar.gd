extends "Vehicle.gd"


var type :=-1
var sprite:Texture
var working:=false

signal done_mining

func _ready() -> void:
	._ready()

func _process(delta: float) -> void:
	if not working:
		do_work()


func do_work():
	if home.is_in_network:
		working=true
		visible=true
		go_to_target()
		yield(self,"reached_target")
		mine()
		yield(self,"done_mining")
		go_to_home()
		yield(self,"back_home")
		visible=false
		yield(get_tree().create_timer(randf()*5),"timeout")
		working=false


func mine():
	var random_val = randi()%30+5
	var iters = 0
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",position-transform.x*10,0.7)
	yield(get_tree().create_timer(0.7),"timeout")
	var starting_pos = position
	while can_work and iters<random_val :
		tween = get_tree().create_tween()
		position=starting_pos
		tween.tween_property(self,"position",position-transform.x*10,0.7)
		tween.tween_property(self,"position",position+transform.x*5,0.3)
		iters+=1
		yield(tween,"finished")
		holding_items+=10
	rotation_degrees=0
	can_work=false
	emit_signal("done_mining")
