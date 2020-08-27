extends KinematicBody

var wall_normal
var speed
var default_move_speed = 10
var crouch_speed = 20
var crouch_move_speed = 3
var default_hieght = 1.5
var crouch_height = 0.5
var acceleration = 10
var gravity = 0.08
var jump = 10

var damage = 100

var mouse_sensitivity = 0.1

var w_runable = false
var grabling = false

var current_weapon = 1


var direction = Vector3()
var velocity = Vector3()
var fall = Vector3() 
var hookpoint = Vector3(1,1,1)
var hookpoint_get = false

onready var pcap = $CollisionShape
onready var mp7_shot = $Head/Hand/MP7/MP7_shot
onready var aimcast = $Head/Camera/AimCast
onready var head = $Head
onready var gun1 = $Head/Hand/MP7
onready var gun2 = $"Head/Hand/Gun 2"
onready var timer = $Timer
onready var GrableCast = $Head/Camera/GrableCast



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity)) 
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity)) 
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))
		
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				if current_weapon < 2:
					current_weapon += 1
				else:
					current_weapon = 1
			elif event.button_index == BUTTON_WHEEL_DOWN:
				if current_weapon > 1:
					current_weapon -= 1
				else:
					current_weapon = 2

func wall_run():
	if w_runable:
		if Input.is_action_pressed("jump"):
			if Input.is_action_pressed("move_forward"):
					if is_on_wall():
						wall_normal = get_slide_collision(0)
						yield(get_tree().create_timer(0.2), "timeout")
						fall.y = 0
						direction = -wall_normal.normal * speed

func weapon_select():
	
	if Input.is_action_just_pressed("weapon1"):
		current_weapon = 1
	elif Input.is_action_just_pressed("weapon2"):
		current_weapon = 2
		
	if current_weapon == 1:
		gun1.visible = true
	else:
		gun1.visible = false

	if current_weapon == 2:
		gun2.visible = true
	else:
		gun2.visible = false
		
		
		
func grablle():
	if Input.is_action_just_pressed("grab"):
		if GrableCast.is_colliding():
			if not grabling:
				grabling = true
	if grabling:
		fall.y = 0
		if not hookpoint_get:
			hookpoint = GrableCast.get_collision_point()
			hookpoint_get = true
		if hookpoint.direction_to(transform.origin) > 1:
			if hookpoint_get:
				transform.origin = lerp(transform.origin, hookpoint, 0.05)
		else:
			grabling = false
			hookpoint_get = false
	
	
func _physics_process(delta):
	
	speed = default_move_speed
	
	wall_run()
	
	weapon_select()
	
	grablle()
	
	direction = Vector3()
	
	move_and_slide(fall, Vector3.UP)
	
	if not is_on_floor():
		fall.y -= gravity
	else:
		w_runable = false
		
	if Input.is_action_just_pressed("fire"):
		if current_weapon == 1:
			mp7_shot.play()
		if aimcast.is_colliding():
			var target = aimcast.get_collider()
			if target.is_in_group("enemy"):
				target.health -= damage
				print("enemy hit")
				
	if Input.is_action_just_pressed("jump") and is_on_floor():
		fall.y = jump
		w_runable = true
		timer.start()
		
	if Input.is_action_pressed("crouch"):
		pcap.shape.height -= crouch_speed * delta
		speed = crouch_move_speed
	else:
		pcap.shape.height += crouch_speed * delta
	pcap.shape.height = clamp(pcap.shape.height, crouch_height, default_hieght)
	
	if Input.is_action_pressed("move_forward"):
	
		direction -= transform.basis.z
	
	elif Input.is_action_pressed("move_backward"):
		
		direction += transform.basis.z
		
	if Input.is_action_pressed("move_left"):
		
		direction -= transform.basis.x			
		
	elif Input.is_action_pressed("move_right"):
		
		direction += transform.basis.x
			
		
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta) 
	velocity = move_and_slide(velocity, Vector3.UP) 


func _on_Timer_timeout():
	w_runable = false
