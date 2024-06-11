class_name Square
extends TextureButton

enum SquareState {
	NORMAL = 0,
	X_MARKED = 16,
	O_MARKED = 32,
	REVEALED = 48,
}

var x_pos = 0
var y_pos = 0

@onready var filled = false
@onready var revealed = false
@onready var sq_state = SquareState.NORMAL

# Called when the node enters the scene tree for the first time.
func _ready():
	var texture = load("res://tex/squares.png") as Texture2D
	texture_normal = AtlasTexture.new()
	texture_normal.set_atlas(texture)
	update_texture_region()
	
func _on_gui_input(event: InputEvent):
	if not event is InputEventMouseButton or (
		not event.pressed
	):
		return
	print(event)
	set_sq_state({
		1: SquareState.NORMAL if sq_state == SquareState.REVEALED else SquareState.REVEALED,
		2: SquareState.X_MARKED,
	}.get(event.button_index, SquareState.O_MARKED))

func set_sq_state(state: SquareState):
	sq_state = state
	update_texture_region()
	
func set_pos(x, y):
	x_pos = x
	y_pos = y

func update_texture_region():
	texture_normal.region = Rect2(sq_state, 0, 16, 16)
