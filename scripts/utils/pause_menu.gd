extends CanvasLayer


func _ready():
	visible = false


func _on_pause_button_pressed():
	get_tree().paused = false
	visible = false
	

func _on_pause_pressed():
	get_tree().paused = false
	visible = false


func _on_quit_button_pressed():
	get_tree().quit()


func _on_quit_pressed():
	get_tree().quit()
	
	
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		visible = true
		get_tree().paused = true


