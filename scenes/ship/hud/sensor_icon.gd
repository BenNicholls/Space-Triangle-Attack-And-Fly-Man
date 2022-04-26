extends Sprite


func _ready():
	$AnimationPlayer.play("appear")


func update_position(angle: float) -> void:
	rotation = angle
	position = Vector2(200, 0).rotated(angle)

func remove() -> void:
	$AnimationPlayer.play("disappear")
	yield($AnimationPlayer, "animation_finished")
	queue_free()

