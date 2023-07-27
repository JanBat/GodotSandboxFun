extends Sprite2D

var speed = 164
var direction = Vector2.ZERO

var new_direction: Vector2

@export var next_segment : Sprite2D

func _ready():
	direction.x = speed
	new_direction = direction
	var next = next_segment
	
	# recursively initialize all lower segments
	while next:
		next.direction = direction
		next.speed = speed
		next = next.next_segment

func _on_move_timer_timeout():
	var next = self
	while next:
		if next.next_segment:
			next.next_segment.new_direction = next.direction
		next.direction = next.new_direction
		next = next.next_segment
	
func _process(delta):
	if Input.is_action_just_pressed("steer_right"):
		new_direction = direction.rotated(PI / 2)
		# TODO: this may eventually cause float imprecision errors - lock
		# onto fixed fractions of PI instead?
	if Input.is_action_just_pressed("steer_left"):
		new_direction = direction.rotated(-PI / 2)
	if Input.is_action_just_pressed("keep_going_straight"):
		new_direction = direction
	# apply movement
	position += direction * delta
