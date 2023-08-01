extends Node2D


@export
var particle_count = 100

var particles = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var path: Path2D = get_node("Path2D")
	particles.append(get_node("Path2D/PathFollow2D"))
	for _i in range(particle_count):
		var particle: PathFollow2D = get_node("Path2D/PathFollow2D").duplicate()
		
		path.add_child(particle)
		
		particle.progress_ratio = randf()
		particles.append(particle)
		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for p in particles:
		p.progress_ratio += delta * (5 + randf()) / 50
