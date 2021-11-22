extends Creature

onready var damageAnimationPlayer: = $DamageAnimationPlayer

func _on_HitBox_damage(info):
	take_damage(info)

func _on_StopBox_area_entered(_area):
	enemy_in_range()

func _on_StopBox_area_exited(_area):
	enemy_out_of_range()

func _on_StaticBodyHitBox_damage(amount):
	take_damage({
		damage = amount,
		force = 0.0,
	})

func _on_ShroomBeetle_took_damage(amount):
	damageAnimationPlayer.stop()
	damageAnimationPlayer.play("Damage")

func _on_HurtBox_hurt(area, info):
	attack(area, info)
