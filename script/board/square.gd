class_name Square
extends TextureButton

const SS = Enum.SquareState

var pos: Vector2

var is_filled = bool(randi() % 2)
@onready var revealed = false
@onready var sq_state = SS.NORMAL
var clickable = true

static func new_square(p: Vector2) -> Square:
	var sq = Resources.sq_scene.instantiate() as Square
	sq.pos = p
	return sq

func _init():
	texture_normal = Resources.sq_tex.duplicate() as SquareTexture
	
func _ready():
	Signals.finished.connect(func(): clickable = false)
	if self in get_parent().auto_reveal_squares: self.reveal()

func _on_gui_input(event: InputEvent):
	if (not event is InputEventMouseButton) or (not event.pressed) or (not clickable) or (revealed): return
	if event.button_index == 1: return reveal(true)
	var mark = {2: SS.X_MARKED, 8: SS.O_MARKED, 9: SS.O_MARKED}.get(event.button_index, SS.NORMAL)
	return toggle_mark(mark)
		
func reveal(from_click: bool = false):
	revealed = true
	Signals.sq_revealed.emit(self)
	if not is_filled:
		if from_click: Signals.damage_taken.emit(1)
		return set_sq_state(SS.REVEALED_X)
	return set_sq_state(SS.REVEALED)
	
func toggle_mark(state):
	if revealed: return
	var toggle_state = func toggle_state(sq_state_a, sq_state_b):
		return sq_state_a if sq_state != sq_state_a else sq_state_b
	set_sq_state(toggle_state.call(state, SS.NORMAL))

func set_sq_state(state: SS):
	sq_state = state
	texture_normal.update_texture_region(sq_state)
