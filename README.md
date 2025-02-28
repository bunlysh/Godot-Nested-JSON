# Godot-Nested-JSON - "Tutorial"

!(/mike_is_broke.png)

# What's this?


Basically a Tutorial on how to save and load data which:

1. is nested in a custom Array[CustomClass]
2. is supposed to be in a single .json


# Info
**[1] "Why would I need that?"**

In case you are only looking for a solution to save simple data, please refer to [this post](https://forum.godotengine.org/t/how-to-load-and-save-things-with-godot-a-complete-tutorial-about-serialization/44515), which explains everything much better. Some passages are actually copied from there. Unfortunately the part about nested data is missing.
<br><br>


**[2] "Aren't Resources capable of saving nested Resources?"**

Yes. But as of right now (February 2025) there is a bug, which can be solved with [workarounds](https://github.com/godotengine/godot/issues/65393), but is annoying regardless.
Furthermore - at least to me - it seems easier to debug .json's, especially in case you want to have consistent save-files which hopefully do not break with your next update, which is probably wrong!
*Once the bug with the Resources is fixed I would (probably) recommend switching to that method.*
<br><br>


**[3] "What are good use-cases?"**

Inventories.
Anything where you need a .json, most likely to transfer data to other apps. [Check this for more information.](https://forum.godotengine.org/t/how-to-load-and-save-things-with-godot-a-complete-tutorial-about-serialization/44515)
<br><br>


**[4] "What is a .json?"**

[Please read this.](https://forum.godotengine.org/t/how-to-load-and-save-things-with-godot-a-complete-tutorial-about-serialization/44515)
<br><br>


# tl;dr
The trick is to save a dictionary in a dictionary in a dictionary to achieve the following structure:


# Overview

Imagine you got the following data_structure of an inventory:
	
	Inventory

		Array[Item]

			Array[SubData]


**Inventory**:
	
1. contains an ID so you can re-use it
2. Array[Item]: basically the storage of all Items in your inventory


**Item**:
1. got an ID and whatever data which is NOT in an Array
2. Array[SubData]: here we got another Array with a distinct class, which contains other information

**SubData**:
1. contains whatever data which is supposed to be saved
<br><br>

Of course, the whole ordeal can go even deeper. This is just an example.
Time to read the code now. Start with inventory.gd

<br>
In case you downloaded it: start debug_json.tscn to see everything in action.
