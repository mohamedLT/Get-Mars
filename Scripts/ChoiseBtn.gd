extends TextureRect


export var sprite:Texture
export(int,"DEFENDER","TRANSPORTER","MINER_STONE","MINER_WOOD") var type
var caller:Node2D



func _ready() -> void:
	texture=sprite
	rect_scale = Vector2.ONE*0.8
	connect("mouse_entered",self,"_mouse_entered")
	connect("mouse_exited",self,"_mouse_exited")



func _mouse_entered():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"rect_scale",Vector2.ONE*0.9,0.1)

func _mouse_exited():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"rect_scale",Vector2.ONE*0.8,0.1)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			caller.type=type
			caller.car_sprite=sprite
			caller.type_chosen(type)


