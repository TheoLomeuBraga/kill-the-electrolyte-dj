@tool
extends Node3D


@export var fill : bool :
	get():
		return fill
	set(v):
		$botle/liquid.visible = v
		fill = v
