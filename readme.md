# Flood Puzzle using Gosu

There's not a lot to say... It's the flooding puzzle done with the Ruby
[Gosu](http://www.libgosu.org/) Library.

## How to play

Click on a colour button at the bottom and all of the blocks that are the same 
colour as the top left corner and next to it will change to that colour. 
Obviously, the idea is to make all the blocks the same colour.

## Features to come

#### Timing and Scoring. 

I think I know how to do it now...

Base score for a round will be 10,000,000 in the spirit of huge scoring everywhere :-)
This will be multiplied by 'optimal' moves (see below) divided by actual moves 
and again by 3 seconds per 'optimal' move divided by actual time.

Hence completing a 23 move grid in 24 moves and 60 seconds will score:

```
(23 / 24) * (69 / 60) * 10,000,000 = 11,020,833
```

## Updated in this version

There is a sub-optimal algorithm used to compute the fewest possible moves 
for a given grid which I will use as basis for the scoring. 

## Keys

Esc Exits

R   Restarts
