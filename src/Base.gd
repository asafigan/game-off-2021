extends Node2D

onready var animation_player: = $AnimationPlayer

func _on_HitBox_damage(amount):
	animation_player.stop()
	animation_player.play("Damage")
