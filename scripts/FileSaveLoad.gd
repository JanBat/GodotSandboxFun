extends Node
##-------------------------------------------------------------------------
## SAVE to user file on device and Load from file
##  High score value

# VARIABLES: 

## location of the highscore save file.
## reference for where it'll end up depending on OS:
## @tutorial: https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html#accessing-persistent-user-data-user
const saved_file = "user://saved_highscore.dat"
#-------------------------------------------------------------------------

## saves score to disk
func save_score(score):
	var file = FileAccess.open(saved_file, FileAccess.WRITE)
	file.store_32(score)
	file.close()
	
## Obtain the one value of highest_record from saved_file.
func load_score():
	var file = FileAccess.open(saved_file, FileAccess.READ)
	if FileAccess.file_exists(saved_file):
		return file.get_32()
	## no file present yet? create one with score 0
	else:
		file = FileAccess.open(saved_file, FileAccess.WRITE)
		file.store_32(0)
		file.close()
		return 0
	

