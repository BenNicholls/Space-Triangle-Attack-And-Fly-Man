extends Node2D
class_name Weapon

signal projectile_fired(projectile)

onready var projectile = preload("res://scenes/ship/weapon/projectile.tscn")
onready var fireRateTimer = $FireRateTimer

export(int) var proj_speed: int = 2500
export(float) var fire_rate: float = 5 #number of projectiles per second


func _ready():
	fireRateTimer.wait_time = 1/fire_rate


func fire() -> void:
	if fireRateTimer.time_left == 0:
		var proj = projectile.instance()
		proj.velocity = Vector2(1,0)*proj_speed
		emit_signal("projectile_fired", proj)
		fireRateTimer.start()
