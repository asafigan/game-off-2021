extends Position2D

export var spawn_scene: PackedScene
export var facing: = Vector2.RIGHT

func _ready():
	call_deferred("spawn")

func _on_Timer_timeout():
	call_deferred("spawn")

func spawn():
	if spawn_scene:
		var spawned = spawn_scene.instance()
		get_parent().add_child(spawned)
		spawned.global_position = global_position
		spawned.set("facing", facing)
