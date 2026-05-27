extends CanvasLayer

class_name GameMain

var red = preload("res://Sprites/Scale_Button_UI_Red.png")
var green = preload("res://Sprites/Scale_Button_UI_Green.png")
var yellow = preload("res://Sprites/Scale_Button_UI_Yellow.png")
var purple = preload("res://Sprites/Scale_Button_UI_Purple.png")
var blue = preload("res://Sprites/Scale_Button_UI_Blue_Select.png")
@onready var status_textures = [red, green, yellow, purple, blue]

@export var ground_settings: Array[GroundSettings] = [
	preload("res://GroundTypes/grass.tres"),
	preload("res://GroundTypes/dull.tres"),
	preload("res://GroundTypes/ice.tres"),
	preload("res://GroundTypes/rubber.tres"),
	preload("res://GroundTypes/glue.tres"),
	preload("res://GroundTypes/kill.tres"),
	preload("res://GroundTypes/boost.tres"),
	preload("res://GroundTypes/cave.tres"),
]

var debug_mode: bool = true
var debug_file: String = "res://ball_path.txt"

@export var main_theme: Theme
var save_data: Dictionary = {}
var level_data: LevelData

@export var fall: bool = false
var grow_button: bool = true
@export var shrink_button: bool = false

var page: int = 0

var level_path: String = "res://Levels/level_drop.tscn"
var level
var level_name: String = ""
var game_ready: bool = false
var starting_level: bool = false

var cheat_codes: Array[Array] = [
	"nerdiscool".to_upper().split(),
	"nerdisdumb".to_upper().split(),
	"pentatonicarpeggio".to_upper().split(),
	"aer".to_upper().split(),
]
var code_idx: Array[int] = []
var cheated: bool = false
var debug: bool = false

var super_mode: bool = false
var super_level: int = 0
var super_run: bool = false
var super_duper_run: bool = false
var super_scale: bool = false

var finish_points: int = 0


#Settings/Accessability

var screen = DisplayServer.WindowMode.WINDOW_MODE_WINDOWED
var comic_text: bool = false

var music_volume: float = 1
var sfx_volume: float = 1

var scale_to_screen: bool = true
var scale_length: float = 0.88#1024
var sticky_scale: bool = false
var scale_step: float = 0.01



func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if FileAccess.file_exists("user://save.txt"):
		#printing the data broke the system
		#print(FileAccess.get_file_as_bytes("user://save.txt"))
		#print(FileAccess.get_file_as_string("user://save.txt"))
		
		var file = FileAccess.open("user://save.txt", FileAccess.READ)
		if file.get_length() > 0:
			save_data = file.get_var()
			#save_data = JSON.parse_string(file.get_var()) as Dictionary
		file.close()
	
	code_idx.resize(cheat_codes.size())
	code_idx.fill(0)
	
	open_page(0)
	
	$AnimationPlayer.play("start")
	
	$Select/PointPath.curve.set_point_position(
		1, 
		$Select/NextPage.position
	)
	
	$Settings.visible = false
	update_settings()
	

func update_settings():
	
	if comic_text: main_theme.default_font = preload("res://UI/Comic Sans MS.ttf")
	else: main_theme.default_font = preload("res://UI/Matemasie-Regular.ttf")
	
	
	_on_music_volume_value_changed($Settings/Settings/Options/Scroll/List/Music/MusicVolume.value)
	_on_sfx_volume_value_changed($Settings/Settings/Options/Scroll/List/SFX/SFXVolume.value)
	
	set_scale_length(scale_length)
	toggle_scale_mode(!scale_to_screen)
	#$Settings/Settings/Options/Scroll/List/ScaleSize/Size.max_value = get_window().size.x
	
	$Settings/Settings/Options/Scroll/List/DisplayMode/Screen.max_value = DisplayServer.get_screen_count()
	

func _input(event: InputEvent) -> void:
	
	if event.is_pressed():#Show all levels if cheat code is inputted
		var letter = event.as_text()
		
		var valid: bool = false
		for code in cheat_codes.size():
			if code_idx[code] < cheat_codes[code].size():
				if letter == cheat_codes[code][code_idx[code]]: code_idx[code] += 1
				elif letter == cheat_codes[code][0]: code_idx[code] = 1
				else: code_idx[code] = 0
				
				if code_idx[code] == cheat_codes[code].size():
					enter_code(code)
					code_idx[code] = 0
					
					
					
		
		
		
	

func enter_code(code: int):
	
	if code == 0:
		for i in $Select/Levels.get_children(): 
				for j in i.get_children():
					j.visible = true
	elif code == 1:
		for i in 12:
			set_level_status(0, i + 1)
		open_page(page)
	elif code == 2:
		#for i in 12:
			#set_level_status(2, i + 1)
		debug = true
		open_page(page)
	elif code == 3:
		if level_path != "": 
			$AnimationPlayer.play("quick")
			await $AnimationPlayer.animation_finished
			#open_level(level_path)
		
	

