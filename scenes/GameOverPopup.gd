extends Control

signal game_end(score)
## holds the score to pass on later
var score: int

## show up when snake triggers game over state
func _on_snake_game_over_sig(score, snake_position):
	position =  snake_position
	$Score.text = "Your Score:" + str(score)
	get_node("../AudioStreamPlayer").stop()
	show()


func _on_back_to_menu_pressed():
	game_end.emit(score)
