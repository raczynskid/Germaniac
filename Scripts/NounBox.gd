extends Control

var noun : String = "Spiel"
var article : String = "das"
var translation : String = "Game"
@onready
var destruction_timer = $Timer
@onready
var button = $Control/CenterContainer/Button
@onready
var grid_position : int
var last_click


func _ready():
	button.text = noun


func check_answer():
	if Globals.active_article.to_lower() == article.to_lower():
		success()
	else:
		fail()

func check_translation():
	button.text = translation

func success():
	Signals.point_add.emit()
	self.modulate = Color(0, 1, 0)
	destroy()
	
func fail():
	Signals.point_remove.emit()
	self.modulate = Color(1, 0, 0)
	destroy()

func destroy():
	destruction_timer.start()
	$GPUParticles2D.emitting = true
	$Control/CorrectAnswerLabel.text = article
	

func _on_timer_timeout():
	queue_free()
	Signals.noun_box_destroyed.emit(grid_position)


func _on_button_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				MOUSE_BUTTON_LEFT:
					check_answer()
				MOUSE_BUTTON_RIGHT:
					check_translation()
		else:
			button.text = noun
