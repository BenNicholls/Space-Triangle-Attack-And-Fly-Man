class_name Ship
extends CharacterBody2D

signal ship_destroyed

@export var accel = 250
@export var rotation_speed: float = 5
@export var thruster_speed: int = 100

var target := Vector2() #normalized vector for where ship wants to aim
var rotation_dir: int = 0
var thrusting_dir: Vector2: set = set_thrusting_dir
var disabled : bool
var boosting: bool: set = set_boosting
@onready var thrusters = $Thrusters


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
	
	if boosting:
		$BoostFlames.process_material.set_shader_parameter("initial_velocity_vec", velocity)

	var collision = move_and_collide(velocity*delta, false, 0.08, true)
	if collision != null:		
		var crash_velo := velocity.project(collision.get_normal())
		if crash_velo.length() > 200:
			destroy()
		else:
			velocity = -crash_velo
			if !$AnimationPlayer.is_playing():
				$AnimationPlayer.play("ouch")

	if thrusting_dir != Vector2.ZERO:
		thrusters.fire_thrusters(thrusting_dir)


# initialize ship
func spawn() -> void:
	disabled = false
	$Visuals.show()


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
	if disabled:
		return
	$Weapons.firing = fire


func destroy() -> void:
	velocity = Vector2.ZERO
	boosting = false
	emit_signal("ship_destroyed")
	$Splosion.emitting = true
	$Visuals.hide()
	$BoostFlames.emitting = false
	self.disabled = true


func get_forward_vec() -> Vector2:
	return Vector2(1,0).rotated(rotation)
