extends CharacterBody3D
#These are the only lines for player stuff so don't worry
@export var inventory_data: InventoryData
signal toggle_inventory()
@onready var touch: RayCast3D = $touch
@onready var interactable: Sprite3D = $Interactable



const SPEED = 5.0
const JUMP_VELOCITY = 4.5
#This is also for the inventory
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Inventory"):
		toggle_inventory.emit()
	if Input.is_action_just_pressed("Interact"):
		Interact()
		
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if touch.is_colliding():
		interactable.show()
	else:
		interactable.hide()
		
		
		
		pass
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
func Interact() -> void:
	if touch.is_colliding():
		touch.get_collider().player_interact()
	pass
	
#func Get_drop_position() -> Vector3:
	
#	pass
