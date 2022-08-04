extends "tile_entity.gd"

func get_class():return "EnergyCrystal"

var matuare:=false

func _init() -> void:
	texture = preload("res://Sprites/Environment/scifiEnvironment_09.png")

func _ready() -> void:
	._ready()
	yield(get_tree().create_timer(6),"timeout")
	texture = preload("res://Sprites/Environment/scifiEnvironment_10.png")
	sprite.texture = texture
	matuare = true
