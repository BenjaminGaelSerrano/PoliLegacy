extends CharacterBody2D

const ProyectilJugador = preload("res://Scenes/proyectil_jugador.tscn")
const ProyectilUlti = preload("res://Scenes/proyectil_ulti.tscn")

const RECARGA_ULTI = 10.0
const ESCUDOS_MAX = 2

@export var danio = 10

@onready var sprite = $AnimatedSprite2D
@onready var timer_disparo = $TimerDisparo
@onready var barra_vida = $CanvasLayer/BarraVida
@onready var barra_ulti = $CanvasLayer/BarraUlti
@onready var contenedor_escudos = $CanvasLayer/Escudos
@onready var camara = $Camera2D

var vida_max = 100
var vida_actual = 100
var esta_muerto = false
var recibiendo_danio = false
var jefe_derrotado = false
var libro_equipado = false
var ulti_desbloqueada = false
var ulti_lista = false
var escudo_desbloqueado = false
var escudos_restantes = 0
var escudo_activo = false

func _ready():
	add_to_group("jugadores")
	vida_actual = vida_max

	_ajustar_limites_camara()

	BusEventos.jefeDerrotado.connect(_al_derrotar_jefe)
	BusEventos.libroAgarrado.connect(_al_agarrar_libro)
	BusEventos.coleccionableObtenido.connect(_al_obtener_coleccionable)

	# Si en una escena anterior ya se desbloqueó la ulti, el inventario (autoload)
	# lo recuerda: restauramos el estado al instanciar este jugador.
	_desbloquear_ulti_si_corresponde()
	_desbloquear_escudo_si_corresponde()

	sprite.play("idle")

func _al_agarrar_libro():
	libro_equipado = true

func _al_obtener_coleccionable():
	_desbloquear_ulti_si_corresponde()
	_desbloquear_escudo_si_corresponde()

func _desbloquear_ulti_si_corresponde():
	if ulti_desbloqueada:
		return
	if Inventario.tieneItem("ulti_guada"):
		ulti_desbloqueada = true
		ulti_lista = true
		barra_ulti.visible = true
		barra_ulti.value = barra_ulti.max_value

func _desbloquear_escudo_si_corresponde():
	if escudo_desbloqueado:
		return
	if Inventario.tieneItem("escudo_nievas"):
		escudo_desbloqueado = true
		escudos_restantes = ESCUDOS_MAX
		contenedor_escudos.visible = true
		_actualizar_escudos()

func _actualizar_escudos():
	var iconos = contenedor_escudos.get_children()
	for i in range(iconos.size()):
		if i < escudos_restantes:
			iconos[i].modulate = Color(0.3, 0.5, 1.0)
		else:
			iconos[i].modulate = Color(0.4, 0.4, 0.4)

func _activar_escudo():
	escudo_activo = true
	sprite.modulate = Color(0.4, 0.6, 1.0)

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
	elif event.is_action_pressed("ulti") and ulti_desbloqueada and ulti_lista:
		_disparar_ulti()
	elif event.is_action_pressed("escudo") and escudo_desbloqueado and escudos_restantes > 0 and not escudo_activo:
		_activar_escudo()

func _disparar():
	sprite.play("disparar")
	var proyectil = ProyectilJugador.instantiate()
	get_parent().add_child(proyectil)
	proyectil.global_position = global_position
	proyectil.direccion = global_position.direction_to(get_global_mouse_position())
	proyectil.rotation = proyectil.direccion.angle()
	proyectil.danio = danio
	BusEventos.disparoRealizado.emit()

func _disparar_ulti():
	sprite.play("disparar")
	var proyectil = ProyectilUlti.instantiate()
	get_parent().add_child(proyectil)
	proyectil.global_position = global_position
	proyectil.direccion = global_position.direction_to(get_global_mouse_position())
	proyectil.rotation = proyectil.direccion.angle()
	proyectil.danio = danio * 3
	BusEventos.ultiRealizada.emit()

	ulti_lista = false
	barra_ulti.value = 0
	var tween = create_tween()
	tween.tween_property(barra_ulti, "value", barra_ulti.max_value, RECARGA_ULTI)
	tween.tween_callback(_recargar_ulti)

func _recargar_ulti():
	ulti_lista = true

func recibir_danio(cantidad):
	if esta_muerto or recibiendo_danio:
		return
	if escudo_activo:
		escudo_activo = false
		escudos_restantes -= 1
		_actualizar_escudos()
		sprite.modulate = Color(1, 1, 1, 1)
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

func _morir():
	esta_muerto = true
	BusEventos.jugadorMuerto.emit()
	sprite.play("morir")
	var menu = get_tree().current_scene.get_node_or_null("MenuMuerte")
	if menu:
		menu.activar_pantalla_muerte()
