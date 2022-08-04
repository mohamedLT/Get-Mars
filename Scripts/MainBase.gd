extends "res://Scripts/BaseBuilding.gd"


func _init() -> void:
	energy_con=-100
	health=30
	ox_con=-100
	texture = preload("res://Sprites/Structure/scifiStructure_07.png")


func die():
	Game.game_over()
