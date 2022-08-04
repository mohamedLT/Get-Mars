extends "res://Scripts/Entity.gd"



signal done_mining


func _ready() -> void:
	._ready()
	go_to_home()
	yield(self,"back_home")
	visible=false
	yield(get_tree().create_timer(5),"timeout")
	while true :
		if home.is_in_network:
			do_work()
			yield(self,"back_home")
			yield(get_tree().create_timer(randf()*5),"timeout")
		yield(get_tree(),"physics_frame")

func do_work():
	visible=true
	go_to_target()
	yield(self,"reached_target")
	mine()
	yield(self,"done_mining")
	go_to_home()
	yield(self,"back_home")
	visible=false


func mine():
	var random_val = randi()%20+1
	var iters = 0
	while can_work and iters<random_val :
		rotation_degrees=0
		var tween = get_tree().create_tween()
		tween.tween_property(self,"rotation",sign(dir.x)*PI/4,0.7)
		tween.tween_property(self,"rotation",-sign(dir.x)*PI/8,0.3)
		iters+=1
		yield(tween,"finished")
		holding_items+=1
	rotation_degrees=0
	can_work=false
	emit_signal("done_mining")
