extends CanvasLayer

@export var grid: GridContainer

func _ready():
	Global.inventory_updated.connect(refresh_ui)
	Global.update_selection_visual.connect(update_selection_visual)
	refresh_ui()

func update_selection_visual():
	var slots = grid.get_children()
	for i in range(slots.size()):
		if i == Global.active_slot_index:
			slots[i].grab_focus()
		else:
			slots[i].release_focus()

func refresh_ui():
	# 1. Очистка старых слотов инвентаря на экране
	for child in grid.get_children(): 
		child.queue_free()
	
	# 2. Отрисовка актуальных предметов из Global.inventory
	for item in Global.inventory:
		var slot = Button.new()
		slot.icon = item.icon
		slot.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		# Фиксированный размер ячеек инвентаря под ваш пиксель-арт
		slot.custom_minimum_size = Vector2(28, 28) 
		
		# Если в стаке больше одного предмета — выводим счетчик
		if item.amount > 1:
			var amount_label = Label.new()
			amount_label.text = str(item.amount)
			
			# Уменьшаем размер шрифта под пиксельное разрешение
			amount_label.add_theme_font_size_override("font_size", 8)
			
			# Полностью отключаем автоматическое позиционирование, ломающее пиксели
			amount_label.grow_horizontal = Control.GROW_DIRECTION_BOTH
			amount_label.grow_vertical = Control.GROW_DIRECTION_BOTH
			
			# РУЧНОЕ ФИКСИРОВАННОЕ ПОЛОЖЕНИЕ (для разрешения 800x600):
			# Ставим координату прямо от правого нижнего края кнопки (28x28 пикселей)
			amount_label.position = Vector2(16, 14) 
			
			# Добавляем надпись на саму кнопку слота
			slot.add_child(amount_label)
		
		grid.add_child(slot)
