extends Node2D

@onready var player = $Player
@onready var camera = $Camera2D
@onready var control = $Hud/Control

func _ready():
	player.follow_camera(camera)
	player.player_has_died.connect(game_over)
	control.time_is_up.connect(game_over)
	#Globals.coins = 0
	#Globals.score = 0
	#Globals.player_life = 3


func reload_game():
	get_tree().reload_current_scene()
	

func game_over():
	get_tree().change_scene_to_file("res://scenes/utils/game_over.tscn")
