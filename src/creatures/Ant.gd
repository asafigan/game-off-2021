extends Creature

var projectile_form: PackedScene = load("res://src/catapult/projectiles/AntProjectile.tscn")
var rng = RandomNumberGenerator.new()
var has_been_flung: = false

func _ready():
	rng.randomize()

func _on_HurtBox_area_entered(area):
	attack(area)


func _on_HitBox_damage(amount):
	take_damage(amount)


func _on_StopBox_area_entered(_area):
	enemy_in_range()


func _on_StopBox_area_exited(_area):
	enemy_out_of_range()


func _on_Ant_took_damage(_amount):
	call_deferred("fling")
	
func fling():
	queue_free()
	if projectile_form and not has_been_flung:
		var spawned = projectile_form.instance()
		get_parent().add_child(spawned)
		spawned.linear_velocity = (Vector2.UP - facing) * 100
		spawned.angular_velocity = rng.randf_range(-100, 100)
		spawned.global_position = global_position + Vector2(0, -4)
		spawned.set("spawn_with_health", current_health)
		spawned.call("disable_enemy_collisions")
		if current_health <= 0:
			spawned.set("spawn_scene", null)
