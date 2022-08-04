extends "res://Scripts/FunctionalBuilding.gd"



func _init() -> void:
	source = preload("res://Scenes/EnergyCrystal.tscn").instance()
	texture = preload("res://Sprites/Structure/scifiStructure_05.png")

func _process(delta: float) -> void:
	._process(delta)
	energy_con=-20*close_sources-20
	
	
	
	

