class_name FinishScreen
extends Control

@onready var game: Game

static func new_finish_screen(board: Board, text) -> FinishScreen:
	var finish = Resources.finish_scene.instantiate() as FinishScreen
	finish.set_label_text("[center]%s[/center]" % text)
	board.add_child(finish)
	finish.game = board.game
	finish.fade_in()
	return finish

func set_label_text(text: String):
	$PanelContainer/RichTextLabel.text = text

func _on_button_pressed():
	game.change_scene(TitleScreen.new_title_screen(game))

func fade_in():
	get_tree().create_tween().tween_property(self, "modulate", Color("ffffffff"), 0.6)
