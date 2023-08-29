extends TileMap

# TileMAp

@onready var autoTiler: = Autotiler.new(self)

var defaultArray: Array = []
var deleteTilePos: Vector2 = Vector2.ZERO
var savedTiles: Array = []
var unselectableTiles: Array = []

func _ready():
	if !Global.existingSave:
		save_tile_map()
	get_parent().get_node("Carl").connect("removeDirt", Callable(self, "get_tile"))
	get_parent().get_node("Carl").connect("notDirt", Callable(self, "not_tile"))
	get_parent().get_node("UI_And_Camera_Scene").connect("saveTileMap", Callable(self, "save_tile_map"))
	

func remove_tile(tileCheck: Vector2):
	print(" LEGAL REMOVE")
	var removeTile = local_to_map(tileCheck)
	
	set_cell(0, removeTile, 0, Vector2i(5, 3))
	set_cell(1, removeTile, -1)
	autoTiler.update_terrain_tiles(1, 1)
#	
#	save_tile_map()
	

func get_tile(tileCoords: Vector2):
	if !get_cell_tile_data(2, local_to_map(tileCoords)) == null:
		print(" and Delete Tile")
		remove_tile(tileCoords)
		set_cell(2, local_to_map(tileCoords), 0, Vector2i(-1, -1))
		return
	if !get_cell_tile_data(0, local_to_map(tileCoords)) == null:
		set_cell(2, local_to_map(deleteTilePos), -1)
		print("Navi Tile")
	elif !get_cell_tile_data(1, local_to_map(tileCoords)) == null:
		set_cell(2, local_to_map(deleteTilePos), 0, Vector2i(-1, -1))
		deleteTilePos = tileCoords
		print("Have collison tile")
		set_cell(2, local_to_map(tileCoords), 0, Vector2i(6, 3))
		
		
	

func place_new_tile(newTilePos: Vector2):
	var noTile = get_cell_tile_data(0, local_to_map(newTilePos))
	if noTile == null:
		set_cell(0, noTile, 0)
	else: return

func save_tile_map():
	Global.save_tile_array(get_used_cells_by_id(1))
	Global.save_navi_tiles(get_used_cells_by_id(0))
#	autoTiler.set_cells_terrain_connect(1, get_used_cells(1), 1, 0)
	

func not_tile():
	set_cell(1, local_to_map(deleteTilePos), -1)
	

func clear_tileMap():
	clear()
	build_saved_tileMap()
	

func build_saved_tileMap():
	var globalArray: Array = Global.savedAntHillTiles
	var globalNaviArray: Array = Global.savedAntHillNavis
	
	var tileCount: int = 0
	for i in globalArray.size():
		var addTile: Vector2i = globalArray[tileCount]
#		autoTiler
		set_cell(1, addTile, 0, Vector2i(0, 0), 0)
		tileCount += 1
	set_cells_terrain_connect(1, get_used_cells(1), 1, 0)
#	autoTiler.update_terrain_tiles(1, 1)
	var naviCount: int = 0
	for i in globalNaviArray.size():
		var addNavi: Vector2i = globalNaviArray[naviCount]
		set_cell(0, addNavi, 0, Vector2i(5, 3))
		naviCount += 1
	

func worker_ant_task(taskLoc: Vector2):
	var removeTile = local_to_map(taskLoc)
#	set_cell(0, removeTile, -1)
	set_cell(0, removeTile, 1)
	

func _on_TileMap_tree_exiting():
	save_tile_map()
	



