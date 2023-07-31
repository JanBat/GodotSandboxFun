class_name Snake extends Sprite2D

var speed = 164
var direction_index = 0

var coins_eaten = 0

var new_direction_index = 0

var dir_x: Vector2
var dir_y: Vector2

var clockwise_directions = [
	Vector2(1,0),
	Vector2(0,-1),
	Vector2(-1,0),
	Vector2(0, 1),
]

@export var next_segment : Sprite2D
@export var tile_map: TileMap
@export var grid_location: Vector2

func _ready():
	var size
	if tile_map:
		size = tile_map.tile_set.tile_size
	else:
		size = Vector2(30,30)
		
	dir_x = size / 2.0
	dir_y = Vector2(size.x / 2.0, size.y / -2.0)
	
	# initialize segments
	var next = self
	var start_location = grid_location
#	while next:	
#		next.direction_index = direction_index
#		next.new_direction_index = direction_index
#		next.position = grid_to_local(start_location)
#		start_location -= clockwise_directions[direction_index]
#		next = next.next_segment
	direction_index = direction_index
	new_direction_index = direction_index
	position = grid_to_local(start_location)
	# start_location -= clockwise_directions[direction_index]


func _on_move_timer_timeout():
	grid_location = grid_location + clockwise_directions[new_direction_index]
	direction_index = new_direction_index
	position = grid_to_local(grid_location)
	
func _process(delta):
	if Input.is_action_just_pressed("steer_right"):
		new_direction_index = (direction_index + 1) % clockwise_directions.size()
	if Input.is_action_just_pressed("steer_left"):
		new_direction_index = (direction_index - 1) % clockwise_directions.size()
	if Input.is_action_just_pressed("steer_back"):
		new_direction_index = direction_index
	if Input.is_action_just_pressed("steer_ahead"):
		new_direction_index = direction_index
		
		
func grid_to_local(coord: Vector2):
	return coord.x * dir_x + coord.y * dir_y
	


func _on_snack_timer_timeout():
	coins_eaten += 1
