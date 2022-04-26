extends Node

onready var playerShip = $Ship


func _ready() -> void:
	$Ship/TargettingHUD.sensors = $Ship/Sensors


func _unhandled_input(event) -> void:
	if event is InputEventKey:
		#handle boost
		if event.is_action_pressed("boost"):
			playerShip.boosting = true
		if event.is_action_released("boost"):
			playerShip.boosting = false
		if Input.is_action_just_pressed("toggle_sensor_hud"):
			$Ship/TargettingHUD.toggle()
	elif event is InputEventMouseMotion:
		playerShip.target = event.position - get_viewport().size/2
	elif event is InputEventMouseButton:
		if event.is_action_pressed("shoot"):
			playerShip.set_firing()		
		if event.is_action_released("shoot"):
			playerShip.set_firing(false)


func _process(_delta) -> void:
	# handle horizontal input
	var new_x_dir = Defs.HDir.NONE
	if Input.is_action_pressed("thruster_left"):
		new_x_dir += Defs.HDir.LEFT
	if Input.is_action_pressed("thruster_right"):
		new_x_dir += Defs.HDir.RIGHT

	# handle vertical input
	var new_y_dir = Defs.VDir.NONE
	if Input.is_action_pressed("thruster_up"):
		new_y_dir += Defs.VDir.UP
	if Input.is_action_pressed("thruster_down"):
		new_y_dir += Defs.VDir.DOWN

	playerShip.thrusting_dir = Vector2(new_x_dir, new_y_dir)
