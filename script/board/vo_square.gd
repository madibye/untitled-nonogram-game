class_name VOSquare
extends TextureRect

const SS = Enum.SquareState
var pos: Vector2
var sq_state = SS.NORMAL

static func new_vo_square(p: Vector2, ss: SS = SS.BLANK, label_text: String = ""):
	var sq = Resources.vo_sq_scene.instantiate() as VOSquare
	sq.set_sq_state(ss)
	sq.pos = p
	sq.set_label_text(label_text)
	return sq

func set_sq_state(state: SS):
	sq_state = state
	texture.update_texture_region(sq_state)

func set_label_text(text: String):
	$NumLabel.text = "[center][color=#000000]%s[/color][/center]" % text
