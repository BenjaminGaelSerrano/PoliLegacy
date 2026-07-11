extends CanvasLayer

@onready var grilla=$Panel/Grilla

var abierto=false

func _ready():
	var casillas=grilla.get_children()
	for i in range(casillas.size()):
		casillas[i].gui_input.connect(_on_casilla_input.bind(i))

func _on_casilla_input(event:InputEvent, idx:int):
	if not (event is InputEventMouseButton and event.pressed and event.button_index==MOUSE_BUTTON_LEFT):
		return
	if idx>=Inventario.items.size():
		return
	var objeto=Inventario.items[idx]
	if objeto.EspacioEnElInventario=="libro":
		_alternar()
		var libros=get_tree().get_nodes_in_group("libro")
		if libros.size()>0:
			libros[0].abrirLibro()

func _input(event):
	if event.is_action_pressed("Inventario"):
		_alternar()

func _alternar():
	if BusEventos.paso_tutorial>0 and BusEventos.paso_tutorial<6:
		return
	var era_abierto=abierto
	abierto=not abierto
	visible=abierto
	get_tree().paused=abierto
	if abierto:
		_refrescar()
	elif era_abierto and BusEventos.paso_tutorial==6:
		BusEventos.inventarioAbierto.emit()

func _refrescar():
	var casillas=grilla.get_children()
	for i in range(casillas.size()):
		var casilla=casillas[i]
		if i<Inventario.items.size():
			var objeto=Inventario.items[i]
			if objeto.datos.has("icono"):
				casilla.texture=load(objeto.datos["icono"])
				casilla.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_COVERED
			casilla.tooltip_text=objeto.datos.get("titulo", objeto.EspacioEnElInventario)
		else:
			casilla.texture=null
			casilla.tooltip_text=""
