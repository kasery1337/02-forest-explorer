extends Node 

# Сигналы для связи систем игры
signal item_collected(item_name: String)
signal update_selection_visual
signal inventory_updated

var player_name: String = "Игрок"
var is_dead: bool = false
var active_slot_index: int = 0

# Строго типизированный массив для ресурсов
var inventory: Array[ItemData] = []

func add_item(item: ItemData) -> bool:
	if not item: return false
	
	# 1. Ищем существующий стак с таким же именем, где меньше 10 предметов
	for current_item in inventory:
		if current_item.name == item.name and current_item.amount < 10:
			current_item.amount += 1
			inventory_updated.emit()
			return true
			
	# 2. Если свободного места в стаках нет, создаем новую ячейку
	# Обязательно дублируем ресурс, чтобы у каждого стака был свой счетчик amount
	var item_clone = item.duplicate()
	item_clone.amount = 1
	
	inventory.append(item_clone)
	inventory_updated.emit()
	return true
