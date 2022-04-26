extends Area2D
class_name Projectile

var velocity: Vector2 = Vector2.ZERO
var damage: int = 10
var hit: bool = false


func _physics_process(delta: float) -> void:
	position += velocity*delta


func _on_VisibilityNotifier2D_screen_exited() -> void:
	#do not activate the despawn process if projectile leaves screen due to a hit
	if hit == true: 
		return

	$DespawnTimer.start()


func _on_VisibilityNotifier2D_screen_entered() -> void:
	$DespawnTimer.stop()


func _on_DespawnTimer_timeout() -> void:
	queue_free()


func _on_Bullet_body_entered(_body:Node) -> void:
	hit = true
	#damage passing code goes here
	queue_free()
