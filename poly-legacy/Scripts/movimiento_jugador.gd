extends Node
const ACCION_IZQUIERDA = "izquierda"
const ACCION_DERECHA = "derecha"
const ACCION_ARRIBA = "arriba"
const ACCION_ABAJO = "abajo"
var velocidad = 350.0
var jugador
func _ready():
	jugador = get_parent()
func _physics_process(_delta):
	if jugador.esta_muerto:
		jugador.velocity = Vector2.ZERO
		return
	var direccion = Input.get_vector(ACCION_IZQUIERDA, ACCION_DERECHA, ACCION_ARRIBA, ACCION_ABAJO)
	jugador.velocity = direccion * velocidad
	if direccion != Vector2.ZERO:
		BusEventos.jugadorSeMovio.emit()
	jugador.move_and_slide()
	_revisar_puerta()
	_gestionar_animaciones(direccion)
func _revisar_puerta():
	for i in jugador.get_slide_collision_count():
		var colision = jugador.get_slide_collision(i)
		var colisionador = colision.get_collider()
		var id_dueno = colisionador.shape_find_owner(colision.get_collider_shape_index())
		var forma = colisionador.shape_owner_get_owner(id_dueno)
		if forma.is_in_group("puerta") and jugador.jefe_derrotado:
			var item_requerido = forma.get_meta("item_requerido", "")
			if item_requerido != "" and not Inventario.tieneItem(item_requerido):
				return
			ManejadorJuego.pasarDeNivel()
			return
		if forma.is_in_group("puerta_entrada"):
			if forma.get_meta("nivel_requerido", -1) != ManejadorJuego.nivelActual:
				continue
			var escena_destino = forma.get_meta("escena_destino", "")
			if escena_destino != "":
				get_tree().change_scene_to_file(escena_destino)
			return
func _gestionar_animaciones(direccion):
	var sprite = jugador.sprite
	if jugador.esta_muerto or jugador.recibiendo_danio:
		return
	if sprite.animation == "disparar" and sprite.is_playing():
		return
	if direccion != Vector2.ZERO:
		if abs(direccion.y) >= abs(direccion.x):
			if direccion.y > 0:
				sprite.play("CaminarArriba")
			else:
				sprite.play("CaminarAbajo")
		else:
			if direccion.x > 0:
				sprite.play("CaminarDerecha")
			else:
				sprite.play("CaminarIzquierda")
	else:
		sprite.play("idle")
