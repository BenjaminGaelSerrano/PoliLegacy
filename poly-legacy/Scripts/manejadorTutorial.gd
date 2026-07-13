extends Node2D
@onready var etiqueta:Label=get_node_or_null("CanvasLayer/Label")
@onready var fondo:ColorRect=get_node_or_null("CanvasLayer/ColorRect")
@onready var boton:Button=get_node_or_null("CanvasLayer/Button")
var pasoActual=0
var tutoActivo=true
func _ready() -> void:
	BusEventos.jugadorSeMovio.connect(_on_movimiento)
	BusEventos.jugadorHablaConNpc.connect(_on_hablo)
	BusEventos.libroEntregado.connect(_on_libro_entregado)
	BusEventos.libroLeido.connect(_on_libro_leido)
	BusEventos.disparoRealizado.connect(_on_disparo)
	BusEventos.inventarioAbierto.connect(_on_inventario_abierto)
	cargarPaso(1)
func cargarPaso(n: int):
	pasoActual=n
	BusEventos.paso_tutorial = n
	if not is_instance_valid(etiqueta):
		return
	match n:
		1: etiqueta.text = "Usá WASD para moverte"
		2: etiqueta.text = "Presioná E para hablar con Charly"
		3: etiqueta.text = "Presioná E de nuevo para recibir el libro"
		4: etiqueta.text = "Presioná L para leer el libro\nPresioná L de nuevo o 'Cerrar' para cerrarlo"
		5: etiqueta.text = "Presioná Click Izquierdo para disparar"
		6: etiqueta.text = "Presioná I para abrir tu inventario\nPresioná I de nuevo para cerrarlo"
		7: _fin_tutorial()
func _on_movimiento():
	if pasoActual==1:cargarPaso(2)
func _on_hablo():
	if pasoActual==2:cargarPaso(3)
func _on_libro_entregado():
	if pasoActual==3:cargarPaso(4)
func _on_libro_leido():
	if pasoActual==4:cargarPaso(5)
func _on_disparo():
	if pasoActual==5:cargarPaso(6)
func _on_inventario_abierto():
	if pasoActual==6:cargarPaso(7)
func _fin_tutorial():
	tutoActivo=false
	BusEventos.paso_tutorial = 0
	etiqueta.text="¡Ya estás para jugar! Comenzá tu aventura en el poli'"
	await get_tree().create_timer(2.0).timeout
	ManejadorJuego.nivelActual = 0
	ManejadorJuego.pasarDeNivel()
func saltarTutorial():
	tutoActivo=false
	BusEventos.paso_tutorial=0
	if not Inventario.tieneItem("libro"):
		var icono=load("res://Assets/IconoLibro.png")
		Inventario.agregarItem("libro","arma",{"titulo":"Matemática Básica","icono":icono})
	BusEventos.libroAgarrado.emit()
	ManejadorJuego.nivelActual=0
	ManejadorJuego.pasarDeNivel()
