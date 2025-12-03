extends RigidBody2D

var aer: float = 1##Current Scale
var full: float = 1##Target Scale
var growth:float = 0##Change in scale since last physics
var contacts = []##Overlap amount with physics bodies
var stuck: bool = false##Is on a sticky surface
var ground_dir: Vector2 = Vector2.ZERO
var ground_pos: Vector2 = Vector2.ZERO
var in_ground: int = 0
var max_speed: float = 24000

var finished: bool = false##Is flag reached
var dead: bool = false##Is ball dead
var time: float = 0##Time elapsed
var total_rotation: float = 0##Sum off degrees rotated
var last_rotation: float = 0##Rotation last update
var max_spin: float = 0##Highest angular velocity
var jump_start: float = 0##Jump start point
var jump_height: float = 0##Height of jump
var max_jump: float = 0##Highest jump

var collect: int = 0##Scales collected
var damaged: bool = false##Has been damaged this game

var invulnerable: float = 0
var power: bool = false##Scale power active (shield and dash)
@export var power_shield: bool = false## Shield power
@export var power_force: bool = false## Force power

@onready var ball = preload("res://ball.tres")##Collision circle object
@export var bus: StringName = "Master"##Name of audio bus to use

var bounce_tone: int = 0##What note to play on bounce
var tone_dir: bool = false##Shift tone up or down on bounce

@export var trail_length: int = 24##Number of sprites in trail
@export var trail_lag: float = 0.02##Trail update intercal
@onready var trail: Node2D = $Offsets##Trail parent object
var trail_lag_time: float = 0##Timer to update trail

func _ready():
	$Audio.bus = bus
	
	for i in trail_length:#Make trail
		var new_trail = $Sprite2D.duplicate(0)
		new_trail.scale = Vector2.ONE
		var alph = float(trail_length - i) / float(trail_length)
		new_trail.modulate = Color(1, 0.686, 0.996, 0.5 * alph)
		trail.add_child.call_deferred(new_trail)
	trail.reparent.call_deferred(get_parent())
	
	if power_force:
		angular_damp = 0.25
		trail.visible = true
	if power_shield:
		modulate = Color(1, 0.686, 0.996)
		trail.modulate = Color(1, 0.686, 0.996)
	
	if Select.super_run and Select.super_scale:
		power = true
		angular_damp = 0.25
		trail.visible = true
		modulate = Color(1, 0.686, 0.996)
		trail.modulate = Color(1, 0.686, 0.996)
	

func _physics_process(delta):
	time += delta
	if invulnerable > 0: invulnerable = clamp(invulnerable - delta, 0, invulnerable)
	
	#Stop if too slow
	#if linear_velocity.length() < 0.01:
	#	linear_velocity = Vector2.ZERO
	
	#Count rotations
	total_rotation += abs(rotation_degrees - last_rotation)
	last_rotation = rotation_degrees
	
	#Set trail sprites
	trail_lag_time -= delta
	if trail_lag_time <= 0 and (power or power_force) and trail.get_child_count() > 0:
		trail_lag_time = trail_lag
		trail.get_child(0).global_position = global_position
		trail.get_child(0).global_rotation = global_rotation
		trail.get_child(0).scale = Vector2($Sprite2D.scale.x, $Sprite2D.scale.x)
		for i in trail.get_child_count():
			var idx = (trail_length - i) - 1
			if idx > 0: 
				trail.get_child(idx).global_position = trail.get_child(idx - 1).global_position
				trail.get_child(idx).global_rotation = trail.get_child(idx - 1).global_rotation
				trail.get_child(idx).scale = trail.get_child(idx - 1).scale
		
	
	if angular_velocity > max_spin: max_spin = angular_velocity
	if linear_velocity.length() > max_speed:
		print("MAX SPEED")
		linear_velocity = linear_velocity.normalized() * max_speed
	

func _on_scale_value_changed(value):
	full = value
	#print(value)

