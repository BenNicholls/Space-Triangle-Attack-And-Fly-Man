extends Node

var needsToRespawn : bool = false
onready var playerShip = $Player/Ship


func _ready():
	# connect ship weapon systems to the projectile manager
	playerShip.get_node("Weapons").connect("projectile_fired", $ProjectileManager, "_on_projectile_fired")


func _process(_delta):
	$UI/SpeedLabel.text = "Speed: " + str(int(playerShip.velocity.length())) + " M/S"

	if needsToRespawn and Input.is_action_just_pressed("ui_accept"):
		needsToRespawn = false
		playerShip.spawn()
		$Player/Ship/TargettingHUD.enabled = true
		playerShip.position = Vector2(100, 100)
		$UI/RespawnLabel.hide()


func _on_Ship_ship_destroyed():
	$UI/RespawnLabel.show()
	$Player/Ship/TargettingHUD.enabled = false
	needsToRespawn = true

