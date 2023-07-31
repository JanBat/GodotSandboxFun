extends Sprite2D

var speed
var direction

var new_direction: Vector2

@export var next_segment : Sprite2D

func _ready():
	pass

func _process(delta):
	# apply movement
	position += direction * delta
	
	
func update_direction():
	pass
