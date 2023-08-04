extends Control

func _ready():
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#--------------------------------------------------------
#  BUTTON FUCTIONS ON MAIN MENU
func _on_start_pressed():
	var start_scene = preload("res://scenes/level.tscn").instantiate() #Not in main function because want new game to start only when button pressed
	start_scene.game_over.connect(on_game_over)  #Allows game over function to show handler for creating a new scene
	print("START GAME")
	get_tree().root.add_child(start_scene)
	hide()

func _on_quit_pressed():
	get_tree().quit()
	print("END GAME")
#--------------------------------------------------------
func on_game_over():
	show()
