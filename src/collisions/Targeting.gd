extends Area2D
class_name Targeting

var targets: = []

func _on_Targeting_area_entered(area):
	targets.append(area)


func _on_Targeting_area_exited(area):
	targets.erase(area)

func get_closest_target():
	var closest = null
	var distance = 0
	for target in targets:
		var target_distance = global_position.distance_to(target.global_position)
		if closest == null or distance > target_distance:
			closest = target
			distance = target_distance
	
	return closest
