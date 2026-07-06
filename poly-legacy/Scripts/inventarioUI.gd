extends CanvasLayer

@onready var grilla = $Panel/Grilla

var abierto = false

func _input(event):
	if event.is_action_pressed("Inventario"):
		_alternar()

func _alternar():
	abierto = not abierto
	visible = abierto
	get_tree().paused = abierto
	if abierto:
		_refrescar()

func _refrescar():
	var slots = grilla.get_children()
	for i in range(slots.size()):
		var slot = slots[i]
		if i < Inventario.items.size():
			var item = Inventario.items[i]
			if item.datos.has("icono"):
				slot.texture = load(item.datos["icono"])
			slot.tooltip_text = item.datos.get("titulo", item.EspacioEnElInventario)
		else:
			slot.texture = null
			slot.tooltip_text = ""
