extends CharacterBody2D

@onready var animation = $AnimatedSprite2D
@onready var remote_transform = $RemoteTransform2D
@onready var raycast_left = $RayCast2D_left
@onready var raycast_right = $RayCast2D_right
@onready var jump_sound = $Jump_Sound
@onready var hurt_sound = $Hurt_Sound
@onready var death_sound = $Death_Sound

const SPEED = 150.0
const JUMP_FORCE = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping = false
var knockback_vector = Vector2.ZERO
var is_hurted = false
var direction
var can_control = true

signal player_has_died()


func _physics_process(delta):
	if !can_control: return
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
		jump_sound.play()
	elif is_on_floor():
		is_jumping = false
		
	direction = Input.get_axis("left", "right")
	
	if direction != 0:
		velocity.x = direction * SPEED
		animation.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
		
	for platforms in get_slide_collision_count():
		var collision = get_slide_collision(platforms)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)
		
	_set_state()
	move_and_slide()


func _on_hurtbox_body_entered(body):
	if raycast_left.is_colliding():
		take_damage(Vector2(200, -200))
	if raycast_right.is_colliding():
		take_damage(Vector2(-200, -200))


func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path


func take_damage(knockback_force = Vector2.ZERO, duration = 0.25):
	if Globals.player_life > 0:
		hurt_sound.play()
		Globals.player_life -= 1
	else:
		death_sound.play()
		queue_free()
		emit_signal("player_has_died")
		
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween = get_tree().create_tween().parallel()
		knockback_tween.tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1, 0, 0, 1)
		knockback_tween.tween_property(animation, "modulate", Color(1, 1, 1, 1), duration)
	
	is_hurted = true
	await get_tree().create_timer(.3).timeout
	is_hurted = false


func _set_state():
	var state = "idle"
	
	if !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "run"
		
	if is_hurted:
		state = "hurt"
		
	if animation.name != state:
		animation.play(state)


func _on_head_collider_body_entered(body):
	if body.has_method("break_sprite"):
		body.hitpoints -= 1
		if body.hitpoints < 0:
			body.break_sprite()
			body.hit_block_sound.play()
		else:
			body.animation_player.play("hit")
			body.hit_block_sound.play()
			body.create_coin()


func handle_danger():
	visible = false
	can_control = false
	await get_tree().create_timer(.2).timeout
	emit_signal("player_has_died")
