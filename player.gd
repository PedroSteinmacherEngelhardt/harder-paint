extends CharacterBody3D

@onready var ray_cast_3d: RayCast3D = $Camera3D/RayCast3D
@onready var fps: Label = $fps

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
# 2,54cm (inch->cm) / 1200 (DPI) * 0,2 (LOOKAROUND_STEP) = 240 deg
const LOOKAROUND_STEP = deg_to_rad(0.2)

var rot_x = 0
var rot_y = 0


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(delta: float) -> void:
	fps.text = str(Engine.get_frames_per_second())


func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _input(event):
	var ray_collision = ray_cast_3d.get_collider()
	if ray_collision:
		if ray_collision.has_method("ray"):
			ray_collision.ray(ray_cast_3d.get_collision_point(), event)
	
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
	
	if event is InputEventMouseMotion:
		rot_x += event.relative.x * LOOKAROUND_STEP
		rot_y += event.relative.y * LOOKAROUND_STEP
		
		rot_y = clamp(rot_y, -1.5, 1.5)
		
		transform.basis = Basis()
		$Camera3D.basis = Basis()
		
		rotate_object_local(Vector3(0, -1, 0), rot_x)
		$Camera3D.rotate_object_local(Vector3(-1, 0, 0), rot_y)
