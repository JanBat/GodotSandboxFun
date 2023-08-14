extends ParallaxLayer
##-----------------------------------------------------
## GAME STATUS BANNER: Displays message based on beating high score
##  or waiting for game to start.

## scrolling speed of the banner
var message_speed = 100


## move parallax banner across the screen
func _process(delta):
	self.motion_offset.x += message_speed * delta
