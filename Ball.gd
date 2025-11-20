extends RigidBody2D

var aer: float = 1
var full = 1
var growth = 0
var contacts = []
var checkpoint = Vector2.ZERO

var finished = false
var dead = false
var time = 0
var total_rotation = 0
var last_rotation = 0
var collect = 0
@export var scales = 1
@onready var ball = preload("res://ball.tres")

@export var bus: StringName = "Master"

var bounce_tone: int = 0
var tone_dir: bool = false

func _ready():
	checkpoint = global_position
	$Audio.bus = bus
	
	

func _physics_process(delta):
	time += delta
	if abs(linear_velocity.length()) < 0.01:
		linear_velocity = Vector2.ZERO
	
	total_rotation += abs(rotation_degrees - last_rotation)
	last_rotation = rotation_degrees
	

func _on_scale_value_changed(value):
	full = value
	#print(value)

func _integrate_forces(state):
	
	ball.radius = aer * 20.0
	$Sprite2D.scale.x = 0.0083 * ball.radius
	$Sprite2D.scale.y = $Sprite2D.scale.x
	mass = aer * 3.0
	physics_material_override.bounce = (10.0 - aer) / 10.0
	
	contacts = []
	if(state.get_contact_count() >= 1): 
		for i in state.get_contact_count():
			contacts.push_front(global_position.direction_to(state.get_contact_local_position(i)) * global_position.distance_to(state.get_contact_local_position(i)))
	
	growth = full - aer
	if growth <= 0:
		growth = 0
	aer = full
	
	for i in contacts:
		linear_velocity += ((-i) * growth)
		growth = 0
	

func reset():
	if !finished:
		if (time <= 1):
			get_tree().change_scene_to_file("res://Levels/select.tscn")
		else:
			get_tree().call_deferred("reload_current_scene")


func _on_body_entered(_body):
	if dead: return
	if abs(linear_velocity.length()) < 8:
		linear_velocity = Vector2.ZERO
	
	if "Spikes" in _body.name and !finished and !dead:
		dead = true
		freeze = true
		$Audio.stream = load("res://Sounds/error_007.ogg")
		$Audio.play()
		await  $Audio.finished
		reset()
	elif "Fan" in _body.name or "Pin" in _body.name:
		$Audio.stream = load("res://Sounds/impactMetal_heavy_002.ogg")
		$Audio.play()
	else:
		grass_sound()

func grass_sound():
	
	var tone: float
	if !tone_dir: tone = bounce_tone
	else: tone = 12 - bounce_tone
	
	
	$Bounce.pitch_scale = pow(2, float(tone) / 12.0 - ((full + 1) / 4.0))
	
	$Bounce.play()
	#prints(tone, tone_dir)
	bounce_tone += 1
	if bounce_tone > 12: 
		bounce_tone = 1
		tone_dir = !tone_dir
	#var sound = randi_range(0, 2)
	#if sound == 0:
		#$Audio.stream = load("res://Sounds/footstep_grass_002.ogg")
	#elif sound == 1:
		#$Audio.stream = load("res://Sounds/footstep_grass_001.ogg")
	#else:
		#$Audio.stream = load("res://Sounds/footstep_carpet_000.ogg")
	#$Audio.play()
	

func _on_area_2d_area_entered(area):
	if "Finish" in area.name and !finished:
		$Audio.stream = preload("res://Sounds/select_005.ogg")
		$Audio.play()
		finished = true
		get_parent().level_complete(int(time), int(total_rotation), collect, scales)
	elif "Collect" in area.name:
		area.queue_free()
		collect += 1
		$Audio.stream = load("res://Sounds/select_005.ogg")
		$Audio.play()
	


func _on_reset_button_down():
	reset()
