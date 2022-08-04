extends Node2D


enum Choices { DEFENDER,TRANSPORTER,MINER_STONE,MINER_WOOD }


const MAP_SIZE = 100


onready var root:Node2D = get_tree().root.get_children()[1]
onready var control:Control = root.get_node("Layer/Control")
onready var cam:Camera2D= root.get_node("Camera")
onready var placed:Node2D = root.get_node("Placed")
onready var NetworkButton:TextureButton = control.get_node("NetworkMode")
onready var energy_label:Label = control.get_node("Energy/Label")
onready var ox_label:Label = control.get_node("Ox/Label")
onready var wood_label:Label = control.get_node("Wood/Label")
onready var crystals_label:Label = control.get_node("Crystals/Label")
onready var main_base:Node2D = placed.get_node("MainBase")
onready var add_worker:Button=control.get_node("Button")
onready var building_panel:Control = control.get_node("BuildingPanel")
onready var workers_node:Node2D = root.get_node("Workers")
onready var timer_label:Label= control.get_node("Timer")
onready var wave_label:Label= control.get_node("Wave")
onready var worker_label:Label= control.get_node("Workers")
onready var tool_tip:Panel= control.get_node("ToolTip")
onready var Garage_panel:Control = control.get_node("GaragePanel")                  



var wave_count:=1
var wave_mobs_number:=2
var wave_time:int=420
var wave_timer:Timer 
var selected:Node2D  setget _on_select
var to_place :Resource
var hovered:Node2D
var to_place_preview:Sprite = Sprite.new()
var network_line :Line2D = Line2D.new()
var network:=[]
var workers:={}
var population:=10
var avaiable_workers:=10
var is_on_network_mode:=false
var can_place:=true
var total_energy_cons:= 0
var total_ox_cons:=0
var wood:=500
var crystals:=500
var choices_shown:=false
var hovered_button:SObject
var in_game:=false






func start_game():
	root.queue_free()
	get_tree().root.add_child(preload("res://Game.tscn").instance())
	reset_nodes(null)
	in_game=true
	ready()


func game_over():
	set_process(false)
	set_process_input(false)
	root.queue_free()
	var new_root=preload("res://Gameover.tscn").instance()
	get_tree().root.add_child(new_root)
	reset_nodes(new_root)
	in_game=false






func end_game():
	root.queue_free()
	var new_root = preload("res://Scenes/MainMenu.tscn").instance()
	get_tree().root.add_child(new_root)
	reset_nodes(new_root)

func reset_nodes(new_root):
	root= get_tree().root.get_children()[2] if not new_root else new_root
	control= root.get_node("Layer/Control")
	cam= root.get_node("Camera")
	placed= root.get_node("Placed")
	NetworkButton= control.get_node("NetworkMode")
	energy_label= control.get_node("Energy/Label")
	ox_label= control.get_node("Ox/Label")
	wood_label= control.get_node("Wood/Label")
	crystals_label= control.get_node("Crystals/Label")
	main_base= placed.get_node("MainBase")
	add_worker=control.get_node("Button")
	building_panel= control.get_node("BuildingPanel")
	workers_node= root.get_node("Workers")
	timer_label= control.get_node("Timer")
	wave_label= control.get_node("Wave")
	worker_label= control.get_node("Workers")
	tool_tip= control.get_node("ToolTip")
	Garage_panel= control.get_node("GaragePanel")     
	if in_game:             
		generate_env()

func show_popup():
	tool_tip.get_node("Name").text = hovered_button.name
	tool_tip.get_node("Wood").text ="wood: "+ str(hovered_button.wood)
	tool_tip.get_node("Stone").text ="stone: "+str(hovered_button.energy_stones)
	tool_tip.visible=true

func is_tile_busy(tile:Node2D):
	return tile in workers.values()

func is_worker_busy(worker:Node2D):
	return worker in workers.keys()


func new_worker(home:Node2D,target:Node2D):
	if is_tile_busy(target):
		return false
	var worker = preload("res://Scenes/Worker.tscn").instance()
	worker.home=home
	worker.target=target.position
	workers[worker]=target
	avaiable_workers-=1
	workers_node.add_child(worker)
	worker.position=main_base.position
	worker.connect("back_home",home,"worker_back",[worker])
	return true



func find_not_busy_tree(pos:Vector2):
	var trees := get_tree().get_nodes_in_group("trees")
	var not_busy:=[]
	for tree in trees:
		if not is_tile_busy(tree):
			not_busy.append(tree)
	var nearest:Node2D=not_busy[0]
	for tree in not_busy:
		if pos.distance_to(tree.position)<pos.distance_to(nearest.position):
			nearest=tree
	return nearest


