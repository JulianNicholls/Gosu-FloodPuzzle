# Flood Puzzle using Gosu

There's not a lot to say... It's the flooding puzzle done with the Ruby
[Gosu](http://www.libgosu.org/) Library.

## How to play

Click on a colour button at the bottom and all of the blocks that are the same 
colour as the top left corner and next to it will change to that colour. 
Obviously, the idea is to make all the blocks the same colour.

## Features to come

#### Timing and Scoring. 

I'm not sure how to score it...

Fewer moves and a shorter time will score more highly. I'm not sure what 
weight I'll give to each of those.

There is obviously a way to compute the fewest possible moves for a given 
grid and I am thinking about that as a basis of the scoring. 

## Updated in this version

Easy mode, accessed via --easy on the command line. This makes a proportion of
blocks the same colour as one of its neighbours, reducing randomness slightly.

## Keys

Esc Exits

R   Restarts
