class_name Grid
extends GridContainer

const SS = Enum.SquareState
const RD = Enum.RowDirection

@export var sq_rows: int
@export var sq_cols: int

@onready var squares: Array[Square] = []
@onready var row_numbers = []
@onready var col_numbers = []
@onready var rows: int

func _ready():
	pivot_offset = get_rect().size / 2
	
func populate_squares(r, c):
	set_grid_size(r, c)
	while squares.size() < (sq_rows*sq_cols):
		squares.append(make_square(squares.size() % sq_cols, floor(float(squares.size()) / float(sq_cols))))
	
	row_numbers = range(sq_rows).map(generate_row_numbers.bind(RD.ROW))
	col_numbers = range(sq_cols).map(generate_row_numbers.bind(RD.COLUMN))
	var max_rn = row_numbers.map(func(rn): return rn.size()).max()
	var max_cn = col_numbers.map(func(rn): return rn.size()).max()
	rows = sq_rows + max_cn
	set_columns(columns + max_rn)
	
	for i in range(rows * columns):
		var pos = Vector2((i % columns) - max_rn, floor(float(i) / float(columns)) - max_cn)
		var filtered = flatten_array([squares, row_numbers, col_numbers]).filter(func(s): return Vector2(s.x_pos, s.y_pos) == pos)
		var sq
		if filtered: sq = filtered[0]
		else: sq = make_vo_square(pos.x, pos.y)
		add_child(sq)
		move_child(sq, i)
	
func make_square(x_pos: int, y_pos: int) -> Square:
	var sq = Resources.sq_scene.instantiate() as Square
	sq.set_pos(x_pos, y_pos)
	return sq
	
func make_vo_square(x_pos: int, y_pos: int, sq_state: SS = SS.BLANK, label_text: String = "") -> VOSquare:
	var sq = Resources.vo_sq_scene.instantiate() as VOSquare
	sq.set_sq_state(sq_state)
	sq.set_pos(x_pos, y_pos)
	sq.set_label_text(label_text)
	return sq

func set_grid_size(r, c) -> void:
	sq_rows = r
	sq_cols = c
	set_columns(c)
	
func get_squares_in_direction(row, row_dir):
	return squares.filter(func(sq: Square): 
		return sq.get('%s_pos' % get_axis_from_rd_opposite(row_dir)) == row)
 		
func get_axis_from_rd(row_dir: RD):
	return {RD.ROW: 'y', RD.COLUMN: 'x'}.get(row_dir)
	
func get_axis_from_rd_opposite(row_dir: RD):
	return {RD.ROW: 'x', RD.COLUMN: 'y'}.get(row_dir)
	
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
	if not rn:
		rn.push_back(0)
	var enum_offset = 4 if row_dir == RD.COLUMN else 0
	var rn_squares = rn.map(func(r): 
		var sq = make_vo_square(0, 0, SS.BLUE_LINES + enum_offset, "[center][color=#000000]%s[/color][/center]" % r)
		sq.set('%s_pos' % get_axis_from_rd_opposite(row_dir), row)
		return sq
	)
	rn_squares[0].set_sq_state(SS.FADING_BLUE_LINES + enum_offset)
	rn_squares[-1].set_sq_state((SS.BOTTOM_FADING_BLUE_LINES if rn_squares.size() == 1 else \
								 SS.BOTTOM_BLUE_LINES) + enum_offset)
	for i in range(rn_squares.size()):
		rn_squares[i].set('%s_pos' % get_axis_from_rd(row_dir), i - rn_squares.size())
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
	
static func new_grid(rows: int, columns: int):
	var grid: Grid = Resources.grid_scene.instantiate()
	grid.populate_squares(rows, columns)
	return grid
