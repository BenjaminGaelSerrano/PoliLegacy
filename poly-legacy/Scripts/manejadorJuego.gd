extends Node2D
var nivelActual=0
func pasarDeNivel():
	nivelActual+=1
	if nivelActual==1:
		get_tree().change_scene_to_file("res://Scenes/pasillo_medio.tscn")
