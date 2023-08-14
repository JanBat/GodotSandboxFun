class_name SnakeSegment extends Area2D
## logical section of the snake 

## signal for the next segment
signal moved(from: Vector2, to: Vector2)

## way the snake went on its last turn
var direction

## way the segment is intending to go on its current turn
var new_direction: Vector2

## next segment down the line
var next_segment : SnakeSegment

## subscribe to movement from prior segments
func _on_previous_moved(from, _to):
	var old_position = position
	position = from
	moved.emit(old_position, position)


## used to initialize the subsegment and have it connected to the previous segment's
## "moved"-signal (snake.gd handles this)
func connect_move_signal(moved_signal):
	moved_signal.connect(_on_previous_moved)
