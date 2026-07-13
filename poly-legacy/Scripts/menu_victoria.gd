extends Control
@onready var boton=$VBoxContainer/Button
func _ready():
	boton.pressed.connect(_irAlMenu)
func _irAlMenu():
	get_tree().change_scene_to_file("res://Scenes/MenuInicio.tscn")
