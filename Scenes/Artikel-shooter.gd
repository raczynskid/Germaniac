extends Node2D

var nouns = "res://Data/Nouns.csv"
var verbs = "res://Data/Verbs.csv"
var adjectives = "res://Data/Adjectives.csv"
var finished = false
@onready
var points : int = 0

@export
var limit : int

@onready
var data = LoadCsv.load_csv(nouns, limit + 1)
@onready
var rng = RandomNumberGenerator.new()
@onready
var der_box = $Control/HBoxContainer/der
@onready
var die_box = $Control/HBoxContainer/die
@onready
var das_box = $Control/HBoxContainer/das
@onready
var boxes = [der_box,die_box,das_box]

var positions = [{"free": true, "pos": [100,100]}, {"free": true, "pos": [100, 500]}, {"free": true, "pos": [100,900]},
				 {"free": true, "pos": [300,100]}, {"free": true, "pos": [300, 500]}, {"free": true, "pos": [300,900]},
				 {"free": true, "pos": [500,100]}, {"free": true, "pos": [500, 500]}, {"free": true, "pos": [500,900]}]


@onready
var NounBox = preload("res://Scenes/NounBox.tscn")
	
	
func _ready():
	Signals.point_add.connect(_point_add)
	Signals.point_remove.connect(_point_remove)
	Signals.noun_box_destroyed.connect(_box_destroyed)
	print(data.size())

func _process(delta):
	var time_remainig = snapped($TimeRemaining.time_left, 0)
	$Control/TimerLabel.text = "Time: " + str(time_remainig)

func get_random_lines(n : int):
	var random_lines = []
	for i in range(0,n):
		var random_number = rng.randi_range(1, data.size()-1)
		random_lines.append(data[random_number])
	return random_lines

func find_free_position():
	for position in positions:
		if position["free"]:
			position["free"] = false
			return [position, positions.find(position)]
		
func create_box():
	var position = find_free_position()
	if position and not finished:
		var noun_box = NounBox.instantiate()
		var lines = get_random_lines(1)[0]
		var grid_index = position[1]
		position = position[0]
		noun_box.grid_position = grid_index
		noun_box.noun = lines[1]
		noun_box.article = lines[0]
		noun_box.translation = lines[4]
		noun_box.global_position.y = position["pos"][0]
		noun_box.global_position.x = position["pos"][1]
		add_child(noun_box)
	
func _input(event):
	if Input.is_action_just_pressed("num1"):
		switch_article("der")
	elif Input.is_action_just_pressed("num2"):
		switch_article("die")
	elif Input.is_action_just_pressed("num3"):
		switch_article("das")

func _point_add():
	points += 1
	$Control/ScoreLabel.text = "Score: " + str(points)
	
func _point_remove():
	points -= 1
	$Control/ScoreLabel.text = "Score: " + str(points)
	
func switch_article(article):
	for box in boxes:
		box.modulate = Color(1,1,1)
	if article == "der":
		der_box.modulate = Color(0,1,0)
		Globals.active_article = "der"
		return
	if article == "die":
		die_box.modulate = Color(0,1,0)
		Globals.active_article = "die"
		return
	if article == "das":
		das_box.modulate = Color(0,1,0)
		Globals.active_article = "das"
		return
		
func _on_timer_timeout():
	create_box()

func _box_destroyed(grid_position):
	positions[grid_position]["free"] = true


func _on_time_remaining_timeout():
	finished = true
	$Control/Button.visible = true


func _on_restart_button_pressed():
	for position in positions:
		position["free"] = true
	$TimeRemaining.start()
	points = 0
	$Control/Button.visible = false
	finished = false
