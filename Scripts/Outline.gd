extends Node2D


func _ready() -> void:
	visible=false


func _draw() -> void:
	var size = 68
	draw_rect(Rect2(get_parent().position-Vector2.ONE*size/2,Vector2.ONE*size),Color.white,false,4)

