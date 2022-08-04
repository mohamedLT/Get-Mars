extends "res://Scripts/BaseBuilding.gd"

func _init():
	texture = preload("res://Sprites/Structure/scifiStructure_16.png") 


func _ready() -> void:
	rotation_degrees=90 
	while true:
		if not is_in_network :
				yield(get_tree(),"physics_frame")
				continue 
		var enemy :Node2D= nearby_enemy()
		if enemy :
			while is_instance_valid(enemy)and position.distance_to(enemy.position)<500:
				look_at(enemy.position)
				var bullet := preload("res://Scripts/Bullet.gd").new()
				bullet.target=enemy
				get_tree().root.add_child(bullet)
				bullet.position=position
				yield(bullet,"hit")
				if not is_instance_valid(enemy):break
				enemy.health-=4
				yield(get_tree(),"physics_frame")
		yield(get_tree(),"physics_frame")







func nearby_enemy():
	var enemies:= get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		if position.distance_to(enemy.position)<300:
			return enemy
