extends Control
## -----------------------------------------------------
## Main menu: This houses the title menu. 
##  Start button, options buttion (Work in progress), quit.
##  A score board that saves high score on players device and 
##  loads high score when new game is opened. 
##
## -----------------------------------------------------
## VARIABLES: 

## class import for file I/O
var FileSaveLoad = load("res://scripts/FileSaveLoad.gd").new()

## menu node for displaying last achieved score
@onready var current_label = $ScoreContainer/CURRENTSCORELABEL
## menu node for displaying highest achieved score
@onready var highscore_label = $ScoreContainer/HIGHSCORELABEL

## toggle for playing sound at start of game or not
var sound_on: bool = false


##--------------------------------------------------------
##  BUTTON FUCTIONS ON MAIN MENU:

func _on_start_pressed():
	# show score next time menu is visible
	$Start_Options_Quit/OPTIONS/ColorRect.hide()
	$ScoreContainer.show()
	var start_scene = preload("res://scenes/level.tscn").instantiate() #Not in main function because want new game to start only when button pressed
	start_scene.game_over.connect(on_game_over)  #Allows game over function to show handler for creating a new scene
	get_tree().root.add_child(start_scene)
	start_scene.play_sound(sound_on)
	hide()
	

## handler for button to toggle between options / scoreboard
func _on_options_pressed():
	if $ScoreContainer.visible:
		$ScoreContainer.hide()
		$Start_Options_Quit/OPTIONS/ColorRect.show()
	else:
		$Start_Options_Quit/OPTIONS/ColorRect.hide()
		$ScoreContainer.show()
	
	
## event handler for "sound on/off" checkbox button
func _on_soundcheck_toggled(button_pressed):
	sound_on = button_pressed
	

## end the program
func _on_quit_pressed():
	get_tree().quit()
	print("END GAME")


##---------------------------------------
## SCORE FUNCTIONS: 
##  display current score on the proper label
func print_current_score(score):
	current_label.text = "YOUR SCORE: " + str(score)
	
	
## print score to the "highscore" label, if high enough
func print_high_score(score):
	if score >= FileSaveLoad.load_score():
		highscore_label.text = "High Score: " + str(score)
		FileSaveLoad.save_score(score)

## game over!
func on_game_over(score):
	print_current_score(score)
	print_high_score(score)
	show()