func quick_save():
	#save_data[level_path] = JSON.stringify(level_data.get_data())
	save_data[level_path] = level_data.get_data()
	
	var file = FileAccess.open("user://save.txt", FileAccess.WRITE)
	#file.store_var(JSON.stringify(save_data))
	file.store_var(save_data)
	file.close()
	

func get_level_status(level: int, on_page: int = -1) -> int:
	if on_page == -1: on_page = page
	
	var file: String = $Select/Levels.get_child(on_page).levels[level]
	
	if !save_data.has(file): return 0
	else: return save_data[file].status
	#else: return JSON.parse_string(save_data[file]).status
	
	

func set_level_status(value: int, level: int, on_page: int = -1):
	if on_page == -1: on_page = page
	
	save_data[$Select/Levels.get_child(on_page).levels[level]].status = value
	

func add_points(amount: int, from_level: int):
	if from_level - 1 < $Select/Levels.get_child_count() and $Select/Levels.get_child(from_level - 1) != null:
		$Select/PointPath.curve.set_point_position(
			0, 
			$Select/Levels.get_child(from_level - 1).position
		)
		
		print("Add", amount)
	

func open_settings():
	$Page.play()
	
	$Settings.visible = true
	$Title.visible = false
	$Select.visible = false
	
	if !scale_to_screen:
		$Settings/Settings/Options/Scroll/List/ScaleSize/Size.max_value = get_window().size.x
		

func close_settings():
	$Page.play()
	
	$Settings.visible = false
	$Title.visible = true
	$Select.visible = true
	

func open_level_info():
	
	if level_data == null: return
	
	$Page.play()
	
	$LevelInfo.visible = true
	$Title.visible = false
	$Select.visible = false
	
	$LevelInfo/Page/Info/List/Text.text = level_data.get_info_text()
	

func close_level_info():
	$Page.play()
	
	$LevelInfo.visible = false
	$Title.visible = true
	$Select.visible = true
	

func next_page():
	if page < $Select/Levels.get_child_count() - 1: open_page(page + 1)
	$Page.play()
	

func last_page():
	if page > 0: open_page(page - 1)
	$Page.play()

func get_points():
	finish_points = 0
	for i in $Select/Levels.get_child_count():
		for j in 12:
			var get_status = get_level_status(j, i)
			if get_status == 1: finish_points += 1
			elif get_status > 1: finish_points += 2

func open_page(new_page: int):
	
	get_points()
	
	$Select/Levels.get_child(page).visible = false
	page = new_page
	
	var this_page = $Select/Levels.get_child(page)
	this_page.visible = true
	
	var gold: int = 0
	for i in 12:
		var set_status = get_level_status(i)
		var set_texture = status_textures[set_status]
		if set_status > 1: 
			gold += 1
		
		this_page.get_child(i).texture_normal = set_texture
		this_page.get_child(i).texture_pressed = set_texture
		this_page.get_child(i).texture_hover = set_texture
		
	
	if debug: gold = 99
	this_page.get_child(9).visible = gold >= 9 or cheated
	this_page.get_child(10).visible = gold >= 9 and get_level_status(9 > 0) or cheated
	this_page.get_child(11).visible = gold >= 9 and get_level_status(10 > 0) or cheated
	
	$Select/Super.visible = gold >= 12
	
	$Select/LastPage.visible = new_page > 0
	$Select/NextPage.visible = new_page < $Select/Levels.get_child_count() - 1
	
	var point_need = (9 * (page + 1)) + (3 * (page))
	$Select/NextPage.disabled = finish_points < point_need and !debug
	$Select/NextPage.tooltip_text = str(finish_points) + "/" + str(point_need)
	
	#end_super()
	

func close():
	get_tree().quit()

func open_level():
	#$Select.visible = false
	#$Title.visible = false
	#$BG.visible = false
	
	var select_idx: int = -1
	for i in $Select/Levels.get_child(page).get_child_count():
		if $Select/Levels.get_child(page).get_child(i).button_pressed:
			select_idx = i
			break
	if select_idx == -1: return
	
	var file: String = $Select/Levels.get_child(page).levels[select_idx]
	
	if starting_level: return
	starting_level = true
	$Music.stop()
	$Button.play()
	game_ready = false
	
	var new_level: bool = !save_data.has(file)
	level_data = LevelData.new()
	if !new_level: level_data.set_data(save_data[file])
	#if !new_level: level_data.set_data(JSON.parse_string(save_data[file]))
	
	
	level_path = file
	level = load(level_path).instantiate()
	get_tree().root.add_child.call_deferred(level)
	
	await level.ready
	$Select/LevelName.text = level_name
	get_tree().paused = true
	$AnimationPlayer.play("open_level")
	
	

