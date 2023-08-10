extends Control
# -----------------------------------------------------
# Main menu: This houses the title menu. 
#  Start button, options buttion (Work in progress), quit.
#  A score board that saves high score on players device and 
#  loads high score when new game is opened. 
#
# -----------------------------------------------------
# VARIABLES: 
@onready var current_label = $VBoxContainer2/CURRENTSCORELABEL
@onready var highscore_label = $VBoxContainer2/HIGHSCORELABEL
# change with variable that gets length of snake
var current_score = 0

# -----------------------------------------------------
func _ready():
	pass # Replace with function body.
#--------------------------------------------------------
#  BUTTON FUCTIONS ON MAIN MENU
func _on_start_pressed():
	var start_scene = preload("res://scenes/level.tscn").instantiate() #Not in main function because want new game to start only when button pressed
	start_scene.game_over.connect(on_game_over)  #Allows game over function to show handler for creating a new scene
	print("START GAME")
	get_tree().root.add_child(start_scene)
	hide()
	
func _on_options_pressed():
	# NO FUNCTION YET
	pass 

func _on_quit_pressed():
	get_tree().quit()
	print("END GAME")
#---------------------------------------
# SCORE FUNCTIONS: 
#  When back to the main menu this are available to be exicutied 
func print_current_score(score):
	current_label.text = "YOUR SCORE: " + str(score)
	
func print_high_score(score):
	if score >= FileSaveLoad.highest_record:
		#print("check HR " + str(SaveLoad.highest_record))
		FileSaveLoad.highest_record = score
		highscore_label.text = "High Score: " + str(FileSaveLoad.highest_record)
	FileSaveLoad.save_score()

#---------------------------------------
func on_game_over(score):
	print_current_score(score)
	print_high_score(score)
	show()

