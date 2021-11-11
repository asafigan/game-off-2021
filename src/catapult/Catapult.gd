extends Position2D

export var spawn_scene: PackedScene
export var launch_speed: = 1000.0
export var max_angular_velocity: = 100.0
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if spawn_scene:
			var origin: = to_global(Vector2.ZERO)
			var end_point: Vector2 = event.position
			var vector = (end_point - origin).normalized()
			var spawned := spawn_scene.instance() as RigidBody2D
			get_parent().add_child(spawned)
			spawned.global_position = to_global(Vector2.ZERO)
			spawned.linear_velocity = vector * launch_speed
			spawned.angular_velocity = rng.randf_range(-max_angular_velocity, max_angular_velocity)
