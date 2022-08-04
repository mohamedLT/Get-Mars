extends Control


func _ready() -> void:
	pass # Replace with function body.



func _on_Start_pressed() -> void:
	Game.start_game()




func _on_Quit_pressed() -> void:
	get_tree().quit()
