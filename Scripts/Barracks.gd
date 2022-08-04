extends "res://Scripts/BaseBuilding.gd"

var soldiers:=[]
var max_soldiers:=10


func get_class(): return "WorkerBuilding"

func _init() -> void:
	texture = preload("res://Sprites/Structure/scifiStructure_01.png")
func die():
	for sold in soldiers : sold.home=Game.main_base
	.die()
func selected():
	Game.add_worker.visible=true

func add_worker():
	if len(soldiers)<max_soldiers and Game.avaiable_workers>0:
		var soldier := preload("res://Scenes/Soldier.tscn").instance()
		Game.workers_node.add_child(soldier)
		soldier.position=position
		soldiers.append(soldier)
		Game.avaiable_workers-=1
	else :
		Game.add_notification("There is no room in this Barracks",Color.yellow)
