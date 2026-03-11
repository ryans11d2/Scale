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

@export var fall: bool = false
var grow_button: bool = true
@export var shrink_button: bool = false

var page: int = 0

var level_path: String = "res://Levels/level_pinball.tscn"
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

var super_mode: bool = false
var super_level: int = 0
var super_run: bool = false
var super_duper_run: bool = false
var super_scale: bool = false

var finish_points: int = 0


#Accessability

var comic_text: bool = false

var scale_length: float = 1024

var sticky_scale: bool = false
var scale_step: float = 0.01

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	
	#var files = FileAccess.open("user://save.txt", FileAccess.WRITE)
	#for i in 12 * $Select/Levels.get_child_count():
		#files.store_var(0)
	#files.close()
	#return
	
	if !FileAccess.file_exists("user://save.txt"):
		var file = FileAccess.open("user://save.txt", FileAccess.WRITE)
		for i in 12 * $Select/Levels.get_child_count():
			file.store_var(0)
		file.close()
	
	var validate = FileAccess.open("user://save.txt", FileAccess.READ)
	if validate.get_as_text().length() > 1:
		print("New File")
		validate.close()
		
		var file = FileAccess.open("user://save.txt", FileAccess.WRITE)
		for i in 12 * $Select/Levels.get_child_count():
			file.store_var(0)
		file.close()
		
	else:
		validate.close()
	
	code_idx.resize(cheat_codes.size())
	code_idx.fill(0)
	
	open_page(0)
	
	$AnimationPlayer.play("start")
	
	$Select/SFX.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	
	$Select/PointPath.curve.set_point_position(
		1, 
		$Select/NextPage.position
	)
	
	
	update_settings()
	

func update_settings():
	
	if comic_text: main_theme.default_font = preload("res://UI/Comic Sans MS.ttf")
	else: main_theme.default_font = preload("res://UI/Matemasie-Regular.ttf")
	

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
		for i in 12:
			set_level_status(2, i + 1)
		open_page(page)
	elif code == 3:
		if level_path != "": 
			open_level(level_path)
		
	

func get_level_status(level: int, on_page: int = -1) -> int:
	if on_page == -1: on_page = page
	
	var file = FileAccess.open("user://save.txt", FileAccess.READ)
	#print(((on_page * 12) + level - 1))
	file.seek(((on_page * 12) + level - 1) * 12)
	var status: int = file.get_var()
	file.close()
	
	return status
	

func set_level_status(value: int, level: int, on_page: int = -1):
	if on_page == -1: on_page = page
	
	var file = FileAccess.open("user://save.txt", FileAccess.READ_WRITE)
	file.seek(((on_page * 12) + level - 1) * 12)
	file.store_var(value)
	file.close()
	

func add_points(amount: int, from_level: int):
	if from_level - 1 < $Select/Levels.get_child_count() and $Select/Levels.get_child(from_level - 1) != null:
		$Select/PointPath.curve.set_point_position(
			0, 
			$Select/Levels.get_child(from_level - 1).position
		)
		
		print("Add", amount)
	

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
			var get_status = get_level_status(j, i - 1)
			if get_status == 1: finish_points += 1
			elif get_status >= 1: finish_points += 2

func open_page(new_page: int):
	
	get_points()
	
	$Select/Levels.get_child(page).visible = false
	page = new_page
	
	var this_page = $Select/Levels.get_child(page)
	this_page.visible = true
	
	var gold: int = 0
	for i in 12:
		var set_status = get_level_status(i + 1)
		var set_texture = status_textures[set_status]
		if set_status > 1: 
			gold += 1
		
		this_page.get_child(i).texture_normal = set_texture
		this_page.get_child(i).texture_pressed = set_texture
		this_page.get_child(i).texture_hover = set_texture
		
	
	this_page.get_child(9).visible = gold >= 9 or cheated
	this_page.get_child(10).visible = gold >= 9 and get_level_status(9 > 0) or cheated
	this_page.get_child(11).visible = gold >= 9 and get_level_status(10 > 0) or cheated
	
	$Select/Super.visible = gold >= 12
	
	$Select/LastPage.visible = new_page > 0
	$Select/NextPage.visible = new_page < $Select/Levels.get_child_count() - 1
	
	var point_need = (9 * (page + 1)) + (3 * (page))
	$Select/NextPage.disabled = finish_points < point_need
	$Select/NextPage.tooltip_text = str(finish_points) + "/" + str(point_need)
	
	#end_super()
	

func close():
	get_tree().quit()

func load_from_file():
	var file = FileAccess.open("user://save.txt", FileAccess.READ)
	var content = file.get_as_text()
	file = null
	#print(content)
	return content

func open_level(file: String):
	#$Select.visible = false
	#$Title.visible = false
	#$BG.visible = false
	if starting_level: return
	starting_level = true
	$Music.stop()
	$Button.play()
	game_ready = false
	level_path = file
	level = load(level_path).instantiate()
	get_tree().root.add_child.call_deferred(level)
	await level.ready
	$Select/LevelName.text = level_name
	get_tree().paused = true
	$AnimationPlayer.play("open_level")
	
	

func to_level():
	game_ready = true
	starting_level = false

func back_to_menu():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
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
	
