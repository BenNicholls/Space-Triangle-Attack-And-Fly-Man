extends Node2D

var IconScene = preload("res://scenes/ship/hud/sensor_icon.tscn")
var icons = {} #icons key:value are {object_id:$SensorIconNode}

var playerShip: Ship
var sensors : SensorSystem
var enabled: bool = true: set = set_enabled

func _process(delta):
	#this keeps the ship's rotation from activating the buzzsaw :)
	#global_rotation = 0

	if !enabled or playerShip == null:
		return
		
	if sensors == null:
		sensors = playerShip.get_node("Sensors")		

	for object_id in icons:
		#update icon positions
		var data = sensors.get_scanData(object_id)
		if data == null:
			_remove_object_icon(object_id)
			continue

		var angle = playerShip.global_position.angle_to_point(data.position)
		icons[object_id].update_position(angle)

	$Reticle.rotate(delta/20)

	
func toggle() -> void:
	set_enabled(!enabled)


func set_enabled(en: bool = true) -> void:
	if enabled == en:
		return

	enabled = en
	if $HudAnimation.is_playing():
		$HudAnimation.stop(false)
	if enabled:
		$HudAnimation.play("enable")
	else:
		$HudAnimation.play_backwards("enable")


func _add_object_icon(object_id) -> void:
	var icon = IconScene.instantiate()
	add_child(icon)
	icons[object_id] = icon

func _remove_object_icon(object_id) -> void:
	if !icons.has(object_id):
		return

	icons[object_id].remove()
	icons.erase(object_id)

func _on_Sensors_new_object_detected(object_id) -> void:
	_add_object_icon(object_id)


func _on_Sensors_tracked_object_lost(object_id) -> void:
	_remove_object_icon(object_id)


func _on_Sensors_scan_complete() -> void:
	$ReticleAnimation.play("pulse")
