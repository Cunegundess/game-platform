extends Node2D

@export var move_speed = 3.0
@export var distance = 192
@export var move_horizontal: bool = true

@onready var platform = $AnimatableBody2D

const WAIT_DURATION = 1.0
var follow = Vector2.ZERO
var plataform_center = 16

func _ready():
	move_platform()
	
func _physics_process(delta):
	platform.position = platform.position.lerp(follow, 0.5)

func move_platform():
	var move_direction = Vector2.RIGHT * distance if move_horizontal else Vector2.UP * distance
	var duration = move_direction.length() / float(move_speed * plataform_center)
	
	var platform_tween = create_tween().set_loops().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	platform_tween.tween_property(self, "follow", move_direction, duration).set_delay(WAIT_DURATION)
	platform_tween.tween_property(self, "follow", Vector2.ZERO, duration).set_delay(duration + WAIT_DURATION * 2)
