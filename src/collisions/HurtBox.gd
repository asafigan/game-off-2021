extends Area2D

onready var collision_shape = $CollisionShape2D

func disable():
	collision_shape.set_deferred("disabled", true)
