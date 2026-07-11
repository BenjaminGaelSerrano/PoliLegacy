extends Node2D
@export var titulo="electricidad basica desordenada"
@export var contenido="La corriente eléctrica se mide en amperes aunque para calcular el voltaje basta con multiplicar la resistencia por la corriente, eso es la Ley de Ohm: V=I*R, también se escribe como I=V/R o R=V/I según lo que quieras calcular.
Los circuitos en serie suman sus resistencias pero la corriente es la misma en todos los componentes, mientras que en paralelo el voltaje es el mismo en cada rama aunque la corriente se divide y la resistencia total queda menor que la más chica.
La potencia eléctrica se calcula con P=V*I y se mide en watts, un conductor permite el paso de la corriente porque tiene electrones libres y un aislante no los tiene así que no pasa nada, los transformadores suben o bajan el voltaje sin partes móviles a diferencia de los generadores.
La diferencia de potencial es lo que empuja a los electrones a moverse desde el polo negativo al positivo de la pila aunque la corriente convencional se define al revés, y el campo eléctrico va de cargas positivas a negativas."
@onready var apretarE=$Label
@onready var panel=$CanvasLayer/PanelContainer
@onready var tituloLabel=$CanvasLayer/PanelContainer/VBoxContainer/Titulo
@onready var contenidoLabel=$CanvasLayer/PanelContainer/VBoxContainer/Contenido
@onready var zonaDeteccion=$Area2D
var jugadorCerca=false
var agarrado=false
var abierto=false
var datos_item={"titulo": "Libro de Electricidad", "icono": "res://Assets/LibroProyectil (2).png"}
func _ready() -> void:
	apretarE.visible=false
	panel.visible=false
	$Sprite2D.visible=false
	zonaDeteccion.monitoring=false
	zonaDeteccion.body_entered.connect(_on_body_entered)
	zonaDeteccion.body_exited.connect(_on_body_exited)
	BusEventos.libroEntregado.connect(_on_libro_entregado_por_npc)
func _on_libro_entregado_por_npc():
	if not agarrado:
		agarrado=true
		apretarE.visible=false
		$Sprite2D.visible=false
		if not Inventario.tieneItem("libro"):
			Inventario.agregarItem("libro", "arma", datos_item)
func _on_body_entered(body):
	if body.is_in_group("jugador") and not agarrado:
		jugadorCerca=true
		apretarE.visible=true
func _on_body_exited(body):
	if body.is_in_group("jugador"):
		jugadorCerca=false
		apretarE.visible=false
func _input(event):
	if event.is_action_pressed("Interactuar"):
		if jugadorCerca and not agarrado:
			agarrar()
	if event.is_action_pressed("Leer"):
		if agarrado and (BusEventos.paso_tutorial==0 or BusEventos.paso_tutorial>=4):
			if not abierto:
				abrirLibro()
			else:
				CerrarLibro()
func agarrar():
	agarrado=true
	apretarE.visible=false
	$Sprite2D.visible=false
	if not Inventario.tieneItem("libro"):
		Inventario.agregarItem("libro", "arma", datos_item)
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
