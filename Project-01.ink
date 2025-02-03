/*
    Project 01
    
    Requirements (for 15 base points)
    - Create an interactive fiction story with at least 8 knots 
    - Create at least one major choice that the player can make
    - Reflect that choice back to the player
    - Include at least one loop
    
    To get a full 20 points, expand upon the game in the following ways
    [+2] Include more than eight passages
    [+1] Allow the player to pick up items and change the state of the game if certain items are in the inventory. Acknowledge if a player does or does not have a certain item
    [+1] Give the player statistics, and allow them to upgrade once or twice. Gate certain options based on statistics (high or low. Maybe a weak person can only do things a strong person can't, and vice versa)
    [+1] Keep track of visited passages and only display the description when visiting for the first time (or requested)
    
    Make sure to list the items you changed for points in the Readme.md. I cannot guess your intentions!

*/


VAR time = 0// 0 Morning, 1 Noon, 2 Evening, 3 Night
VAR stamina = 6 //player starts
VAR key = false 
VAR knife = false 
VAR crowbar = false 
VAR health = 10
VAR journal = false 
VAR food = 0
VAR fightzombie = false


//visited//
VAR visitOutside = false
VAR visitedcity = false
VAR visitfight = false
VAR visitsecret = false

//Introduction//
It was just another long day at work. You step into you house, exhausted. You hear the noisy city not too far from your neighborhood. You take off your shoes as you fall onto your bed, slowly drifting into sleep ...

* [Wake up] ->home



== home ==
You wake up abruptly as the phone rings. You answer, but only static comes through. 
You look around and notice your house looks strange, as if it has aged. The windows are cracked, and the noise of the city is no where to be heard. 

*[Check  the house] -> check_house

->DONE


///allow for stamina and health to be updated/upgraded //
== homebase == 
You are at your house 
It's{time == 0: Morning} 
~visitOutside = true
[-----STATS-----]

 health: {health}
 stamina = {stamina} //player starts
 
[-----BACKPACK-----]

 {key == true: key = {key} |}
 {knife == true:  knife = {knife} |}
{crowbar == true: crowbar{crowbar} | }
 {journal == true: journal = {journal} | }
 food = {food} 
+[Rest] -> rest 
+[Eat] -> eat
+{stamina > 0 && not visitfight}[Continue Exploring] -> outside
+{visitfight == true} [Continue Exploring] -> loot


->DONE

== eat == 
You eat some of your canned food.
You increase your health
It's {advance_time()}
~ health = health + 2
~ food = food -1
+[Return] -> homebase
-> DONE

== rest == 
You take some time to rest, regaining your stamina.
{& --You are dreaming about cows-| -You are dreaming about flying high above the ground--| --You are dreaming about swimming in deep water-- | --You are dreaming about exploring a cave--}
~ time = 0
~ stamina = stamina + 6
It's about to be{time == 0: Morning |}
+[Wake up] -> homebase


->DONE

== check_house ==
You search your home for anything useful. But all your belongings seem to be missing.

*[check the kicthen] -> kitchen 
*[check bedroom] -> bedroom

-> DONE

== kitchen == 
You find an old flashlight. It might be useful.
You also find some canned food.
~flashlight = true 
~ food = food + 2

*[Go back] -> check_house
->DONE

== bedroom == 
You check your room.
You find a strange journal with weird writings about parallel worlds. You also find a backpack. 
You take both items
~ journal = true 
*[Check Outside] -> outside
-> DONE

== outside == 
You are now outside the street of your neighborhood.


{not visitOutside: You step outside into the street of your neighborhood, but realize everyting seems abandoned. Cars are rusted, the houses around you are crumbling, and most importanlty not a single person in sight. Complete silence... }




It is {advance_time()}.
~stamina = stamina -1 

{check_stamina()}
+{stamina > 0}[Explore into the city] -> city_center
* [Return home] ->homebase

->END

== city_center == 
You find yourself in what used to be downtown. {not visitedcity:You notice a figure in the distance.} {not fightzombie: You still notice a figure in the distance}

What do you do?
~ visitOutside = true

*{stamina > 0}[Hide] -> hidden 
*{stamina > 0}[Fight]  -> fight 
*{stamina > 0}[Run] -> outside

-> DONE

== fight == 
You prepare yourself and engage the zombie looking figure.  It catches you off guard and scratches your chest. With quick feet, you manage to take it down.
You notice it has something in its pocket.
~ fightzombie = true
~ visitfight = true
~ stamina = stamina - 3
~ health = health - 5 

