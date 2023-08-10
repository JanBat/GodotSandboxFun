extends ParallaxLayer
#-----------------------------------------------------
# GAME STATUS BANNER: Displays message based on beating high score
#  or waiting for game to start.

var message_speed = 100

func _process(delta):
	self.motion_offset.x += message_speed * delta
