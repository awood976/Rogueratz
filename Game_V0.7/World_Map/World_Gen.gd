extends TileMap

# Declare member variables here.
var my_tiles = get_tileset()
var tile_block = my_tiles.find_tile_by_name("Block")
var tile_ground = my_tiles.find_tile_by_name("Ground")
var tile_wall_left = my_tiles.find_tile_by_name("Wall_Left")
var tile_wall_right = my_tiles.find_tile_by_name("Wall_Right")
var tile_sky = my_tiles.find_tile_by_name("Sky")

# Called when the node enters the scene tree for the first time.
func _ready():
	#get generated map layouts from file
	var file = File.new()
	file.open("res://World_Map/map_layouts.txt", File.READ)
	var content = file.get_as_text()
	file.close()
#	print(content)
	
	#select a line and save it to an array
	var pick
	randomize()					#use random numbers
	pick = randi()%100			#pick num between 0-99
	var line_start = pick*17	#get index of chosen line start
	var layout = []
	layout.resize(16)
	var tmp = 0
	for i in range(line_start,line_start+16):
		layout[tmp] = content[i]
		tmp = tmp + 1
	print("Layout: ",layout)
	
	#place terrain
	var lay_count = 0
	var build_area
	#set up map layout
	for y in range(4):
		for x in range(4):
			build_area = bool(int(layout[lay_count]))
			if build_area:
				#set up 
				set_cellv(Vector2(x,y),tile_block)
			#else:
				#set_cellv(Vector2(x,y),tile_sky)
			lay_count = lay_count + 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
