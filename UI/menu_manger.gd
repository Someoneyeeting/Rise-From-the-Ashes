extends Node2D
class_name UIManger

var curmenu
var menus = {
	"main" : preload("res://UI/MainMenu.tscn"),
	"times" : preload("res://vectoryScene.tscn"),
	"confirm" : preload("res://UI/confirm.tscn"),
	"note" : preload("res://UI/note.tscn")
}
@export var startmenu := true

func _ready() -> void:
	open_menu("main")
	if("web" in OS.get_name().to_lower()):
		open_menu("note")

func open_menu(menu):
	var men = menus[menu].instantiate()
	if($menus.get_child_count() > 0):
		$menus.get_children().back().selected = false
		$menus.get_children().back().hide()
	men.selected = true
	men.manger = self
	$menus.add_child(men)
	

func close_current():
	$menus.get_children().back().killyourself()
	if($menus.get_children().size() > 0):
		$menus.get_children()[-1].set_deferred("selected",true)
	#$menus.get_children()[.].show()
	
func close_menu():
	get_parent().remove_child(self)
	queue_free()
