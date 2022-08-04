extends MultiMeshInstance2D

func _ready() -> void:
	var size = 100
	multimesh.instance_count = size*size
	position = Vector2(0.5,0.5)*-multimesh.instance_count
	var i =0
	for x in size :
		for y in size :
			multimesh.set_instance_transform_2d(i,Transform2D(0,Vector2(x*64,y*64)))
			i+=1
