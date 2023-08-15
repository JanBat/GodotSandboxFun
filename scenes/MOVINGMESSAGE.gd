extends ParallaxLayer

@onready var MessageStatus = $MOVINGBACKGROUND/MOVINGMESSAGE/GAMEMESSAGE
var message_speed = 100

func _process(delta) -> void:
	self.motion_offset.x += message_speed * delta
	self.motion_mirroring = Vector2(500, 0)
