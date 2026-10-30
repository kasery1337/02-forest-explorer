extends Resource

class_name ItemData

@export var name: String = ''
@export var icon: Texture2D
@export var is_tool: bool = false
@export var damage: int = 0

# Количество предметов в текущем стаке (по умолчанию 1)
var amount: int = 1
