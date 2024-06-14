class_name VOSquare
extends TextureRect

const SS = Enum.SquareState
var x_pos = 0
var y_pos = 0
var sq_state = SS.NORMAL

func set_sq_state(state: SS):
	sq_state = state
	texture.update_texture_region(sq_state)

func set_pos(x, y):
	x_pos = x
	y_pos = y

func set_label_text(text: String):
	$NumLabel.text = text
