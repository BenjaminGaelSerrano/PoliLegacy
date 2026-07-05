extends Node

const ACCION_IZQUIERDA = "mover_izquierda"
const ACCION_DERECHA = "mover_derecha"
const ACCION_ARRIBA = "mover_arriba"
const ACCION_ABAJO = "mover_abajo"

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
	_gestionar_animaciones(direccion)

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
