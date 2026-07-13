extends Control
func _jugar():
	get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")
func _salir():
	get_tree().quit()
