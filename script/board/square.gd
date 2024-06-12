class_name Square
extends TextureButton

enum SquareState {NORMAL, X_MARKED, O_MARKED, REVEALED, FADING_BLUE_LINES, BLUE_LINES, BOTTOM_BLUE_LINES, 
				  BOTTOM_FADING_BLUE_LINES, SIDE_FADING_BLUE_LINES, SIDE_BLUE_LINES, SIDE_BOTTOM_BLUE_LINES, 
				  SIDE_BOTTOM_FADING_BLUE_LINES, BLANK}

var x_pos = 0
var y_pos = 0

var is_filled = bool(randi() % 2)
@onready var revealed = false
@onready var sq_state = SquareState.NORMAL

func _on_gui_input(event: InputEvent):
	if (x_pos < 0 or y_pos < 0) or (
		not event is InputEventMouseButton) or (
		not event.pressed
	):
		return
	set_sq_state({
		1: sq_state if not is_filled else SquareState.REVEALED, 2: SquareState.X_MARKED,
	}.get(event.button_index, SquareState.O_MARKED) if sq_state <= SquareState.O_MARKED else sq_state)

func set_sq_state(state: SquareState):
	sq_state = state
	update_texture_region()
	
func set_pos(x, y):
	x_pos = x
	y_pos = y

func update_texture_region():
	# All of the texture mapping math happens here.
	var region_size: Vector2 = texture_normal.region.size
	var atlas_size: Vector2 = texture_normal.atlas.get_size()
	texture_normal.region = Rect2(
		int(sq_state * region_size.x) % int(atlas_size.x), 
		floor((sq_state * region_size.x) / atlas_size.x) * region_size.x, 
		region_size.x, region_size.y)

func set_label_text(text: String):
	$NumLabel.text = text
	
