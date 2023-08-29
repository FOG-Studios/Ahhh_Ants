extends Node

# GlobalScript

#onready var osStoragePath: String
@onready var root = get_tree().get_root()

var savedFile: String =  "res://SaveFile/AntSaveFile.txt"#"user://AntSaveFile.txt"#

var savedAntHillNavis: Array = []
var savedAntHillTiles: Array = []
var simFoodLocArray: Array = [] # Simmed at runtime, not saved
var simWoodLocArray: Array = [] # Simmed at runtime, not saved
var simLeafLocArray: Array = [] # Simmed at runtime, not saved
var workerAntArray: Array = []
var itemArray: Array = [] # Food, Wood, Leaf count array
var foodItemsMarkedArray: Array = [] # Actual locations of marked items
var woodItemsMarkedArray: Array = [] # Actual locations of marked items
var leafItemsMarkedArray: Array = [] # Actual locations of marked items

var saveDict: Dictionary = {}
var storageSavedLoc: Dictionary = {}
var itemDropLoc: Dictionary = {}
var markedItemsLoc: Dictionary = {}

var existingSave: bool = false
var cameraOutside: bool = false
var foodMarked: bool = false
var woodMarked: bool = false
var leafMarked: bool = false
var been_outside: bool = false
var day_time: bool = true

var currentFoodLoc: Vector2 = Vector2(448, 251)
var currentWoodLoc: Vector2 = Vector2(512, 251)
var currentLeafLoc: Vector2 = Vector2(576, 251)
var foodStorageLoc: Vector2
var woodStorageLoc: Vector2
var leafStorageLoc: Vector2
var defendHere: Vector2

var camera: int = 2
var icon_cycle_seeker: int = 0
var antMultiplier: int = 1
var food_count: int = 400
var leaf_count: int = 400
var wood_count: int = 400
var numOfWorkers: int = 0
var itemGrabCount: int = 0 # default job count
var dayCount: int = 1

var antColor

func _ready():
	randomize()
	load_game()
	

# Add marked items
func add_marked_items(arrayToMark: String, itemPlace: Vector2):
	markedItemsLoc.clear()
	if arrayToMark == "Food":
		if !foodItemsMarkedArray.has(itemPlace):
			foodItemsMarkedArray.append(itemPlace)
		currentFoodLoc = foodItemsMarkedArray[0]
		foodMarked = true
	if arrayToMark == "Wood":
		if !woodItemsMarkedArray.has(itemPlace):
			woodItemsMarkedArray.append(itemPlace)
		currentWoodLoc = woodItemsMarkedArray[0]
		woodMarked = true
	if arrayToMark == "Leaf":
		if !leafItemsMarkedArray.has(itemPlace):
			leafItemsMarkedArray.append(itemPlace)
		currentLeafLoc = leafItemsMarkedArray[0]
		leafMarked = true
	markedItemsLoc = {
		"Food": foodItemsMarkedArray,
		"Wood": woodItemsMarkedArray,
		"Leaf": leafItemsMarkedArray
		}
	

# Remove marked itmes
func remove_marked_item(arrayToUnMark: String, itemPlace: Vector2):
	markedItemsLoc.clear()
	var removeAt: int = 0
	if arrayToUnMark == "Food":
		if foodItemsMarkedArray.has(itemPlace):
			removeAt = foodItemsMarkedArray.find(itemPlace)
			foodItemsMarkedArray.remove_at(removeAt)
		if foodItemsMarkedArray.is_empty():
			foodMarked = false
		else:
			currentFoodLoc = foodItemsMarkedArray[0]
	if arrayToUnMark == "Wood":
		if woodItemsMarkedArray.has(itemPlace):
			removeAt = woodItemsMarkedArray.find(itemPlace)
			woodItemsMarkedArray.remove_at(removeAt)
		if woodItemsMarkedArray.is_empty():
			woodMarked = false
		else:
			currentWoodLoc = woodItemsMarkedArray[0]
	if arrayToUnMark == "Leaf":
		if leafItemsMarkedArray.has(itemPlace):
			removeAt = leafItemsMarkedArray.find(itemPlace)
			leafItemsMarkedArray.remove_at(removeAt)
		if leafItemsMarkedArray.is_empty():
			leafMarked = false
		else:
			currentLeafLoc = leafItemsMarkedArray[0]
	markedItemsLoc = {
		"Food": foodItemsMarkedArray,
		"Wood": woodItemsMarkedArray,
		"Leaf": leafItemsMarkedArray
		}
	

func set_time_of_day():
#	day_time = !day_time
	print("Daytime =  ", day_time)

func save_game():
	var file = FileAccess.open(savedFile, FileAccess.WRITE)
	file.store_string(var_to_str(saveDict))
	file.close()
	

