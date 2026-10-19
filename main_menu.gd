extends Control

@onready var name_input = %LineEdit
@onready var error_label = %Label

func _ready() -> void:
	# Если мы зашли в меню из-за того, что игрок умер
	if Global.is_dead:
		error_label.text = "Вы умерли!"
		error_label.visible = true
		Global.is_dead = false # Сбрасываем флаг для следующего раза

func _on_button_pressed() -> void:
	var entered_name = name_input.text.strip_edges() # Убираем лишние пробелы по бокам
	
	# Проверяем условие (длина больше 2 символов)
	if entered_name.length() > 2:
		Global.player_name = entered_name # Сохраняем имя в ваш глобальный Global.gd
		get_tree().change_scene_to_file("res://scenes/forest.tscn") # Запускаем сцену игры
	else:
		# Если имя слишком короткое — пишем предупреждение
		error_label.text = "Имя слишком короткое!"
		error_label.visible = true
