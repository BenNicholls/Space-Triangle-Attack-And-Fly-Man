extends Node2D

signal projectile_fired(proj) #proj is a Projectile node (see Projectile.gd)

var firing: bool = false setget set_firing


func _ready() -> void:
	for node in get_children():
		node.connect("projectile_fired", self, "_on_projectile_fired")


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
	proj.velocity = proj.velocity.rotated(global_rotation)
	proj.rotate(global_rotation)
	emit_signal("projectile_fired", proj)
