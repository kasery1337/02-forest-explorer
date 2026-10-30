extends Area2D

func _on_body_entered(body: Node) -> void:
	# Команда меняет сцену на сцену лагеря (camp.tscn)
	get_tree().change_scene_to_file("res://scenes/forestportal.tscn")