func find_not_busy_stone(pos:Vector2):
	var stones := get_tree().get_nodes_in_group("stones")
	var not_busy:=[]
	for stone in stones:
		if not is_tile_busy(stone):
			not_busy.append(stone)
	var nearest:Node2D=not_busy[0]
	for stone in not_busy:
		if pos.distance_to(stone.position)<pos.distance_to(nearest.position):
			nearest=stone
	return nearest

func add_notification(text:String,color:Color):
	var tween = get_tree().create_tween()
	var label = Label.new()
	label.text=text
	label.set("custom_colors/font_color",color)
	control.add_child(label)
	var center :float = (get_viewport().size.x-len(text)*8)/2
	label.rect_position = Vector2(center,40)
	tween.tween_property(label,"rect_position",Vector2(center,70),1)
	tween.set_parallel(true)
	tween.tween_property(label,"rect_position",Vector2(center,150),3)
	tween.tween_property(label,"modulate",Color(1,1,1,0),3)
	tween.chain().tween_callback(label,"queue_free")


func _on_select(value):
	if selected and selected != value :
		selected.deselected()
	if value:
		if value.get_class() == "WorkerBuilding":
			add_worker.visible=true
			add_worker.base=value
		else:
			add_worker.visible=false
	else :
		if selected.get_class() != "WorkerBuilding":
			selected=value
		else :
			return
	if value == main_base:
		var tween = get_tree().create_tween()
		tween.tween_property(building_panel,"rect_position",Vector2(-80,0),0.5)
	if building_panel.rect_position==Vector2(-80,0):
		var tween = get_tree().create_tween()
		tween.tween_property(building_panel,"rect_position",Vector2(50,0),0.5)
	if selected:
		selected.update()
	selected=value

func add_building(building:Node2D):
	placed.add_child(building)
	

func get_connections(building:Node2D,from:Node2D):
	for con in building.connections:
		if con != from and not con in network: 
			network.append(con)
			get_connections(con,building)
	
func get_network():
	network.clear()
	network.append(main_base)
	get_connections(main_base,null)
	update_totals()


func update_totals():
	total_energy_cons=0
	total_ox_cons=0
	for node in network:
		if is_instance_valid(node):
			total_energy_cons+=node.energy_con
			total_ox_cons+=node.ox_con
	
func ready():
	if not in_game:return
	tool_tip.visible=false
	wave_timer=Timer.new()
	wave_timer.one_shot=true
	wave_timer.connect("timeout",self,"wave_timer_done")
	add_child(wave_timer)
	wave_timer.start(wave_time)
	z_index=4
	to_place_preview.z_index=10
	to_place_preview.modulate=Color(1,1,1,0.4)
	add_child(network_line)
	network_line.width=5
	network_line.z_as_relative=false
	network_line.z_index=10
	add_child(to_place_preview)
	get_network()
	set_process(true)
	set_process_input(true)

func _ready() -> void:
	set_process(false)
	set_process_input(false)
	ready()





func spawn_mobs():
	var i:=0
	while i<wave_mobs_number :
		var randx := sign(randf()*2-1)
		var randy := sign(randf()*2-1)
		var pos = Vector2(randx*rand_range(-5000,1200),randy*rand_range(-500,1200))
		if is_instance_valid(main_base) and main_base.position.distance_to(pos)<800:continue
		var mob :=preload("res://Scenes/Enemy.tscn").instance()
		root.add_child(mob)
		mob.position=pos
		i+=1

func wave_timer_done():
	wave_time-=30 if wave_time>120 else 0
	spawn_mobs()
	yield(get_tree().create_timer(20),"timeout")
	wave_timer.start(wave_time)
	wave_count+-1
	wave_mobs_number+=randi()%(wave_count*2)+wave_count/2

