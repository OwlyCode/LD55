extends HSlider

var _bus := AudioServer.get_bus_index("Master")

func _ready() -> void:
	value = db_to_linear(GlobalState.master_sound)
	apply()

func _on_value_changed(v: float) -> void:
	GlobalState.master_sound = linear_to_db(v)
	apply()
	release_focus()

func apply() -> void:
	AudioServer.set_bus_volume_db(_bus, GlobalState.master_sound)