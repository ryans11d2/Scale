extends Node2D

var last_value = 1
var changing = false
var last_change = false
@export var level = 0

func level_complete(time, rot, collect, scales):
	$CanvasLayer/Finish.visible = true
	$CanvasLayer/Scale.visible = false
	$CanvasLayer/Finish/Time.text = "Time: " + str(int(time / 60)) + ":" + str(time % 60)
	$CanvasLayer/Finish/Rotation.text = "Rotations: " + str(rot) + " (" + str(int(rot / 360)) + ")"
	$CanvasLayer/Finish/Collect.text = "Scales: " + str(collect) + "/" + str(scales)
	
	var state = 1
	if collect == scales:
		state = 2
	
	write_progress(state)
	

func load_from_file():
	var file = FileAccess.open("user://save.txt", FileAccess.READ)
	var content = file.get_as_text()
	file = null
	print(content)
	return content

func save_to_file(content):
	var file = FileAccess.open("user://save.txt", FileAccess.WRITE)
	file.store_string(content)
	file = null
	
	

func write_progress(state):
	var data = load_from_file().split()
	if (state > int(data[level - 1])):
		data[level - 1] = str(state)
	var new_data = ""
	for i in data:
		new_data += i
	#$CanvasLayer/Finish/Collect.text = new_data
	save_to_file(new_data)
	load_from_file()

func _process(_delta):
	changing = ($CanvasLayer/Scale.value - last_value != 0)
	if changing != last_change and !last_change:
		$AudioUI.play()
	last_value = $CanvasLayer/Scale.value
	last_change = changing
	

func menu():
	get_tree().change_scene_to_file("res://Levels/select.tscn")

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		menu()

func _on_scale_drag_started():
	$AudioUI.play()

