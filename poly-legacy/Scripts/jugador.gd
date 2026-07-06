extends CharacterBody2D
<<<<<<< HEAD
@export var velocidad:float=350.0
@export var vidaMaxima:int=100
@export var daño:int=10
@export var libroEscena:PackedScene
@export var limiteIzquierda:int=0
@export var limiteDerecha:int=600
@export var limiteArriba:int=0
@export var limiteAbajo:int=648
@export var zoomCamara:Vector2=Vector2(1,1)
@onready var animacion:AnimatedSprite2D=$AnimatedSprite2D
@onready var camara:Camera2D=$Camera2D
@onready var timerDisparo:Timer=$TimerDisparo
@onready var barraVida:ProgressBar=$CanvasLayer/BarraVida
var vidas:int
var ultimaDir:String="abajo"
var atacando:bool=false
var libroEquipado:bool=false
var estaMuerto:bool=false
var recibiendoDanio:bool=false
var cooldownDisparo:float=0.5
func _ready()->void:
	add_to_group("jugadores")
	BusEventos.libroAgarrado.connect(_onLibroAgarrado)
	vidas=vidaMaxima
	barraVida.max_value=vidaMaxima
	barraVida.value=vidas
	camara.limit_left=limiteIzquierda
	camara.limit_right=limiteDerecha
	camara.limit_top=limiteArriba
	camara.limit_bottom=limiteAbajo
	camara.zoom=zoomCamara
	timerDisparo.one_shot=true
	timerDisparo.wait_time=cooldownDisparo
	animacion.play("idle")
func _onLibroAgarrado(_titulo:String,_contenido:String)->void:
	libroEquipado=true
func _physics_process(_delta:float)->void:
	if estaMuerto:
		velocity=Vector2.ZERO
=======

const ProyectilJugador = preload("res://Scenes/proyectil_jugador.tscn")

const ACCION_AGARRAR = "Interactuar"

@onready var sprite = $AnimatedSprite2D
@onready var timer_disparo = $TimerDisparo
@onready var barra_vida = $CanvasLayer/BarraVida
@onready var camara = $Camera2D

@export var zoom_camara = Vector2(0.5, 0.5)

var vida_max = 100
var vida_actual = 100
var esta_muerto = false
var recibiendo_danio = false
var recarga_disparo = 1.5
var jefe_derrotado = false

func _ready():
	vida_actual = vida_max
	barra_vida.max_value = vida_max
	barra_vida.value = vida_actual

	camara.zoom = zoom_camara
	_ajustar_limites_camara()

	timer_disparo.one_shot = true
	timer_disparo.wait_time = recarga_disparo

	BusEventos.jefeDerrotado.connect(_al_derrotar_jefe)

	sprite.play("idle")

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
>>>>>>> origin/main
		return
	if atacando:
		move_and_slide()
		return
	var direccion=Input.get_vector("izquierda","derecha","arriba","abajo")
	if direccion==Vector2.ZERO:
		velocity=Vector2.ZERO
	else:
		if abs(direccion.x)>abs(direccion.y):
			ultimaDir="derecha" if direccion.x>0 else "izquierda"
		else:
			ultimaDir="abajo" if direccion.y>0 else "arriba"
		velocity=direccion*velocidad
		BusEventos.jugadorSeMueve.emit()
	move_and_slide()
	_gestionarAnimaciones(direccion)
func _gestionarAnimaciones(direccion:Vector2)->void:
	if estaMuerto or recibiendoDanio:
		return
	if animacion.animation=="disparar" and animacion.is_playing():
		return
	if direccion!=Vector2.ZERO:
		animacion.play("caminar")
		if direccion.x!=0:
			animacion.flip_h=direccion.x<0
	else:
		animacion.play("idle")
func _input(event:InputEvent)->void:
	if estaMuerto:
		return
	if event.is_action_pressed("atacar") and not atacando and timerDisparo.is_stopped():
		if libroEquipado:
			atacar()
			timerDisparo.start()
func atacar()->void:
	atacando=true
	velocity=Vector2.ZERO
	animacion.play("disparar")
	var proyectil=libroEscena.instantiate()
	proyectil.global_position=global_position
	proyectil.dañoJugador=daño
	proyectil.jugadorOrigen=self
	match ultimaDir:
		"arriba":proyectil.direction=Vector2(0,-1)
		"abajo":proyectil.direction=Vector2(0,1)
		"izquierda":proyectil.direction=Vector2(-1,0)
		"derecha":proyectil.direction=Vector2(1,0)
	get_parent().add_child(proyectil)
	BusEventos.disparo.emit()
	atacando=false
func recibirDaño(dañoRecibido:int)->void:
	if estaMuerto:
		return
<<<<<<< HEAD
	vidas-=dañoRecibido
	vidas=clamp(vidas,0,vidaMaxima)
	barraVida.value=vidas
	BusEventos.jugadorRecibioDanio.emit(vidas)
	if vidas<=0:
		_morir()
	else:
		recibiendoDanio=true
		animacion.play("recibir_danio")
func _alTerminarAnimacion()->void:
	if animacion.animation=="recibir_danio":
		recibiendoDanio=false
		animacion.play("idle")
	elif animacion.animation=="disparar":
		animacion.play("idle")
func _morir()->void:
	estaMuerto=true
	BusEventos.jugadorMuerto.emit()
	animacion.play("morir")
	get_tree().current_scene.get_node("MenuPerdido").activar_game_over()
	queue_free()
=======
	vida_actual -= cantidad
	vida_actual = clamp(vida_actual, 0, vida_max)
	barra_vida.value = vida_actual
	BusEventos.jugadorRecibioDanio.emit(vida_actual)
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
	BusEventos.jugadorMuerto.emit()
	sprite.play("morir")
>>>>>>> origin/main
