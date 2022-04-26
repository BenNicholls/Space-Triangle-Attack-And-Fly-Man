extends Node2D

enum {FORWARDLEFT, LEFTFORWARD, LEFTAFT, AFTLEFT, AFTRIGHT, RIGHTAFT, RIGHTFORWARD, FORWARDRIGHT}

var thrusters = []


func _ready() -> void:
	thrusters.append($ForwardLeft)
	thrusters.append($LeftForward)
	thrusters.append($LeftAft)
	thrusters.append($AftLeft)
	thrusters.append($AftRight)
	thrusters.append($RightAft)
	thrusters.append($RightForward)
	thrusters.append($ForwardRight)


func fire_rotation_thrusters(rotation_direction: int) -> void:
	if rotation_direction == Defs.RotDir.CCW:
		for thruster in [RIGHTFORWARD, LEFTAFT]:
			_fire_once(thrusters[thruster])
	elif rotation_direction == Defs.RotDir.CW:
		for thruster in [LEFTFORWARD, RIGHTAFT]:
			_fire_once(thrusters[thruster])


# fires the strafing thrusters for WASD style strafing maneuvers
func fire_thrusters(dir: Vector2) -> void:
	if dir == Vector2.ZERO:
		_stop_all()
		return

	dir.x = -dir.x #not sure why i have to flip the x-axis here.
	var thrust_dir = dir.rotated(global_rotation)
	var angle = Vector2(1,0).angle_to(thrust_dir) + PI/8
	if angle < 0:
		angle += 2*PI
	var index = int(angle/(PI/4))
	for i in range(8):
		if i == index || i == index - 1 || index == 0 && i ==7:
			_fire(thrusters[i])
		else:
			_stop(thrusters[i])


func _fire(thruster : Particles2D) -> void:
	# do not fire thruster that is already firing
	if thruster.emitting && !thruster.one_shot:
		return

	thruster.one_shot = false
	thruster.explosiveness = 0.0
	thruster.restart()
	thruster.emitting = true


func _fire_once(thruster : Particles2D) -> void:
	if thruster.emitting:
		return

	thruster.one_shot = true
	thruster.explosiveness = 0.5
	thruster.emitting = true


func _stop(thruster: Particles2D) -> void:
	if !thruster.emitting:
		return

	thruster.emitting = false


func _stop_all() -> void:
	for thruster in thrusters:
		_stop(thruster)
