class_name Item extends Node

@export var item_name : String = "ITEM"
@export var item_icon : Texture = load("res://icon.png")
@export var item_description : String = "DESCRIPTION"
@export var uses_amount : int = 1

func _use(player : Player) -> void:
	queue_free()

func pick_up(player : Player):
	if !player: return
	if !player.inventory: return
	
	var p_inventory = player.inventory
	
	if !p_inventory.inventory_size > p_inventory.items.size():
		## Tell the player that they don't have enough inventory space or smth
		return
	
	get_parent().queue_free()
	reparent(p_inventory)
	p_inventory.item_added.emit(self)
	
# bit of an explination to this ^^^:
#    originally when an item spawns in somewhere on the floor, this "item" node is child of it
#    basically as a data-holder
#    upon being picked up, the overworld representation of that item is destoryed (line 15)
#    n then we add that item to the inventory of the player that picked it up, as well as tell the-
#    player's inventory about there being a new item in it
