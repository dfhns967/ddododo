extends RigidBody

var shoot = false

const DAMAGE = 200
const SPEED = 10

func _ready():
	pass
func _physics_process(delta):
	if shoot:	
		apply_impulse(transform.basis.z, -transform.basis.z * SPEED) 


func _on_Area_body_entered(body):
	if body.is_in_group("Enemy"):
		body.health -= DAMAGE
