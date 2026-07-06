extends CanvasLayer

@onready var negro = $Negro
@onready var menu = $Menu

func activar_game_over():
	visible = true
	get_tree().paused = true
	var tween = create_tween()
	tween.tween_property(negro, "modulate:a", 1.0, 3.0)
	tween.tween_interval(2.0)
	tween.tween_property(menu, "modulate:a", 1.0, 3.0)

func _reintentar():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _menu_principal():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MenuInicio.tscn")

func _salir():
	get_tree().quit()
