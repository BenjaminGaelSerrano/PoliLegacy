extends Node2D
var items=[]
func agregarItem(esp: String, tipo: String, datos: Dictionary):
	items.append({
		"EspacioEnElInventario": esp,
		"tipo": tipo,
		"datos": datos
	})
func tieneItem(esp: String) -> bool:
	for item in items:
		if item.EspacioEnElInventario == esp:
			return true
	return false
func limpiar():
	items.clear()
