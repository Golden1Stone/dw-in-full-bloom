class_name PlayerInventory extends Node

@export var inventory_size : int = 3
var items : Array[Item] = [] : 
	get:
		var items_arr : Array[Item] = []
		for c in get_children():
			items_arr.append(c)
		return items_arr

signal item_added(item : Item)
