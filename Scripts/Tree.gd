extends "res://Scripts/tile_entity.gd"
func get_class():return "Tree"

func _init() -> void:
	add_to_group("trees")
	var textures = []
	textures.append(preload("res://Sprites/Tile/scifiTile_01.png"))
	textures.append(preload("res://Sprites/Tile/scifiTile_02.png"))
	textures.append(preload("res://Sprites/Tile/scifiTile_15.png"))
	textures.append(preload("res://Sprites/Tile/scifiTile_16.png"))
	textures.append(preload("res://Sprites/Tile/scifiTile_27.png"))
	textures.append(preload("res://Sprites/Tile/scifiTile_28.png"))
	textures.append(preload("res://Sprites/Tile/scifiTile_29.png"))
	textures.append(preload("res://Sprites/Tile/scifiTile_30.png"))
	texture = textures[randi()%len(textures)]
