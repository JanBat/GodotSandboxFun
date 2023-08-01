class_name SnakeSegment extends Sprite2D

signal moved(from: Vector2, to: Vector2)

var direction
var direction_index
var new_direction_index

var new_direction: Vector2

@export var next_segment : Sprite2D

func _init():
	scale = Vector2(0.2, 0.2)
	texture = load("res://art/boxCoinAlt.png")

func _ready():
	pass

func _process(_delta):
	# apply movement
	pass
	
	
func update_direction():
	pass


# subscribe to movement from prior segments
func _on_previous_moved(from, _to):
	var old_position = position
	position = from
	moved.emit(old_position, position)


func connect_move_signal(moved_signal):
	moved_signal.connect(_on_previous_moved)
