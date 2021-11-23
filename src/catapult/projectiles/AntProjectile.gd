extends Projectile

func _on_AntProjectile_body_entered(body):
	on_hit(body)

func _on_AntProjectile_sleeping_state_changed():
	on_sleeping_state_changed()

func _on_Timer_timeout():
	disable_enemy_collisions()
