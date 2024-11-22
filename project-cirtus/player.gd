extends CharacterBody3D

@export var sprite: AnimatedSprite3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var in_shadow:bool = false
var shadow_timer: float = 0.0

var can_interact: bool = false

func _ready() -> void:
	pass
	#Dialogic.signal_event.connect(_on_dialogic_signal)
	
func _process(delta: float) -> void:
	if in_shadow:
		shadow_timer += delta
		if shadow_timer>=3:
			sprite.set_modulate(Color(0,0,0,1))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func update_animation():
	var animation_prefix = Global.character + "_"
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction + speed
	
	if direction != Vector2.ZERO:
		last_direction = direction.normalized()


func _input(event: InputEvent) -> void:
	pass

func _on_dialogic_signal(argument: String):
	if argument == "its a signal":
		print("A signal was fired")
