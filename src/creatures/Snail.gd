extends Creature
onready var damage_animation_player = $DamageAnimationPlayer

func _on_HitBox_damage(info):
	take_damage(info)


func _on_HurtBox_hurt(area, info):
	attack(area, info)


func _on_StopBox_area_entered(area):
	enemy_in_range()


func _on_StopBox_area_exited(area):
	enemy_out_of_range()


func _on_Snail_took_damage(amount):
	damage_animation_player.stop()
	damage_animation_player.play("Damage")
