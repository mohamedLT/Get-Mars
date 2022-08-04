extends "res://Scripts/BaseBuilding.gd"


func get_class():return "Garage"

var vehicle:Node2D
var type:int=-1
var car_sprite:Texture

func _init() -> void:
	texture = preload("res://Sprites/Structure/scifiStructure_03.png")
	process_priority=10
	energy_con=100
	ox_con=150
	

func worker_back(worker):
	if type==2:
		Game.crystals+=worker.holding_items
	if type==3:
		Game.wood+=worker.holding_items
	worker.holding_items=0

func selected():
	if type==-1:
		show_choices()

func deselected():
	if Game.choices_shown :
		hide_choices()
		

func type_chosen(type):
	match type :
		Game.Choices.MINER_STONE , Game.Choices.MINER_WOOD :
			var target:Node2D= Game.find_not_busy_stone(position) if type == Game.Choices.MINER_STONE else Game.find_not_busy_tree(position)
			var worker = preload("res://Scenes/MiningCar.tscn").instance()
			worker.home=self
			worker.target=target.position
			Game.workers[self]=target
			Game.avaiable_workers-=1
			Game.workers_node.add_child(worker)
			worker.get_node("Sprite").texture=car_sprite
			worker.position=position
			worker.connect("back_home",self,"worker_back",[worker])
			vehicle=worker
		Game.Choices.TRANSPORTER:
			var trans :=preload("res://Scenes/Transporter.tscn").instance()
			Game.workers_node.add_child(trans)
			trans.position=position
			Game.avaiable_workers-=1
			trans.home=self
			trans.get_node("Sprite").texture=car_sprite
			vehicle=trans
		Game.Choices.DEFENDER:
			var defender:=preload("res://Scenes/Defender.tscn").instance()
			Game.workers_node.add_child(defender)
			defender.position = position
			Game.avaiable_workers-=1
			defender.home=self
			vehicle=defender

func die():
	vehicle.home=Game.main_base
	.die()

func show_choices():
	var tween := get_tree().create_tween()
	var pos :Vector2=Game.Garage_panel.rect_position
	pos.x=0
	tween.tween_property(Game.Garage_panel,"rect_position",pos,0.5)
	Game.choices_shown=true
	for btn in Game.Garage_panel.get_children():
		btn.caller=self

func hide_choices():
	var tween := get_tree().create_tween()
	var pos :Vector2=Game.Garage_panel.rect_position
	pos.x=-50
	tween.tween_property(Game.Garage_panel,"rect_position",pos,0.5)
	Game.choices_shown=false

