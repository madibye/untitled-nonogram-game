class_name Grid
extends GridContainer

const SS = Enum.SquareState
const RD = Enum.RowDirection

@export var sq_rows: int
@export var sq_cols: int

@onready var squares: Array[Square] = []
@onready var row_numbers = []
@onready var col_numbers = []
@onready var max_rn: int
@onready var max_cn: int
@onready var rows: int
@onready var board: Board

var sq_filled: int = 0
var curr_sq_filled: int = 0
	
static func new_grid(board: Board, rows: int, columns: int):
	var grid: Grid = Resources.grid_scene.instantiate()
	board.add_child(grid)
	grid.board = board
	grid.populate_squares(rows, columns)
	return grid

func _ready():
	Signals.finished.connect(_on_finish)
	Signals.sq_revealed.connect(_on_sq_revealed)
	await get_tree().process_frame
	pivot_offset = get_rect().size / 2
	
func _on_finish() -> void:
	get_tree().create_tween().tween_property(self, "modulate", Color("ffffff6b"), 0.6) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
		
func _on_sq_revealed(sq: Square):
	if not sq.is_filled: return
	curr_sq_filled += 1
	if curr_sq_filled >= sq_filled: board.finish("you won!! :D")
	
func populate_squares(r, c):
	set_grid_size(r, c)
	while squares.size() < (sq_rows*sq_cols):
		squares.append(Square.new_square(
			Vector2(squares.size() % sq_cols, floor(float(squares.size()) / float(sq_cols)))))
		if squares[-1].is_filled: sq_filled += 1
	
	row_numbers = range(sq_rows).map(generate_row_numbers.bind(RD.ROW))
	col_numbers = range(sq_cols).map(generate_row_numbers.bind(RD.COLUMN))
	max_rn = row_numbers.map(func(rn): return rn.size()).max()
	max_cn = col_numbers.map(func(rn): return rn.size()).max()
	rows = sq_rows + max_cn
	set_columns(columns + max_rn)
	
	for i in range(rows * columns):
		var pos = Vector2((i % columns) - max_rn, floor(float(i) / float(columns)) - max_cn)
		var sq = flatten_array([squares, row_numbers, col_numbers]).filter(func(s): return s.pos == pos)
		if not sq: sq.append(VOSquare.new_vo_square(pos))
		add_child(sq[0])
		
func set_grid_size(r, c) -> void:
	sq_rows = r
	sq_cols = c
	set_columns(c)
	
func get_squares_in_direction(row, row_dir):
	return squares.filter(func(sq: Square): 
		return ((sq.pos.x if row_dir == RD.COLUMN else sq.pos.y) == row))

func set_axis_from_rd(n: float, rd: RD, vector: Vector2 = Vector2()) -> Vector2:
	if rd == RD.ROW: vector.y = n
	else: vector.x = n
	return vector
	
func opp_row_dir(rd: RD):
	return RD.COLUMN if rd == RD.ROW else RD.ROW
	
func generate_row_numbers(row: int, row_dir: RD) -> Array:
	var rn = []
	var last_was_filled = false
	for sq in get_squares_in_direction(row, row_dir):
		if not sq.is_filled:
			last_was_filled = false
			continue
		if last_was_filled: rn[-1] += 1
		else: rn.push_back(1)
		last_was_filled = true
	if not rn: rn.push_back(0)
	var enum_offset = 4 if row_dir == RD.ROW else 0
	var rn_squares = rn.map(func(r): return VOSquare.new_vo_square(
		set_axis_from_rd(row, row_dir), SS.BLUE_LINES + enum_offset, str(r)))
	rn_squares[0].set_sq_state(SS.FADING_BLUE_LINES + enum_offset)
	rn_squares[-1].set_sq_state((SS.BOTTOM_FADING_BLUE_LINES if rn_squares.size() == 1 else \
								 SS.BOTTOM_BLUE_LINES) + enum_offset)
	for i in range(rn_squares.size()):
		rn_squares[i].pos = set_axis_from_rd(i - rn_squares.size(), opp_row_dir(row_dir), rn_squares[i].pos)
	return rn_squares
	
func find_square_from_pos(list, pos):
	return list.filter(func(i): return Vector2(i.x_pos, i.y_pos) == pos)

func flatten_array(list) -> Array:
	var ret_list = []
	for i in list:
		if i is Array:
			ret_list.append_array(flatten_array(i))
		else:
			ret_list.append(i)
	return ret_list
