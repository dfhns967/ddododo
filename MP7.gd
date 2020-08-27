extends Spatial

func _ready():
	pass

func shoot():
	if Input.is_action_just_pressed("fire"):
			print("mp7 Fired")
func _process(delta):
	shoot()
