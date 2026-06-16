extends Node2D
var pasoActual=0
var pasosTutorial: Array =[]
var ManejadorJuego= "res://Scenes/ManejadorJuego.tscn"
func _ready() -> void:
	$CanvasLayer/Button.pressed.connect(saltarTutorial)
	cargarPaso(0)
func cargarPaso(paso: int):
	pasoActual=paso	
func pasoCompletado():
	if pasoActual < pasosTutorial.size()-1:
		cargarPaso(pasoActual+1)	
	else:
		ManejadorJuego.pasarDeNivel()
func saltarTutorial():
	ManejadorJuego.pasarDeNivel()		
		
