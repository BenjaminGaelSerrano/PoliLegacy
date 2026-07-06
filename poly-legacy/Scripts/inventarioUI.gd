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
	var casillas = grilla.get_children()
	for i in range(casillas.size()):
		var casilla = casillas[i]
		if i < Inventario.items.size():
			var objeto = Inventario.items[i]
			if objeto.datos.has("icono"):
				casilla.texture = load(objeto.datos["icono"])
			casilla.tooltip_text = objeto.datos.get("titulo", objeto.EspacioEnElInventario)
		else:
			casilla.texture = null
			casilla.tooltip_text = ""
