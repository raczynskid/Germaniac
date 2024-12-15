extends Node2D

var nouns = "res://Data/Nouns.csv"
var verbs = "res://Data/Verbs.csv"
var adjectives = "res://Data/Adjectives.csv"
var finished = true
@onready
var points : int = 0

@export
var limit : int

@onready
var difficulties = [50, 100, 500, 1000, 2000, 3000]

@onready
var data = LoadCsv.load_csv(verbs, limit + 1)
