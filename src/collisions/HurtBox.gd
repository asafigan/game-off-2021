extends Area2D

export var damage_multiplier: = 1.0
export var force_multiplier: = 1.0

signal hurt(area, info)

onready var collision_shape = $CollisionShape2D

func disable():
	collision_shape.set_deferred("disabled", true)

func _on_HurtBox_area_entered(area):
	emit_signal("hurt", area, {
		damage_multiplier = damage_multiplier,
		force_multiplier = force_multiplier,
	})
