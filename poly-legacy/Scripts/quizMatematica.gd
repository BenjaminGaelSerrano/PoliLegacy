extends CanvasLayer
@onready var preguntaLabel=$PanelContainer/VBoxContainer/Label
@onready var btnA=$PanelContainer/VBoxContainer/Button
@onready var btnB=$PanelContainer/VBoxContainer/Button2
@onready var btnC=$PanelContainer/VBoxContainer/Button3
@onready var feedbackLabel=$PanelContainer/VBoxContainer/Label2
var preguntas=[
	{
		"texto": "Si x + 3 = 7, ¿cuánto vale x?",
		"opciones": ["A)  x = 4", "B)  x = 10", "C)  x = 3"],
		"correcta": 0
	},
	{
		"texto": "¿Cuál es el resultado de 2 × (3 + 4) − 8?",
		"opciones": ["A)  6", "B)  14", "C)  2"],
		"correcta": 0
	},
	{
		"texto": "¿A qué fracción simple equivale 3/6?",
		"opciones": ["A)  2/3", "B)  1/3", "C)  1/2"],
		"correcta": 2
	},
	{
		"texto": "En 5 + 3 × 2, ¿qué operación se realiza primero según el orden correcto?",
		"opciones": ["A)  La suma (5+3)", "B)  La multiplicación (3×2)", "C)  El orden no importa"],
		"correcta": 1
	}
]
var preguntaActual=0
func _ready():
	visible=false
	BusEventos.jefeMateDerrotado.connect(_activar)
func _activar():
	preguntaActual=0
	visible=true
	get_tree().paused=true
	_mostrarPregunta()
func _mostrarPregunta():
	var p=preguntas[preguntaActual]
	preguntaLabel.text="Pregunta " + str(preguntaActual + 1) + " / " + str(preguntas.size()) + "\n\n" + p["texto"]
	btnA.text=p["opciones"][0]
	btnB.text=p["opciones"][1]
	btnC.text=p["opciones"][2]
	feedbackLabel.text=""
	btnA.disabled=false
	btnB.disabled=false
	btnC.disabled=false
func _onBtnAPressed():
	_responder(0)
func _onBtnBPressed():
	_responder(1)
func _onBtnCPressed():
	_responder(2)
func _responder(indice: int):
	btnA.disabled=true
	btnB.disabled=true
	btnC.disabled=true
	var p=preguntas[preguntaActual]
	if indice == p["correcta"]:
		feedbackLabel.modulate=Color(0.3, 1.0, 0.4)
		feedbackLabel.text="Correcto!"
		await get_tree().create_timer(1.0).timeout
		preguntaActual+=1
		if preguntaActual >= preguntas.size():
			_victoria()
		else:
			_mostrarPregunta()
	else:
		_error()
func _error():
	feedbackLabel.modulate=Color(1.0, 0.3, 0.3)
	feedbackLabel.text="Incorrecto. Volvete a leer el libro y enfrentate al profesor de nuevo."
	await get_tree().create_timer(2.5).timeout
	visible=false
	get_tree().paused=false
	BusEventos.quizFallado.emit()
func _victoria():
	feedbackLabel.modulate=Color(1.0, 0.9, 0.2)
	feedbackLabel.text="Aprobaste matematica!"
	await get_tree().create_timer(2.0).timeout
	get_tree().paused=false
	Inventario.agregarItem("calculadora", "objeto", {"titulo": "Calculadora", "icono": ""})
	ManejadorJuego.pasarDeNivel()
