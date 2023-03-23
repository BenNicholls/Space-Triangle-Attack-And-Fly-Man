extends Sprite2D


func _ready():
	$AnimationPlayer.play("appear")


func update_position(angle: float) -> void:
	rotation = angle
	position = Vector2(200, 0).rotated(angle)


func remove() -> void:
	$AnimationPlayer.play("disappear")
	await $AnimationPlayer.animation_finished
	queue_free()
