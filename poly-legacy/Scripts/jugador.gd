extends CharacterBody2D

const ProyectilJugador = preload("res://Scenes/proyectil_jugador.tscn")

const ACCION_AGARRAR = "agarrar"

@onready var sprite = $AnimatedSprite2D
@onready var timer_disparo = $TimerDisparo
@onready var barra_vida = $CanvasLayer/BarraVida
@onready var camara = $Camera2D

@export var limite_izquierda = 0
@export var limite_derecha = 600
@export var limite_arriba = 0
@export var limite_abajo = 648
@export var zoom_camara = Vector2(1, 1)

var vida_max = 100
var vida_actual = 100
var esta_muerto = false
var recibiendo_danio = false
var cooldown_disparo = 0.5

func _ready():
	vida_actual = vida_max
	barra_vida.max_value = vida_max
	barra_vida.value = vida_actual

	camara.limit_left = limite_izquierda
	camara.limit_right = limite_derecha
	camara.limit_top = limite_arriba
	camara.limit_bottom = limite_abajo
	camara.zoom = zoom_camara

	timer_disparo.one_shot = true
	timer_disparo.wait_time = cooldown_disparo

	sprite.play("idle")

func _input(event):
	if esta_muerto:
		return
	if event.is_action_pressed("click_derecho") and timer_disparo.is_stopped():
		_disparar()
		timer_disparo.start()
	elif event.is_action_pressed(ACCION_AGARRAR):
		_agarrar_objeto()

func _disparar():
	sprite.play("disparar")
	var proyectil = ProyectilJugador.instantiate()
	get_parent().add_child(proyectil)
	proyectil.global_position = global_position
	proyectil.direccion = global_position.direction_to(get_global_mouse_position())
	proyectil.rotation = proyectil.direccion.angle()

func _agarrar_objeto():
	pass

func recibir_danio(cantidad):
	if esta_muerto or recibiendo_danio:
		return
	vida_actual -= cantidad
	vida_actual = clamp(vida_actual, 0, vida_max)
	barra_vida.value = vida_actual
	BusEventos.jugador_recibio_danio.emit(vida_actual)
	if vida_actual <= 0:
		_morir()
	else:
		recibiendo_danio = true
		sprite.play("recibir_danio")

func _al_terminar_animacion():
	if sprite.animation == "recibir_danio":
		recibiendo_danio = false
		sprite.play("idle")
	elif sprite.animation == "disparar":
		sprite.play("idle")

func _morir():
	esta_muerto = true
	BusEventos.jugador_murio.emit()
	sprite.play("morir")
