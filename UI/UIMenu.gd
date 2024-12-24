extends Node2D
class_name UIMenu


@export var buttons : Node2D
var manger : UIManger
var selected = true
var curselect = 0
var curbut

func _ready() -> void:
	curbut = buttons.get_children()[0]
	curbut.select()

func _physics_process(delta: float) -> void:
	visible = selected

func _input(event: InputEvent) -> void:
	if(not selected or not is_visible_in_tree()):
		return
	if(buttons.get_child_count() > 1):
		if(Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_left")):
			curselect += 1
		elif(Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_right")):
			curselect -= 1
		else:
			return
		if(curselect < 0):
			curselect += buttons.get_child_count()
		curselect %= buttons.get_child_count()
		
		curbut.unselect()
		
		buttons.get_children()[curselect].select()
		curbut = buttons.get_children()[curselect]


func killyourself():
	get_parent().remove_child(self)
	queue_free()
