extends "res://Scripts/tile_entity.gd"

func get_class():return "BaseBuilding"

var energy_con:=10
var ox_con:=10
var connections:=[]
var is_in_network:=false
var health:=15



func take_damage():
	health-=1
	if health<=0:
		die()
	

func die():
	remove_from_group("building")
	visible=false
	get_node("Area2D/CollisionShape2D").set_deferred("disabled",true)
	for con in connections : con.connections.erase(self)
	Game.update()
	yield(get_tree().create_timer(5),"timeout")
	queue_free()

func _ready() -> void:
	._ready()
	Game.add_notification("this building in not on the network" , Color.yellow)
	add_to_group("building")
	z_index=5
	show_on_top=true

func mouse_changed(entered):
	update()



func _process(delta: float) -> void:
	is_in_network = self in Game.network and Game.total_energy_cons<0
	modulate = Color.white if is_in_network else Color.gray
	if not is_in_network : return
	._process(delta)

