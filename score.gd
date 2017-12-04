extends Label

var score = 0

func _ready():
	add_to_group("leaf_death")
	update_score()

func leaf_death():
	score += 1
	update_score()

func update_score():
	set_text("Score: " + str(score))

