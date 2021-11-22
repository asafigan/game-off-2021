extends Creature

func _on_HitBox_damage(amount):
	take_damage(amount)

func _on_StopBox_area_entered(_area):
	enemy_in_range()

func _on_StopBox_area_exited(_area):
	enemy_out_of_range()

func _on_HurtBox_hurt(area, info):
	attack(area, info)
