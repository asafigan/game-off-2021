extends KinematicBody2D
class_name Creature

# max movement speed (pixels/second)
export var max_speed: = 0.0
# time it takes to get to max_speed (seconds)
export var rampup_time: = 1.0
# roughly how long it takes to top (seconds)
export var stop_time: = 2.0
# amount of damage creature does
export var strength: = 1.0
# amount of health creature has
export var max_health: = 10.0
# gravity (pixels/second/second)
export var gravity: = 98.0
# the direction they face
export var facing: = Vector2.RIGHT

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

onready var pivot: Position2D = $Pivot
onready var targeting: Targeting
onready var animation_tree: AnimationTree = $AnimationTree
onready var animation_state: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
onready var current_health: = max_health

# Called when the node enters the scene tree for the first time.
func _ready():
	facing.y = 0
	facing = facing.normalized()
	
	targeting = get_node_or_null("Targeting")
	if targeting:
		retarget()
		
	animation_tree.active = true

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
	
func attack(area):
	area.emit_signal("damage", strength)

func take_damage(amount: float):
	current_health -= amount
	emit_signal("took_damage", amount)
	
	if current_health <= 0:
		emit_signal("killed")
		queue_free()
