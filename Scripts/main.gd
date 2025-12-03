extends Node2D

var last_value = 1
var changing = false
var last_change = false
@export var level = 0##Ordering of current level
@export var scales: int = 1
@export var level_name: String = ""

var hud: CanvasLayer

func _ready():
	#save_to_file("000000000000")
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	Select.level_name = level_name
	$Ball/Camera2D.position_smoothing_enabled = true
	
	if get_node_or_null("GameHUD") == null:
		hud = $CanvasLayer
		hud.process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		hud = $GameHUD
		$GameHUD/Scale.connect("drag_started", _on_scale_drag_started)
		$GameHUD/Scale.connect("value_changed", $Ball._on_scale_value_changed)
		$GameHUD/Finish/Back.connect("pressed", menu)
		$GameHUD/Reset.connect("pressed", $Ball.reset)
	

##Finished a level
func level_complete(stats: Array, collect, damaged):
	hud.get_node("Finish").visible = true#Show menu
	hud.get_node("Scale").visible = false#Hide scale bar
	#Display game stats
	hud.get_node("Finish/Time").text = "Time: " + str(int(stats[0] / 60)) + ":" + str(stats[0] % 60)
	hud.get_node("Finish/Rotation").text = "Rotations: " + str(stats[1]) + " (" + str(int(stats[1] / 360)) + ")"
	hud.get_node("Finish/Collect").text = "Scales: " + str(collect) + "/" + str(scales) + "\n"
	hud.get_node("Finish/Collect").text += "Max Roll: " + str(int(stats[2])) + "\n" 
	hud.get_node("Finish/Collect").text += "Max Bounce: " + str(int(stats[3]))# + "\n" 
	
	var state: int = 1#Set level to complete on file
	if collect == scales and !damaged:#If all scales collected
		state = 2#Set level to gold on file
		if Select.super_duper_run:
			state = 4
		elif Select.super_run:
			state = 3
	elif Select.super_run:
		state = 3
		Select.super_duper_run = false
	#write_progress(state)#Write new state to file
	
	if state > Select.get_level_status(level):
		Select.set_level_status(state, level)
	Select.finish_level()
	

func load_from_file():##Open file contents
	var file = FileAccess.open("user://save.txt", FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	#print(content)
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
	changing = (hud.get_node("Scale").value - last_value != 0)
	if changing != last_change and !last_change: _on_scale_drag_started()
	last_value = hud.get_node("Scale").value
	last_change = changing
	

func menu():##Go to menu
	#get_tree().change_scene_to_file("res://select.tscn")
	Select.back_to_menu()
	

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"): menu()
	

func _on_scale_drag_started():
	if get_node_or_null("AudioUI") == null:
		hud.get_node("AudioUI").play()
	else:
		$AudioUI.play()
