class_name Inventory
extends Node

@export var fill_amount : int = 3

var items : Array[Item]
const ITEM_ID := "ITEM_ID."
const ITEMS_SIZE := "ITEMS_SIZE"

var save_path : String = "user://inventory.json"


func _get_item_count_id(inCount : int) -> String:
	return ITEM_ID + str(inCount)


func fill_inventory() -> void:
	items = []
	var newItem : Item
	for count in range(0, fill_amount):
		newItem = Item.new()
		newItem.fill_sub_data("Item" + str(count))
		items.append(newItem)
	print("Inventory filled with %s Items" % [fill_amount])


func clear_inventory() -> void:
	items.clear()
	print("Inventory cleared.")


func save_inventory() -> void:
	var saved_dict : Dictionary = {ITEMS_SIZE: items.size()}
	var fetched_dict : Dictionary
	for count in range(0, items.size()):
		fetched_dict = items[count].get_save_dict()
		saved_dict[_get_item_count_id(count)] = fetched_dict
	
	var json_data = JSON.stringify(saved_dict, "\t")
	
	var file_access := FileAccess.open(save_path, FileAccess.WRITE)
	if not file_access:
		print("An error happened while saving data: ", FileAccess.get_open_error())
		return
	
	file_access.store_line(json_data)
	file_access.close()
	
	print("Inventory saved.")


func load_inventory() -> void:
	if not FileAccess.file_exists(save_path):
		print("SaveFile does not exist in Path: ", save_path)
		return
	
	var file_access := FileAccess.open(save_path, FileAccess.READ)
	var json_string := file_access.get_as_text()
	file_access.close()
	
	var json := JSON.new()
	var error := json.parse(json_string)
	if error:
		print("JSON Parse Error: ", json.get_error_message(), " in '", json_string, "' at line ", json.get_error_line())
		return
	
	items = []
	var data : Dictionary = json.data
	var new_item : Item
	for count in range(0, data[ITEMS_SIZE]):
		new_item = Item.new()
		new_item.read_save_dict(data[_get_item_count_id(count)])
		items.append(new_item)
	
	print("Inventory loaded.")


func open_save_location() -> void:
	OS.shell_open(ProjectSettings.globalize_path("user://"))


const SEPARATOR := "---------------\n"
func d_debug() -> void:
	var dispData : String = "Inventory: contains %s Items\n" % [items.size()]
	for count in range(0, items.size()):
		dispData += str(count) + ": " + items[count].d_debug() + "\n"
	print(SEPARATOR + dispData + "\n" + SEPARATOR) 
