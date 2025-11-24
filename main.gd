extends Node2D

var last_value = 1
var changing = false
var last_change = false
@export var level = 0##Ordering of current level
@export var scales: int = 1

func _ready():
	#save_to_file("000000000000")
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

##Finished a level
func level_complete(time, rot, collect):
	$CanvasLayer/Finish.visible = true#Show menu
	$CanvasLayer/Scale.visible = false#Hide scale bar
	#Display game stats
	$CanvasLayer/Finish/Time.text = "Time: " + str(int(time / 60)) + ":" + str(time % 60)
	$CanvasLayer/Finish/Rotation.text = "Rotations: " + str(rot) + " (" + str(int(rot / 360)) + ")"
	$CanvasLayer/Finish/Collect.text = "Scales: " + str(collect) + "/" + str(scales)
	
	var state = 1#Set level to complete on file
	if collect == scales:#If all scales collected
		state = 2#Set level to gold on file
	write_progress(state)#Write new state to file
	

func load_from_file():##Open file contents
	var file = FileAccess.open("user://save.txt", FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	print(content)
	return content

func save_to_file(content):##Write file contents
	var file = FileAccess.open("user://save.txt", FileAccess.WRITE)
	file.store_string(content)
	file.close()
	
	

func write_progress(state):##Update certain level state on file
	var data = load_from_file().split()
	if (state > int(data[level - 1])):
		data[level - 1] = str(state)
	var new_data = ""
	for i in data:
		new_data += i
	
	#print("New Data: ", new_data)
	#Refresh level display
	save_to_file(new_data)
	load_from_file()
	

func _process(_delta):
	
	#If the slider starts moving, play the sound
	changing = ($CanvasLayer/Scale.value - last_value != 0)
	if changing != last_change and !last_change: $AudioUI.play()
	last_value = $CanvasLayer/Scale.value
	last_change = changing
	

func menu():##Go to menu
	get_tree().change_scene_to_file("res://Levels/select.tscn")

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"): menu()
	

func _on_scale_drag_started():
	$AudioUI.play()
