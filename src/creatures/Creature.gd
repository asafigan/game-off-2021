extends KinematicBody2D
class_name Creature

# max movement speed (pixels/second)
export var max_speed: = 0.0
# time it takes to get to max_speed (seconds)
export var rampup_time: = 1.0
# roughly how long it takes to top (seconds)
export var stop_time: = 2.0
# amount of damage creature's attacks do
export var attack_damage: = 1.0
# amount of force creature's attacks do
export var attack_force: = 1.0
# amount of health creature has
export var max_health: = 10.0
# how much force it takes to fling them
export var max_stance: = 1.0
# gravity (pixels/second/second)
export var gravity: = 98.0
# the direction they face
export var facing: = Vector2.RIGHT
# projectile form
export(String, FILE, "*.tscn") var path_to_projectile_form 
# scene spawned on death
export var death_scene: PackedScene = preload("res://src/effects/ghost.tscn")
# scale of death scene
export var death_scene_scale: = 1.0

signal killed
signal took_damage(amount)

enum State {
	Move,
	Attack
}

var velocity: = Vector2.ZERO
var acceleration = Vector2(0, gravity)
var state = State.Move
var enemies_in_range: = 0
var current_drag: = 0.0
var has_been_flung: = false
var has_been_killed: = false
var rng = RandomNumberGenerator.new()

onready var pivot: Position2D = $Pivot
onready var targeting: Targeting
onready var animation_tree: AnimationTree = $AnimationTree
onready var animation_state: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
onready var current_health: = max_health
onready var projectile_form: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	facing.y = 0
	facing = facing.normalized()
	
	targeting = get_node_or_null("Targeting")
	if targeting:
		retarget()
		
	animation_tree.active = true
	
	if path_to_projectile_form:
		projectile_form = load(path_to_projectile_form)

func _physics_process(delta: float) -> void:
	velocity += acceleration * delta
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.x -= velocity.x * clamp(current_drag * delta, 0, 1)
	velocity = move_and_slide(velocity)
	
	animation_tree.set("parameters/Move/TimeScale/scale", abs(velocity.x) * 0.1)
	
	if facing.x < 0:
		pivot.scale.x = -1
	else:
		pivot.scale.x = 1
	
	match state:
		State.Move:
			moving()
		State.Attack:
			attacking()

func enemy_in_range() -> void:
	enemies_in_range += 1
	if enemies_in_range == 1:
		start_attacking()

func start_attacking() -> void:
	acceleration.x = 0
	state = State.Attack
	current_drag = 1/stop_time

func enemy_out_of_range() -> void:
	enemies_in_range -= 1
	if enemies_in_range == 0:
		stop_attacking()

func stop_attacking() -> void:
	state = State.Move
	current_drag = 0.0

func moving() -> void:
	animation_state.travel("Move")
	if targeting:
		retarget()
	acceleration = facing * max_speed / rampup_time + Vector2(0, gravity)

func retarget():
	var target = targeting.get_closest_target()
	if target:
		facing.x = (target.global_position - global_position).x
		facing = facing.normalized()
	

func attacking() -> void:
	animation_state.travel("Attack")
	
func attack(area, info):
	area.emit_signal("damage", {
		damage = attack_damage * info.damage_multiplier, 
		force = attack_force * info.force_multiplier,
	})

func take_damage(info: Dictionary):
	current_health -= info.damage
	emit_signal("took_damage", info.damage)

	if info.force > max_stance:
		call_deferred("fling")
	
	if current_health <= 0:
		call_deferred("kill")

func kill():
	emit_signal("killed")
	queue_free()
	if death_scene and not (has_been_flung or has_been_killed):
		has_been_killed = true
		var spawned = death_scene.instance()
		get_parent().add_child(spawned)
		spawned.global_position = global_position
		spawned.scale = Vector2(death_scene_scale, death_scene_scale)
	

func fling():
	if projectile_form and not has_been_flung:
		queue_free()
		has_been_flung = true
		
		var spawned: RigidBody2D = projectile_form.instance()
		spawned.global_position = global_position + Vector2(0, -4)
		spawned.angular_velocity = rng.randf_range(-20, 20)
		spawned.set("play_damage_animation", true)
		spawned.set("should_do_damage", false)
		spawned.call("disable_enemy_collisions")
		get_parent().add_child(spawned)
		
		spawned.apply_central_impulse((Vector2.UP - facing) * 100)
		
		spawned.set("spawn_with_health", current_health)
		
		if current_health <= 0:
			spawned.set("spawn_scene", death_scene)
			spawned.set("spawn_scene_scale", death_scene_scale)
