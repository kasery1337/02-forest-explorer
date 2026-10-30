extends Node

# Поменяйте $GridContainer на имя вашей сетки, если оно другое
@onready var grid = $GridContainer 

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func update_selection_visual():
	var slots = grid.get_children()
	for i in range(slots.size()):
		if i == Global.active_slot_index:
			slots[i].grab_focus()
		else:
			slots[i].release_focus()
