extends Node

var needsToRespawn := false
@onready var playerShip = $Player/Ship


func _ready():
	playershipSetup()	


func _process(_delta):
	$UI/SpeedLabel.text = "Speed: " + str(int(playerShip.velocity.length())) + " M/S"

	if needsToRespawn and Input.is_action_just_pressed("ui_accept"):
		needsToRespawn = false
		playerShip.spawn()
		%TargettingHUD.enabled = true
		playerShip.position = Vector2(100, 100)
		$UI/RespawnLabel.hide()


# connect signals for the player's ship to UI elements, manager singletons, etc.
func playershipSetup():
	if playerShip == null:
		printerr("No player ship to setup! Doh!")
		return
	
	# connect ship weapon systems to the projectile manager
	playerShip.get_node("Weapons").projectile_fired.connect($ProjectileManager._on_projectile_fired)
	
	#connect ship sensors to the targetting hud display
	%TargettingHUD.playerShip = playerShip
	var sensorSystem: SensorSystem = playerShip.get_node("Sensors")
	sensorSystem.scan_complete.connect(%TargettingHUD._on_Sensors_scan_complete)
	sensorSystem.new_object_detected.connect(%TargettingHUD._on_Sensors_new_object_detected)
	sensorSystem.tracked_object_lost.connect(%TargettingHUD._on_Sensors_tracked_object_lost)
	playerShip.ship_destroyed.connect(_on_Ship_ship_destroyed)


func _on_Ship_ship_destroyed():
	$UI/RespawnLabel.show()
	%TargettingHUD.enabled = false
	needsToRespawn = true