func _process(_delta: float) -> void:
	var viewport_size := get_viewport().size
	var mouse_pos:=get_global_mouse_position()
	var tooltip_pos:=mouse_pos+viewport_size/2+Vector2.DOWN*20 if viewport_size.x-mouse_pos.x>700 else \
	mouse_pos+viewport_size/2+Vector2(-140,20)
	tool_tip.rect_global_position=tooltip_pos
	worker_label.text = "workers "+str(avaiable_workers)+"/"+str(population)
	wave_label.text = "Wave "+str(wave_count)
	var wave_minutes := floor(wave_timer.time_left/60)
	timer_label.text = str(wave_minutes)+":"+str(int(wave_timer.time_left-wave_minutes*60))
	timer_label.modulate = Color.red if wave_timer.time_left<10 else Color.white
	NetworkButton.grab_focus()
	network_line.visible=is_on_network_mode
	to_place_preview.texture=to_place.scene.instance().texture if to_place else null
	to_place_preview.position=get_global_mouse_position()
	energy_label.text = str(abs(total_energy_cons))
	energy_label.modulate = Color.green if total_energy_cons<0 else Color.red
	ox_label.text = str(abs(total_ox_cons))
	ox_label.modulate=  Color.green if total_energy_cons<0 else Color.red
	wood_label.text = str(wood)
	crystals_label.text = str(crystals)
	var tmp = is_on_network_mode
	is_on_network_mode=NetworkButton.pressed
	if  tmp != NetworkButton.pressed:
		update()
	if is_on_network_mode:
		do_network_management()
	if to_place :
		var objs := get_colliding_objects(get_global_mouse_position(),Vector2.ONE*32)
		if not objs.empty():
			to_place_preview.modulate=Color(1,0,0,0.4)
		else :
			to_place_preview.modulate=Color(1,1,1,0.4)
	update_totals()
	



func do_network_management():
	if selected:
		if "connections" in selected:
			network_line.points = [selected.position,get_global_mouse_position()]
			if Input.is_action_just_pressed("MouseR"):
				if   hovered and "connections" in hovered:
					if not(selected in hovered.connections):
						hovered.connections.append(selected)
					if not(hovered in selected.connections):
						selected.connections.append(hovered)
					get_network()
					update()
	else :
		network_line.points=[]
	

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("MouseR"):
		if to_place:
			to_place=null
	if Input.is_action_just_pressed("MouseL"):
		var tween = get_tree().create_tween()
		if selected :
			tween.tween_interval(0.1)
			tween.tween_callback(selected,"update")
			if selected.get_class() !="BaseBuilding":
				tween.tween_property(selected,"show_on_top",false,0.01)
			_on_select(null)
			yield(get_tree().create_timer(0.5),"timeout")
		if to_place and can_place:
			var pos = get_global_mouse_position()
			if not check_cell(pos):
				var root = placed
				var to_place_instance :Node2D = to_place.scene.instance()
				wood-=to_place.wood
				crystals-=to_place.energy_stones
				add_building(to_place_instance)
				to_place_instance.position=pos
				to_place=null
			else :
				tween.tween_property(to_place_preview,"offset",Vector2.RIGHT*10,0.05)
				tween.tween_property(to_place_preview,"offset",Vector2.LEFT*10,0.05)
				tween.tween_property(to_place_preview,"offset",Vector2.ZERO,0.05)
		

func generate_env():
	var base = root.get_node("Generated")
	var nodes  =[preload("res://Scenes/EnergyStone.tscn"),preload("res://Scenes/Tree.tscn")]
	var start_pos = -Vector2.ONE*0.5*MAP_SIZE*MAP_SIZE
	var pos = Vector2.ZERO
	for x in MAP_SIZE:
		for y in MAP_SIZE:
			pos= start_pos+ Vector2(x,y)*64
			if randf()>0.8:
				if not check_cell(pos):
					randomize()
					var num =randi()%2
					var node = nodes[num].instance()
					base.add_child(node)
					node.position=pos
		yield(get_tree(),"idle_frame")

func check_cell(pos:Vector2)->bool:
	var space = get_world_2d().direct_space_state
	var tras = Transform2D(0,pos)
	var shape =  RectangleShape2D.new()
	shape.extents = Vector2.ONE*32
	var query = Physics2DShapeQueryParameters.new()
	query.set_shape(shape)
	query.transform=tras
	query.collide_with_areas=true
	return not space.intersect_shape(query).empty()


func _draw() -> void:
	if is_on_network_mode:
		draw_network()


func draw_network():
	draw_connections(main_base,null)

func draw_connections(building:Node2D,from:Node2D):
	for con in building.connections:
		if con != from : 
			draw_line(building.position,con.position,Color.white,5,true)
			draw_connections(con,building)


func get_colliding_objects(pos:Vector2,extents:Vector2)->Array:
	var space = get_world_2d().direct_space_state
	var tras = Transform2D(0,pos)
	var shape =  RectangleShape2D.new()
	shape.extents = extents
	var query = Physics2DShapeQueryParameters.new()
	query.set_shape(shape)
	query.transform=tras
	query.collide_with_areas=true
	return space.intersect_shape(query)
