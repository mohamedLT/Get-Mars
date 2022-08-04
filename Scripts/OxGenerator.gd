extends "res://Scripts/FunctionalBuilding.gd"


func _init() -> void:
	source = preload("res://Scenes/OxProducer.tscn").instance()
	energy_con=50
	texture = preload("res://Sprites/Structure/scifiStructure_15.png")

func _process(delta: float) -> void:
	._process(delta)
	ox_con = -20-20*close_sources
