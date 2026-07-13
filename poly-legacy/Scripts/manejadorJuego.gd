extends Node2D
var nivelActual=0
var transicionando=false
const PASILLO="res://Scenes/pasillo_niveles.tscn"
const VICTORIA="res://Scenes/pantalla_victoria.tscn"
const TOTAL_NIVELES=3
func pasarDeNivel():
	if transicionando:
		return
	transicionando=true
	nivelActual+=1
	if nivelActual>TOTAL_NIVELES:
		get_tree().change_scene_to_file(VICTORIA)
	else:
		get_tree().change_scene_to_file(PASILLO)
func reiniciar():
	nivelActual=0
	transicionando=false
	Inventario.limpiar()
