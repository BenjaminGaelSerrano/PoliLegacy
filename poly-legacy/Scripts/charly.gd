extends Area2D
@export var dialogo="Bienvenido. Este libro te va a ser útil en tu aventura. Con este, podrás pasar pruebas extremadamente rigurosas."
@onready var panel=$CanvasLayer/PanelContainer
@onready var etiqueta=$CanvasLayer/PanelContainer/Label
@onready var sprite=$Sprite2D
var jugadorCerca=false
var dialogoAbierto=false
var libroYaEntregado=false
func _ready() -> void:
	panel.visible=false
	sprite.play("idle")
func _on_body_entered(body):
	if body.is_in_group("jugador"):
		jugadorCerca=true
func _on_body_exited(body):
	if body.is_in_group("jugador"):
		jugadorCerca=false
		cerrarDialogo()
func _input(event):
	if not event.is_pressed():
		return
	if jugadorCerca and not libroYaEntregado:
		if event.is_action("Interactuar"):
			if not dialogoAbierto:
				abrirDialogo()
			else:
				cerrarDialogo()
				entregarLibro()
func abrirDialogo():
	etiqueta.text=dialogo
	panel.visible=true
	dialogoAbierto=true
	sprite.play("Hablando")
	BusEventos.jugadorHablaConNpc.emit()
func cerrarDialogo():
	panel.visible=false
	dialogoAbierto=false
	sprite.play("idle")
func entregarLibro():
	libroYaEntregado=true
	BusEventos.libroEntregado.emit()
	BusEventos.libroAgarrado.emit()
