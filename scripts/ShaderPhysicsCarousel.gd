extends Node2D

@export
var speed = 0.3

@export
var shader: ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
