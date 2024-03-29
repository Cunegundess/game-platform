extends CharacterBody2D

@onready var animation = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var wall_detector = $RayCast2D
@onready var death_enemy_sound = $Death_Sound

@export var enemy_score = 100

var SPEED = 30.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = -1

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
	
	if direction == 1:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
		
	velocity.x = direction * SPEED + delta
	
	move_and_slide()



func _on_animated_sprite_2d_animation_finished():
	if animation.name == "hurt":
		queue_free()
