extends Node2D
@export var titulo="Matemática Básica"
@export var contenido="La matemática trabaja con números y operaciones. La suma y la resta son operaciones inversas: si sumás 5 y después restás 5 volvés al mismo número. La multiplicación es una suma repetida y la división es su inversa.
Las fracciones representan partes de un entero. El numerador indica cuántas partes tomamos y el denominador en cuántas está dividido el total. Para sumar fracciones con distinto denominador hay que encontrar el mínimo común múltiplo.
Una ecuación es una igualdad con una incógnita, generalmente llamada 'x'. Para resolverla hay que despejar la variable haciendo la misma operación a ambos lados: si tenés x+3=7, restás 3 en los dos lados y obtenés x=4.
El orden de las operaciones es fundamental: primero paréntesis, después potencias, luego multiplicación y división de izquierda a derecha, y por último suma y resta de izquierda a derecha."
const ICONO = preload("res://Assets/IconoLibro.png")
@onready var apretarE=$Label
@onready var panel=$CanvasLayer/PanelContainer
@onready var tituloLabel=$CanvasLayer/PanelContainer/VBoxContainer/Titulo
@onready var contenidoLabel=$CanvasLayer/PanelContainer/VBoxContainer/Contenido
@onready var zonaDeteccion=$Area2D
var jugadorCerca=false
var agarrado=false
var abierto=false
var datos_item={"titulo": "Matemática Básica", "icono": ICONO}
func _ready() -> void:
	apretarE.visible=false
	panel.visible=false
	$Sprite2D.visible=false
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
