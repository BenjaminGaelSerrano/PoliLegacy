extends Node2D
@onready var etiqueta=$CanvasLayer/Label
@onready var fondo=$CanvasLayer/ColorRect
@onready var boton=$CanvasLayer/Button
var pasoActual=0
var tutoActivo=true
func _ready() -> void:
	boton.pressed.connect(saltarTutorial)
	BusEventos.jugadorSeMueve.connect(_on_movimiento)
	BusEventos.jugadorHablaConNpc.connect(_on_hablo)
	BusEventos.libroEntregado.connect(_on_libro_entregado)
	BusEventos.libroAgarrado.connect(_on_libro_agarrado)
	BusEventos.libroLeido.connect(_on_libro_leido)
	BusEventos.disparo.connect(_on_disparo)
	cargarPaso(0)
func cargarPaso(n: int):
	pasoActual=n
	match n:
		0: etiqueta.text = "Usá WASD para moverte"
		1: etiqueta.text = "Presioná E para hablar con el profesor"
		2: etiqueta.text = "Presioná E de nuevo para cerrar el diálogo"
		3: etiqueta.text = "Presioná E para agarrar el libro"
		4: etiqueta.text = "Presioná L para abrir el libro y leerlo"
		5: etiqueta.text = "Presioná Espacio para disparar"
		6: _fin_tutorial()
func _on_movimiento():
	if pasoActual==0:cargarPaso(1)
func _on_hablo():
	if pasoActual==1:cargarPaso(2)
func _on_libro_entregado():
	if pasoActual==2:cargarPaso(3)
func _on_libro_agarrado():
	if pasoActual==3:cargarPaso(4)
func _on_libro_leido():
	if pasoActual==4:cargarPaso(5)
func _on_disparo():
	if pasoActual==5:cargarPaso(6)
func _fin_tutorial():
	tutoActivo=false
	etiqueta.text="¡Ya estás para jugar! Comenzá tu aventura en el poli'"
	await get_tree().create_timer(2.0).timeout
	ManejadorJuego.pasarDeNivel()
func saltarTutorial():
	tutoActivo=false
	ManejadorJuego.pasarDeNivel()
