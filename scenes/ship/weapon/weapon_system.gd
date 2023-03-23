extends Node2D

signal projectile_fired(proj) #proj is a Projectile node (see Projectile.gd)

var firing: bool = false: set = set_firing
var ship: Ship #attached ship. TODO: weapons can be attached to more than just ships.


func _ready() -> void:
	for node in get_children():
		if node is Weapon:
			node.projectile_fired.connect(_on_projectile_fired)
		


func _physics_process(_delta: float) -> void:
	if firing:
		for weapon in get_children():
			weapon.fire()


func set_firing(fire: bool = true) -> void:
	if firing == fire:
		return

	firing = fire


func _on_projectile_fired(proj):
	proj.global_position = global_position
	proj.velocity = proj.velocity.rotated(global_rotation) + ship.velocity
	proj.rotate(global_rotation)
	projectile_fired.emit(proj)
