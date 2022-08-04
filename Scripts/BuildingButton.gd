extends TextureRect


export var object:Resource



func _ready() -> void:
	material = preload("res://Resources/GrayScale.tres").duplicate()
	texture=object.texture
	rect_scale = Vector2.ONE*0.8
	connect("mouse_entered",self,"_mouse_entered")
	connect("mouse_exited",self,"_mouse_exited")


func _process(delta: float) -> void:
	material.set("shader_param/gray",Game.wood<object.wood or Game.crystals < object.energy_stones)
	  




func _mouse_entered():
	Game.hovered_button=object
	Game.show_popup()
	var tween = get_tree().create_tween()
	tween.tween_property(self,"rect_scale",Vector2.ONE*0.9,0.1)

func _mouse_exited():
	Game.tool_tip.visible=false
	var tween = get_tree().create_tween()
	tween.tween_property(self,"rect_scale",Vector2.ONE*0.8,0.1)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if Game.wood>=object.wood and Game.crystals>=object.energy_stones:
				Game.to_place=object
				Game.can_place=false
				yield(get_tree().create_timer(0.5),"timeout")
				Game.can_place = true
			else :
				Game.add_notification("You Dont Have Enough Resources !!",Color.yellow.lightened(0.2))
				


