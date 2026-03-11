extends Node2D

var last_value = 1
var changing = false
var last_change = false
@export var level = 0##Ordering of current level on it's page
@export var scales: int = 1##Number of scales in level
@export var level_name: String = ""#Level display name

var hud: CanvasLayer

var scaling: bool = false
var dragging: bool = false
var drag_pos: Vector2 = Vector2.ZERO
var slide_pos: float = 0
var drag_value: float = 0


func _ready():
	#save_to_file("000000000000")
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	Select.level_name = level_name
	$Ball/Camera2D.position_smoothing_enabled = true
	
	if get_node_or_null("GameHUD") == null:
		hud = $CanvasLayer
		hud.process_mode = Node.PROCESS_MODE_ALWAYS
		hud.get_node("Scale").connect("drag_ended", _on_scale_drag_ended)
	else:
		hud = $GameHUD
		$GameHUD/Scale.connect("drag_started", _on_scale_drag_started)
		$GameHUD/Scale.connect("drag_ended", _on_scale_drag_ended)
		$GameHUD/Scale.connect("value_changed", $Ball._on_scale_value_changed)
		$GameHUD/Finish/Back.connect("pressed", menu)
		$GameHUD/Reset.connect("pressed", $Ball.reset)
	
	hud.get_node("Scale").step = Select.scale_step
	
	hud.get_node("Reset").grab_focus()
	
	drag_value = hud.get_node("Scale").max_value / hud.get_node("Scale").size.x
	drag_value *= (hud.get_node("Scale").size.x / get_window().size.x)
	
	


func _process(delta):
	
	var scale_start: float = hud.get_node("Scale").value
	var scale_delta: float = hud.get_node("Scale").value
	
	if Input.is_action_just_pressed("main"):
		if !dragging and !scaling: 
			dragging = true
			slide_pos = hud.get_node("Scale").value
		else:
			dragging = scaling
		drag_pos = get_viewport().get_mouse_position()
	
	if dragging and !scaling:
		var drag_delta: float = get_viewport().get_mouse_position().x - drag_pos.x
		scale_delta = slide_pos + (drag_delta * drag_value)
		#prints(slide_pos, slide_pos + (drag_delta * drag_value))
	
	if Input.is_action_pressed("slow_left"):
		scale_delta -= 8 * delta
	if Input.is_action_pressed("med_left"):
		scale_delta -= 16 * delta
	if Input.is_action_pressed("fast_left"):
		scale_delta -= 60 * delta
	
	if Input.is_action_pressed("slow_right"):
		scale_delta += 8 * delta
	if Input.is_action_pressed("med_right"):
		scale_delta += 16 * delta
	if Input.is_action_pressed("fast_right"):
		scale_delta += 60 * delta
	
	if $Ball.no_grow:
		hud.get_node("Scale").value = min(scale_start, scale_delta)
	elif $Ball.no_shrink:
		hud.get_node("Scale").value = max(scale_start, scale_delta)
	elif !$Ball.no_grow and !$Ball.no_shrink:
		hud.get_node("Scale").value = scale_delta
	
	#If the slider starts moving, play the sound
	changing = (hud.get_node("Scale").value - last_value != 0)
	if changing != last_change and !last_change: _on_scale_drag_started()
	last_value = hud.get_node("Scale").value
	last_change = changing
	

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
	hud.get_node("Finish/Back").grab_focus
	
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
	
	var current: int = Select.get_level_status(level)
	if state > current:
		Select.set_level_status(state, level)
		Select.add_points(state - current, level)
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
	


func menu():##Go to menu
	#get_tree().change_scene_to_file("res://select.tscn")
	Select.back_to_menu()
	

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"): menu()
	

func _on_scale_drag_started():
	
	if Input.is_action_just_pressed("main"):
		dragging = true
		scaling = true
		slide_pos = hud.get_node("Scale").value
		print("START")
	
	if get_node_or_null("AudioUI") == null:
		hud.get_node("AudioUI").play()
	else:
		$AudioUI.play()
	

func _on_scale_drag_ended(_value):
	
	if Input.is_action_just_released("main"):
		dragging = Select.sticky_scale
		scaling = false
		print("END")
	
