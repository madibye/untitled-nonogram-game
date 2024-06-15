class_name TitleScreen
extends Control

@onready var title_label: RichTextLabel = $Title
@onready var splash_label: RichTextLabel = $SplashText
@onready var row_sb: SpinBox = $RowSpinBox
@onready var col_sb: SpinBox = $ColSpinBox
@onready var game: Game

static func new_title_screen(game: Game) -> TitleScreen:
	var title = Resources.title_scene.instantiate() as TitleScreen
	title.game = game
	return title

func _ready():
	var tween = get_tree().create_tween()
	var start_scale = splash_label.scale
	tween.set_loops()
	tween.tween_property(splash_label, "scale", start_scale * 1.1, 0.7).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(splash_label, "scale", start_scale, 0.7).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	
func _process(_delta):
	splash_label.pivot_offset = splash_label.size / 2

func _on_start_button_pressed():
	var board = Board.new_board(game, row_sb.value, col_sb.value, 5)
	game.change_scene(board)
