extends Node

const ACCION_IZQUIERDA = "Izquierda"
const ACCION_DERECHA = "Derecha"
const ACCION_ARRIBA = "Arriba"
const ACCION_ABAJO = "Abajo"

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
	jugador.move_and_slide()
	_revisar_puerta()
	_gestionar_animaciones(direccion)

func _revisar_puerta():
	if not jugador.jefe_derrotado:
		return
	for i in jugador.get_slide_collision_count():
		var colision = jugador.get_slide_collision(i)
		var colisionador = colision.get_collider()
		var id_dueno = colisionador.shape_find_owner(colision.get_collider_shape_index())
		var forma = colisionador.shape_owner_get_owner(id_dueno)
		if forma.is_in_group("puerta"):
			get_tree().change_scene_to_file("res://Scenes/pasillo_medio.tscn")
			return

func _gestionar_animaciones(direccion):
	var sprite = jugador.sprite

	if jugador.esta_muerto or jugador.recibiendo_danio:
		return
	if sprite.animation == "disparar" and sprite.is_playing():
		return

	if direccion != Vector2.ZERO:
		sprite.play("caminar")
		if direccion.x != 0:
			sprite.flip_h = direccion.x < 0
	else:
		sprite.play("idle")
