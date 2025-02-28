class_name SubData

## ID
var id : int
const SAVE_ID := "ID"

## VALUE
var value : int
const SAVE_VALUE := "VALUE"


func generate_data() -> void:
	## RAND Data Generation so you got something to compare
	id = randi_range(0, 99999999)
	value = randi_range(0, 99999999)


func read_save_dict(inDict : Dictionary) -> void:
	id = inDict[SAVE_ID]
	value = inDict[SAVE_VALUE]


func get_save_dict() -> Dictionary:
	return {SAVE_ID: id, SAVE_VALUE: value}
	## Above is a shortcut. This is more elaborate:
	#var dict : Dictionary = {}
	#dict[SAVE_ID] = id
	#dict[SAVE_VALUE] = value
	#return dict


func d_debug() -> String:
	return "%s: %s / %s: %s" % [SAVE_ID, id, SAVE_VALUE, value] 
