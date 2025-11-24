extends CanvasLayer

var red = preload("res://Sprites/Scale_Button_UI_Red.png")
var green = preload("res://Sprites/Scale_Button_UI_Green.png")
var yellow = preload("res://Sprites/Scale_Button_UI_Yellow.png")

@export var fall = false
var grow_button = true
@export var shrink_button = false

var cheat_code: Array = "nerdiscool".to_upper().split()
var code_idx: int = 0
var cheated: bool = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	#if true:
		#var file = FileAccess.open("user://save.txt", FileAccess.WRITE)
		#file.store_string("000000000000")
		##sfile.store_string("222222222110")
		#file = null
	
	if !FileAccess.file_exists("user://save.txt"):
		var file = FileAccess.open("user://save.txt", FileAccess.WRITE)
		file.store_string("000000000000")
		file.close()
	
	var status = load_from_file().split()
	print(status)
	for i in status.size():
		if status[i] == "1":
			$Select/Levels.get_child(i).texture_normal = green
			$Select/Levels.get_child(i).texture_pressed = green
			$Select/Levels.get_child(i).texture_hover = green
		elif status[i] == "2":
			$Select/Levels.get_child(i).texture_normal = yellow
			$Select/Levels.get_child(i).texture_pressed = yellow
			$Select/Levels.get_child(i).texture_hover = yellow
		else:
			$Select/Levels.get_child(i).texture_normal = red
			$Select/Levels.get_child(i).texture_pressed = red
			$Select/Levels.get_child(i).texture_hover = red
	
	if Time.get_ticks_msec() < 5000:
		$AnimationPlayer.play("start")
	else:
		$AnimationPlayer.play("quick")
	
	var file_stuff = load_from_file()
	$Select/Levels/Level10.visible = "222222222" in file_stuff
	$Select/Levels/Level11.visible = int(file_stuff[9]) > 0
	$Select/Levels/Level12.visible = int(file_stuff[10]) > 0
	
	$Select/SFX.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	

func _input(event: InputEvent) -> void:
	if event.is_pressed() and !cheated:#Show all levels if cheat code is inputted
		var letter = event.as_text()
		
		if letter == cheat_code[code_idx]: code_idx += 1
		elif letter == cheat_code[0]: code_idx = 1
		else: code_idx = 0
		
		if code_idx == cheat_code.size():
			cheated = true
			
			for i in $Select/Levels.get_children(): i.visible = true
			
		
		
	

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

func _process(_delta):
	if shrink_button: $Title/Button.scale = $Title/Button.scale.lerp(Vector2(0.9, 0.9), _delta * 5)

func _on_volume_value_changed(value):
	
	if value == -20:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
		
	

func deflate():
	if fall and grow_button: $AnimationPlayer.play("deflate")


func inflate():
	if fall and grow_button: $AnimationPlayer.play("inflate")

func grow():
	if fall:
		grow_button = false
		$AnimationPlayer.play("grow")

func shrink():
	fall = false
	#$AnimationPlayer.pause()
	#await get_tree().create_timer(0.25).timeout
	$AnimationPlayer.play("shrink")
