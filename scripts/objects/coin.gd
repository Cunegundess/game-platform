extends Area2D

@onready var coin_sound = $Coin_Sound

var coins = 1

func _on_body_entered(body):
	$AnimatedSprite2D.play("collect")
	coin_sound.play()
	await $CollisionShape2D.call_deferred("queue_free")
	Globals.coins += coins


func _on_animated_sprite_2d_animation_finished():
	queue_free()
