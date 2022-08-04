extends "res://Scripts/Attacker.gd"

var health:=10

func _ready() -> void:
	speed=200
	._ready()
	add_to_group("enemy")
	yield(get_tree().create_timer(10),"timeout")
	while health>0 :
		opponent = find_opponent()
		if is_instance_valid(opponent):
			rotation_tween = get_tree().create_tween().set_loops(0)
			rotation_tween.tween_property(self,"rotation",-PI/8,0.2)
			rotation_tween.tween_property(self,"rotation",PI/8,0.2)
			while is_instance_valid(opponent) and position.distance_to(opponent.position)>20:
				position+=position.direction_to(opponent.position).normalized()*(speed/50)
				yield(get_tree(),"physics_frame")
			rotation_tween.stop()
			rotation_tween=null
			attack()
			yield(self,"killed_opponent")
		yield(get_tree(),"physics_frame")

func _process(delta: float) -> void:
	if health<=0:
		queue_free()

func find_opponent()->Node2D:
	var workers_list = get_tree().get_nodes_in_group("building")
	if workers_list.empty(): 
		print("uh oh")
		return null
	if len(workers_list)==1:return workers_list[0]
	var nearest:Node2D=workers_list[0]
	for worker in workers_list:
		if worker.health<=0:continue
		if position.distance_to(worker.position)<position.distance_to(nearest.position) and worker.health>0:
			nearest=worker
	return nearest
