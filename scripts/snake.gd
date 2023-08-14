class_name Snake extends CharacterBody2D
## Head segment of the titular Snake that is responding to player input


## notify downstream segments of position change
signal moved(from: Vector2, to: Vector2)
## notify level of game over condition being met
signal game_over_sig(score: int)
## notify AudioPlayer of speed change
signal speed_changed(new_factor: float)

## non-controlled snake segments are managed by this simplified class
const SnakeSegment = preload("res://scenes/snake_body_segment.tscn")

## 1 step of the snake on every other beat (150bpm base)
const base_speed: float = 60.0 / 150.0 * 2 

## how many shaded segments per logical segment
const subsegments_per_segment = 4

## how far do the dots (cells) stray from the center of segments
## this is for providing persistent orientation coordinates for the
## snake shader
const polkadots_within_radius = 15.0

## how many dots/cells per shaded subsegment
const dots_per_segment = 1

## grace period before starting to increase difficulty (speed)
const min_snake_length_for_difficulty_increase: int = 10

## the TileMap our intrepid Snake travels on
@export var tile_map: TileMap
## Reference to the Shader material rendering our Snake, used for passing uniforms
@export var snake_shader: ShaderMaterial

## direction the snake has gone towards on its last turn
var direction: Vector2i = Vector2.ZERO
## direction the snake is set to go towards on its current turn
var new_direction: Vector2i = Vector2.ZERO

## keeps track of coins that have been eaten, but not yet turned into a new body segment
var coins_eaten: int = 1  # snake with length 1 looks a bit glitchy, so let's have it start out at length 2

# last_segment and snake_length are updated with each snake segment added
## keeps track of the last segment of the snake; needed for adding new ones
var last_segment = self
## amount of segments in the snake, including this Head Segment
var snake_length: int = 1

## next downstream segment of the snake
var next_segment : Area2D

## snake location on the Tilemap
var grid_location: Vector2i

## keeps track of how far along individual snake subsegments
## should be rendered along their section of the Path2D describing the Snake
var custom_animation_progress: float = 0.0

## speed affects the time in between Snake movement ticks
## and Soundtrack playback speed
var speed :float :
	get:
		return speed
	set(value):
		speed = value
		$MoveTimer.wait_time = value * base_speed
		speed_changed.emit(value)


## ensures position conforms to the provided TileMap
## sets initial direction to South-East
## adds a first set of visual subsegments
func _ready():
	# snap position to grid
	speed = 1.0
	grid_location = tile_map.local_to_map(position)
	position = tile_map.map_to_local(grid_location)
	
	const SE = Vector2(1,0)
	direction = SE
	new_direction = SE

	add_segment()

## processes input, updates position and rendering parameters
func _process(delta):
	if Input.is_action_just_pressed("steer_right"):
		new_direction = rotate_clockwise(direction)
	if Input.is_action_just_pressed("steer_left"):
		new_direction = rotate_counter_clockwise(direction)
	if Input.is_action_just_pressed("steer_back"):
		new_direction = direction
	if Input.is_action_just_pressed("steer_ahead"):
		new_direction = direction
	
	# advance the rendered subsegments along their path:
	custom_animation_progress += delta
	# something's still glitchy here. alternative version:
	# custom_animation_progress = ($MoveTimer.wait_time - $MoveTimer.time_left) / $MoveTimer.wait_time
	
	# update the path that the rendered subsegments follow along
	update_path()
	process_path()
	

## handles collision with hazards (trees and the snake itself)
## and coins
func _on_area_2d_area_entered(area):
	if area.is_in_group("hazard"):
		faint()
		
	elif area.is_in_group("coin"):
		coins_eaten += 1
		area.get_gobbled_up()
		
	else:
		print("unhandled collision!")
	

## MoveTimer enforces the rhythm of the snake movement
## when it times out, we move the snake!
func _on_move_timer_timeout():
	# create new snake segment
	if coins_eaten >= 1:
		create_new_snake_segment()
	move()
	
## creates both a logical and a visual new section for the snake
func create_new_snake_segment():
	var new_last = SnakeSegment.instantiate()
	add_sibling(new_last)
	new_last.position = last_segment.position
	new_last.connect_move_signal(last_segment.moved)
	last_segment.next_segment = new_last
	last_segment = new_last
	snake_length += 1
	coins_eaten -= 1
	add_segment()
	# after picking up the first few coins, gradually increse difficulty:
	if snake_length >= min_snake_length_for_difficulty_increase:
		speed *= 0.99 
	
	
