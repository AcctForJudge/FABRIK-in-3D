extends Node3D
@export var speed:int = 5
@onready var camera_3d: Camera3D = $Camera3D
@onready var inner: Node3D = $"."

func _ready() -> void:
	camera_3d.make_current()


func _process(delta: float) -> void:
	input_stuff()
	
func input_stuff():
	
	var forward = self.transform.basis.z.normalized()
	var right = -self.transform.basis.x.normalized()  
	var up = -self.transform.basis.y.normalized()     
	var move_direction = Vector3.ZERO
	
	if Input.is_action_pressed("forward"):
		move_direction -= forward
	if Input.is_action_pressed("backward"):
		move_direction += forward
	if Input.is_action_pressed("right"):
		move_direction -= right
	if Input.is_action_pressed("left"):
		move_direction += right
	if Input.is_action_pressed("up"):
		move_direction -= up
	if Input.is_action_pressed("down"):
		move_direction += up
		
	self.position += move_direction * speed
