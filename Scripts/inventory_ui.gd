extends Control

@export var player : Player
@export var slot_container : Control

const SLOT_SCENE = preload("res://Scenes/inv_slot.tscn")

func _ready() -> void:
	setup_slots()

func setup_slots():
	if !player: return
	if !player.inventory: return
	if !slot_container: return
	
	var inventory = player.inventory
	
	for i in range(inventory.inventory_size):
		var slot = SLOT_SCENE.instantiate()
		slot_container.add_child(slot)
	
	update_slots()

func update_slots():
	if !player: return
	if !player.inventory: return
	if !slot_container: return
	
	var inventory = player.inventory
	var slot_id : int = 1
	
	for c in slot_container.get_children():
		if !c is InventoryUISlot: continue
		var slot : InventoryUISlot = c
		slot.slot_number_label.text = str(slot_id)
		
		slot_id += 1
