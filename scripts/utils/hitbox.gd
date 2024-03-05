extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		body.velocity.y = body.JUMP_FORCE
		# Owner = Enemy
		owner.animation.play("hurt")
		owner.animation_player.play("death")
		owner.death_enemy_sound.play()
		owner.SPEED = 0
		await get_tree().create_timer(.3).timeout
		Globals.score += owner.enemy_score
		owner.queue_free()