func _integrate_forces(state):
	
	ball.radius = aer * 20.0# Set ball size
	$Sprite2D.scale.x = 0.0083 * ball.radius
	$Sprite2D.scale.y = $Sprite2D.scale.x
	mass = aer * 3.0# Set ball mass 
	physics_material_override.bounce = (10.0 - aer) / 10.0# Set ball bounce
	
	#Get overlapping colliders
	contacts = []
	if(state.get_contact_count() >= 1): 
		in_ground += 1
		ground_dir = -state.get_contact_local_normal(0)
		ground_pos = state.get_contact_collider_position(0)
		jump_start = global_position.y
		for i in state.get_contact_count():
			var i_pos = state.get_contact_local_position(i)
			var new_contact = global_position.direction_to(i_pos) * global_position.distance_to(i_pos)
			contacts.push_front(new_contact)
	else:
		in_ground = 0
		jump_height = global_position.y - jump_start
		if jump_height > max_jump: max_jump = jump_height
	
	growth = full - aer#Set growth, change in scale since last update
	if growth < 0:
		if stuck:
			var dist = global_position.distance_to(ground_pos) - ball.radius
			global_position += ground_dir * dist
		growth = 0
	aer = full#Set scale to match set value
	
	
	
	#Apply velocity away from overlap
	if contacts.size() > 0:
		#if growth > 0: print(linear_velocity.length())
		var push_force: Vector2 = Vector2.ZERO
		for i in contacts:
			push_force += i
		push_force /= float(contacts.size())
		linear_velocity -= push_force * growth
		
	
	
	stuck = false
	for i in state.get_contact_count():
		var ground = state.get_contact_collider_object(i)
		if ground is Ground:
			if ground.type == ground.ground_type.STICK:
				stuck = true
				var dir: Vector2 = -state.get_contact_local_normal(i)
				var along: float = linear_velocity.dot(dir)
				var reduce: Vector2 = dir * along
				linear_velocity -= reduce * 1.9
			elif ground.type == ground.ground_type.BOUNCE:
				var dir = state.get_contact_local_normal(i)
				linear_velocity += dir * (350.0 / ((mass - 2.5) * 2))
			elif ground.type == ground.ground_type.KILL:
				damage(state.get_contact_local_normal(i))
			
	#print(linear_velocity.length())
	

func damage(dir: Vector2 = Vector2.ZERO):
	
	if !finished and !dead and invulnerable == 0:
		
		damaged = true
		if power or power_shield:#Remove shield
			
			if power: #Lose scale
				collect -= 1
				angular_damp = 0.8
				apply_impulse(dir * (150 + 100 * (aer / 2.0)))
				trail.visible = false
			
			invulnerable = 0.2
			
			power = false
			power_shield = false
			
			#Visual Changes
			modulate = Color.WHITE
			trail.modulate = Color.WHITE
			
			#Damage Sound
			$Collect.play()
			
		else:#No Shield
			dead = true# dead
			set_deferred("freeze", true)# freeze physics
			
			#Play dead sound
			$Damage.play()
			await  $Damage.finished
			reset()# Reset after sound
			
		
	

func reset():
	if !finished:#Hasn't won
		if (time <= 1) or Select.super_run:#If only 1 second has passed, return to menu
			if Select.super_run and !finished: Select.end_super()
			Select.back_to_menu()
		else:#Reload level
			Select.reset_level()


func _on_body_entered(_body):
	if dead: return#Don't trigger a bunch of times
	
	#Stop if too slow on ground
	#if abs(linear_velocity.length()) < 8:
	#	linear_velocity = Vector2.ZERO
	
	if "Spikes" in _body.name:#Hit a spike
		damage(Vector2.RIGHT.rotated(_body.rotation))
	elif "Pin" in _body.name:#Hit pin
		#Apply force to hit object
		#prints(linear_velocity, mass, linear_velocity * mass)
		if power or power_force: _body.apply_impulse(linear_velocity * mass * 1.7)
		#else: _body.apply_impulse(linear_velocity * mass)
	elif "Fan" in _body.name:# Hit fan
		#Play metal sound
		$Audio.stream = load("res://Sounds/impactMetal_heavy_002.ogg")
		$Audio.play()
	else:#Hit ground
		grass_sound()#Play ground sound

func grass_sound():## Play tone adjusted ground hit
	if stuck: return
	#Set note based on tone direction
	var tone: float
	if !tone_dir: tone = bounce_tone
	else: tone = 12 - bounce_tone
	
	#Set tone of bounce sound to note 
	$Bounce.pitch_scale = pow(2, float(tone) / 12.0 - ((full + 1) / 4.0))
	
	$Bounce.play()#Play bounce sound
	
	#Incriment note, wrap around after full scale
	bounce_tone += 1
	if bounce_tone > 12: 
		bounce_tone = 1
		tone_dir = !tone_dir
	

func _on_area_2d_area_entered(area):
	if "Finish" in area.name and !finished:#Hit finish flag
		$Collect.play()#Play sound
		finished = true
		#Trigger level complete function
		var stats = [int(time), int(total_rotation), max_spin, max_jump]
		if Select.super_run and power: Select.super_scale = true
		get_parent().level_complete(stats, collect, damaged)
		
	elif "Collect" in area.name:#Hit scale
		
		area.queue_free()#Remove scale
		collect += 1#Add to scale count
		
		$Collect.play()#Play sound
		
		#Activate scale power (dash and shield)
		power = true
		angular_damp = 0.25
		modulate = Color(1, 0.686, 0.996)
		trail.visible = true
		trail.modulate = Color(1, 0.686, 0.996)
	


func _on_reset_button_down():#Reset button
	reset()
