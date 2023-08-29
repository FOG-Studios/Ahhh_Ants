extends Node

# Ant Phrases

var antPhraseArray: Array = []

func _return_ant_phrase()-> String:
	var randInt: int = randi() %20
	antPhraseArray = [
		"If I had a FOG coin for evey time I heard that one...", 
		"The ants go marching one by one, horah, horah...", 
		"If 1 + 2 = 3... Then 3 - 2 must equal 1...", 
		"If you build it, the bugs will come!!!...", 
		"The best defense is a great offense!!!...", 
		"The best offense is a great defense!!!...", 
		"No matter what they say, you can do it...", 
		"Do do do do dooo do dooo do do do...", 
		"How did that song go again???...", 
		"Well what matters the most is that you're happy!!!...", 
		"I wonder how the halls are looking???...", 
		"Oh, I think I've been here before...", 
		"Let's see, left at Albuquerque Ave, right at Ant Blvd...", 
		"Is there a light in here, I can't see...", 
		"Did you hear that? I'm certain I just heard...", 
		"Hmmmmm...", 
		"I wonder if we have any sweets...", 
		"Your Majesty, I don't know how to tell you this...", 
		"Let's see, My favorite band is Lil Ant...", 
		"I love Mac and Cheese, is that what's for dinner???...", 
		"I'm going to play FOG Studios ANTS!!!..." 
	]
	return antPhraseArray[randInt]
	

