extends Node2D
class_name Sector


func get_objects_in_range(pos: Vector2, search_range: float) -> Dictionary:
	var objects = {}
	for node in get_children():
		if node.position.distance_to(pos) < search_range:
			objects[node.get_instance_id()] = node
	return objects
