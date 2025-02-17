class_name Dialogue extends Label3D

const LINE_DURATION = 0.5
const TYPE_SPEED = 0.02

signal type_letter(letter: String)

@export var dialogue: DialogueResource

@onready var player: AudioStreamPlayer3D = $AudioStreamPlayer3D

var target_text = ""
var typewriter_timer = 0.0
var line_index = 0
var line_timer = 0.0

func change_text(new_text: String) -> void:
	target_text = new_text

func _process(delta: float) -> void:
	# typewriter effect
	if typewriter_timer >= TYPE_SPEED:
		typewriter_timer = 0.0

		if len(text) < len(target_text):
			text += target_text[text.length()]
			var typed_letter = target_text[text.length() - 1]
			type_letter.emit(typed_letter)

			if dialogue.sounds.get(typed_letter):
				player.stream = dialogue.sounds.get(typed_letter)
				player.play()
		elif len(text) > len(target_text):
			text = text.substr(0, text.length() - 1)
	else:
		typewriter_timer += delta

func enable() -> void:
	line_index = 0
	target_text = dialogue.lines[line_index].text

func disable() -> void:
	line_index = 0
	target_text = ""
