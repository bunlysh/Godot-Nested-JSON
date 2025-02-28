class_name Inventory
extends Node

@export var fill_amount : int = 3

var items : Array[Item]
## Why is an ITEM_ID necessary? In theory it isn't. In this case it just makes it easier to fetch it from a Dictionary when loading. Furthermore it helps the structure. Be careful in case you use a shared-id amongst Items which may exist several times in your inventory!
const ITEM_ID := "ITEM_ID."
const ITEMS_SIZE := "ITEMS_SIZE"

## MORE_INFO: https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html
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
	## COPED from https://forum.godotengine.org/t/how-to-load-and-save-things-with-godot-a-complete-tutorial-about-serialization/44515
	var saved_dict : Dictionary = {ITEMS_SIZE: items.size()}
	var fetched_dict : Dictionary
	for count in range(0, items.size()):
		fetched_dict = items[count].get_save_dict()
		saved_dict[_get_item_count_id(count)] = fetched_dict
	
	var json_data = JSON.stringify(saved_dict, "\t")	## the "\t" ensures that the JSON ends up being human-readable
	
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
	var json_string := file_access.get_as_text()	## in the original one here is written get_line(), which will only fetch the first line. We do not want that, instead the whole text!
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
		## Create a new ITEM. After all it does not exist right now! In case you are using Resources, this is basically the same
		new_item = Item.new()
		## The important part: ensure that the class got a function which allows you to read out the data. Furthermore: only send the necessary data, in this case the data from the specific ID.
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
