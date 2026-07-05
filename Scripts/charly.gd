extends Area2D
@export var dialogo="Bienvenido. Este libro te va a ser útil en tu aventura. Con este, podrás pasar pruebas extremadamente rigurosas."
@onready var panel=$CanvasLayer/PanelContainer
@onready var etiqueta=$CanvasLayer/PanelContainer/Label
var jugadorCerca=false
var dialogoAbierto=false
var libroYaEntregado=false
func _ready() -> void:
	panel.visible=false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
func _on_body_entered(body):
	if body.is_in_group("jugadores"):
		jugadorCerca=true
func _on_body_exited(body):
	if body.is_in_group("jugadores"):
		jugadorCerca=false
		cerrarDialogo()
func _input(event):
	if jugadorCerca and not libroYaEntregado:
		if event.is_action_just_pressed("Interactuar"):
			if not dialogoAbierto:
				abrirDialogo()
			else:
				cerrarDialogo()
				entregarLibro()
func abrirDialogo():
	etiqueta.text=dialogo
	panel.visible=true
	dialogoAbierto=true
	BusEventos.jugadorHablaConNpc.emit()
func cerrarDialogo():
	panel.visible=false
	dialogoAbierto=false
func entregarLibro():
	libroYaEntregado=true
	BusEventos.libroEntregado.emit()
