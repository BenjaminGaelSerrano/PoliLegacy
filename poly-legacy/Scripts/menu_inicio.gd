extends Control
func _jugar():
	ManejadorJuego.reiniciar()
	get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")
func _salir():
	get_tree().quit()
