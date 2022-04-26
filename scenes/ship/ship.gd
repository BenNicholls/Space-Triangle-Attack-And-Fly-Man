class_name Ship
extends KinematicBody2D

signal ship_destroyed

export (int) var accel = 250
export(float) var rotation_speed = 5
export(int) var thruster_speed = 100

onready var thrusters = $Thrusters
var velocity := Vector2()
var target := Vector2() #normalized vector for where ship wants to aim
var rotation_dir: int = 0
var thrusting_dir: Vector2 setget set_thrusting_dir #thrusting dir is an (HDIR, VDIR) pair
var disabled : bool
var boosting: bool setget set_boosting

func _ready() -> void:
	$Weapons.ship = self

func _physics_process(delta):
	if disabled:
		return

	rotate_ship(delta)

	var impulse = Vector2.ZERO
	if thrusting_dir != Vector2.ZERO:
		impulse += thruster_speed*thrusting_dir
	if boosting:
		impulse += get_forward_vec()*accel
	velocity = velocity + impulse*delta

	var collision = move_and_collide(velocity*delta)
	if collision != null:
		if velocity.length() > 100:
			ship_destroyed()

	if thrusting_dir != Vector2.ZERO:
		thrusters.fire_thrusters(thrusting_dir)


# initialize ship
func spawn() -> void:
	disabled = false
	velocity = Vector2()
	$Splosion.restart()
	$Splosion.hide()
	$Sprite.show()


func rotate_ship(delta) -> void:
	var new_dir: int = Defs.RotDir.NONE
	var angle_towards_target =  get_forward_vec().angle_to(target)
	if abs(angle_towards_target) > 0.15:
		if angle_towards_target < 0:
			new_dir = Defs.RotDir.CCW
		else:
			new_dir = Defs.RotDir.CW

	if new_dir != rotation_dir:
		if new_dir == Defs.RotDir.NONE:
			thrusters.fire_rotation_thrusters(-rotation_dir)
		else:
			thrusters.fire_rotation_thrusters(new_dir)
		rotation_dir = new_dir

	if rotation_dir != Defs.RotDir.NONE:
		rotate(rotation_speed*rotation_dir*delta)


func set_thrusting_dir(dir: Vector2) -> void:
	if thrusting_dir != dir:
		if dir == Vector2.ZERO:
			thrusters._stop_all()

		thrusting_dir = dir


func set_boosting(boost: bool) -> void:
	if boosting == boost:
		return

	boosting = boost
	$BoostFlames.emitting = boosting


func set_firing(fire: bool = true) -> void:
	$Weapons.firing = fire


func ship_destroyed() -> void:
	velocity = Vector2.ZERO
	emit_signal("ship_destroyed")
	$Splosion.show()
	$Splosion.emitting = true
	$Sprite.hide()
	$BoostFlames.emitting = false
	self.disabled = true


func get_forward_vec() -> Vector2:
	return Vector2(1,0).rotated(rotation)
