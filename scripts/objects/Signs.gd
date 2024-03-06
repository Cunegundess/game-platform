extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var area_2d = $Area2D

const lines: Array[String] = [
	"Ola, aventureiro!",
	"Que otimo te ver por aqui",
	"Espero que esteja preparado",
	"Sua jornada esta apenas comecando!",
	"...E cuidado com os monstrinhos...",
	"Eles parecem ser fofos...",
	"Mas sao muito PERIGOSOS!!"
]

func _unhandled_input(event):
	if event.is_action_pressed("interact") && !DialogManager.is_message_active:
		sprite_2d.hide()
		DialogManager.start_message(global_position, lines)


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		sprite_2d.show()


func _on_area_2d_body_exited(body):
	sprite_2d.hide()
	if DialogManager.dialog_box != null:
		DialogManager.dialog_box.queue_free()
		DialogManager.is_message_active = false
