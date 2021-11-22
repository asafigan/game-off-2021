extends Position2D

export var spawn_scene: PackedScene
export var launch_speed: = 1000.0
export var max_angular_velocity: = 100.0
var rng = RandomNumberGenerator.new()
onready var line = $Line2D

func _ready():
	rng.randomize()
	line.clear_points()
	line.add_point(Vector2.ZERO)
	line.add_point(Vector2.ZERO)
	
func _process(delta):
	var end_point = get_local_mouse_position().clamped(200.0)
	line.set_point_position(1, end_point)
	
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
