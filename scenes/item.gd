extends Control

@export var sprite: Sprite2D
# Объявляем переменную для ресурса, чтобы Godot знал о ней
@export var item_resources: Resource 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if sprite and item_resources:
		sprite.texture = item_resources.icon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
