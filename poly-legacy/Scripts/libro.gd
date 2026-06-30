extends Node2D
@export var titulo="geografia basica desordenada"
@export var contenido= "La longitud depende del meridiano de Greenwich, aunque las selvas suelen encontrarse cerca del ecuador, donde los ríos pueden desembocar en el mar o en un lago, mientras que los desiertos, a pesar de ocupar grandes extensiones,
reciben muy pocas lluvias y no tienen relación con que los océanos cubran alrededor del 71% de la superficie terrestre.Un istmo une dos masas de tierra, pero un estrecho conecta dos masas de agua,
al mismo tiempo que las placas tectónicas se desplazan lentamente formando montañas y favoreciendo la actividad de volcanes que expulsan magma, cenizas y gases. La latitud influye en el clima junto con la altitud y la cercanía al mar, los polos son las regiones más frías del planeta,
las coordenadas geográficas permiten ubicar cualquier punto de la Tierra, un archipiélago está formado por varias islas y, aunque la Tierra tiene siete continentes, la capital de un país no necesariamente es su ciudad más poblada."
@onready var apretarE=$Label
@onready var panel=$CanvasLayer/PanelContainer
@onready var tituloLabel=$CanvasLayer/PanelContainer/VBoxContainer/Titulo
@onready var contenidoLabel=$CanvasLayer/PanelContainer/VBoxContainer/Contenido
@onready var cerrarLibro=$CanvasLayer/PanelContainer/VBoxContainer/Button
@onready var zonaDeteccion=$Area2D
var jugadorCerca=false
var agarrado=false
var abierto=false
func _ready() -> void:
	apretarE.visible = false
	panel.visible = false
	cerrarLibro.pressed.connect(CerrarLibro)
	zonaDeteccion.body_entered.connect(_on_body_entered)
	zonaDeteccion.body_exited.connect(_on_body_exited)
func _on_body_entered(body):
	if body.is_in_group("jugadores") and not agarrado:
		jugadorCerca=true
		apretarE.visible=true
func _on_body_exited(body):
	if body.is_in_group("jugadores"):
		jugadorCerca=false
		apretarE.visible=false
func _input(event):
	if not (event is InputEventKey):
		return
	if event.is_action_just_pressed("Interactuar"):
		if jugadorCerca and not agarrado:
			agarrar()
		elif agarrado:
			if not abierto:
				abrirLibro()
			else:
				CerrarLibro()
func agarrar():
	agarrado=true
	apretarE.visible=false
	$Sprite2D.visible=false
	BusEventos.libroAgarrado.emit()
func abrirLibro():
	tituloLabel.text=titulo
	contenidoLabel.text=contenido
	panel.visible=true
	abierto=true
	BusEventos.libroLeido.emit()
func CerrarLibro():
	panel.visible=false
	abierto=false
