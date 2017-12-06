extends Node2D

# Fonts:
#   leaf counter is Godot's default label font
#   Game Start and Game Over banners are aseprite-rendered LiberationSansNarrow-Regular

var respite_trigger_count = 60
onready var respite_countdown = get_node("respite_countdown")

var leaf_scene = preload("res://leaf/leaf.tscn")

var dims = Vector2(Globals.get("display/width"), Globals.get("display/height"))
onready var wind = get_node("wind")

onready var ysort = get_node("YSort")
onready var rock_sprite = get_node("YSort/rock")

onready var game_over_banner = get_node("CanvasLayer/Panel/VBoxContainer/banner_panel/CenterContainer/Panel/game_over")
onready var game_start_banner = get_node("CanvasLayer/Panel/VBoxContainer/banner_panel/CenterContainer/Panel/game_start")
onready var score = get_node("score")

onready var leaf_spawn_timer = get_node("leaf_spawn_timer")
onready var respite_timer = get_node("respite_timer")
onready var leaf_counter = get_node("leaf_counter")
var total_leaves = 0
var in_respite = false
var game_lost = false

var leaf_death_counter = 0


func _ready():
	get_node("leaf_spawn_timer").connect("timeout", self, "new_leaf")
	leaf_counter.connect("lose_game", self, "lose_game")
	
	get_node("CanvasLayer/AnimationPlayer").play("title_fade")
	
	respite_countdown.hide()
	
	set_process_unhandled_input(true)
	
	set_process(true)
	
	add_to_group("laser_fire")
	add_to_group("leaf_death")
	
	leaf_counter.connect("hard_mode", leaf_spawn_timer, "set_wait_time", [0.05])



func _process(delta):
	if total_leaves >= respite_trigger_count and not in_respite and not game_lost:
		in_respite = true
		leaf_spawn_timer.stop()
		respite_countdown.show()
		print("starting respite")
		respite_timer.set_wait_time(leaf_counter.get_next_respite_length())
		respite_timer.start()
		get_tree().call_group(0, "respite_listener", "respite_start")
		
		yield(respite_timer, "timeout")
		
		get_tree().call_group(0, "respite_listener", "respite_end")
		respite_trigger_count += 10
		leaf_spawn_timer.start()
		total_leaves = 0
		in_respite = false
		rock_sprite.set_modulate(Color(1,1,1,1))
		respite_countdown.hide()
	elif in_respite:
		var total_time = respite_timer.get_wait_time()
		var time_remaining = respite_timer.get_time_left()
		var percent = time_remaining / float(total_time)
		var fish = lerp(0.3, 1, percent)
		rock_sprite.set_modulate(Color(1,1,1,fish))
		respite_countdown.set_text("%2.0f" % respite_timer.get_time_left())

func laser_start():
	respite_trigger_count += 20
	leaf_counter.modify_next_respite(-5)

func laser_end():
	pass

func leaf_death():
	leaf_death_counter += 1
	if (leaf_death_counter % 20) == 0:
		leaf_counter.modify_next_respite(1)
		leaf_death_counter = 0

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		get_tree().change_scene("res://main_menu.tscn")

func new_leaf():
	var inst = leaf_scene.instance()
	inst.set_dims(dims)
	inst.set_wind(wind)
	ysort.add_child(inst)
	total_leaves += 1

func lose_game():
	if not game_lost:
		game_lost = true
		game_over_banner.show()
		in_respite = false
		#leaf_spawn_timer.stop()
		#leaf_spawn_timer.set_wait_time(0.05)
		leaf_spawn_timer.start()
		wind.lose_game()
		score.stop()
		
		#for leaf in get_tree().get_nodes_in_group("leaf"):
		#	var pos = leaf.get_pos()
		#	pos.y -= 200
		#	leaf.set_pos(pos)
	
	
