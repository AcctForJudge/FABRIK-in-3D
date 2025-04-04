extends Node3D


@onready var button: Button = $"../Panel/Target Position/GridContainer/Button"
@onready var x: HSlider = $"../Panel/Target Position/x"
@onready var y: HSlider = $"../Panel/Target Position/y"
@onready var z: HSlider = $"../Panel/Target Position/z"
@onready var points = self.get_children().filter(func(child): return child.name.begins_with("Point") )
@onready var target: Node3D = $Target
@onready var labelx: Label = $"../Panel/Target Position/x/Label"
@onready var labely: Label = $"../Panel/Target Position/y/Label"
@onready var labelz: Label = $"../Panel/Target Position/z/Label"

@export var tolerance:int = 100
@export var weight = 0.7
@export var x_amp:float = -1.0
@export var x_f:float = 1.0
@export var y_amp:float = 40.0
@export var y_f:float = 0.5
@export var z_amp:float = 30.0
@export var z_f:float = 0.1
@export var continuous_change:bool = false

var lines:Array[MeshInstance3D] = []
var t = 0
var distances: Array[Vector3] = []

func _ready() -> void:
	get_distances()
	set_sliders()
	
func _physics_process(delta: float) -> void:
	var distance:float = (points[0].position - target.position).length()
	if continuous_change:
		t = t + 1
		var t_in_rad = deg_to_rad(t)
		var xw = 2 * PI * x_f
		var yw = 2 * PI * y_f
		var zw = 2 * PI * z_f
		target.position = Vector3(x_amp * deg_to_rad(xw * t_in_rad), y_amp * cos(yw * t_in_rad), z_amp * (sin(zw * t_in_rad) + cos(zw * t_in_rad)))
	if sum(distances) < distance:
		fabrik_straight()
	else:
		fabrik_solve()
	draw_lines()

	
func fabrik_straight():
	for ind in range(points.size() - 1):
		var point = points[ind]
		var r = (target.position - point.position).length()
		var lambda = distances[ind].length() / r
		var points_target = (1 - lambda) * point.position + lambda * target.position
		points[ind + 1].position = lerp(points[ind + 1].position, points_target, weight)
		
func fabrik_solve():
	var initial = points[0].position
	var distance_to_target = (points[-1].position - target.position).length()
	var passes = 0
	
	while passes < 10 and tolerance > distance_to_target:
		passes += 1
		
		#forward
		points[-1].position = lerp(points[-1].position, target.position, weight)
		for ind in range(points.size() - 2, 0, -1):
			var r = (points[ind + 1].position - points[ind].position).length()
			var lambda = distances[ind].length() / r
			var points_target = (1 - lambda) * points[ind + 1].position + lambda * points[ind].position
			points[ind].position = lerp(points[ind].position, points_target, weight)
		
		#backward
		points[0].position = initial
		for ind in range(points.size() - 1):
			var r = (points[ind + 1].position - points[ind].position).length()
			var lambda = distances[ind].length() / r
			var points_target = (1 - lambda) * points[ind].position + lambda * points[ind + 1].position
			points[ind + 1].position = lerp(points[ind + 1].position, points_target, weight)			
		
		distance_to_target = (points[-1].position - target.position).length()
	
	
func get_distances():
	for ind in range(points.size() - 1):
		distances.append(points[ind + 1].position - points[ind].position)
		
func sum(arr:Array[Vector3]) -> float:
	var s:float = 0.0
	for item in arr:
		s += item.length()
	return s

func create_line(from:Vector3, to:Vector3):
	var line = MeshInstance3D.new()
	var cylinder:ImmediateMesh = ImmediateMesh.new()
	var material:StandardMaterial3D = StandardMaterial3D.new()
	
	cylinder.surface_begin(Mesh.PRIMITIVE_LINES, material)
	cylinder.surface_add_vertex(from)
	cylinder.surface_add_vertex(to)
	cylinder.surface_end()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	
	line.mesh = cylinder
	
	$"../Lines".add_child(line)
	lines.append(line)

func draw_lines():
	for line in $"../Lines".get_children():
		line.queue_free()
	lines = []
	for ind in range(points.size() - 1):
		create_line(points[ind].global_position, points[ind + 1].global_position)

func _on_button_pressed() -> void:
	target.global_position = Vector3(x.value, y.value, z.value)

func set_sliders():
	x.min_value = int(target.global_position.x - 50)
	x.max_value = int(target.global_position.x + 50)
	y.min_value = int(target.global_position.y - 50)
	y.max_value = int(target.global_position.y + 50)
	z.min_value = int(target.global_position.z - 50)
	z.max_value = int(target.global_position.z + 50)
	labelx.text = str(target.global_position.x)
	labely.text = str(target.global_position.y)
	labelz.text = str(target.global_position.z)

func _on_x_value_changed(value: float) -> void:
	labelx.text = str(value)

func _on_y_value_changed(value: float) -> void:
	labely.text = str(value)

func _on_z_value_changed(value: float) -> void:
	labelz.text = str(value)
