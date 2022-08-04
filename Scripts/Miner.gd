extends "res://Scripts/BaseBuilding.gd"

var number_of_workers:=0



func get_class(): return "WorkerBuilding"

func _init() -> void:
	texture = preload("res://Sprites/Structure/scifiStructure_02.png")
	energy_con=50

func worker_back(worker):
	Game.crystals+=worker.holding_items
	worker.holding_items=0


func selected():
	Game.add_worker.visible=true

func add_worker():
	if  Game.avaiable_workers>0:
		var stone :Node2D=Game.find_not_busy_stone(position)
		if stone :
			Game.new_worker(self,stone)
