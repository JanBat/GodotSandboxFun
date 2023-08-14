extends Node2D
## this script controls the invisible geometries
## floating around in backdrop.tscn in order to pass
## pass location parameters to the uniform variables
## of its canvas shader (rotating rainbowy swirly thing)

## speed at which individual PathFollow2Ds
## rotate around the Path describing its shape
@export
var speed = 0.3


## material of the backdrop canvas
@export
var shader: ShaderMaterial


## update the geometries that serve as orientation for 
## backdrop.gdshader
func _process(delta):
	var path = $RedPath
	var follow: PathFollow2D = path.get_node("PathFollow2D")
	follow.progress_ratio += delta * speed
	shader.set_shader_parameter("red_location", follow.position)
	
	path = $GreenPath
	follow = path.get_node("PathFollow2D")
	follow.progress_ratio += delta * speed
	shader.set_shader_parameter("green_location", follow.position)
	
	path = $BluePath
	follow = path.get_node("PathFollow2D")
	follow.progress_ratio += delta * speed
	shader.set_shader_parameter("blue_location", follow.position)
	
	var new_rotation = clamp(rotation + delta, 0, 360)
	rotation = new_rotation
