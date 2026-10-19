extends CharacterBody2D

var speed = 40
@export var anim: AnimatedSprite2D

# 1. Добавляем ссылку на ваш узел текста над головой (уникальное имя)
@onready var name_label = %Label

# 2. Функция ready срабатывает ОДИН раз при старте сцены
func _ready():
	# Подтягиваем имя, которое сохранилось в Global при нажатии кнопки в меню
	name_label.text = Global.player_name

func _physics_process(_delta):
	var input = Vector2(Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left'), Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up'))
	velocity = input.normalized() * speed
	
	# Отмена расчета движения и тд
	if is_sitting:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	# Пооворот спрайта в зависимости от направления персонажа
	if input.x > 0:
		anim.flip_h = true
	elif input.x < 0:
		anim.flip_h = false
		
	# Переключение состояний анимации
	if input != Vector2.ZERO:
		anim.play('walk')
	else:
		anim.play('idle')
		
	move_and_slide()
	
# Флаг для sit (перенесли повыше, чтобы код выглядел аккуратнее)
var is_sitting = false

# Функция мониторит все, что нажал игрок
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('interact'):
		if is_sitting:
			is_sitting = false
			anim.play('idle')
		else:
			is_sitting = true
			anim.play('sit')
