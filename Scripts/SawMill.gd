extends "res://Scripts/BaseBuilding.gd"


var number_of_workers:=0


func get_class(): return "WorkerBuilding"

func _init() -> void:
	texture = preload("res://Sprites/Structure/scifiStructure_06.png")
	ox_con=50
	energy_con=50

func worker_back(worker):
	Game.wood+=worker.holding_items
	worker.holding_items=0


func selected():
	Game.add_worker.visible=true


func add_worker():
	print("hello")
	if Game.avaiable_workers>0:
		var tree :Node2D= Game.find_not_busy_tree(position)
		if tree :
			Game.new_worker(self,tree)
