extends "res://Scripts/Vehicle.gd"


var working:=false
var attacking:=false

func _process(delta: float) -> void:
	if home.is_in_network and not attacking: 
		if not working :
			do_work()
		var nearby = nearby_enemy()
		if nearby :
			attack(nearby)
		
		

func attack(enemy:Node2D):
	attacking=true
	while is_instance_valid(enemy) and position.distance_to(enemy.position)<300:
		look_at(enemy.position)
		var bullet := preload("res://Scripts/Bullet.gd").new()
		bullet.target=enemy
		get_tree().root.add_child(bullet)
		bullet.position=position
		yield(bullet,"hit")
		if not is_instance_valid(enemy) :break
		enemy.health-=5
	attacking=false


func do_work():
	working=true
	while home.is_in_network:
		target=home.position + Vector2(randi()%200,randi()%200)
		go_to_target()
		yield(self,"reached_target")
		yield(get_tree().create_timer(rand_range(10,120)),"timeout")
	working=false


func nearby_enemy():
	var enemies:= get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		if position.distance_to(enemy.position)<300:
			return enemy
