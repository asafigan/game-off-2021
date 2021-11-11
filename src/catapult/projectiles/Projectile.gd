extends RigidBody2D


# amount of damage done on hit
export var strength: = 10.0
export var spawn_scene: PackedScene
export var should_do_damage: = true
export var spawn_with_health: float

var has_done_damage: = false
var bodies_in = 0

onready var timer: Timer = $Timer

func _on_AntProjectile_body_entered(body):
	timer.start()
	if should_do_damage and not has_done_damage:
		attack(body)
		has_done_damage = true

const enemyProjectileHitBoxLayer = 5
func disable_enemy_collisions():
	collision_mask = collision_mask - pow(2, enemyProjectileHitBoxLayer)

func attack(body):
	bodies_in += 1
	if has_done_damage:
		return
	body.emit_signal("damage", strength)


func _on_AntProjectile_sleeping_state_changed():
	if sleeping:
		if spawn_scene:
			# have to defer because we are in the middle of collisions
			call_deferred("spawn")
		queue_free()

func spawn():
	var spawned = spawn_scene.instance()
	get_parent().add_child(spawned)
	spawned.global_position = global_position
	
	var facing = to_global(Vector2.RIGHT)-global_position
	facing.y = 0
	spawned.set("facing", facing.normalized())
	
	if spawn_with_health:
		spawned.set("current_health", spawn_with_health)

func _on_Timer_timeout():
	disable_enemy_collisions()
