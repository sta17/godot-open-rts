@icon("res://assets/icons/Stevens/Godot Editor Icons/Gear.png")
extends Node

@export_group("Game")
@export var show_logos_on_startup = false
@export var save_user_files_in_tmp = false

@export_group("Match")
@export var allow_resources_deficit_spending = false
@export var handle_match_end = true
@export var show_minimap = true
@export var allow_navigation_rebaking = true

@export_group("Match/Debug")
@export var frame_incrementer = true
@export var god_mode = true
