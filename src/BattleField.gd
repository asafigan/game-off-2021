extends Node2D

var cross_hair = preload("res://assets/sprites/cross-hair.png")

func _ready():
	Input.set_custom_mouse_cursor(cross_hair, Input.CURSOR_ARROW, Vector2(10.0, 10.0))