## adjust snake position by the scheduled new_direction
## check for collisions with the tilemap 
func move():
	var old_position = position
	direction = new_direction
	grid_location = grid_location + direction
	position = tile_map.map_to_local(grid_location)
	for layer in range(1):
		var t = tile_map.get_cell_tile_data(layer, grid_location)
		if t:
			break
		# else if no tile has been found, triggering a break:
		faint()
		
	# since we couldn't find a a way to directly access the signal emitters
	# of individual tilemap-cells, 
	# we're scanning for the collision manually here:
	var coll = move_and_collide(Vector2.ZERO)
	if coll:
		# all collisions are fatal
		faint()
		return
	
	moved.emit(old_position, position)
	
	custom_animation_progress = 0.0
	update_path()
	process_path()


## rotate Vector2 by PI/2 clockwise
func rotate_clockwise(vector: Vector2):
	return Vector2(
		vector.x * 0 + vector.y * -1,
		vector.x * 1 + vector.y * 0
	)


## rotate Vector2 by PI/2 counterclockwise
func rotate_counter_clockwise(vector: Vector2):
	return Vector2(
		vector.x * 0 + vector.y * 1,
		vector.x * -1 + vector.y * 0)


## this gets called when the snake finds itself 
## in a pickle and wants to sign off for the day
func faint():
	$MoveTimer.stop()
	# subtract 2 from score for initial snake length
	game_over_sig.emit(snake_length-2)


## intended to be called during _process(), 
## this function updates all the PathFollow2D nodes
## following along $SubSegmentPath to create a visual 
## of a (somewhat) gradually moving snake on top of the 
## logical snake segments that only update their position 
## once in a $MoveTimer-timeout
func process_path():
	var sub_segments = $SubSegmentPath.get_children()
	for segment_index in sub_segments.size():
		var segment = sub_segments[segment_index]
		
		segment.progress_ratio = 1 - (float(segment_index) / (float(len(sub_segments) + subsegments_per_segment)) \
							+ custom_animation_progress / (float(len(sub_segments))/subsegments_per_segment))
							# alternative form that's smoother but occasionally glitches:
							# + ($MoveTimer.wait_time - $MoveTimer.time_left) / $MoveTimer.wait_time / (float(len(sub_segments))/subsegments_per_segment))
							
		# so the pathfollow still rotates but its graphic appears upright
		segment.get_node("SubSegmentGraphic").rotation = - segment.rotation
		# segment.rotation = 0
	
		
	# alert shader to polakadot positions
	var dots = []
	for follow in $SubSegmentPath.get_children():
		var screen_coord = get_viewport().get_screen_transform() * follow.get_global_transform_with_canvas()
		# dots.append(screen_coord.origin)
		for d in follow.polkadots:
			dots.append(screen_coord.origin + d)
	snake_shader.set_shader_parameter("dots", dots)
	
	
## add a set of sprites to follow along $SubSegmentPath
## these are purely visual in nature
func add_segment():
	var path: Path2D = $SubSegmentPath
	for i in range(subsegments_per_segment):
		var segment = $SubSegmentPath/SubSegmentFollow.duplicate()
		# segment.show()
		path.add_child(segment)
		
		# give segment 3 random polkadots:
		
		var polkadots = []
		for j in range(dots_per_segment):
			var dot = Vector2(
				randf_range(-polkadots_within_radius, polkadots_within_radius), 
				randf_range(-polkadots_within_radius, polkadots_within_radius))
			polkadots.append(dot)
		segment.polkadots = polkadots


## updates the $SubSegmentPath to conform to the logical positions of the snake on the tilemap
## and its subsequent segments
func update_path():
	var path: Path2D = $SubSegmentPath
	var curve: Curve2D = path.get_curve()
	curve.clear_points()
	#if snake_length > 1:
	curve.add_point(tile_map.map_to_local(grid_location + new_direction) - self.position)
	var curr = self
	while curr:
		curve.add_point(curr.position - self.position)
		curr = curr.next_segment
