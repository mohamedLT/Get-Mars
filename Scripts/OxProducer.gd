extends "res://Scripts/tile_entity.gd"

func get_class():return "OxProducer"

var matuare:=false


func _init() -> void:
	texture = preload("res://Sprites/Structure/scifiStructure_11.png")
	

func _ready() -> void:
	._ready()
	yield(get_tree().create_timer(6),"timeout")
	texture = preload("res://Sprites/Structure/scifiStructure_12.png")
	sprite.texture = texture
	matuare=true
	
