extends Node


func _on_projectile_fired(proj):
	add_child(proj)
