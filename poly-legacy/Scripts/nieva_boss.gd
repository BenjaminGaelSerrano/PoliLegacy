extends Node2D

const Coleccionable = preload("res://Scenes/coleccionable_guada.tscn")

@onready var sprite = $AnimatedSprite2D
@onready var barra_vida = $BarraVida
@onready var timer_inicio = $TimerInicio
@onready var timer_golpe = $TimerGolpe
@onready var camara_intro = $CamaraIntro

var vida_maxima = 100
var velocidad = 70.0
var velocidad_fase2 = 120.0
var recarga_golpe = 1.0
var danio_contacto = 10
var numero_nivel = 2

var vida = 100
var objetivo = null
var en_contacto = false
var fase_actual = 1
var transicion_realizada = false
var muriendo = false

func _ready():
	vida = vida_maxima
	barra_vida.max_value = vida_maxima
	barra_vida.value = vida

	timer_inicio.wait_time = 2.0
	timer_inicio.one_shot = true
	timer_golpe.wait_time = recarga_golpe
	timer_golpe.one_shot = true

	objetivo = _buscar_jugador()

	sprite.play("idle")

	camara_intro.make_current()
	timer_inicio.start()

func _buscar_jugador():
	for nodo in get_tree().get_nodes_in_group("jugador"):
		if nodo is CharacterBody2D:
			return nodo
	return null

func _physics_process(delta):
	if muriendo or objetivo == null:
		return
	var velocidad_actual = velocidad
	if fase_actual == 2:
		velocidad_actual = velocidad_fase2
	var direccion = (objetivo.global_position - global_position).normalized()
	position += direccion * velocidad_actual * delta
	if direccion.x != 0:
		sprite.flip_h = direccion.x < 0

func _al_terminar_timer_inicio():
	var jugador_nodo = null
	var camara_jugador = null
	for nodo in get_tree().get_nodes_in_group("jugador"):
		if nodo.has_node("Camera2D"):
			jugador_nodo = nodo
			camara_jugador = nodo.get_node("Camera2D")
			break
	if camara_jugador == null:
		return

	camara_intro.reparent(get_parent())
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(camara_intro, "global_position", jugador_nodo.global_position, 1.0)
	tween.tween_property(camara_intro, "zoom", camara_jugador.zoom, 1.0)
	await tween.finished

	camara_jugador.make_current()
	camara_intro.queue_free()

func _al_entrar_contacto(area):
	if area.is_in_group("jugador") and not muriendo:
		en_contacto = true
		_golpear()
		timer_golpe.start()

func _al_salir_contacto(area):
	if area.is_in_group("jugador"):
		en_contacto = false
		timer_golpe.stop()

func _al_terminar_timer_golpe():
	if en_contacto and not muriendo:
		_golpear()
		timer_golpe.start()

func _golpear():
	if objetivo == null or muriendo:
		return
	sprite.play("atacar")
	objetivo.recibir_danio(danio_contacto)

func recibir_danio(cantidad):
	if muriendo:
		return
	vida -= cantidad
	vida = max(vida, 0)
	barra_vida.value = vida
	sprite.play("recibir_danio")

	if not transicion_realizada and vida <= vida_maxima / 2:
		transicion_realizada = true
		fase_actual = 2

	if vida <= 0:
		_morir()

func _morir():
	muriendo = true
	timer_golpe.stop()
	sprite.play("morir")

func _al_terminar_animacion():
	if sprite.animation == "morir":
		await get_tree().create_timer(5.0).timeout
		BusEventos.jefeDerrotado.emit(numero_nivel)
		var coleccionable = Coleccionable.instantiate()
		get_parent().add_child(coleccionable)
		coleccionable.global_position = global_position
		queue_free()
	elif sprite.animation == "atacar" or sprite.animation == "recibir_danio":
		sprite.play("idle")
