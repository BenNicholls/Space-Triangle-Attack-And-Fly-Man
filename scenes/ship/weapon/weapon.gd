class_name Weapon
extends Node2D


signal projectile_fired(projectile)

@onready var projectile = preload("res://scenes/ship/weapon/projectile.tscn")
@onready var fireRateTimer = $FireRateTimer

@export var proj_speed: int = 2500
@export var fire_rate: float = 5 #number of projectiles per second


func _ready():
	fireRateTimer.wait_time = 1/fire_rate


func fire() -> void:
	if fireRateTimer.time_left == 0:
		var proj = projectile.instantiate()
		proj.velocity = Vector2(1,0)*proj_speed
		projectile_fired.emit(proj)
		fireRateTimer.start()
