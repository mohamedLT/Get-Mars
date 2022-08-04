extends "res://Scripts/tile_entity.gd"
func get_class():return "EnergyStone"

func _init() -> void:
	add_to_group("stones")
	var textures = []
	textures.append(preload("res://Sprites/Environment/scifiEnvironment_01.png"))
	textures.append(preload("res://Sprites/Environment/scifiEnvironment_02.png"))
	textures.append(preload("res://Sprites/Environment/scifiEnvironment_07.png"))
	textures.append(preload("res://Sprites/Environment/scifiEnvironment_08.png"))
	texture = textures[randi()%len(textures)]