func load_game():
#	if OS.get_name() == "Windows":
#		var findFile = File.new()
#		osStoragePath = OS.get_executable_path()
#		savedFile = osStoragePath + "/SaveFile/AntSaveFile.txt"
#
#		if findFile.file_exists(savedFile):
#
#			findFile.open(osStoragePath, File.READ)
#			saveDict = str2var(findFile.get_as_text())
#			findFile.close()
#			init_saved_dict()
#			existingSave = true
#		else:
#			set_default_vars()
#			OS.shell_open(osStoragePath)
##			OS.execute("CMD.exe", [osStoragePath, "fsutil file createnew AntSaveFile.txt 1000"], true)
#			return
			
	
	if !FileAccess.file_exists(savedFile):
		set_default_vars()
		return
	var file: FileAccess = FileAccess.open(savedFile, FileAccess.READ)
#	file.open(savedFile, FileAccess.READ)
	saveDict = str_to_var(file.get_as_text())
	file.close()
	init_saved_dict()
	existingSave = true

	

func set_default_vars():
	itemArray.append(food_count)
	itemArray.append(wood_count)
	itemArray.append(leaf_count)
	storageSavedLoc["Food"] = Vector2(512, 500)
	storageSavedLoc["Leaf"] = Vector2(540, 540)
	storageSavedLoc["Wood"] = Vector2(484, 540)
	build_default_item_array("Food", currentFoodLoc)
	await get_tree().create_timer(0.1).timeout
	build_default_item_array("Wood", currentWoodLoc)
	await get_tree().create_timer(0.1).timeout
	build_default_item_array("Leaf", currentLeafLoc)
	foodItemsMarkedArray = []
	woodItemsMarkedArray = []
	leafItemsMarkedArray = []
	

func build_default_item_array(itemType: String, startLoc: Vector2):
	var startPos: = startLoc
	if itemType == "Food":
		for i in 10:
			var newLoc: Vector2 = Vector2.ZERO
			simFoodLocArray.append(startPos)
			newLoc.x = randf_range(102, 903)
			newLoc.y = randf_range(287, -1480)
			startPos = newLoc
	if itemType == "Wood":
		for i in 10:
			var newLoc: Vector2 = Vector2.ZERO
			simWoodLocArray.append(startPos)
			newLoc.x = randf_range(102, 903)
			newLoc.y = randf_range(287, -1480)
			startPos = newLoc
	if itemType == "Leaf":
		for i in 10:
			var newLoc: Vector2 = Vector2.ZERO
			simLeafLocArray.append(startPos)
			newLoc.x = randf_range(102, 903)
			newLoc.y = randf_range(287, -1480)
			startPos = newLoc
	

func save_tile_array(newTileArray: Array):
	savedAntHillTiles.clear()
	savedAntHillTiles = newTileArray.duplicate()
	

func save_navi_tiles(newNaviArray: Array):
	savedAntHillNavis.clear()
	savedAntHillNavis = newNaviArray.duplicate()
	
#
#func save_player_navi_tiles(newPlayerNaviArray: Array):
#	savedPlayerNaviTiles.clear()
#	savedPlayerNaviTiles = newPlayerNaviArray.duplicate()
#

func clear_tileArray():
	savedAntHillTiles.clear()
	

func write_dict():
	itemDropLoc["Food"] = simFoodLocArray
	itemDropLoc["Wood"] = simWoodLocArray
	itemDropLoc["Leaf"] = simLeafLocArray
	
	saveDict.clear()
	saveDict["NumOfWorkers"] = numOfWorkers
	saveDict["AntColor"] = antColor
	saveDict["ItemArray"] = itemArray
	saveDict["WorkerAntArray"] = workerAntArray
	saveDict["SavedAntHillTiles"] = savedAntHillTiles
	saveDict["SavedAntHillNavis"] = savedAntHillNavis
	saveDict["StorageSavedLoc"] = storageSavedLoc
	saveDict["ItemGrabCount"] = itemGrabCount
	saveDict["ItemDropLoc"] = itemDropLoc
	saveDict["MarkedItemsLoc"] = markedItemsLoc
	save_game()
	

