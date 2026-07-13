extends Area2D
@onready var sprite = $AnimatedSprite2D
var velocidad = 600.0
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
func _al_chocar_cuerpo(cuerpo_rid, cuerpo, indice_forma, indice_forma_local):
	var id_dueno = cuerpo.shape_find_owner(indice_forma)
	var forma = cuerpo.shape_owner_get_owner(id_dueno)
	if forma.is_in_group("limites"):
		queue_free()
