extends Area2D
tool

export(Texture) var icon setget set_icon
export(Vector2) var offset setget set_offset
export(bool) var label_enabled setget set_label_enabled
export(String) var label_text = "" setget set_label_text

func set_icon(value : Texture):
	icon = value
	$IconSprite.set_texture(icon)

func set_offset(value : Vector2):
	offset = value
	$IconSprite.set_offset(offset)

func set_label_enabled(value : bool):
	label_enabled = value
	$LabelSprite.visible = value

func set_label_text(value : String):
	label_text = value
	$LabelSprite/CenterContainer/Label.set_text(label_text)