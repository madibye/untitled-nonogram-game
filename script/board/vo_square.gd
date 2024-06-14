class_name VOSquare
extends TextureRect

const SS = Enum.SquareState
var pos: Vector2
var sq_state = SS.NORMAL

func set_sq_state(state: SS):
	sq_state = state
	texture.update_texture_region(sq_state)

func set_label_text(text: String):
	$NumLabel.text = "[center][color=#000000]%s[/color][/center]" % text

static func new_vo_square(pos: Vector2, sq_state: SS = SS.BLANK, label_text: String = ""):
	var sq = Resources.vo_sq_scene.instantiate() as VOSquare
	sq.set_sq_state(sq_state)
	sq.pos = pos
	sq.set_label_text(label_text)
	return sq
