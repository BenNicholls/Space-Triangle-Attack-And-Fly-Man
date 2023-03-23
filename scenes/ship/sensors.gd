class_name SensorSystem
extends Node2D

signal new_object_detected(object_id)
signal tracked_object_lost(object_id)
signal scan_complete

enum Modes {ALL, PLANETS, SHIPS, FRIENDLY, HOSTILE}

@export var sensor_range: float = 2500
var sensor_mode: Modes = Modes.ALL
var active_tracking: bool = true #if true, will update tracked objects' position each tick
var tracked_objects = {} #dict elements key:values are {obj_id: scandata}

class ScanData:
#	var name: String
#	var type: int #object type, as defined in Defs.OBJTYPES. used to filter objects for certain scan modes
#	var hostile: bool
	var position: Vector2 #global position


func _process(_delta) -> void:
	pass
	#if active_tracking:
		# put active position scanning and updating logic here


# this function finds all objects in range for tracking, and acquires scan data
func scan() -> void:
	var sector = get_tree().get_root().get_node("Main/Sector") #TODO: make this less horrific
	assert(sector != null)

	var new_objects = sector.get_objects_in_range(global_position, sensor_range)

	# remove tracked objects not in range anymore
	for object_id in tracked_objects.keys():
		if not new_objects.has(object_id):
			emit_signal("tracked_object_lost", object_id)
			tracked_objects.erase(object_id)

	# add new objects
	for object_id in new_objects:
		if not tracked_objects.has(object_id):
			var data = ScanData.new()
			data.position = new_objects[object_id].global_position
			tracked_objects[object_id] = data
			emit_signal("new_object_detected", object_id)
		else: #update data for objects that are already being tracked
			tracked_objects[object_id].position = new_objects[object_id].global_position

	emit_signal("scan_complete")


func get_scanData(id: int) -> ScanData:
	return tracked_objects[id]


func _on_SensorTimer_timeout() -> void:
	scan()
