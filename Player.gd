extends CharacterBody3D

const SPEED = 9.0
var CORRER = 20.0
const JUMP_VELOCITY = 6.5
const GRAVITY = 9.8


@onready var camerabase = $CameraBase
var is_running = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		camerabase.rotation.x -= deg_to_rad(event.relative.y * 1)
		camerabase.rotation.x = clamp(camerabase.rotation.x, deg_to_rad(15), deg_to_rad(45))
		rotation.y -= deg_to_rad(event.relative.x * 1)

func _physics_process(delta):
	# gravidade.
	
	if is_on_floor():
		CORRER = 20
	
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
		CORRER = 12
	
	# Pulando.
	if Input.is_action_just_pressed("pula") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# correndo
	is_running = Input.is_action_pressed("correr") 
		
		
	var input_dir = Input.get_vector("anda_esquerda", "anda_direita", "anda_frente", "anda_tras")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if is_running:
		velocity.x = direction.x * CORRER
		velocity.z = direction.z * CORRER
	elif direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
