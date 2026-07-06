extends Node2D

const ProyectilGuada = preload("res://Scenes/proyectil_guada.tscn")
const Coleccionable = preload("res://Scenes/coleccionable.tscn")

@onready var sprite = $AnimatedSprite2D
@onready var area_deteccion = $AreaDeteccion
@onready var barra_vida = $BarraVida
@onready var timer_inicio = $TimerInicio
@onready var timer_ataque = $TimerAtaque
@onready var timer_doble_disparo = $TimerDobleDisparo

var vida_maxima = 100
var radio_deteccion = 200.0
var cooldown_ataque = 2.0
var cooldown_ataque_fase2 = 1.5
var mini_timer_doble_disparo = 0.4
var cantidad_proyectiles_explosion = 8
var numero_nivel = 1

var vida = 100
var jugador = null
var en_combate = false
var fase_actual = 1
var transicion_realizada = false
var muriendo = false

func _ready():
	vida = vida_maxima
	barra_vida.max_value = vida_maxima
	barra_vida.value = vida

	var forma_nueva = CircleShape2D.new()
	forma_nueva.radius = radio_deteccion
	$AreaDeteccion/CollisionShape2D.shape = forma_nueva

	timer_inicio.wait_time = 2.0
	timer_inicio.one_shot = true
	timer_ataque.one_shot = true
	timer_doble_disparo.wait_time = mini_timer_doble_disparo
	timer_doble_disparo.one_shot = true

	sprite.play("idle")

func _al_entrar_al_area(cuerpo):
	if cuerpo.is_in_group("jugador") and not en_combate:
		jugador = cuerpo
		timer_inicio.start()

func _al_terminar_timer_inicio():
	en_combate = true
	_iniciar_ciclo_ataque()

func _iniciar_ciclo_ataque():
	if not en_combate or muriendo:
		return
	if fase_actual == 1:
		timer_ataque.wait_time = cooldown_ataque
	else:
		timer_ataque.wait_time = cooldown_ataque_fase2
	timer_ataque.start()

func _al_terminar_timer_ataque():
	if not en_combate or jugador == null or muriendo:
		return
	if fase_actual == 1:
		_disparar_hacia_jugador()
		_iniciar_ciclo_ataque()
	else:
		_disparar_hacia_jugador()
		timer_doble_disparo.start()

func _al_terminar_timer_doble_disparo():
	if not en_combate or jugador == null or muriendo:
		return
	_disparar_hacia_jugador()
	_iniciar_ciclo_ataque()

func _disparar_hacia_jugador():
	if jugador == null:
		return
	sprite.play("disparar")
	var proyectil = ProyectilGuada.instantiate()
	get_parent().add_child(proyectil)
	proyectil.global_position = global_position
	proyectil.direccion = (jugador.global_position - global_position).normalized()

func _disparo_explosion():
	for i in range(cantidad_proyectiles_explosion):
		var angulo = (TAU / cantidad_proyectiles_explosion) * i
		var proyectil = ProyectilGuada.instantiate()
		get_parent().add_child(proyectil)
		proyectil.global_position = global_position
		proyectil.direccion = Vector2(cos(angulo), sin(angulo))

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
		_disparo_explosion()

	if vida <= 0:
		_morir()

func _morir():
	muriendo = true
	en_combate = false
	timer_ataque.stop()
	timer_doble_disparo.stop()
	area_deteccion.monitoring = false
	sprite.play("morir")

func _al_terminar_animacion():
	if sprite.animation == "morir":
		BusEventos.boss_derrotado.emit(numero_nivel)
		var coleccionable = Coleccionable.instantiate()
		get_parent().add_child(coleccionable)
		coleccionable.global_position = global_position
		queue_free()
	elif sprite.animation == "disparar" or sprite.animation == "recibir_danio":
		sprite.play("idle")
