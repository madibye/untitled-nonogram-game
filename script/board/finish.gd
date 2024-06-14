class_name FinishScreen
extends Control

func set_label_text(text: String):
	$PanelContainer/RichTextLabel.text = text

func _on_button_pressed():
	var game: Game = get_tree().current_scene
	game.change_scene(TitleScreen.new_title_screen())
