extends CanvasLayer

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_alternar()

func _alternar():
	visible = not visible
	get_tree().paused = visible

func _reanudar():
	visible = false
	get_tree().paused = false

func _reiniciar():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _menu_principal():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MenuInicio.tscn")

func _salir():
	get_tree().quit()
