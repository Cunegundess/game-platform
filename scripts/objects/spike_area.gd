extends Area2D

@onready var collision_shape = $CollisionShape2D
@onready var spikes = $Sprite2D

func _ready():
	collision_shape.shape.size = spikes.get_rect().size
	

func _on_body_entered(body):
	if body.name == "Player" && body.has_method("take_damage"):
		body.take_damage(Vector2(0, -250))
