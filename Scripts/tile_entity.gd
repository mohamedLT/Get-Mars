extends VisibilityNotifier2D


export var texture:Texture

onready var sprite:Sprite = get_node("Sprite")
onready var area:Area2D = get_node("Area2D")

var hovered :=false

func _ready() -> void:
	z_index=3
	sprite.show_behind_parent=true
	show_on_top=false
	sprite.texture = texture
	area.connect("mouse_entered",self,"_mouse_entered")
	area.connect("mouse_exited",self,"_mouse_exited")
	connect("screen_entered",self,"_on_screen")
	connect("screen_exited",self,"_off_screen")

func get_class():return "TileEntity"

func _on_screen():
	visible=true

func _off_screen():
	visible=false

func _mouse_entered():
	hovered=true
	Game.hovered=self
	mouse_changed(true)

func _mouse_exited():
	hovered=false
	Game.hovered=null
	mouse_changed(false)
	
func selected():
	pass

func deselected():
	pass

func _process(delta: float) -> void:
	if hovered :
		if Input.is_action_just_pressed("MouseL"):
			Game.selected=self
			selected()
			show_on_top=true
			update()

func mouse_changed(entered):
	pass

func _draw() -> void:
	if Game.selected==self and self.get_class() !="FunctionalBuilding"  :
		draw_rect(Rect2(Vector2.ONE*-32,Vector2.ONE*64),Color.white,false,5)



