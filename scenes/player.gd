extends Node

@onready var playerShip: Ship = $Ship


func _unhandled_input(event) -> void:
	if playerShip.disabled:
		return
		
	if event is InputEventKey:
		#handle boost
		if event.is_action_pressed("boost"):
			playerShip.boosting = true
		if event.is_action_released("boost"):
			playerShip.boosting = false
		if Input.is_action_just_pressed("toggle_sensor_hud"):
			%TargettingHUD.toggle()
	elif event is InputEventMouseMotion:
		playerShip.target = event.position - Vector2(get_viewport().get_visible_rect().size/2)
	elif event is InputEventMouseButton:
		if event.is_action_pressed("shoot"):
			playerShip.set_firing()		
		if event.is_action_released("shoot"):
			playerShip.set_firing(false)


func _process(_delta) -> void:
	# handle horizontal input
	var new_x_dir: int = int(Defs.HDir.NONE)
	if Input.is_action_pressed("thruster_left"):
		new_x_dir += int(Defs.HDir.LEFT)
	if Input.is_action_pressed("thruster_right"):
		new_x_dir += int(Defs.HDir.RIGHT)

	# handle vertical input
	var new_y_dir: int = int(Defs.VDir.NONE)
	if Input.is_action_pressed("thruster_up"):
		new_y_dir += int(Defs.VDir.UP)
	if Input.is_action_pressed("thruster_down"):
		new_y_dir += int(Defs.VDir.DOWN)

	playerShip.thrusting_dir = Vector2(new_x_dir, new_y_dir)
