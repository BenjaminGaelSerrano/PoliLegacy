extends CharacterBody2D

const ProyectilJugador = preload("res://Scenes/proyectil_jugador.tscn")

@export var zoom_camara = Vector2(0.5, 0.5)
@export var danio = 10

@onready var sprite = $AnimatedSprite2D
@onready var timer_disparo = $TimerDisparo
@onready var barra_vida = $CanvasLayer/BarraVida
@onready var camara = $Camera2D

var vida_max = 100
var vida_actual = 100
var esta_muerto = false
var recibiendo_danio = false
var recarga_disparo = 1.5
var jefe_derrotado = false
var libro_equipado = false

func _ready():
	add_to_group("jugador")
	vida_actual = vida_max
	barra_vida.max_value = vida_max
	barra_vida.value = vida_actual

	camara.zoom = zoom_camara
	_ajustar_limites_camara()

	timer_disparo.one_shot = true
	timer_disparo.wait_time = recarga_disparo

	BusEventos.jefeDerrotado.connect(_al_derrotar_jefe)
	BusEventos.libroAgarrado.connect(_al_agarrar_libro)

	sprite.play("idle")

func _al_agarrar_libro():
	libro_equipado = true

func _al_derrotar_jefe(_nivel):
	jefe_derrotado = true

func _ajustar_limites_camara():
	var nodos = get_tree().get_nodes_in_group("limites")
	if nodos.is_empty():
		return

	var min_x = INF
	var min_y = INF
	var max_x = -INF
	var max_y = -INF

	for nodo in nodos:
		var extension = nodo.shape.size / 2
		var centro = nodo.global_position
		min_x = min(min_x, centro.x - extension.x)
		max_x = max(max_x, centro.x + extension.x)
		min_y = min(min_y, centro.y - extension.y)
		max_y = max(max_y, centro.y + extension.y)

	camara.limit_left = int(min_x)
	camara.limit_right = int(max_x)
	camara.limit_top = int(min_y)
	camara.limit_bottom = int(max_y)

func _input(event):
	if esta_muerto:
		return
	if event.is_action_pressed("click_derecho") and timer_disparo.is_stopped():
		_disparar()
		timer_disparo.start()
	if event.is_action_pressed("ui_accept"):
		_usar_ulti()
func _usar_ulti():
	BusEventos.ultiRealizada.emit()
func _disparar():
	sprite.play("disparar")
	var proyectil = ProyectilJugador.instantiate()
	get_parent().add_child(proyectil)
	proyectil.global_position = global_position
	proyectil.direccion = global_position.direction_to(get_global_mouse_position())
	proyectil.rotation = proyectil.direccion.angle()
	proyectil.danio = danio
	BusEventos.disparoRealizado.emit()

func recibir_danio(cantidad):
	if esta_muerto or recibiendo_danio:
		return
	vida_actual -= cantidad
	vida_actual = clamp(vida_actual, 0, vida_max)
	barra_vida.value = vida_actual
	BusEventos.jugadorRecibioDanio.emit(vida_actual)
	if vida_actual <= 0:
		_morir()
	else:
		recibiendo_danio = true
		sprite.play("recibir_danio")

func _alTerminarAnimacion():
	if sprite.animation == "recibir_danio":
		recibiendo_danio = false
		sprite.play("idle")
	elif sprite.animation == "disparar":
		sprite.play("idle")
	elif sprite.animation == "morir":
		var menu = get_tree().current_scene.get_node_or_null("MenuPerdido")
		if menu:
			menu.activar_game_over()

func _morir():
	esta_muerto = true
	BusEventos.jugadorMuerto.emit()
	sprite.play("morir")