func init_saved_dict():
	if !saveDict["ItemArray"][0] == null:
		food_count = saveDict["ItemArray"][0]
		wood_count = saveDict["ItemArray"][1]
		leaf_count = saveDict["ItemArray"][2]
	workerAntArray = saveDict["WorkerAntArray"]
	numOfWorkers = saveDict["NumOfWorkers"]
	savedAntHillNavis = saveDict["SavedAntHillNavis"]
	savedAntHillTiles = saveDict["SavedAntHillTiles"]
	antColor = saveDict["AntColor"]
	storageSavedLoc = saveDict["StorageSavedLoc"]
	itemGrabCount = saveDict["ItemGrabCount"]
	itemDropLoc = saveDict["ItemDropLoc"]
	markedItemsLoc = saveDict["MarkedItemsLoc"]
	if !markedItemsLoc.is_empty():
		
		if !markedItemsLoc.has("Food"):
			if !markedItemsLoc["Food"].is_empty():
				foodMarked = true
		if !markedItemsLoc.has("Wood"):
			if !markedItemsLoc["Wood"].is_empty():
				woodMarked = true
		if !markedItemsLoc.has("Leaf"):
			if !markedItemsLoc["Leaf"].is_empty():
				leafMarked = true
	
	build_fItem_array(itemDropLoc["Food"])
	build_wItem_array(itemDropLoc["Wood"])
	build_lItem_array(itemDropLoc["Leaf"])
	

func set_color(newColor: Color):
	antColor = newColor
	

func save_items():
	itemArray.clear()
	itemArray.append(food_count)
	itemArray.append(wood_count)
	itemArray.append(leaf_count)
	return itemArray
	

func save_this_storage_loc(storageName: String, storageLoc: Vector2):
	storageSavedLoc[storageName] = storageLoc
	return storageSavedLoc
	

# Request from saved worker ant to get ant stats.
# The requste starts here to see if it's number exist
# in the array already. Pass in will be the Node 
# count num from parent ie.. WorkerAnt.. WorkerAnt1.. 
# WorkerAnt2 and so on. Which will be linked to the 
# value in the array. A return null here tells the 
# ant to create itself. Then makes the call to
# add_new_ant_to_dict()
func build_worker_ant_dict(nodeCount: int):
	var antDict: Array
	if  numOfWorkers == nodeCount:
		return []
	antDict = workerAntArray[nodeCount]
	
	return antDict
	

func add_new_ant_to_dict(givenName: String, item: String, activity: String, location: Vector2, isOutside: bool, carryingItem: bool):
	numOfWorkers += 1
	var antArray: Array = []
	antArray.append(givenName)
	antArray.append(item)
	antArray.append(activity)
	antArray.append(location)
	antArray.append(isOutside)
	antArray.append(carryingItem)
	workerAntArray.append(antArray)
	write_dict()
	

func update_my_dict(MyNum: int, givenName: String, item: String, activity: String, location: Vector2, isOutside: bool, carryingItem: bool):
	var myOldArray: Array = []
	myOldArray = workerAntArray[MyNum]
	myOldArray.clear()
	myOldArray.append(givenName)
	myOldArray.append(item)
	myOldArray.append(activity)
	myOldArray.append(location)
	myOldArray.append(isOutside)
	myOldArray.append(carryingItem)
	return myOldArray
	

func build_fItem_array(fItemsLocArray: Array):
	simFoodLocArray.clear()
	simFoodLocArray = fItemsLocArray.duplicate()
	return simFoodLocArray
	

func remove_fItem_array(oldLoc: Vector2)-> Vector2:
	simFoodLocArray.remove_at(simFoodLocArray.find(oldLoc))
	var newLoc: Vector2 = Vector2.ZERO
	newLoc.x = randf_range(74, 967)
	newLoc.y = randf_range(262, -1480)
	simFoodLocArray.append(newLoc)
	return newLoc
	

func build_wItem_array(wItemsLocArray: Array):
	simWoodLocArray.clear()
	simWoodLocArray = wItemsLocArray.duplicate()
	return simWoodLocArray
	

func remove_wItem_array(oldLoc: Vector2)-> Vector2:
	simWoodLocArray.remove_at(simWoodLocArray.find(oldLoc))
	var newLoc: Vector2 = Vector2.ZERO
	newLoc.x = randf_range(74, 967)
	newLoc.y = randf_range(262, -1480)
	simWoodLocArray.append(newLoc)
	return newLoc
	

func build_lItem_array(lItemsLocArray: Array):
	simLeafLocArray.clear()
	simLeafLocArray = lItemsLocArray.duplicate()
	return simLeafLocArray
	

func remove_lItem_array(oldLoc: Vector2)-> Vector2:
	simLeafLocArray.remove_at(simLeafLocArray.find(oldLoc))
	var newLoc: Vector2 = Vector2.ZERO
	newLoc.x = randf_range(74, 967)
	newLoc.y = randf_range(262, -1480)
	simLeafLocArray.append(newLoc)
	return newLoc
	

func get_job()-> int:
	itemGrabCount += 1
	
	if itemGrabCount == 1:
		return 1
	elif itemGrabCount == 2:
		return 2
	elif itemGrabCount == 3:
		return 3
	elif itemGrabCount == 4:
		return 4
	else:
		itemGrabCount = 1
		return 1
	
