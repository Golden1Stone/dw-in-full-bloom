extends Node3D

@onready var UI : Control = $UI
@onready var thePlayer : CharacterBody3D = $CharacterBody3D
@onready var Interaction : Control = UI.find_child("Interaction")
var InteractionStop : bool = false
var active_state: Callable

func _ready() -> void:
	Interaction.visible = false
	$UI/SkillCheck.visible = false
	active_state = IdleProcess

func _process(delta: float) -> void:
	if active_state.is_valid():
		active_state.call(delta)


func IdleProcess(delta: float) -> void:
	var Bar : ColorRect = Interaction.get_child(0).get_child(1)
	for E : Node3D in find_child("Interactions").get_children():
		var distance : float = (thePlayer.position - E.position).length()
		if distance < 3:
			var camera : Camera3D = thePlayer.get_child(2).get_child(0)
			Interaction.position = camera.unproject_position(E.global_position) + Vector2(-130,-20)
			Interaction.visible = true
			Interaction.modulate.a = 1 - (distance - 2)
			if distance < 2: Interaction.modulate.a = 1
			if Input.is_action_pressed("Interact"):
				InteractionStop = false
				if Interaction.visible:
					Bar.scale.x += delta
			else: InteractionStop = true
			break
		else: 
			Interaction.visible = false
			InteractionStop = true
	if InteractionStop:
		Bar.scale.x += (0 - Bar.scale.x) * delta * 4
		if Bar.scale.x < 0.1:
			InteractionStop = true
	elif Bar.scale.x > 1:
		active_state = SkillProcess
		Interaction.visible = false
		Bar.scale.x = 0
		SkillInit()

var SkillVars : Array
var SkillAge : float = 0.0 
func SkillProcess(delta: float) -> void:
	SkillAge += delta
	var SkillCheck = $UI/SkillCheck
	var Arrow : ColorRect = SkillCheck.find_child("Arrow")
	var ArrowPos : float = Arrow.position.x
	Arrow.position.x = SkillAge * 200 - 4
	if Input.is_action_just_pressed("Interact"):
		var Space : ColorRect = SkillCheck.find_child("Space")
		var SpaceMiddle : float = Space.position.x + Space.pivot_offset.x
		var Semi : ColorRect = SkillCheck.find_child("SemiSpace")
		var SemiMiddle : float = Semi.position.x + Semi.pivot_offset.x
		if ArrowPos > SpaceMiddle - Space.pivot_offset.x * Space.scale.x and ArrowPos < SpaceMiddle + Space.pivot_offset.x * Space.scale.x:
			print("Awesome!")
		elif ArrowPos > SemiMiddle - Semi.pivot_offset.x * Semi.scale.x and ArrowPos < SemiMiddle + Semi.pivot_offset.x * Semi.scale.x:
			print("Ok!")
		else:
			print("Bad!")
		print("ArrowPos: {0};\nSemiSpace: Start = {1}, End = {2};\nSpace: Start = {3}, End = {4}".format([ArrowPos,
		SemiMiddle - Semi.pivot_offset.x * Semi.scale.x,SemiMiddle + Semi.pivot_offset.x * Semi.scale.x,
		SpaceMiddle - Space.pivot_offset.x * Space.scale.x,SpaceMiddle + Space.pivot_offset.x * Space.scale.x]))
		SkillDestroy()
		active_state = IdleProcess
	elif ArrowPos > 480:
		print("Lazy!")
		SkillDestroy()
		active_state = IdleProcess

func SkillInit() -> void:
	$UI/SkillCheck.visible = true
	$UI/SkillCheck/Arrow.position.x = -4.0
	$UI/SkillCheck/Space.scale.x = Player.SkillCheckLevel * 0.2
	$UI/SkillCheck/SemiSpace.scale.x = Player.SkillCheckLevel * 0.2
	SkillVars.append(0.0)

func SkillDestroy() -> void:
	$UI/SkillCheck.visible = false
	SkillAge = 0.0
	for Var in SkillVars:
		SkillVars.pop_back()