func default_array():
	defaultArray = [ 
		Vector2( -1, 24 ), Vector2( 0, 24 ), Vector2( 1, 24 ), Vector2( 2, 24 ), Vector2( 3, 24 ), 
		Vector2( 4, 24 ), Vector2( 5, 24 ), Vector2( 6, 24 ), Vector2( 7, 24 ), Vector2( 8, 24 ), 
		Vector2( 9, 24 ), Vector2( 10, 24 ), Vector2( 11, 24 ), Vector2( 12, 24 ), Vector2( 13, 24 ), 
		Vector2( 14, 24 ), Vector2( 15, 24 ), Vector2( 16, 24 ), Vector2( 17, 24 ), Vector2( 18, 24 ), 
		Vector2( 19, 24 ), Vector2( 20, 24 ), Vector2( 21, 24 ), Vector2( 22, 24 ), Vector2( 23, 24 ), 
		Vector2( 24, 24 ), Vector2( 25, 24 ), Vector2( 26, 24 ), Vector2( 27, 24 ), Vector2( 28, 24 ), 
		Vector2( 29, 24 ), Vector2( 30, 24 ), Vector2( 31, 24 ), Vector2( 32, 24 ), Vector2( 35, 24 ), 
		Vector2( 36, 24 ), Vector2( 37, 24 ), Vector2( 38, 24 ), Vector2( 39, 24 ), Vector2( 40, 24 ), 
		Vector2( 41, 24 ), Vector2( 42, 24 ), Vector2( 43, 24 ), Vector2( 44, 24 ), Vector2( 45, 24 ), 
		Vector2( 46, 24 ), Vector2( 47, 24 ), Vector2( 48, 24 ), Vector2( 49, 24 ), Vector2( 50, 24 ), 
		Vector2( 51, 24 ), Vector2( 52, 24 ), Vector2( 53, 24 ), Vector2( 54, 24 ), Vector2( 55, 24 ), 
		Vector2( 56, 24 ), Vector2( 57, 24 ), Vector2( 58, 24 ), Vector2( 59, 24 ), Vector2( 60, 24 ), 
		Vector2( 61, 24 ), Vector2( 62, 24 ), Vector2( 63, 24 ), Vector2( 64, 24 ), Vector2( 65, 24 ), 
		Vector2( 66, 24 ), Vector2( 67, 24 ), Vector2( 68, 24 ), Vector2( -1, 25 ), Vector2( 0, 25 ), 
		Vector2( 1, 25 ), Vector2( 2, 25 ), Vector2( 3, 25 ), Vector2( 4, 25 ), Vector2( 5, 25 ), 
		Vector2( 6, 25 ), Vector2( 7, 25 ), Vector2( 8, 25 ), Vector2( 9, 25 ), Vector2( 10, 25 ), 
		Vector2( 11, 25 ), Vector2( 12, 25 ), Vector2( 13, 25 ), Vector2( 14, 25 ), Vector2( 15, 25 ), 
		Vector2( 16, 25 ), Vector2( 17, 25 ), Vector2( 18, 25 ), Vector2( 19, 25 ), Vector2( 20, 25 ), 
		Vector2( 21, 25 ), Vector2( 22, 25 ), Vector2( 23, 25 ), Vector2( 24, 25 ), Vector2( 25, 25 ), 
		Vector2( 26, 25 ), Vector2( 27, 25 ), Vector2( 28, 25 ), Vector2( 29, 25 ), Vector2( 30, 25 ), 
		Vector2( 31, 25 ), Vector2( 32, 25 ), Vector2( 35, 25 ), Vector2( 36, 25 ), Vector2( 37, 25 ), 
		Vector2( 38, 25 ), Vector2( 39, 25 ), Vector2( 40, 25 ), Vector2( 41, 25 ), Vector2( 42, 25 ), 
		Vector2( 43, 25 ), Vector2( 44, 25 ), Vector2( 45, 25 ), Vector2( 46, 25 ), Vector2( 47, 25 ), 
		Vector2( 48, 25 ), Vector2( 49, 25 ), Vector2( 50, 25 ), Vector2( 51, 25 ), Vector2( 52, 25 ), 
		Vector2( 53, 25 ), Vector2( 54, 25 ), Vector2( 55, 25 ), Vector2( 56, 25 ), Vector2( 57, 25 ), 
		Vector2( 58, 25 ), Vector2( 59, 25 ), Vector2( 60, 25 ), Vector2( 61, 25 ), Vector2( 62, 25 ), 
		Vector2( 63, 25 ), Vector2( 64, 25 ), Vector2( 65, 25 ), Vector2( 66, 25 ), Vector2( 67, 25 ), 
		Vector2( 68, 25 ), Vector2( -1, 26 ), Vector2( 0, 26 ), Vector2( 1, 26 ), Vector2( 2, 26 ), 
		Vector2( 3, 26 ), Vector2( 4, 26 ), Vector2( 5, 26 ), Vector2( 6, 26 ), Vector2( 7, 26 ), 
		Vector2( 8, 26 ), Vector2( 9, 26 ), Vector2( 10, 26 ), Vector2( 11, 26 ), Vector2( 12, 26 ), 
		Vector2( 13, 26 ), Vector2( 14, 26 ), Vector2( 15, 26 ), Vector2( 16, 26 ), Vector2( 17, 26 ), 
		Vector2( 18, 26 ), Vector2( 19, 26 ), Vector2( 20, 26 ), Vector2( 21, 26 ), Vector2( 22, 26 ), 
		Vector2( 23, 26 ), Vector2( 24, 26 ), Vector2( 25, 26 ), Vector2( 26, 26 ), Vector2( 27, 26 ), 
		Vector2( 28, 26 ), Vector2( 29, 26 ), Vector2( 30, 26 ), Vector2( 31, 26 ), Vector2( 32, 26 ), 
		Vector2( 35, 26 ), Vector2( 36, 26 ), Vector2( 37, 26 ), Vector2( 38, 26 ), Vector2( 39, 26 ), 
		Vector2( 40, 26 ), Vector2( 41, 26 ), Vector2( 42, 26 ), Vector2( 43, 26 ), Vector2( 44, 26 ), 
		Vector2( 45, 26 ), Vector2( 46, 26 ), Vector2( 47, 26 ), Vector2( 48, 26 ), Vector2( 49, 26 ), 
		Vector2( 50, 26 ), Vector2( 51, 26 ), Vector2( 52, 26 ), Vector2( 53, 26 ), Vector2( 54, 26 ), 
		Vector2( 55, 26 ), Vector2( 56, 26 ), Vector2( 57, 26 ), Vector2( 58, 26 ), Vector2( 59, 26 ), 
		Vector2( 60, 26 ), Vector2( 61, 26 ), Vector2( 62, 26 ), Vector2( 63, 26 ), Vector2( 64, 26 ), 
		Vector2( 65, 26 ), Vector2( 66, 26 ), Vector2( 67, 26 ), Vector2( 68, 26 ), Vector2( -1, 27 ), 
		Vector2( 0, 27 ), Vector2( 1, 27 ), Vector2( 2, 27 ), Vector2( 3, 27 ), Vector2( 4, 27 ), 
		Vector2( 5, 27 ), Vector2( 6, 27 ), Vector2( 7, 27 ), Vector2( 8, 27 ), Vector2( 9, 27 ), 
		Vector2( 10, 27 ), Vector2( 11, 27 ), Vector2( 12, 27 ), Vector2( 13, 27 ), Vector2( 14, 27 ), 
		Vector2( 15, 27 ), Vector2( 16, 27 ), Vector2( 17, 27 ), Vector2( 18, 27 ), Vector2( 19, 27 ), 
		Vector2( 20, 27 ), Vector2( 21, 27 ), Vector2( 22, 27 ), Vector2( 23, 27 ), Vector2( 24, 27 ), 
		Vector2( 43, 27 ), Vector2( 44, 27 ), Vector2( 45, 27 ), Vector2( 46, 27 ), Vector2( 47, 27 ), 
		Vector2( 48, 27 ), Vector2( 49, 27 ), Vector2( 50, 27 ), Vector2( 51, 27 ), Vector2( 52, 27 ), 
		Vector2( 53, 27 ), Vector2( 54, 27 ), Vector2( 55, 27 ), Vector2( 56, 27 ), Vector2( 57, 27 ), 
		Vector2( 58, 27 ), Vector2( 59, 27 ), Vector2( 60, 27 ), Vector2( 61, 27 ), Vector2( 62, 27 ), 
		Vector2( 63, 27 ), Vector2( 64, 27 ), Vector2( 65, 27 ), Vector2( 66, 27 ), Vector2( 67, 27 ), 
		Vector2( 68, 27 ), Vector2( -1, 28 ), Vector2( 0, 28 ), Vector2( 1, 28 ), Vector2( 2, 28 ), 
		Vector2( 3, 28 ), Vector2( 4, 28 ), Vector2( 5, 28 ), Vector2( 6, 28 ), Vector2( 7, 28 ), 
		Vector2( 8, 28 ), Vector2( 9, 28 ), Vector2( 10, 28 ), Vector2( 11, 28 ), Vector2( 12, 28 ), 
		Vector2( 13, 28 ), Vector2( 14, 28 ), Vector2( 15, 28 ), Vector2( 16, 28 ), Vector2( 17, 28 ), 
		Vector2( 18, 28 ), Vector2( 19, 28 ), Vector2( 20, 28 ), Vector2( 21, 28 ), Vector2( 22, 28 ), 
		Vector2( 23, 28 ), Vector2( 24, 28 ), Vector2( 43, 28 ), Vector2( 44, 28 ), Vector2( 45, 28 ), 
		Vector2( 46, 28 ), Vector2( 47, 28 ), Vector2( 48, 28 ), Vector2( 49, 28 ), Vector2( 50, 28 ), 
		Vector2( 51, 28 ), Vector2( 52, 28 ), Vector2( 53, 28 ), Vector2( 54, 28 ), Vector2( 55, 28 ), 
		Vector2( 56, 28 ), Vector2( 57, 28 ), Vector2( 58, 28 ), Vector2( 59, 28 ), Vector2( 60, 28 ), 
		Vector2( 61, 28 ), Vector2( 62, 28 ), Vector2( 63, 28 ), Vector2( 64, 28 ), Vector2( 65, 28 ), 
		Vector2( 66, 28 ), Vector2( 67, 28 ), Vector2( 68, 28 ), Vector2( -1, 29 ), Vector2( 0, 29 ), 
		Vector2( 1, 29 ), Vector2( 2, 29 ), Vector2( 3, 29 ), Vector2( 4, 29 ), Vector2( 5, 29 ), 
		Vector2( 6, 29 ), Vector2( 7, 29 ), Vector2( 8, 29 ), Vector2( 9, 29 ), Vector2( 10, 29 ), 
		Vector2( 11, 29 ), Vector2( 12, 29 ), Vector2( 13, 29 ), Vector2( 14, 29 ), Vector2( 15, 29 ), 
		Vector2( 16, 29 ), Vector2( 17, 29 ), Vector2( 18, 29 ), Vector2( 19, 29 ), Vector2( 20, 29 ), 
		Vector2( 21, 29 ), Vector2( 22, 29 ), Vector2( 23, 29 ), Vector2( 24, 29 ), Vector2( 29, 29 ), 
		Vector2( 30, 29 ), Vector2( 31, 29 ), Vector2( 32, 29 ), Vector2( 35, 29 ), Vector2( 36, 29 ), 
		Vector2( 37, 29 ), Vector2( 38, 29 ), Vector2( 43, 29 ), Vector2( 44, 29 ), Vector2( 45, 29 ), 
		Vector2( 46, 29 ), Vector2( 47, 29 ), Vector2( 48, 29 ), Vector2( 49, 29 ), Vector2( 50, 29 ), 
		Vector2( 51, 29 ), Vector2( 52, 29 ), Vector2( 53, 29 ), Vector2( 54, 29 ), Vector2( 55, 29 ), 
		Vector2( 56, 29 ), Vector2( 57, 29 ), Vector2( 58, 29 ), Vector2( 59, 29 ), Vector2( 60, 29 ), 
		Vector2( 61, 29 ), Vector2( 62, 29 ), Vector2( 63, 29 ), Vector2( 64, 29 ), Vector2( 65, 29 ), 
		Vector2( 66, 29 ), Vector2( 67, 29 ), Vector2( 68, 29 ), Vector2( -1, 30 ), Vector2( 0, 30 ), 
		Vector2( 1, 30 ), Vector2( 2, 30 ), Vector2( 3, 30 ), Vector2( 4, 30 ), Vector2( 5, 30 ), 
		Vector2( 6, 30 ), Vector2( 7, 30 ), Vector2( 8, 30 ), 
		Vector2( 9, 30 ), Vector2( 10, 30 ), Vector2( 11, 30 ), Vector2( 12, 30 ), Vector2( 13, 30 ), 
		Vector2( 14, 30 ), Vector2( 15, 30 ), Vector2( 16, 30 ), Vector2( 17, 30 ), Vector2( 18, 30 ), 
		Vector2( 19, 30 ), Vector2( 20, 30 ), Vector2( 21, 30 ), Vector2( 22, 30 ), Vector2( 23, 30 ), 
		Vector2( 24, 30 ), Vector2( 29, 30 ), Vector2( 30, 30 ), Vector2( 31, 30 ), Vector2( 32, 30 ), 
		Vector2( 35, 30 ), Vector2( 36, 30 ), Vector2( 37, 30 ), Vector2( 38, 30 ), Vector2( 43, 30 ), 
		Vector2( 44, 30 ), Vector2( 45, 30 ), Vector2( 46, 30 ), Vector2( 47, 30 ), Vector2( 48, 30 ), 
		Vector2( 49, 30 ), Vector2( 50, 30 ), Vector2( 51, 30 ), Vector2( 52, 30 ), Vector2( 53, 30 ), 
		Vector2( 54, 30 ), Vector2( 55, 30 ), Vector2( 56, 30 ), Vector2( 57, 30 ), Vector2( 58, 30 ), 
		Vector2( 59, 30 ), Vector2( 60, 30 ), Vector2( 61, 30 ), Vector2( 62, 30 ), Vector2( 63, 30 ), 
		Vector2( 64, 30 ), Vector2( 65, 30 ), Vector2( 66, 30 ), Vector2( 67, 30 ), Vector2( 68, 30 ), 
		Vector2( -1, 31 ), Vector2( 0, 31 ), Vector2( 1, 31 ), Vector2( 2, 31 ), Vector2( 3, 31 ), 
		Vector2( 4, 31 ), Vector2( 5, 31 ), Vector2( 6, 31 ), Vector2( 7, 31 ), Vector2( 8, 31 ), 
		Vector2( 9, 31 ), Vector2( 10, 31 ), Vector2( 11, 31 ), Vector2( 12, 31 ), Vector2( 13, 31 ), 
		Vector2( 14, 31 ), Vector2( 15, 31 ), Vector2( 16, 31 ), Vector2( 17, 31 ), Vector2( 18, 31 ), 
		Vector2( 19, 31 ), Vector2( 20, 31 ), Vector2( 21, 31 ), Vector2( 22, 31 ), Vector2( 23, 31 ), 
		Vector2( 24, 31 ), Vector2( 29, 31 ), Vector2( 30, 31 ), Vector2( 31, 31 ), Vector2( 32, 31 ), 
		Vector2( 35, 31 ), Vector2( 36, 31 ), Vector2( 37, 31 ), Vector2( 38, 31 ), Vector2( 43, 31 ), 
		Vector2( 44, 31 ), Vector2( 45, 31 ), Vector2( 46, 31 ), Vector2( 47, 31 ), Vector2( 48, 31 ), 
		Vector2( 49, 31 ), Vector2( 50, 31 ), Vector2( 51, 31 ), Vector2( 52, 31 ), Vector2( 53, 31 ), 
		Vector2( 54, 31 ), Vector2( 55, 31 ), Vector2( 56, 31 ), Vector2( 57, 31 ), Vector2( 58, 31 ), 
		Vector2( 59, 31 ), Vector2( 60, 31 ), Vector2( 61, 31 ), Vector2( 62, 31 ), Vector2( 63, 31 ), 
		Vector2( 64, 31 ), Vector2( 65, 31 ), Vector2( 66, 31 ), Vector2( 67, 31 ), Vector2( 68, 31 ), 
		Vector2( -1, 32 ), Vector2( 0, 32 ), Vector2( 1, 32 ), Vector2( 2, 32 ), Vector2( 3, 32 ), 
		Vector2( 4, 32 ), Vector2( 5, 32 ), Vector2( 6, 32 ), Vector2( 7, 32 ), Vector2( 8, 32 ), 
		Vector2( 9, 32 ), Vector2( 10, 32 ), Vector2( 11, 32 ), Vector2( 12, 32 ), Vector2( 13, 32 ), 
		Vector2( 14, 32 ), Vector2( 15, 32 ), Vector2( 16, 32 ), Vector2( 17, 32 ), Vector2( 18, 32 ), 
		Vector2( 19, 32 ), Vector2( 20, 32 ), Vector2( 21, 32 ), Vector2( 22, 32 ), Vector2( 23, 32 ), 
		Vector2( 24, 32 ), Vector2( 25, 32 ), Vector2( 26, 32 ), Vector2( 27, 32 ), Vector2( 28, 32 ), 
		Vector2( 29, 32 ), Vector2( 30, 32 ), Vector2( 31, 32 ), Vector2( 32, 32 ), Vector2( 35, 32 ), 
		Vector2( 36, 32 ), Vector2( 37, 32 ), Vector2( 38, 32 ), Vector2( 39, 32 ), Vector2( 40, 32 ), 
		Vector2( 41, 32 ), Vector2( 42, 32 ), Vector2( 43, 32 ), Vector2( 44, 32 ), Vector2( 45, 32 ), 
		Vector2( 46, 32 ), Vector2( 47, 32 ), Vector2( 48, 32 ), Vector2( 49, 32 ), Vector2( 50, 32 ), 
		Vector2( 51, 32 ), Vector2( 52, 32 ), Vector2( 53, 32 ), Vector2( 54, 32 ), Vector2( 55, 32 ), 
		Vector2( 56, 32 ), Vector2( 57, 32 ), Vector2( 58, 32 ), Vector2( 59, 32 ), Vector2( 60, 32 ), 
		Vector2( 61, 32 ), Vector2( 62, 32 ), Vector2( 63, 32 ), Vector2( 64, 32 ), Vector2( 65, 32 ), 
		Vector2( 66, 32 ), Vector2( 67, 32 ), Vector2( 68, 32 ), Vector2( -1, 33 ), Vector2( 0, 33 ), 
		Vector2( 1, 33 ), Vector2( 2, 33 ), Vector2( 3, 33 ), Vector2( 4, 33 ), Vector2( 5, 33 ), 
		Vector2( 6, 33 ), Vector2( 7, 33 ), Vector2( 8, 33 ), Vector2( 9, 33 ), Vector2( 10, 33 ), 
		Vector2( 11, 33 ), Vector2( 12, 33 ), Vector2( 13, 33 ), Vector2( 14, 33 ), Vector2( 15, 33 ), 
		Vector2( 16, 33 ), Vector2( 17, 33 ), Vector2( 18, 33 ), Vector2( 19, 33 ), Vector2( 20, 33 ), 
		Vector2( 21, 33 ), Vector2( 22, 33 ), Vector2( 23, 33 ), Vector2( 24, 33 ), Vector2( 25, 33 ), 
		Vector2( 26, 33 ), Vector2( 27, 33 ), Vector2( 28, 33 ), Vector2( 29, 33 ), Vector2( 30, 33 ), 
		Vector2( 31, 33 ), Vector2( 32, 33 ), Vector2( 35, 33 ), Vector2( 36, 33 ), Vector2( 37, 33 ), 
		Vector2( 38, 33 ), Vector2( 39, 33 ), Vector2( 40, 33 ), Vector2( 41, 33 ), Vector2( 42, 33 ), 
		Vector2( 43, 33 ), Vector2( 44, 33 ), Vector2( 45, 33 ), Vector2( 46, 33 ), Vector2( 47, 33 ), 
		Vector2( 48, 33 ), Vector2( 49, 33 ), Vector2( 50, 33 ), Vector2( 51, 33 ), Vector2( 52, 33 ), 
		Vector2( 53, 33 ), Vector2( 54, 33 ), Vector2( 55, 33 ), Vector2( 56, 33 ), Vector2( 57, 33 ), 
		Vector2( 58, 33 ), Vector2( 59, 33 ), Vector2( 60, 33 ), Vector2( 61, 33 ), Vector2( 62, 33 ), 
		Vector2( 63, 33 ), Vector2( 64, 33 ), Vector2( 65, 33 ), Vector2( 66, 33 ), Vector2( 67, 33 ), 
		Vector2( 68, 33 ), Vector2( -1, 34 ), Vector2( 0, 34 ), Vector2( 1, 34 ), Vector2( 2, 34 ), 
		Vector2( 3, 34 ), Vector2( 4, 34 ), Vector2( 5, 34 ), Vector2( 6, 34 ), Vector2( 7, 34 ), 
		Vector2( 8, 34 ), Vector2( 9, 34 ), Vector2( 10, 34 ), Vector2( 11, 34 ), Vector2( 12, 34 ), 
		Vector2( 13, 34 ), Vector2( 14, 34 ), Vector2( 15, 34 ), Vector2( 16, 34 ), Vector2( 17, 34 ), 
		Vector2( 18, 34 ), Vector2( 19, 34 ), Vector2( 20, 34 ), Vector2( 21, 34 ), Vector2( 22, 34 ), 
		Vector2( 23, 34 ), Vector2( 24, 34 ), Vector2( 43, 34 ), Vector2( 44, 34 ), Vector2( 45, 34 ), 
		Vector2( 46, 34 ), Vector2( 47, 34 ), Vector2( 48, 34 ), Vector2( 49, 34 ), Vector2( 50, 34 ), 
		Vector2( 51, 34 ), Vector2( 52, 34 ), Vector2( 53, 34 ), Vector2( 54, 34 ), Vector2( 55, 34 ), 
		Vector2( 56, 34 ), Vector2( 57, 34 ), Vector2( 58, 34 ), Vector2( 59, 34 ), Vector2( 60, 34 ), 
		Vector2( 61, 34 ), Vector2( 62, 34 ), Vector2( 63, 34 ), Vector2( 64, 34 ), Vector2( 65, 34 ), 
		Vector2( 66, 34 ), Vector2( 67, 34 ), Vector2( 68, 34 ), Vector2( -1, 35 ), Vector2( 0, 35 ), 
		Vector2( 1, 35 ), Vector2( 2, 35 ), Vector2( 3, 35 ), Vector2( 4, 35 ), Vector2( 5, 35 ), 
		Vector2( 6, 35 ), Vector2( 7, 35 ), Vector2( 8, 35 ), Vector2( 9, 35 ), Vector2( 10, 35 ), 
		Vector2( 11, 35 ), Vector2( 12, 35 ), Vector2( 13, 35 ), Vector2( 14, 35 ), Vector2( 15, 35 ), 
		Vector2( 16, 35 ), Vector2( 17, 35 ), Vector2( 18, 35 ), Vector2( 19, 35 ), Vector2( 20, 35 ), 
		Vector2( 21, 35 ), Vector2( 22, 35 ), Vector2( 23, 35 ), Vector2( 24, 35 ), Vector2( 43, 35 ), 
		Vector2( 44, 35 ), Vector2( 45, 35 ), Vector2( 46, 35 ), Vector2( 47, 35 ), Vector2( 48, 35 ), 
		Vector2( 49, 35 ), Vector2( 50, 35 ), Vector2( 51, 35 ), Vector2( 52, 35 ), Vector2( 53, 35 ), 
		Vector2( 54, 35 ), Vector2( 55, 35 ), Vector2( 56, 35 ), Vector2( 57, 35 ), Vector2( 58, 35 ), 
		Vector2( 59, 35 ), Vector2( 60, 35 ), Vector2( 61, 35 ), Vector2( 62, 35 ), Vector2( 63, 35 ), 
		Vector2( 64, 35 ), Vector2( 65, 35 ), Vector2( 66, 35 ), Vector2( 67, 35 ), Vector2( 68, 35 ), 
		Vector2( -1, 36 ), Vector2( 0, 36 ), Vector2( 1, 36 ), Vector2( 2, 36 ), Vector2( 3, 36 ), 
		Vector2( 4, 36 ), Vector2( 5, 36 ), Vector2( 6, 36 ), Vector2( 7, 36 ), Vector2( 8, 36 ), 
		Vector2( 9, 36 ), Vector2( 10, 36 ), Vector2( 11, 36 ), Vector2( 12, 36 ), Vector2( 13, 36 ), 
		Vector2( 14, 36 ), Vector2( 15, 36 ), Vector2( 16, 36 ), Vector2( 17, 36 ), Vector2( 18, 36 ), 
		Vector2( 19, 36 ), Vector2( 20, 36 ), Vector2( 21, 36 ), Vector2( 22, 36 ), Vector2( 23, 36 ), 
		Vector2( 24, 36 ), Vector2( 29, 36 ), Vector2( 30, 36 ), Vector2( 31, 36 ), Vector2( 32, 36 ), 
		Vector2( 35, 36 ), Vector2( 36, 36 ), Vector2( 37, 36 ), Vector2( 38, 36 ), Vector2( 43, 36 ), 
		Vector2( 44, 36 ), Vector2( 45, 36 ), Vector2( 46, 36 ), Vector2( 47, 36 ), Vector2( 48, 36 ), 
		Vector2( 49, 36 ), Vector2( 50, 36 ), Vector2( 51, 36 ), Vector2( 52, 36 ), Vector2( 53, 36 ), 
		Vector2( 54, 36 ), Vector2( 55, 36 ), Vector2( 56, 36 ), Vector2( 57, 36 ), Vector2( 58, 36 ), 
		Vector2( 59, 36 ), Vector2( 60, 36 ), Vector2( 61, 36 ), Vector2( 62, 36 ), Vector2( 63, 36 ), 
		Vector2( 64, 36 ), Vector2( 65, 36 ), Vector2( 66, 36 ), Vector2( 67, 36 ), Vector2( 68, 36 ), 
		Vector2( -1, 37 ), Vector2( 0, 37 ), Vector2( 1, 37 ), Vector2( 2, 37 ), Vector2( 3, 37 ), 
		Vector2( 4, 37 ), Vector2( 5, 37 ), Vector2( 6, 37 ), Vector2( 7, 37 ), Vector2( 8, 37 ), 
		Vector2( 9, 37 ), Vector2( 10, 37 ), Vector2( 11, 37 ), Vector2( 12, 37 ), Vector2( 13, 37 ), 
		Vector2( 14, 37 ), Vector2( 15, 37 ), Vector2( 16, 37 ), Vector2( 17, 37 ), Vector2( 18, 37 ), 
		Vector2( 19, 37 ), Vector2( 20, 37 ), Vector2( 21, 37 ), Vector2( 22, 37 ), Vector2( 23, 37 ), 
		Vector2( 24, 37 ), Vector2( 29, 37 ), Vector2( 30, 37 ), Vector2( 31, 37 ), Vector2( 32, 37 ), 
		Vector2( 35, 37 ), Vector2( 36, 37 ), Vector2( 37, 37 ), Vector2( 38, 37 ), Vector2( 43, 37 ), 
		Vector2( 44, 37 ), Vector2( 45, 37 ), Vector2( 46, 37 ), Vector2( 47, 37 ), Vector2( 48, 37 ), 
		Vector2( 49, 37 ), Vector2( 50, 37 ), Vector2( 51, 37 ), Vector2( 52, 37 ), Vector2( 53, 37 ), 
		Vector2( 54, 37 ), Vector2( 55, 37 ), Vector2( 56, 37 ), Vector2( 57, 37 ), Vector2( 58, 37 ), 
		Vector2( 59, 37 ), Vector2( 60, 37 ), Vector2( 61, 37 ), Vector2( 62, 37 ), Vector2( 63, 37 ), 
		Vector2( 64, 37 ), Vector2( 65, 37 ), Vector2( 66, 37 ), Vector2( 67, 37 ), Vector2( 68, 37 ), 
		Vector2( -1, 38 ), Vector2( 0, 38 ), Vector2( 1, 38 ), Vector2( 2, 38 ), Vector2( 3, 38 ), 
		Vector2( 4, 38 ), Vector2( 5, 38 ), Vector2( 6, 38 ), Vector2( 7, 38 ), Vector2( 8, 38 ), 
		Vector2( 9, 38 ), Vector2( 10, 38 ), Vector2( 11, 38 ), Vector2( 12, 38 ), Vector2( 13, 38 ), 
		Vector2( 14, 38 ), Vector2( 15, 38 ), Vector2( 16, 38 ), Vector2( 17, 38 ), Vector2( 18, 38 ), 
		Vector2( 19, 38 ), Vector2( 20, 38 ), Vector2( 21, 38 ), Vector2( 22, 38 ), Vector2( 23, 38 ), 
		Vector2( 24, 38 ), Vector2( 29, 38 ), Vector2( 30, 38 ), Vector2( 31, 38 ), Vector2( 32, 38 ), 
		Vector2( 35, 38 ), Vector2( 36, 38 ), Vector2( 37, 38 ), Vector2( 38, 38 ), Vector2( 43, 38 ), 
		Vector2( 44, 38 ), Vector2( 45, 38 ), Vector2( 46, 38 ), Vector2( 47, 38 ), Vector2( 48, 38 ), 
		Vector2( 49, 38 ), Vector2( 50, 38 ), Vector2( 51, 38 ), Vector2( 52, 38 ), Vector2( 53, 38 ), 
		Vector2( 54, 38 ), Vector2( 55, 38 ), Vector2( 56, 38 ), Vector2( 57, 38 ), Vector2( 58, 38 ), 
		Vector2( 59, 38 ), Vector2( 60, 38 ), Vector2( 61, 38 ), Vector2( 62, 38 ), Vector2( 63, 38 ), 
		Vector2( 64, 38 ), Vector2( 65, 38 ), Vector2( 66, 38 ), Vector2( 67, 38 ), Vector2( 68, 38 ), 
		Vector2( -1, 39 ), Vector2( 0, 39 ), Vector2( 1, 39 ), Vector2( 2, 39 ), Vector2( 3, 39 ), 
		Vector2( 4, 39 ), Vector2( 5, 39 ), Vector2( 6, 39 ), Vector2( 7, 39 ), Vector2( 8, 39 ), 
		Vector2( 9, 39 ), Vector2( 10, 39 ), Vector2( 11, 39 ), Vector2( 12, 39 ), Vector2( 13, 39 ), 
		Vector2( 14, 39 ), Vector2( 15, 39 ), Vector2( 16, 39 ), Vector2( 17, 39 ), Vector2( 18, 39 ), 
		Vector2( 19, 39 ), Vector2( 20, 39 ), Vector2( 21, 39 ), Vector2( 22, 39 ), Vector2( 23, 39 ), 
		Vector2( 24, 39 ), Vector2( 25, 39 ), Vector2( 26, 39 ), Vector2( 27, 39 ), Vector2( 28, 39 ), 
		Vector2( 29, 39 ), Vector2( 30, 39 ), Vector2( 31, 39 ), Vector2( 32, 39 ), Vector2( 35, 39 ), 
		Vector2( 36, 39 ), Vector2( 37, 39 ), Vector2( 38, 39 ), Vector2( 39, 39 ), Vector2( 40, 39 ), 
		Vector2( 41, 39 ), Vector2( 42, 39 ), Vector2( 43, 39 ), Vector2( 44, 39 ), Vector2( 45, 39 ), 
		Vector2( 46, 39 ), Vector2( 47, 39 ), Vector2( 48, 39 ), Vector2( 49, 39 ), Vector2( 50, 39 ), 
		Vector2( 51, 39 ), Vector2( 52, 39 ), Vector2( 53, 39 ), Vector2( 54, 39 ), Vector2( 55, 39 ), 
		Vector2( 56, 39 ), Vector2( 57, 39 ), Vector2( 58, 39 ), Vector2( 59, 39 ), Vector2( 60, 39 ), 
		Vector2( 61, 39 ), Vector2( 62, 39 ), Vector2( 63, 39 ), Vector2( 64, 39 ), Vector2( 65, 39 ), 
		Vector2( 66, 39 ), Vector2( 67, 39 ), Vector2( 68, 39 ), Vector2( -1, 40 ), Vector2( 0, 40 ), 
		Vector2( 1, 40 ), Vector2( 2, 40 ), Vector2( 3, 40 ), Vector2( 4, 40 ), Vector2( 5, 40 ), 
		Vector2( 6, 40 ), Vector2( 7, 40 ), Vector2( 8, 40 ), Vector2( 9, 40 ), Vector2( 10, 40 ), 
		Vector2( 11, 40 ), Vector2( 12, 40 ), Vector2( 13, 40 ), Vector2( 14, 40 ), Vector2( 15, 40 ), 
		Vector2( 16, 40 ), Vector2( 17, 40 ), Vector2( 18, 40 ), Vector2( 19, 40 ), Vector2( 20, 40 ), 
		Vector2( 21, 40 ), Vector2( 22, 40 ), Vector2( 23, 40 ), Vector2( 24, 40 ), Vector2( 25, 40 ), 
		Vector2( 26, 40 ), Vector2( 27, 40 ), Vector2( 28, 40 ), Vector2( 29, 40 ), Vector2( 30, 40 ), 
		Vector2( 31, 40 ), Vector2( 32, 40 ), Vector2( 35, 40 ), Vector2( 36, 40 ), Vector2( 37, 40 ), 
		Vector2( 38, 40 ), Vector2( 39, 40 ), Vector2( 40, 40 ), Vector2( 41, 40 ), Vector2( 42, 40 ), 
		Vector2( 43, 40 ), Vector2( 44, 40 ), Vector2( 45, 40 ), Vector2( 46, 40 ), Vector2( 47, 40 ), 
		Vector2( 48, 40 ), Vector2( 49, 40 ), Vector2( 50, 40 ), Vector2( 51, 40 ), Vector2( 52, 40 ), 
		Vector2( 53, 40 ), Vector2( 54, 40 ), Vector2( 55, 40 ), Vector2( 56, 40 ), Vector2( 57, 40 ), 
		Vector2( 58, 40 ), Vector2( 59, 40 ), Vector2( 60, 40 ), Vector2( 61, 40 ), Vector2( 62, 40 ), 
		Vector2( 63, 40 ), Vector2( 64, 40 ), Vector2( 65, 40 ), Vector2( 66, 40 ), Vector2( 67, 40 ), 
		Vector2( 68, 40 ), Vector2( -1, 41 ), Vector2( 0, 41 ), Vector2( 1, 41 ), Vector2( 2, 41 ), 
		Vector2( 3, 41 ), Vector2( 4, 41 ), Vector2( 5, 41 ), Vector2( 6, 41 ), Vector2( 7, 41 ), 
		Vector2( 8, 41 ), Vector2( 9, 41 ), Vector2( 10, 41 ), Vector2( 11, 41 ), Vector2( 12, 41 ), 
		Vector2( 13, 41 ), Vector2( 14, 41 ), Vector2( 15, 41 ), Vector2( 16, 41 ), Vector2( 17, 41 ), 
		Vector2( 18, 41 ), Vector2( 19, 41 ), Vector2( 20, 41 ), Vector2( 21, 41 ), Vector2( 22, 41 ), 
		Vector2( 23, 41 ), Vector2( 24, 41 ), Vector2( 43, 41 ), Vector2( 44, 41 ), Vector2( 45, 41 ), 
		Vector2( 46, 41 ), Vector2( 47, 41 ), Vector2( 48, 41 ), Vector2( 49, 41 ), Vector2( 50, 41 ), 
		Vector2( 51, 41 ), Vector2( 52, 41 ), Vector2( 53, 41 ), Vector2( 54, 41 ), Vector2( 55, 41 ), 
		Vector2( 56, 41 ), Vector2( 57, 41 ), Vector2( 58, 41 ), Vector2( 59, 41 ), Vector2( 60, 41 ), 
		Vector2( 61, 41 ), Vector2( 62, 41 ), Vector2( 63, 41 ), Vector2( 64, 41 ), Vector2( 65, 41 ), 
		Vector2( 66, 41 ), Vector2( 67, 41 ), Vector2( 68, 41 ), Vector2( -1, 42 ), Vector2( 0, 42 ), 
		Vector2( 1, 42 ), Vector2( 2, 42 ), Vector2( 3, 42 ), Vector2( 4, 42 ), Vector2( 5, 42 ), 
		Vector2( 6, 42 ), Vector2( 7, 42 ), Vector2( 8, 42 ), Vector2( 9, 42 ), Vector2( 10, 42 ), 
		Vector2( 11, 42 ), Vector2( 12, 42 ), Vector2( 13, 42 ), Vector2( 14, 42 ), Vector2( 15, 42 ), 
		Vector2( 16, 42 ), Vector2( 17, 42 ), Vector2( 18, 42 ), Vector2( 19, 42 ), Vector2( 20, 42 ), 
		Vector2( 21, 42 ), Vector2( 22, 42 ), Vector2( 23, 42 ), Vector2( 24, 42 ), Vector2( 43, 42 ), 
		Vector2( 44, 42 ), Vector2( 45, 42 ), Vector2( 46, 42 ), Vector2( 47, 42 ), Vector2( 48, 42 ), 
		Vector2( 49, 42 ), Vector2( 50, 42 ), Vector2( 51, 42 ), Vector2( 52, 42 ), Vector2( 53, 42 ), 
		Vector2( 54, 42 ), Vector2( 55, 42 ), Vector2( 56, 42 ), Vector2( 57, 42 ), Vector2( 58, 42 ), 
		Vector2( 59, 42 ), Vector2( 60, 42 ), Vector2( 61, 42 ), Vector2( 62, 42 ), Vector2( 63, 42 ), 
		Vector2( 64, 42 ), Vector2( 65, 42 ), Vector2( 66, 42 ), Vector2( 67, 42 ), Vector2( 68, 42 ), 
		Vector2( -1, 43 ), Vector2( 0, 43 ), Vector2( 1, 43 ), Vector2( 2, 43 ), Vector2( 3, 43 ), 
		Vector2( 4, 43 ), Vector2( 5, 43 ), Vector2( 6, 43 ), Vector2( 7, 43 ), Vector2( 8, 43 ), 
		Vector2( 9, 43 ), Vector2( 10, 43 ), Vector2( 11, 43 ), Vector2( 12, 43 ), Vector2( 13, 43 ), 
		Vector2( 14, 43 ), Vector2( 15, 43 ), Vector2( 16, 43 ), Vector2( 17, 43 ), Vector2( 18, 43 ), 
		Vector2( 19, 43 ), Vector2( 20, 43 ), Vector2( 21, 43 ), Vector2( 22, 43 ), Vector2( 23, 43 ), 
		Vector2( 24, 43 ), Vector2( 25, 43 ), Vector2( 26, 43 ), Vector2( 27, 43 ), Vector2( 28, 43 ), 
		Vector2( 29, 43 ), Vector2( 30, 43 ), Vector2( 31, 43 ), Vector2( 32, 43 ), Vector2( 33, 43 ), 
		Vector2( 34, 43 ), Vector2( 35, 43 ), Vector2( 36, 43 ), Vector2( 37, 43 ), Vector2( 38, 43 ), 
		Vector2( 39, 43 ), Vector2( 40, 43 ), Vector2( 41, 43 ), Vector2( 42, 43 ), Vector2( 43, 43 ), 
		Vector2( 44, 43 ), Vector2( 45, 43 ), Vector2( 46, 43 ), Vector2( 47, 43 ), Vector2( 48, 43 ), 
		Vector2( 49, 43 ), Vector2( 50, 43 ), Vector2( 51, 43 ), Vector2( 52, 43 ), Vector2( 53, 43 ), 
		Vector2( 54, 43 ), Vector2( 55, 43 ), Vector2( 56, 43 ), Vector2( 57, 43 ), Vector2( 58, 43 ), 
		Vector2( 59, 43 ), Vector2( 60, 43 ), Vector2( 61, 43 ), Vector2( 62, 43 ), Vector2( 63, 43 ), 
		Vector2( 64, 43 ), Vector2( 65, 43 ), Vector2( 66, 43 ), Vector2( 67, 43 ), Vector2( 68, 43 ), 
		Vector2( -1, 44 ), Vector2( 0, 44 ), Vector2( 1, 44 ), Vector2( 2, 44 ), Vector2( 3, 44 ), 
		Vector2( 4, 44 ), Vector2( 5, 44 ), Vector2( 6, 44 ), Vector2( 7, 44 ), Vector2( 8, 44 ), 
		Vector2( 9, 44 ), Vector2( 10, 44 ), Vector2( 11, 44 ), Vector2( 12, 44 ), Vector2( 13, 44 ), 
		Vector2( 14, 44 ), Vector2( 15, 44 ), Vector2( 16, 44 ), Vector2( 17, 44 ), Vector2( 18, 44 ), 
		Vector2( 19, 44 ), Vector2( 20, 44 ), Vector2( 21, 44 ), Vector2( 22, 44 ), Vector2( 23, 44 ), 
		Vector2( 24, 44 ), Vector2( 25, 44 ), Vector2( 26, 44 ), Vector2( 27, 44 ), Vector2( 28, 44 ), 
		Vector2( 29, 44 ), Vector2( 30, 44 ), Vector2( 31, 44 ), Vector2( 32, 44 ), Vector2( 33, 44 ), 
		Vector2( 34, 44 ), Vector2( 35, 44 ), Vector2( 36, 44 ), Vector2( 37, 44 ), Vector2( 38, 44 ), 
		Vector2( 39, 44 ), Vector2( 40, 44 ), Vector2( 41, 44 ), Vector2( 42, 44 ), Vector2( 43, 44 ), 
		Vector2( 44, 44 ), Vector2( 45, 44 ), Vector2( 46, 44 ), Vector2( 47, 44 ), Vector2( 48, 44 ), 
		Vector2( 49, 44 ), Vector2( 50, 44 ), Vector2( 51, 44 ), Vector2( 52, 44 ), Vector2( 53, 44 ), 
		Vector2( 54, 44 ), Vector2( 55, 44 ), Vector2( 56, 44 ), Vector2( 57, 44 ), Vector2( 58, 44 ), 
		Vector2( 59, 44 ), Vector2( 60, 44 ), Vector2( 61, 44 ), Vector2( 62, 44 ), Vector2( 63, 44 ), 
		Vector2( 64, 44 ), Vector2( 65, 44 ), Vector2( 66, 44 ), Vector2( 67, 44 ), Vector2( 68, 44 ), 
		Vector2( -1, 45 ), Vector2( 0, 45 ), Vector2( 1, 45 ), Vector2( 2, 45 ), Vector2( 3, 45 ), 
		Vector2( 4, 45 ), Vector2( 5, 45 ), Vector2( 6, 45 ), Vector2( 7, 45 ), Vector2( 8, 45 ), 
		Vector2( 9, 45 ), Vector2( 10, 45 ), Vector2( 11, 45 ), Vector2( 12, 45 ), Vector2( 13, 45 ), 
		Vector2( 14, 45 ), Vector2( 15, 45 ), Vector2( 16, 45 ), Vector2( 17, 45 ), Vector2( 18, 45 ), 
		Vector2( 19, 45 ), Vector2( 20, 45 ), Vector2( 21, 45 ), Vector2( 22, 45 ), Vector2( 23, 45 ), 
		Vector2( 24, 45 ), Vector2( 25, 45 ), Vector2( 26, 45 ), Vector2( 27, 45 ), Vector2( 28, 45 ), 
		Vector2( 29, 45 ), Vector2( 30, 45 ), Vector2( 31, 45 ), Vector2( 32, 45 ), Vector2( 33, 45 ), 
		Vector2( 34, 45 ), Vector2( 35, 45 ), Vector2( 36, 45 ), Vector2( 37, 45 ), Vector2( 38, 45 ), 
		Vector2( 39, 45 ), Vector2( 40, 45 ), Vector2( 41, 45 ), Vector2( 42, 45 ), Vector2( 43, 45 ), 
		Vector2( 44, 45 ), Vector2( 45, 45 ), Vector2( 46, 45 ), Vector2( 47, 45 ), Vector2( 48, 45 ), 
		Vector2( 49, 45 ), Vector2( 50, 45 ), Vector2( 51, 45 ), Vector2( 52, 45 ), Vector2( 53, 45 ), 
		Vector2( 54, 45 ), Vector2( 55, 45 ), Vector2( 56, 45 ), Vector2( 57, 45 ), Vector2( 58, 45 ), 
		Vector2( 59, 45 ), Vector2( 60, 45 ), Vector2( 61, 45 ), Vector2( 62, 45 ), Vector2( 63, 45 ), 
		Vector2( 64, 45 ), Vector2( 65, 45 ), Vector2( 66, 45 ), Vector2( 67, 45 ), Vector2( 68, 45 ), 
		Vector2( -1, 46 ), Vector2( 0, 46 ), Vector2( 1, 46 ), Vector2( 2, 46 ), Vector2( 3, 46 ), 
		Vector2( 4, 46 ), Vector2( 5, 46 ), Vector2( 6, 46 ), Vector2( 7, 46 ), Vector2( 8, 46 ), 
		Vector2( 9, 46 ), Vector2( 10, 46 ), Vector2( 11, 46 ), Vector2( 12, 46 ), Vector2( 13, 46 ), 
		Vector2( 14, 46 ), Vector2( 15, 46 ), Vector2( 16, 46 ), Vector2( 17, 46 ), Vector2( 18, 46 ), 
		Vector2( 19, 46 ), Vector2( 20, 46 ), Vector2( 21, 46 ), Vector2( 22, 46 ), Vector2( 23, 46 ), 
		Vector2( 24, 46 ), Vector2( 25, 46 ), Vector2( 26, 46 ), Vector2( 27, 46 ), Vector2( 28, 46 ), 
		Vector2( 29, 46 ), Vector2( 30, 46 ), Vector2( 31, 46 ), Vector2( 32, 46 ), Vector2( 33, 46 ), 
		Vector2( 34, 46 ), Vector2( 35, 46 ), Vector2( 36, 46 ), Vector2( 37, 46 ), Vector2( 38, 46 ), 
		Vector2( 39, 46 ), Vector2( 40, 46 ), Vector2( 41, 46 ), Vector2( 42, 46 ), Vector2( 43, 46 ), 
		Vector2( 44, 46 ), Vector2( 45, 46 ), Vector2( 46, 46 ), Vector2( 47, 46 ), Vector2( 48, 46 ), 
		Vector2( 49, 46 ), Vector2( 50, 46 ), Vector2( 51, 46 ), Vector2( 52, 46 ), Vector2( 53, 46 ), 
		Vector2( 54, 46 ), Vector2( 55, 46 ), Vector2( 56, 46 ), Vector2( 57, 46 ), Vector2( 58, 46 ), 
		Vector2( 59, 46 ), Vector2( 60, 46 ), Vector2( 61, 46 ), Vector2( 62, 46 ), Vector2( 63, 46 ), 
		Vector2( 64, 46 ), Vector2( 65, 46 ), Vector2( 66, 46 ), Vector2( 67, 46 ), Vector2( 68, 46 ) 
		]
	
























