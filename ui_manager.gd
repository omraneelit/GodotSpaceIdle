extends CanvasLayer

var money_label: Label
var phase_label: Label
var health_label: Label

func _ready():
    money_label = Label.new()
    money_label.position = Vector2(30, 30)
    money_label.add_theme_font_size_override("font_size", 48)
    money_label.add_theme_color_override("font_color", Color(1, 0.84, 0)) # Gold
    add_child(money_label)

    phase_label = Label.new()
    phase_label.position = Vector2(30, 90)
    phase_label.add_theme_font_size_override("font_size", 32)
    add_child(phase_label)
    
    health_label = Label.new()
    health_label.position = Vector2(30, 140)
    health_label.add_theme_font_size_override("font_size", 40)
    health_label.add_theme_color_override("font_color", Color.RED)
    add_child(health_label)

    GameManager.connect("money_changed", Callable(self, "_on_money_changed"))
    PhaseManager.connect("phase_changed", Callable(self, "_on_phase_changed"))
    GameManager.connect("health_changed", Callable(self, "_on_health_changed"))
    
    _on_money_changed(GameManager.money)
    _on_phase_changed(PhaseManager.current_phase)
    _on_health_changed(100)

func _on_money_changed(amount: int):
    money_label.text = "Credits: $" + str(amount)
    
func _on_phase_changed(phase: int):
    phase_label.text = "Current World: Phase " + str(phase + 1)
    
func _on_health_changed(hp: int):
    health_label.text = "HP: " + str(hp) + "/100"
