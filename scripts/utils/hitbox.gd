extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		body.velocity.y = body.JUMP_FORCE
		owner.animation.play("hurt")
		owner.SPEED = 0
		await get_tree().create_timer(.3).timeout
		owner.queue_free()
