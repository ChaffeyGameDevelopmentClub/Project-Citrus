extends CharacterBody3D

var fight_P_left
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
signal fighting

func fight():
	fight_P_left = global_position - Vector3 (3, 0, 0,)
	SignalBus.emit_signal("fighting",fight_P_left) 
	
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	
	
	
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_area_3d_area_entered(area: Area3D) -> void:
	fight()
