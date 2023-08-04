class_name Snake extends CharacterBody2D

const SnakeSegment = preload("res://scenes/snake_body_segment.tscn")

signal moved(from: Vector2, to: Vector2)
signal game_over_sig()

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



var last_segment = self

@export var next_segment : Area2D
@export var tile_map: TileMap
@export var grid_location: Vector2

@export var snake_shader: ShaderMaterial


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
	while last_segment.next_segment:
		last_segment.next_segment.connect_move_signal(last_segment.moved)
		last_segment = last_segment.next_segment
		


func _on_move_timer_timeout():
	
	if coins_eaten >= 1:
		var new_last = SnakeSegment.instantiate()
		add_sibling(new_last)
		new_last.position = last_segment.position
		# new_last.next_segment = null
		new_last.connect_move_signal(last_segment.moved)
		last_segment.next_segment = new_last
		last_segment = new_last
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
		
	var shader_pulse = sin($SnackTimer.time_left / $SnackTimer.wait_time * TAU)
	snake_shader.set_shader_parameter("time_progress", shader_pulse)
	snake_shader.set_shader_parameter("red_location", position)
	snake_shader.set_shader_parameter("blue_location", last_segment.position)
	var in_between = (last_segment.position - position) / 2 + position
	snake_shader.set_shader_parameter("green_location", in_between)
	
	

func grid_to_local(coord: Vector2):
	return coord.x * dir_x + coord.y * dir_y
	
func move():
	var old_position = position
	direction = new_direction
	grid_location = grid_location + direction
	position = grid_to_local(grid_location)
	var coll = move_and_collide(Vector2.ZERO)
	if coll:
		# all collisions are fatal
		faint()
		queue_free()
		return
	
	moved.emit(old_position, position)

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


var Coin = load("res://scenes/coin.tscn")

func _on_area_2d_area_entered(area):
	if area.is_in_group("hazard"):
		faint()
		
		
	elif area.is_in_group("coin"):

		coins_eaten += 1
		area.get_gobbled_up()
	else:
		print("unhandled collision!")
	
func faint():
	$MoveTimer.stop()
	var curr = self
	while curr:
		var next = curr.next_segment
		curr.queue_free()
		curr = next
	game_over()

func game_over():
	game_over_sig.emit()
	
