extends Control
## -----------------------------------------------------
## Main menu: This houses the title menu. 
##  Start button, options buttion (Work in progress), quit.
##  A score board that saves high score on players device and 
##  loads high score when new game is opened. 
##
## -----------------------------------------------------
## VARIABLES: 
@onready var current_label = $ScoreContainer/CURRENTSCORELABEL
@onready var highscore_label = $ScoreContainer/HIGHSCORELABEL
# change with variable that gets length of snakeW
var current_score = 0
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
	
func _on_options_pressed():
	if $ScoreContainer.visible:
		$ScoreContainer.hide()
		$Start_Options_Quit/OPTIONS/ColorRect.show()
	else:
		$Start_Options_Quit/OPTIONS/ColorRect.hide()
		$ScoreContainer.show()
		
func _on_soundcheck_toggled(button_pressed):
	sound_on = button_pressed
	print(sound_on)

func _on_quit_pressed():
	get_tree().quit()
	print("END GAME")


##---------------------------------------
## SCORE FUNCTIONS: 
##  When back to the main menu this are available to be exicutied 
func print_current_score(score):
	current_label.text = "YOUR SCORE: " + str(score)
	
func print_high_score(score):
	if score >= FileSaveLoad.highest_record:
		#print("check HR " + str(SaveLoad.highest_record))
		FileSaveLoad.highest_record = score
		highscore_label.text = "High Score: " + str(FileSaveLoad.highest_record)
	FileSaveLoad.save_score()

## game over!
func on_game_over(score):
	print_current_score(score)
	print_high_score(score)
	show()

##---------------------------------------
## SOCIAL MEDIA LINKS: 

func _on_linkedin_pressed():
	OS.shell_open("https://www.linkedin.com/company/github")

func _on_godot_pressed():
	OS.shell_open("https://docs.godotengine.org/en/stable/index.html")

func _on_youtube_pressed():
	OS.shell_open("https://www.youtube.com/c/GodotEngineOfficial")

func _on_github_pressed():
	OS.shell_open("https://github.com/JanBat/GodotSandboxFun")

func _on_reddit_pressed():
	OS.shell_open("https://www.reddit.com/r/godot/")
