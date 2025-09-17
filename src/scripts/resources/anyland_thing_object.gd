class_name AnylandThingResource
extends Resource
## Construction of an Anyland Thing object in Godot
##
## Contains the Thing parts, Thing info, and Thing attributes.

@export_subgroup("Thing Info") ## Basic info about the Thing
@export var name: String = "Thing"; ## The Thing's name
@export var attributes: Array[int]; ## Attributes of the Thing

#@export var inc: Array[String];
@export_multiline var description: String; ## An optional description of up to 200 characters

@export var thing_version: int = 7; ## Thing format version id

@export_subgroup("Physics")

@export_subgroup("Construction") ## Aspects that construct the Thing
@export var parts: Array[AnylandThingPartResource]; ## Parts of the Thing
