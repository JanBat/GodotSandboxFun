class_name Snake extends CharacterBody2D

const SnakeSegment = preload("res://scenes/snake_body_segment.tscn")

signal moved(from: Vector2, to: Vector2)
signal camera_suggestion(pos: Vector2)
signal game_over_sig(score)

var direction: Vector2 = Vector2.ZERO
var new_direction: Vector2 = Vector2.ZERO

var coins_eaten = 1

const SE = Vector2(1,0)
# not actually correct
#const SW  = Vector2(0,1)
#const NW = Vector2(-1,0)
#const NE = Vector2(0,-1)



var last_segment = self
var snake_length = 1

# how many shaded segments for logical segment
@export
var subsegments_per_segment = 4


# how far do the dots stray from the center of segments
@export
var polkadots_within_radius = 15.0

# how many dots per shaded segment
@export
var dots_per_segment = 1

var time_to_move = false

@export var next_segment : Area2D
@export var tile_map: TileMap
@export var grid_location: Vector2

@export var snake_shader: ShaderMaterial

var custom_animation_progress: float = 0.0

func _ready():
	
	# initialize segments
	direction = SE
	new_direction = SE
	position = tile_map.map_to_local(grid_location)
	
	# set up signals for existing segments:
	while last_segment.next_segment:
		last_segment.next_segment.connect_move_signal(last_segment.moved)
		last_segment = last_segment.next_segment

	add_segment()
	# update_path()


func _on_move_timer_timeout():
	time_to_move = true
	

func _process(delta):
	if Input.is_action_just_pressed("steer_right"):
		new_direction = rotate_clockwise(direction)
	if Input.is_action_just_pressed("steer_left"):
		new_direction = rotate_counter_clockwise(direction)
	if Input.is_action_just_pressed("steer_back"):
		new_direction = direction
	if Input.is_action_just_pressed("steer_ahead"):
		new_direction = direction
	
	custom_animation_progress += delta #/ $MoveTimer.wait_time
	
	if time_to_move:
		if coins_eaten >= 1:
			var new_last = SnakeSegment.instantiate()
			add_sibling(new_last)
			new_last.position = last_segment.position
			new_last.connect_move_signal(last_segment.moved)
			last_segment.next_segment = new_last
			last_segment = new_last
			snake_length += 1
			coins_eaten -= 1
			add_segment()
		
		move()
		custom_animation_progress = 0.0
		time_to_move = false
	
	update_path()
	process_path()

func move():
	var old_position = position
	direction = new_direction
	grid_location = grid_location + direction
	position = tile_map.map_to_local(grid_location)
	if not tile_map.get_cell_tile_data(0, grid_location):
		faint()
		
	var coll = move_and_collide(Vector2.ZERO)
	if coll:
		# all collisions are fatal
		faint()
		queue_free()
		return
	
	moved.emit(old_position, position)

# these two rotation functions rotate by PI/2
func rotate_clockwise(vector: Vector2):
	return Vector2(
		vector.x * 0 + vector.y * -1,
		vector.x * 1 + vector.y * 0
	)

func rotate_counter_clockwise(vector: Vector2):
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
	game_over_sig.emit(snake_length)


func process_path():
	var sub_segments = $SubSegmentPath.get_children()
	for segment_index in sub_segments.size():
		var segment = sub_segments[segment_index]
		
		segment.progress_ratio = 1 - (float(segment_index) / (float(len(sub_segments) + subsegments_per_segment)) \
							+ custom_animation_progress / (float(len(sub_segments))/subsegments_per_segment))
		
							
		# so the pathfollow still rotates but its graphic appears upright
		segment.get_node("SubSegmentGraphic").rotation = - segment.rotation
		# segment.rotation = 0
	
	if sub_segments:
		camera_suggestion.emit(position + sub_segments[len(sub_segments)-1].position)
	else:  # at the beginning when no segments are present
		camera_suggestion.emit(position)
		
	# alert shader to polakadot positions
	var dots = []
	for follow in $SubSegmentPath.get_children():
		var screen_coord = get_viewport().get_screen_transform() * follow.get_global_transform_with_canvas()
		# dots.append(screen_coord.origin)
		for d in follow.polkadots:
			dots.append(screen_coord.origin + d)
	snake_shader.set_shader_parameter("dots", dots)
	
	
		
func add_segment():
	var path: Path2D = $SubSegmentPath
	for i in range(subsegments_per_segment):
		var segment = $SubSegmentFollow.duplicate()
		segment.show()
		path.add_child(segment)
		
		# give segment 3 random polkadots:
		
		var polkadots = []
		for j in range(dots_per_segment):
			var dot = Vector2(
				randf_range(-polkadots_within_radius, polkadots_within_radius), 
				randf_range(-polkadots_within_radius, polkadots_within_radius))
			polkadots.append(dot)
		segment.polkadots = polkadots

func update_path():
	var path: Path2D = $SubSegmentPath
	var curve: Curve2D = path.get_curve()
	curve.clear_points()
	if snake_length > 1:
		curve.add_point(tile_map.map_to_local(grid_location + new_direction) - self.position)
	var curr = self
	while curr:
		curve.add_point(curr.position - self.position)
		curr = curr.next_segment
