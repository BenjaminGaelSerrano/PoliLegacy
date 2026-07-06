extends CanvasLayer
@onready var panel=$PanelContainer
@onready var lista=$PanelContainer/VBoxContainer
var abierto=false
func _ready() -> void:
	panel.visible=false
func _input(event):
	if not event.is_pressed():
		return
	if event.is_action("Inventario"):
		abierto = not abierto
		panel.visible = abierto
		if abierto:
			actualizarLista()
func actualizarLista():
	for child in lista.get_children():
		child.queue_free()   
	for item in Inventario.items:
		var label = Label.new()
		label.text = item.datos.get("titulo", item.EspacioEnElInventario)
		lista.add_child(label)
