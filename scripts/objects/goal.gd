extends Area2D

@onready var transition = $"../Transition"
@export var next_level: String = ""

func _on_body_entered(body):
	if body.name == "Player" and !next_level == "":
		$AnimatedSprite2D.play("default")
		transition.change_scene(next_level)
