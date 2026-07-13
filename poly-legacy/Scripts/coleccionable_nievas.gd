extends Area2D
@onready var sprite=$Sprite2D
@onready var aviso=$Aviso
const ICONO=preload("res://Assets/ColectibleNievas.png")
var jugador_cerca=false
var recogido=false
func _ready():
	if Inventario.tieneItem("escudo_nievas"):
		queue_free()
		return
func _al_entrar_cuerpo(cuerpo):
	if cuerpo.is_in_group("jugadores") and not recogido:
		jugador_cerca=true
		aviso.visible=true
func _al_salir_cuerpo(cuerpo):
	if cuerpo.is_in_group("jugadores"):
		jugador_cerca=false
		aviso.visible=false
func _input(event):
	if not (event is InputEventKey):
		return
	if event.is_action_pressed("Interactuar") and jugador_cerca and not recogido:
		_recoger()
func _recoger():
	recogido=true
	aviso.visible=false
	Inventario.agregarItem("escudo_nievas", "habilidad", {"titulo": "Escudo de Nieva", "icono": ICONO})
	BusEventos.coleccionableObtenido.emit()
	ManejadorJuego.pasarDeNivel()
