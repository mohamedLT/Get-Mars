extends "res://Scripts/Entity.gd"

var attacking:=false


func _ready() -> void:
	._ready()
	while true:
		var random_pos := Vector2(rand_range(-300,300),rand_range(-300,300))+position
		if random_pos.distance_to(Game.main_base.position)>1500:
			random_pos=Vector2(rand_range(-300,300),rand_range(-300,300))+Game.main_base.position
		go_to(random_pos)
		yield(self,"done_moving")
		var enemy:Node2D=nearby_enemy()
		var wait_time := randi()%1200+240
		var elapsed_time :=0
		while elapsed_time<wait_time:
			if enemy : break
			enemy = nearby_enemy()
			yield(get_tree(),"physics_frame")
			elapsed_time+=1
		if enemy :
			attacking=true
			attack(enemy)
			while attacking:
				yield(get_tree(),"physics_frame")
	
func attack(enemy:Node2D):
	while is_instance_valid(enemy) and position.distance_to(enemy.position)<300:
		look_at(enemy.position)
		var bullet := preload("res://Scripts/Bullet.gd").new()
		bullet.target=enemy
		get_tree().root.add_child(bullet)
		bullet.position=position
		yield(bullet,"hit")
		if not is_instance_valid(enemy):break 
		enemy.health-=1
	attacking=false

func nearby_enemy():
	var enemies:= get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		if position.distance_to(enemy.position)<300:
			return enemy

func _process(_delta):
	visible=$VisibilityNotifier2D.is_on_screen()
