extends Area2D

@onready var sprite = $AnimatedSprite2D

var velocidad = 300.0
var danio = 10
var direccion = Vector2.ZERO

func _ready():
	sprite.play("idle")

func _physics_process(delta):
	position += direccion * velocidad * delta

func _al_entrar_area(area):
	if area.is_in_group("jugador"):
		area.get_parent().recibir_danio(danio)
		queue_free()
	elif area.is_in_group("limites"):
		queue_free()