func get_level_info(_event: InputEvent, select_idx: int = -1):
	
	if Input.is_action_just_pressed("cancel"):
		
		var file: String = $Select/Levels.get_child(page).levels[select_idx]
		
		var new_level: bool = !save_data.has(file)
		if !new_level:
			level_data = LevelData.new() 
			level_data.set_data(save_data[file])
			#level_data.set_data(JSON.parse_string(save_data[file]))
			open_level_info()
			
		
	

func to_level():
	game_ready = true
	starting_level = false

func back_to_menu():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	quick_save()
	
	level.queue_free()
	$Select.visible = true
	$Title.visible = true
	$BG.visible = true
	open_page(page)
	$Music.play()
	$AnimationPlayer.play("quick")
	
	

func reset_level():
	level.queue_free()
	level = load(level_path).instantiate()
	get_tree().root.add_child.call_deferred(level)

func _process(_delta):
	
	if shrink_button: $Title/Button.scale = $Title/Button.scale.lerp(Vector2(0.9, 0.9), _delta * 5)
	
	if super_mode:
		for i in $Select/Levels.get_child(page).get_children():
			i.visible = false
		$Select/Levels.get_child(page).get_child(super_level).visible = true
		
	
	if game_ready and Input.is_action_just_pressed("action"):
		get_tree().paused = false
		
	
	if Input.is_action_pressed("main"): $AnimationPlayer.speed_scale = 3.0
	else: $AnimationPlayer.speed_scale = 1.0
	
	

func finish_level(level: int = -1, got_scale: bool = false):
	if super_mode: super_level += 1
	


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

func back_to_main_menu():
	$AnimationPlayer.play_backwards("shrink")

func quit_game():
	get_tree().quit()
	


func end_super():
	_on_super_toggled(false)
	$Select/Super.set_pressed_no_signal(false)

func _on_super_toggled(toggled_on: bool) -> void:
	if starting_level: return
	
	super_mode = toggled_on
	super_run = toggled_on
	super_duper_run = toggled_on
	super_level = 0
	super_scale = false
	
	$Select/LastPage.visible = !toggled_on
	$Select/NextPage.visible = !toggled_on
	
	if !super_mode:
		for i in $Select/Levels.get_child(page).get_children():
			i.visible = true
	


func _on_music_volume_value_changed(value: float) -> void:
	
	var slider := $Settings/Settings/Options/Scroll/List/Music/MusicVolume
	var bus: int = AudioServer.get_bus_index("Music")
	
	#AudioServer.set_bus_volume_db(bus, log(value / 10.0) * 80)
	music_volume = value
	AudioServer.set_bus_volume_linear(bus, music_volume)
	AudioServer.set_bus_mute(bus, slider.value == slider.min_value)
	


func _on_sfx_volume_value_changed(value: float) -> void:
	
	var slider := $Settings/Settings/Options/Scroll/List/SFX/SFXVolume
	var bus: int = AudioServer.get_bus_index("SFX")
	
	#AudioServer.set_bus_volume_db(bus, log(value / 10.0) * 80)
	sfx_volume = value
	AudioServer.set_bus_volume_linear(bus, sfx_volume)
	AudioServer.set_bus_mute(bus, slider.value == slider.min_value)
	

func set_scale_length(length: float):
	
	if scale_to_screen:
		scale_length = get_window().size.x * length
	else:
		scale_length = length

func toggle_scale_mode(pixels: bool):
	
	scale_to_screen = pixels
	var screen_width: int = get_window().size.x
	var spin_box: SpinBox = $Settings/Settings/Options/Scroll/List/ScaleSize/Size
	
	if pixels:
		var new_length = scale_length * float(screen_width)
		print(screen_width)
		spin_box.max_value = screen_width
		spin_box.min_value = 64
		spin_box.step = 1.0
		
		scale_length = new_length
		spin_box.set_value_no_signal(scale_length)
		$Settings/Settings/Options/Scroll/List/ScaleSize/ScaleMode.text = "Pixel"
	else:
		var new_length = scale_length / float(screen_width)
		print(new_length)
		spin_box.max_value = 1
		spin_box.min_value = 0.1
		spin_box.step = 0.01
		
		scale_length = new_length
		spin_box.set_value_no_signal(new_length)
		$Settings/Settings/Options/Scroll/List/ScaleSize/ScaleMode.text = "Screen"
	
	#$Settings/Settings/Options/Scroll/List/ScaleSize/Size.value = scale_length
	

func set_display(display: int):
	
	DisplayServer.window_set_current_screen(display)
	

func set_window_mode(mode: int):
	
	match mode:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			
		2: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	
