extends CanvasLayer
@export var tipo:String="ulti"
@onready var etiqueta=$Label
var esperandoAccion:bool=false
func _ready():
	visible=false
	var item="ulti_guada" if tipo=="ulti" else "escudo_nievas"
	if Inventario.tieneItem(item):
		ManejadorJuego.miniTutCompleto=true
		return
	ManejadorJuego.miniTutCompleto=false
func _process(_delta):
	if ManejadorJuego.miniTutCompleto:
		return
	var item="ulti_guada" if tipo=="ulti" else "escudo_nievas"
	if not esperandoAccion:
		if Inventario.tieneItem(item):
			esperandoAccion=true
			visible=true
			if tipo=="ulti":
				etiqueta.text="¡Conseguiste la Ulti!\nUsala con ESPACIO antes de salir"
			else:
				etiqueta.text="¡Conseguiste el Escudo!\nActivalo con Q antes de salir"
	else:
		var accionUsada=(tipo=="ulti" and Input.is_action_just_pressed("ulti")) or (tipo=="escudo" and Input.is_action_just_pressed("escudo"))
		if accionUsada:
			alCompletar()
func alCompletar():
	etiqueta.text="¡Perfecto! Podés salir por la puerta"
	ManejadorJuego.miniTutCompleto=true
	await get_tree().create_timer(2.5).timeout
	visible=false