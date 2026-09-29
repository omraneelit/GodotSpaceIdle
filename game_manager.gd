extends Node

var money: int = 0
signal money_changed(new_amount)
signal health_changed(new_hp)

func _ready():
    print("Godot Game Manager Initialized!")

func update_health_ui(hp: int):
    health_changed.emit(hp)

func shake_camera(amount: float = 0.5):
    var cam = get_tree().get_root().find_child("MainCamera", true, false)
    if cam and cam.has_method("add_trauma"):
        cam.add_trauma(amount)

func add_money(amount: int):
    money += amount
    money_changed.emit(money)
    print("Bank: $", money)

func spend_money(amount: int) -> bool:
    if money >= amount:
        money -= amount
        money_changed.emit(money)
        return true
    return false

func spawn_floating_text(pos: Vector3, text: String, color: Color = Color.GREEN):
    var ft = load("res://floating_text.gd").new()
    ft.text = text
    ft.position = pos
    if color != Color.GREEN:
        ft.modulate = color
    get_tree().get_root().add_child(ft)
