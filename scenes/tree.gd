extends Node2D

@export var item_resources: Resource

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		# Проверяем, что инструмент экипирован И это топор
		if body.equipped_tool != null and body.equipped_tool.name == "axe":
			spawn_wood()
			queue_free()

func spawn_wood() -> void:
	if item_resources != null:
		Global.add_item(item_resources)
