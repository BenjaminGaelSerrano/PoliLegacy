extends CharacterBody2D
const ProyectilGuada=preload("res://Scenes/proyectil_fiore.tscn")
@onready var sprite=$AnimatedSprite2D
@onready var barraVida=$ProgressBar
@onready var timerInicio=$Timer
@onready var timerAtaque=$Timer2
@onready var timerDobleDisparo=$Timer3
@onready var timerGolpe=$Timer4
@onready var areaDeteccion=$Area2D
@onready var areaContacto=$Area2D2
@onready var camaraIntro=$Camera2D
var vidaMaxima=150
var velocidad=180.0
var velocidadFase2=270.0
var danioContacto=30
var numeroNivel=3
var vida=150
var objetivo=null
var enCombate=false
var faseActual=1
var transicionRealizada=false
var muriendo=false
var puedeMoverse=false
var aturdido=false
var posicionInicial=Vector2.ZERO
func _ready():
	vida=vidaMaxima
	posicionInicial=position
	objetivo=get_tree().get_first_node_in_group("jugador")
	sprite.play("idle")
	camaraIntro.make_current()
	timerInicio.start()
	BusEventos.quizFallado.connect(reiniciar)
func reiniciar():
	vida=vidaMaxima
	position=posicionInicial
	barraVida.value=vidaMaxima
	barraVida.max_value=vidaMaxima
	faseActual=1
	transicionRealizada=false
	muriendo=false
	puedeMoverse=false
	aturdido=false
	enCombate=false
	sprite.visible=true
	sprite.flip_h=false
	sprite.play("idle")
	areaDeteccion.monitoring=true
	areaContacto.monitoring=true
	timerGolpe.stop()
	timerAtaque.stop()
	timerDobleDisparo.stop()
	objetivo=get_tree().get_first_node_in_group("jugador")
	await get_tree().create_timer(1.5).timeout
	if not muriendo:
		puedeMoverse=true
		enCombate=true
		_iniciarCicloAtaque()
func _physics_process(delta):
	if muriendo or objetivo == null or not puedeMoverse or aturdido:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	var velActual
	if faseActual == 1:
		velActual=velocidad
	else:
		velActual=velocidadFase2
	var direccion=(objetivo.global_position - global_position).normalized()
	velocity = direccion * velActual
	move_and_slide()
	sprite.flip_h=direccion.x < 0
func _alTerminarTimerInicio():
	var jug=get_tree().get_first_node_in_group("jugador")
	if jug == null or not jug.has_node("Camera2D"):
		return
	var cam=jug.get_node("Camera2D")
	camaraIntro.reparent(get_parent())
	var tween=create_tween()
	tween.set_parallel(true)
	tween.tween_property(camaraIntro, "global_position", jug.global_position, 1.0)
	tween.tween_property(camaraIntro, "zoom", cam.zoom, 1.0)
	await tween.finished
	cam.make_current()
	camaraIntro.queue_free()
	puedeMoverse=true
	enCombate=true
	_iniciarCicloAtaque()
func _alEntrarAlArea(cuerpo):
	if cuerpo.is_in_group("jugador") and not enCombate and not muriendo:
		objetivo=cuerpo
		enCombate=true
		_iniciarCicloAtaque()
func _alEntrarContacto(area):
	if area.is_in_group("jugador") and not muriendo:
		_golpear()
		timerGolpe.start()
func _alSalirContacto(area):
	if area.is_in_group("jugador"):
		timerGolpe.stop()
func _alTerminarTimerGolpe():
	if enCombate and not muriendo and objetivo != null:
		_golpear()
		timerGolpe.start()
func _golpear():
	if objetivo == null or muriendo or aturdido:
		return
	sprite.play("atacar")
	objetivo.recibir_danio(danioContacto)
	_aturdir()
func _aturdir():
	aturdido=true
	await get_tree().create_timer(1.2).timeout
	aturdido=false
func _iniciarCicloAtaque():
	if not enCombate or muriendo:
		return
	if faseActual == 1:
		timerAtaque.wait_time=2.5
	else:
		timerAtaque.wait_time=1.0
	timerAtaque.start()
func _alTerminarTimerAtaque():
	if not enCombate or objetivo == null or muriendo:
		return
	_dispararHaciaJugador()
	if faseActual == 2:
		timerDobleDisparo.start()
	else:
		_iniciarCicloAtaque()
func _alTerminarTimerDobleDisparo():
	if not enCombate or objetivo == null or muriendo:
		return
	_dispararHaciaJugador()
	_iniciarCicloAtaque()
func _dispararHaciaJugador():
	if objetivo == null:
		return
	sprite.play("disparar")
	var proyectil=ProyectilGuada.instantiate()
	get_parent().add_child(proyectil)
	proyectil.global_position=global_position
	proyectil.direccion=(objetivo.global_position - global_position).normalized()
func _disparoExplosion():
	for i in range(6):
		var angulo=(TAU / 6.0) * i
		var proyectil=ProyectilGuada.instantiate()
		get_parent().add_child(proyectil)
		proyectil.global_position=global_position
		proyectil.direccion=Vector2(cos(angulo), sin(angulo))
func recibir_danio(cantidad):
	if muriendo:
		return
	vida-=cantidad
	vida=max(vida, 0)
	barraVida.value=vida
	sprite.play("recibirDanio")
	if not transicionRealizada and vida <= vidaMaxima / 2:
		transicionRealizada=true
		faseActual=2
		_disparoExplosion()
	if vida <= 0:
		_morir()
func _morir():
	muriendo=true
	enCombate=false
	timerAtaque.stop()
	timerDobleDisparo.stop()
	timerGolpe.stop()
	areaDeteccion.monitoring=false
	areaContacto.monitoring=false
	sprite.play("morir")
	BusEventos.jefeDerrotado.emit(numeroNivel)
	await get_tree().create_timer(3.0).timeout
	sprite.visible=false
	BusEventos.jefeMateDerrotado.emit()
func _alTerminarAnimacion():
	if muriendo:
		return
	if sprite.animation in ["atacar", "disparar", "recibirDanio"]:
		sprite.play("idle")
