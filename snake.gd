class_name Snake extends Area2D

const SnakeSegment = preload("res://snake_body_segment.tscn")

signal moved(from: Vector2, to: Vector2)

var direction: Vector2 = Vector2.ZERO
var new_direction: Vector2 = Vector2.ZERO

var coins_eaten = 0

# grid_to_local (?)
var dir_x: Vector2
var dir_y: Vector2

const SE = Vector2(1,0)
const SW  = Vector2(0,-1)
const NW = Vector2(-1,0)
const NE = Vector2(0, 1)


# these two rotation functions rotate by PI/2
func rotate_counter_clockwise(vector: Vector2):
	return Vector2(
		vector.x * 0 + vector.y * -1,
		vector.x * 1 + vector.y * 0
	)

func rotate_clockwise(vector: Vector2):
	return Vector2(
		vector.x * 0 + vector.y * 1,
		vector.x * -1 + vector.y * 0)

@export var next_segment : Area2D
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
	
	direction = SE
	new_direction = SE
	position = grid_to_local(grid_location)
	
	# set up signals for existing segments:
	var curr = self
	while  curr.next_segment:
		curr.next_segment.connect_move_signal(curr.moved)
		curr = curr.next_segment


func _on_move_timer_timeout():
	
	if coins_eaten:
		var old_last = last_segment()
		var new_last = SnakeSegment.instantiate()
		add_sibling(new_last)
		new_last.position = old_last.position
		# new_last.next_segment = null
		new_last.connect_move_signal(old_last.moved)
		old_last.next_segment = new_last
		coins_eaten -= 1
	
	move()
	

func _process(_delta):
	if Input.is_action_just_pressed("steer_right"):
		new_direction = rotate_clockwise(direction)
	if Input.is_action_just_pressed("steer_left"):
		new_direction = rotate_counter_clockwise(direction)
	if Input.is_action_just_pressed("steer_back"):
		new_direction = direction
	if Input.is_action_just_pressed("steer_ahead"):
		new_direction = direction
	

func grid_to_local(coord: Vector2):
	return coord.x * dir_x + coord.y * dir_y
	
	
func _on_snack_timer_timeout():
	coins_eaten += 1
	
func move():
	var old_position = position
	grid_location = grid_location + direction
	direction = new_direction
	position = grid_to_local(grid_location)
	moved.emit(old_position, position)
	
func last_segment():
	var curr = self
	while curr.next_segment:
		curr = curr.next_segment
	return curr
