class_name TPPCameraController
extends Node

@export var camera_pivot: Node3D = null
@export_range(0.0, 1.0) var mouse_sensitivity: float = 0.25

var _camera_input_direction: Vector2 = Vector2.ZERO

func _input(event: InputEvent) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity
	
func _physics_process(delta: float) -> void:
	camera_pivot.rotation.x += _camera_input_direction.y * delta
	
	# camera limit -PI/6.0 = -30 derajat | PI/3.0 = 60 derajat
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -PI / 6.0, PI / 3.0) 
	
	camera_pivot.rotation.y = _camera_input_direction.x * delta
	_camera_input_direction = Vector2.ZERO
