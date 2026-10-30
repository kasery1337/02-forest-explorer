extends CharacterBody2D

var speed = 40
@export var anim: AnimatedSprite2D
@export var item_resources: ItemData
@export var hand: Sprite2D
@export var item_world_scene: PackedScene

var equipped_tool: ItemData

# Ссылка на узел текста над головой
@onready var name_label = %Label

# Флаг для sit
var is_sitting = false

func _ready():
	name_label.text = Global.player_name
	Global.add_item(item_resources)
	
	if hand:
		hand.visible = false

func _physics_process(_delta):
	var input = Vector2(Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left'), Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up'))
	velocity = input.normalized() * speed
	
	if is_sitting:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	if input.x > 0:
		anim.flip_h = true
		if hand: hand.flip_h = true
	elif input.x < 0:
		anim.flip_h = false
		if hand: hand.flip_h = false
		
	if input != Vector2.ZERO:
		anim.play('walk')
	else:
		anim.play('idle')
		
	move_and_slide()

# ОБЪЕДИНЕННАЯ функция ввода
func _unhandled_input(event: InputEvent) -> void:
	# 1. Логика приседания (клавиша interact)
	if event.is_action_pressed('interact'):
		if is_sitting:
			is_sitting = false
			anim.play('idle')
		else:
			is_sitting = true
			anim.play('sit')
			
	# 2. Листание инвентаря
	if event.is_action_pressed('next_item'):
		change_selection(1)
	if event.is_action_pressed('prev_item'):
		change_selection(-1)

	# 3. ВЫБРАСЫВАНИЕ ПРЕДМЕТА
	if event.is_action_pressed('drop_item'):
		drop_item()

# Функция смены активного слота
func change_selection(direction: int):
	if Global.inventory.size() == 0: return
	
	Global.active_slot_index = (Global.active_slot_index + direction) % Global.inventory.size()
	if Global.active_slot_index < 0: 
		Global.active_slot_index = Global.inventory.size() - 1
	Global.update_selection_visual.emit()
	update_hand_visual()

# Функция обновления внешнего вида руки при пролистывании
func update_hand_visual():
	if Global.inventory.size() == 0:
		if hand:
			hand.visible = false
			hand.texture = null
		equipped_tool = null
		return

	var item = Global.inventory[Global.active_slot_index]
	
	if item:
		if item.is_tool:
			equipped_tool = item
			if hand:
				hand.texture = item.icon
				hand.visible = true
		else:
			if hand:
				hand.texture = item.icon
				hand.visible = true
			equipped_tool = null
	else:
		if hand:
			hand.visible = false
			hand.texture = null
		equipped_tool = null

# Функция удаления предмета из инвентаря при выбрасывании
func drop_item():
	if Global.inventory.size() > 0:
		var item_to_drop = Global.inventory[Global.active_slot_index]
		
		# Спавним предмет в мире
		spawn_dropped_item(item_to_drop)
		
		# Уменьшаем количество предметов в активном стаке
		item_to_drop.amount -= 1
		
		# Если предметов в ячейке не осталось — удаляем её из инвентаря
		if item_to_drop.amount <= 0:
			Global.inventory.remove_at(Global.active_slot_index)
		
		# Корректируем индекс и обновляем визуальные элементы
		Global.active_slot_index = clamp(Global.active_slot_index, 0, Global.inventory.size() - 1)
		Global.inventory_updated.emit()
		Global.update_selection_visual.emit() 
		update_hand_visual()

# Функция спавна предмета на сцене
func spawn_dropped_item(item_to_drop: ItemData):
	if not item_world_scene:
		print("КРИТИЧЕСКАЯ ОШИБКА: Вы забыли перетащить сцену дропа в поле 'item_world_scene' в Инспекторе игрока!")
		return
		
	var new_item = item_world_scene.instantiate()
	
	if "item_resources" in new_item:
		new_item.item_resources = item_to_drop
		
	var random_offset = Vector2(randf_range(-15, 15), randf_range(-15, 15))
	new_item.global_position = self.global_position + random_offset
	
	var current_main_scene = get_tree().current_scene
	if current_main_scene:
		current_main_scene.add_child(new_item)
		print("Предмет успешно выброшен в мир: ", item_to_drop.name)
	else:
		print("Ошибка: Не удалось найти главную сцену для спавна.")