*[Search the body] -> loot
+[Return home] -> homebase

->DONE

== loot == 
{not visitfight:You make your way back to the defeated zombie |You find a rusted key. You take it.}
~ key = true

{check_stamina()}
+{stamina > 0} [Continue exploring] -> ruins
+[Return home] -> homebase

-> DONE





== hidden ==
You crouch in the shadows. The figure limps past you, unaware of your presence. 
~stamina = stamina -1 
~ visitedcity = true

{check_stamina()}
*[Continue Exploring] -> ruins
->DONE


== ruins == 
You are now in an abandoned market. Supplies might be inside.//check for if entered 
It's {advance_time()}
{check_stamina()}
*[Search for food] -> food1
*[Search for weapons] -> weapons
+[Investigate the backroom] -> backroom
+[Return home] -> homebase
*[Go to the coordinates] -> coordinates
->DONE

== food1 == 
You find some canned food. Your stamina and health recover.
~ stamina = stamina + 2 
~ health = health + 2

*[Continue searching] -> ruins 
+[Return home] -> homebase

-> DONE

== weapons == 
You find a old knife. It might be useful.
~ knife = true 

*[Continue searching] -> ruins
*[Return home] -> home 
-> DONE

== backroom == 
You see a door down the market. The door is locked. Maybe you need a key.
{key == false: You need a key maybe trace back and explore more}
*{key == true}[Use the key] -> secretroom
+[Go back] -> ruins

->DONE

== secretroom == 
Inside, you find advance machinery and more weird writings on parallel worlds. This might explain everything.
It's {advance_time()}
~ visitsecret = true
*[Take the writings] -> take_w 
*[Leave] -> ruins

->DONE

== take_w == 
You take the writings and read them. You realize it gives you coordinates on a map. You might have a way back home.

*[Leave] -> ruins
->DONE

== coordinates == 
You make your way there and see its a lab. 
but before you enter you hear a hoard of zombies running at you!
What will you do?

*[Fight] ->fighthoard
+[Prepare] -> prepare
->DONE

== fighthoard == 
You find a crowbar near. You pick it up. Remember you also have a knife. 
What will you use ?
~crowbar = true
 +[use crowbar] -> crowbarused
 +[use knife] ->knifeused
 
 ->DONE
 == prepare == 
 
 Reflect on what you have before you enter the fight 
 [-----STATS-----]

 health: {health}
 stamina = {stamina} //player starts
 
[-----BACKPACK-----]

 {key == true: key = {key} |}
 {knife == true:  knife = {knife} |}
{crowbar == true: crowbar{crowbar} | }
 {journal == true: journal = {journal} | }
 food = {food} 
+{stamina > 0 && not visitfight}[Go Back] -> outside

*[Continue to Fight] ->fighthoard

 == knifeused == 
 Your knife is well sharpened and you are able to take all zombies out but costing you alot of your stamina. 
 ~ stamina =stamina - 3
 * [Explore the lab] -> explorelab
 ->DONE
 
 
 == crowbarused == 
 You use the crow bar and manage to defeat a couple of the zombies. You end up running away and barley making it through the door of the lab closing it the handles with you crowbar.
 
 ~stamina = stamina - 2
 
 * [Explore the lab] -> explorelab
 ->DONE
 
 ==explorelab==
 
 You explore the lab and see a long hallway leading to a room. As you walk down the hallway you notice a bright light coming at the end of it. As you approach closer you hear a strange noise...
 
*[End of the hall] -> endofhall

==endofhall ==
As you enter the room... 
Your eyes gets flashed, seeing nothing but white... 


[TO BE CONTINUED....]
-> DONE
































== function advance_time ==

    ~ time = time + 1
    
    {
        - time > 2:
            ~ time = 0
    }    
    
    {    
        - time == 0:
            ~ return "Morning"
        
        - time == 1:
            ~ return "Noon"
            
        - time == 2:
            ~ return "Evening"
            
        - time == 3:
            ~ return "Night"

    }
    
    
        
    ~ return time
    

== function check_stamina == 
    ~ stamina = stamina - 1 
    
    {
     -stamina < 0:
     ~ stamina = 0
    
    
    }
    {
    - stamina < 0 or stamina < 1:
    ~ return "Your stamina is depleted! Head back home to get some rest"
    
    
    }
    
    {
    -stamina == 2:
    ~ return "You might need to consider some rest in order to continue."
    
    }
    
    
    {
    -stamina > 3:
    ~ return "Your feeling pretty energized "
    }





























































































































































