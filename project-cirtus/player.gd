extends CharacterBody3D

@export var sprite: AnimatedSprite3D
@export var timerP:Timer


var idle_anim:String = "Idle Right"
const SPEED = 5.0
const JUMP_VELOCITY = 4.5


var fighting = false
var in_shadow:bool = false
var shadow_timer: float = 0.0
var lock = false
var can_interact: bool = false
var postionL
func postioning(postion):
	lock = true
	postionL = postion
	print("connecting")

func fight():
	fighting = true
	lock = false



func _ready() -> void:
	#Dialogic.signal_event.connect(_on_dialogic_signal)
	SignalBus.connect("fighting", postioning)
func _process(delta: float) -> void:
	if in_shadow:
		shadow_timer += delta
		if shadow_timer>=3:
			sprite.set_modulate(Color(0,0,0,1))
	

func _physics_process(delta: float) -> void:
	
	if lock:
		
		global_position.x = move_toward(global_position.x,postionL.x,delta * 20)
		global_position.z = move_toward(global_position.z,postionL.z,delta * 20)
		print("global postion")
		print(global_position)
		print("postion Left")
		print(postionL)
		
		if global_position.x == postionL.x && global_position.z == postionL.z:
			print("pluh")
			fight()
		
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("Jump") and is_on_floor():
		#elocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
	
	if direction && not fighting:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if direction.x>0:
			sprite.play("Walk Right")
			idle_anim = "Idle Right"
		elif direction.x<0:
			sprite.play("Walk Left")
			idle_anim = "Idle Left"
		elif direction.z<0:
			sprite.play("Walk Up")
			idle_anim = "Idle Up"
		elif direction.z>0:
			sprite.play("Walk Down")
			idle_anim = "Idle Down"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		sprite.play(idle_anim)

	move_and_slide()




func _input(event: InputEvent) -> void:
	pass

func _on_dialogic_signal(argument: String):
	if argument == "its a signal":
		print("A signal was fired")


func _on_timer_timeout() -> void:
	fight()
	print("pluh")
