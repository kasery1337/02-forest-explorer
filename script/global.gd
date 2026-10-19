extends Node 

# Сигнал передает имя предмета 
signal item_collected(item_name: String)

var player_name: String = ""
var is_dead: bool = false
