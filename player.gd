extends CharacterBody3D

class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
static var SkillCheckLevel : int = 1
@onready var CameraRay : SpringArm3D = $SpringArm3D
@onready var MeshInst : MeshInstance3D = $MeshInstance3D
var direction : Vector2i = Vector2i(0,0)



func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == 2:
			CameraRay.rotation.y -= event.relative.x * 0.01
			var change : float = CameraRay.rotation.x - event.relative.y * 0.01
			if change <= 1.5 and change >= -1.5:
				CameraRay.rotation.x = change
	elif event is InputEventMouseButton:
		var change : float = $SpringArm3D.spring_length + (0.3 if event.button_index == 5 else (-0.3 if event.button_index == 4 else 0.0))
		if change > 0.5 and change < 14:
			$SpringArm3D.spring_length = change

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	direction = Vector2i(0,0)
	if Input.is_action_pressed("Up"):
		direction.x = 1
	if Input.is_action_pressed("Down"):
		direction.x = -1
	if Input.is_action_pressed("Left"):
		direction.y = -1
	if Input.is_action_pressed("Right"):
		direction.y = 1
	
	if direction:
		velocity.x = (direction.x * cos(CameraRay.rotation.y) + direction.y * sin(CameraRay.rotation.y)) * SPEED
		velocity.z = (-direction.x * sin(CameraRay.rotation.y) + direction.y * cos(CameraRay.rotation.y)) * SPEED
		var first : float = (MeshInst.rotation.y + PI * 0.5)
		var second : float  = (CameraRay.rotation.y - atan2(direction.y,direction.x))
		var rotchange := angle_difference(first,second) 
		MeshInst.rotation.y += rotchange * 0.1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_line_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		SkillCheckLevel = int(new_text)
	else:
		$"../LineEdit".text = "1"
		SkillCheckLevel = 1
