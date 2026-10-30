extends Area2D

# Сюда автоматически запишутся данные из player.gd при спавне
var item_resources: ItemData 

@onready var sprite = $Sprite2D

# Флаг задержки подбора
var can_be_picked_up: bool = false

func _ready() -> void:
	if item_resources:
		sprite.texture = item_resources.icon
	
	# Безопасное подключение физического сигнала столкновения
	body_entered.connect(_on_body_entered)
	
	# Задержка в 0.6 секунды, чтобы игрок успел отойти при выбрасывании
	await get_tree().create_timer(0.6).timeout
	can_be_picked_up = true

func _on_body_entered(body: Node) -> void:
	if not can_be_picked_up:
		return
		
	# Самая надежная проверка физического тела игрока
	if body is CharacterBody2D and body.has_method("spawn_dropped_item"):
		var success = Global.add_item(item_resources)
		
		if success:
			print("Предмет подобран: ", item_resources.name)
			queue_free()
