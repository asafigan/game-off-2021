extends Projectile

func _on_SnailProjectile_body_entered(body):
	on_hit(body)

func _on_SnailProjectile_sleeping_state_changed():
	on_sleeping_state_changed()

func _on_Timer_timeout():
	disable_enemy_collisions()
