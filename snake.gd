extends Sprite2D

var speed = 200
var direction = Vector2.ZERO

var new_direction: Vector2

func _ready():
	direction.x = speed
	new_direction = direction

func _on_move_timer_timeout():
	direction = new_direction


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
	print(direction)
	print(new_direction)
	position += direction *  delta
