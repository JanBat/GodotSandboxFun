extends Node2D
## a simple makeshift "ParticleEngine" we set up before discovering
## that Godot has its own ParticleEngines. currently used to display
## our "Coin"s as a rotating circle of multiple sprites


## amount of sprites to be drawn
@export
var particle_count = 100


## array to keep track of individual particles
var particles = []


## initialize particles array
func _ready():
	var path: Path2D = get_node("Path2D")
	particles.append(get_node("Path2D/PathFollow2D"))
	for _i in range(particle_count):
		var particle: PathFollow2D = get_node("Path2D/PathFollow2D").duplicate()
		
		path.add_child(particle)
		
		particle.progress_ratio = randf()
		particles.append(particle)
		

## move particles along the predefined path with a little bit of random fluctuation
func _process(delta):
	for p in particles:
		p.progress_ratio += delta * (5 + randf()) / 50
