extends CanvasLayer

var red = preload("res://Sprites/Scale_Button_UI_Red.png")
var green = preload("res://Sprites/Scale_Button_UI_Green.png")
var yellow = preload("res://Sprites/Scale_Button_UI_Yellow.png")

func _ready():
	
	if !FileAccess.file_exists("user://save.txt"):
		var file = FileAccess.open("user://save.txt", FileAccess.WRITE)
		file.store_string("0000000")
		file = null
	
	var status = load_from_file().split()

	for i in 9:
		if status[i] == "1":
			$Levels.get_child(i).texture_normal = green
			$Levels.get_child(i).texture_pressed = green
			$Levels.get_child(i).texture_hover = green
		elif status[i] == "2":
			$Levels.get_child(i).texture_normal = yellow
			$Levels.get_child(i).texture_pressed = yellow
			$Levels.get_child(i).texture_hover = yellow
		else:
			$Levels.get_child(i).texture_normal = red
			$Levels.get_child(i).texture_pressed = red
			$Levels.get_child(i).texture_hover = red
	

func close():
	get_tree().quit()

func load_from_file():
	var file = FileAccess.open("user://save.txt", FileAccess.READ)
	var content = file.get_as_text()
	file = null
	print(content)
	return content


func open_level(file):
	get_tree().change_scene_to_file(file)

func _on_volume_value_changed(value):
	
	if value <= -10:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	
	
	
