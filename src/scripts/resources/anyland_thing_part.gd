class_name AnylandThingPartResource
extends Resource


@export var base_shape_type: int; # Base shape type
@export var material_type: int; # Material type

@export var attributes: Array[int]; ## Thing part attributes
@export var unique_part_id: String; ## Optional unique part identifier

@export var states: Array[ThingStateResource]; ## States of the Thing
