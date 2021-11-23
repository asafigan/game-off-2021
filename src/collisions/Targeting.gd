extends Area2D
class_name Targeting

var ref: WeakRef

func get_closest_target():
	if ref:
		var deref = ref.get_ref()
		if deref:
			return deref
			
	return find_new_target()

func find_new_target():
	var closest = null
	var distance = 0
	for target in get_overlapping_areas():
		var target_distance = global_position.distance_to(target.global_position)
		if closest == null or distance > target_distance:
			closest = target
			distance = target_distance
	
	ref = weakref(closest)
	return closest

func _on_Timer_timeout():
	find_new_target()
