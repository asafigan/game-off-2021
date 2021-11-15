extends Creature

export var death_scene: PackedScene

onready var damageAnimationPlayer: = $DamageAnimationPlayer

func _on_HurtBox_area_entered(area):
	attack(area)


func _on_HitBox_damage(amount):
	take_damage(amount)


func _on_StopBox_area_entered(_area):
	enemy_in_range()


func _on_StopBox_area_exited(_area):
	enemy_out_of_range()


func _on_StaticBodyHitBox_damage(amount):
	take_damage(amount)


func _on_ShroomBeetle_took_damage(amount):
	damageAnimationPlayer.stop()
	damageAnimationPlayer.play("Damage")


func _on_ShroomBeetle_killed():
	if death_scene:
		var spawned = death_scene.instance()
		get_parent().add_child(spawned)
		spawned.global_position = global_position
		spawned.scale = Vector2(2, 2)
