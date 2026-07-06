extends CharacterBody2D
@export var velocidad= 150
@export var vidaMaxima:int= 50
@export var daño:int= 10
@export var libroEscena:PackedScene
@onready var animacion = $AnimatedSprite2D
@onready var relleno = $BarraVida/Relleno
@onready var vidas: int = vidaMaxima
@export var ancho_barra: float = 50.0

var ultimaDir = "abajo"
var atacando: bool = false
var libro_equipado: bool = false

func _ready() -> void:
	add_to_group("jugadores")
	EventBus.libro_agarrado.connect(_on_libro_agarrado)
	actualizar_barra()

func _on_libro_agarrado(_titulo: String, _contenido: String) -> void:
	libro_equipado = true

func _physics_process(_delta: float) -> void:
	if atacando:
		move_and_slide()
		return

	var direccion = Input.get_vector("izquierda", "derecha", "arriba", "abajo")

	if direccion == Vector2.ZERO:
		velocity = Vector2.ZERO
		##actualizar_animacion("parado")
	else:
		if abs(direccion.x) > abs(direccion.y):
			ultimaDir = "derecha" if direccion.x > 0 else "izquierda"
		else:
			ultimaDir = "abajo" if direccion.y > 0 else "arriba"
		velocity = direccion * velocidad
		##actualizar_animacion("caminar")
		EventBus.jugador_se_movio.emit()

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("atacar") and not atacando:
		if libro_equipado:
			atacar()

func atacar() -> void:
	atacando = true
	velocity = Vector2.ZERO
	##animacion.play("atacar_" + ultimaDir)

	var proyectil = escena_libro.instantiate()
	proyectil.global_position = global_position
	proyectil.daño_jugador = daño
	proyectil.jugador_origen = self

	match ultimaDir:
		"arriba":    proyectil.direction = Vector2(0, -1)
		"abajo":     proyectil.direction = Vector2(0,  1)
		"izquierda": proyectil.direction = Vector2(-1, 0)
		"derecha":   proyectil.direction = Vector2(1,  0)

	get_parent().add_child(proyectil)
	EventBus.disparo_realizado.emit()

	##await animacion.animation_finished
	atacando = false

func actualizar_barra() -> void:
	relleno.size.x = (float(vidas) / float(vida_maxima)) * ancho_barra

func recibir_daño(dañorecibido: int) -> void:
	vidas -= dañorecibido
	actualizar_barra()
	if vidas <= 0:
		get_tree().current_scene.get_node("MenuPerdido").activar_game_over()
		queue_free()
