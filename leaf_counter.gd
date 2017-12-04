extends Panel

signal lose_game
signal hard_mode

# onready var leaf_counter_label = get_node("VBoxContainer/leaf_counter/Label")
onready var respite_label = get_node("VBoxContainer/Panel/respite_length/Label")

const max_respite_length = 30
var respite_length = 30
var respite_active = false

var leaf_count = 0
var lose_count = 150
var lost = false
var quit_count = 200

func _ready():
	set_process(true)
	update_respite_text()

func _process(delta):
	add_to_group("respite_listener")
	
	leaf_count = 0
	for leaf in get_tree().get_nodes_in_group("leaf"):
		if leaf.has_hit_the_ground():
			leaf_count += 1
	# var text = "Leaf Count: %s / %s" % [str(leaf_count), str(lose_count)]
	# leaf_counter_label.set_text(text)
	var percent = float(leaf_count) / lose_count * 100.0
	get_node("TextureProgress").set_value(percent)
	
	if respite_active:
		# respite_length = clamp(max_respite_length - int(sqrt(leaf_count)), 0, max_respite_length)
		update_respite_text()
	
	if leaf_count > lose_count and not lost:
		emit_signal("lose_game")
		lost = true
	
	if leaf_count > quit_count:
		get_tree().change_scene("res://game.tscn")

func update_respite_text():
	var respite_text = "Length of Next Respite: " + str(respite_length)
	respite_label.set_text(respite_text)

func get_leaf_count():
	return leaf_count

func get_next_respite_length():
	return respite_length

func respite_start():
	respite_active = true

func respite_end():
	respite_active = false

func modify_next_respite(amount):
	respite_length += amount
	if respite_length <= 0:
		emit_signal("hard_mode")
	respite_length = clamp(respite_length, 1, max_respite_length)
	update_respite_text()

