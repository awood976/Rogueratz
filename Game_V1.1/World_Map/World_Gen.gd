extends TileMap

# Declare member variables here.
var my_tiles = get_tileset()
var tile_block = my_tiles.find_tile_by_name("Block")
#var tile_ground = my_tiles.find_tile_by_name("Ground")
#var tile_wall_left = my_tiles.find_tile_by_name("Wall_Left")
#var tile_wall_right = my_tiles.find_tile_by_name("Wall_Right")
var tile_sky = my_tiles.find_tile_by_name("Sky")

onready var enemy = preload("res://Enemy.tscn")
onready var flyingenemy = preload("res://FlyingEnemy.tscn")
var number_of_enemys = 10
var number_of_flyingenemys = 10

var time = 0

var view_width = 64
var view_height = 42

# Called when the node enters the scene tree for the first time.
func _ready():
	time = OS.get_unix_time()
	
	#get generated map layouts from file
	var file = File.new()
	file.open("res://World_Map/map_layouts.txt", File.READ)
	var content = file.get_as_text()
	file.close()
#	print(content)
	
	var layout = get_layout(content)
	#get their tile types
	var tile_types = get_tile_types(layout)
#	print(tile_types)
	
	#place terrain
	var lay_count = 0
	var build_area
	#set up map layout
	for y_layout in range(4):
		for x_layout in range(4):
			build_area = bool(int(layout[lay_count]))
			if build_area:
				#detect tile type
				#import proper file
				var fil = File.new()
				
				var views = []
				var filename = "res://World_Map/Views/"
				var dir = Directory.new()
				if dir.open(filename) == OK:
					dir.list_dir_begin()
					var file_name = dir.get_next()
					while (file_name != ""):
						if dir.current_is_dir():
#							print("Found directory: " + file_name)
							pass
						else:
#							print("Found file: " + file_name)
							views.append(file_name)
						file_name = dir.get_next()
				else:
					print("An error occurred when trying to access the path.")
#				fil.open("res://World_Map/Views/"+views[0], File.READ)
#TEMP
				fil.open("res://World_Map/Views/"+tile_types[lay_count]+"_0.txt", File.READ)

#				fil.open("res://World_Map/Views/pixil-frame-0.txt", File.READ)
#				print(fil.is_open())
				var view = fil.get_as_text()
				fil.close()
				#load tile
				var tile_cursor = 0
#				print(view)
				for y in range(view_height):
					for x in range(view_width):
						if bool(int(view[tile_cursor])):
							set_cellv(Vector2(x+(x_layout*view_width),y+(y_layout*view_height)),tile_block)
						else:
							set_cellv(Vector2(x+(x_layout*view_width),y+(y_layout*view_height)),tile_sky)
						tile_cursor = tile_cursor + 1
					#Skip newline characters
					tile_cursor = tile_cursor + 1
			lay_count = lay_count + 1
	
	#Once map is loaded, load player
	var player = load("res://Player.tscn")
	var player_node = player.instance()	
	player_node.global_position = (get_valid_random_positon())
	add_child(player_node)	
	# add 10 enemys 10 flyingenemys
	add_enemy()
	add_flyingenemy()

func get_valid_random_positon():
	randomize()
	var valid_spawn = false
	var spawn_location = Vector2(0,0)
	while not valid_spawn:
		var x = randi()%400+20			
		var y = randi()%400+20	
		spawn_location = Vector2(x,y)
		if get_cellv(spawn_location) == tile_sky and get_cellv(spawn_location+Vector2(0,-1)) == tile_sky:
			valid_spawn = true
		spawn_location *= 16
		pass
		
	print("Spawning at: "+str(spawn_location))
	return spawn_location

func respawn_enemy():
	
	pass

func respawn_flyingenemy():
	
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var curr_time = OS.get_unix_time()
#	if  curr_time != time:
#		time = curr_time
#		#use function for spawn rate
#		var enemy = load("res://Enemy.tscn")
#		var enemy_instance = enemy.instance()
#	#	var valid_spawn = false
#		var valid_spawn = false
#		var spawn_location = Vector2(0,0)
#		while not valid_spawn:
#			var pick1 = randi()%400+20			#pick num between 0-199
#			var pick2 = randi()%400+20			#pick num between 0-199
#			spawn_location = Vector2(pick1,pick2)
#			if get_cellv(spawn_location) == tile_sky and get_cellv(spawn_location+Vector2(0,-1)) == tile_sky:
#				valid_spawn = true
#			spawn_location *= 16
#			pass
#		print("Spawning enemy at: "+str(spawn_location))
#		enemy_instance.global_position = (spawn_location)
#		add_child(enemy_instance)
		
	pass

func add_enemy():
	while number_of_enemys > 0:			
		var enemy = load("res://Enemy.tscn")
		
		var new_enemy = enemy.instance()
		new_enemy.global_position = (get_valid_random_positon())
		add_child(new_enemy)
		number_of_enemys = number_of_enemys - 1
		
func add_flyingenemy():
	while number_of_flyingenemys > 0:		
		var flyingenemy = load("res://FlyingEnemy.tscn")	
		var new_flyingenemy = flyingenemy.instance()
		new_flyingenemy.global_position = (get_valid_random_positon())
		add_child(new_flyingenemy)
		number_of_flyingenemys = number_of_flyingenemys - 1
	
func get_layout(content):
	#select a line and save it to an array
	var pick
	randomize()					#use random numbers
	pick = randi()%100			#pick num between 0-99
	var line_start = pick*17	#get index of chosen line start
	var layout = []
	layout.resize(16)
	var tmp = 0
	for i in range(line_start,line_start+16):
		layout[tmp] = int(content[i])
		tmp = tmp + 1
	print("Layout: ",layout)
	return layout

func get_tile_types(list):
	#Formulate and return a list of extensions that define the walls of each tile
	var return_list = []
	for i in range(len(list)):
		var extension = "b"
		#Check North
		if ((i-4) < 0) or (list[i-4] == 0):
			extension = extension + "n"
		#Check East
		if (int(fmod(i+1,4)) == 0) or (list[i+1] == 0):
			extension = extension + "e"
		#Check South
		if ((i+4) > 15) or (list[i+4] == 0):
			extension = extension + "s"
		#Check West
		if (int(fmod(i,4)) == 0) or (list[i-1] == 0):
			extension = extension + "w"
		return_list.append(extension)
	return return_list
		