extends CharacterBody3D

var look_rotation:Vector2
@onready var inner: Node3D = $Inner
@export var look_speed :float = 0.01
@export var move_speed :float = 50.0

func _ready() -> void:
	look_rotation.y = rotation.y
	look_rotation.x = inner.rotation.x
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		rotate_look(event.relative)
	
func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var motion = (inner.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	motion *= move_speed * delta
	
	move_and_collide(motion)
	
	
		
func rotate_look(rot_input:Vector2):
	look_rotation.x -= rot_input.y * look_speed
	look_rotation.x = clamp(look_rotation.x, deg_to_rad(-85), deg_to_rad(85))
	look_rotation.y -= rot_input.x * look_speed
	transform.basis = Basis()
	rotate_y(look_rotation.y)
	inner.transform.basis = Basis()
	inner.rotate_x(look_rotation.x)
	
