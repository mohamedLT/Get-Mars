extends "BaseBuilding.gd"

var effect_field_size :=2
var source :Node2D
var draw_field:=false
var close_sources:=0

func get_class():return "FunctionalBuilding"

func _draw() -> void:
	draw_field = Game.selected==self or  (hovered and Game.selected==null)
	if draw_field:
		sprite.show_behind_parent=false
		var col =Color.aqua
		var pos = -Vector2.ONE*32-Vector2.ONE*64*effect_field_size
		col.a=0.4
		draw_rect(Rect2(pos,Vector2.ONE*(effect_field_size*2+1)*64),Color.aquamarine,false,8)
		draw_rect(Rect2(pos,Vector2.ONE*(effect_field_size*2+1)*64),col,true,1)

func _process(delta: float) -> void:
	._process(delta)
	var objects = Game.get_colliding_objects(position,Vector2.ONE*32*effect_field_size)
	close_sources=0
	for object in objects:
		var obj = object["collider"].get_parent()
		if obj == self : continue
		if obj.get_class()==source.get_class() :
			if obj.matuare:
				close_sources+=1
			obj.z_index= z_index+1 if draw_field else obj.z_index


func get_sources():
	var objects = Game.get_colliding_objects(position,Vector2.ONE*32*effect_field_size)
	var sources=[]
	for object in objects:
		var obj = object["collider"].get_parent()
		if obj == self : continue
		if obj.get_class()==source.get_class() :
			sources.append(obj)
