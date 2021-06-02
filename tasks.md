# unsorted / starters

- [x] show a row of cards at the bottom of the screen (the hand)
- [x] create movement cards: up, down, left, right
- [x] show a random set of three cards
- [x] on card click, move it back to deck
- [x] on card click, draw a new card
- [x] simple tile map, grid of dungeon tiles
- [x] show an adventurer on one tile
- [x] camera
- [x] clicking a card should move the adventurer in the corresponding direction on the grid
- [x] sort cards in a user-friendly order
- [x] new cards should pop in from the bottom like toast
- [x] allow multiple types of cards in one deck
- [x] idea: cards to move multiple spaces (x1, x3)
- [ ] manage facing direction of player (?)

# combat

- [x] show an enemy sprite on map
- [x] add attack card
- [x] when using attack card, damage an adjacent enemy
- [x] visible enemy health
- [x] enemy should move towards player every second(?)
- [x] if enemy wants to move but player is occupying the space, player takes damage
- [ ] if player tries to move into enemy, player takes damage
- [x] player health bar
- [ ] attacking should make the player face the direction of the enemy they damaged

# enemies

- [ ] show a little dial on enemies that winds down until their next move

# consumables / items / drops

- [ ] some item on the field which gives you a card
- [ ] card does not go back to deck when used

# worldgen

- [ ] limit the movement bounds of the player
- [ ] random player spawn
- [ ] place random enemies in the room (excluding around player area?)
- [ ] place a staircase to go to the next room (recreate room but with more enemies)

# juice

- [x] animate cards with linear interpolation
- [ ] animate movement
- [ ] animate attacking
- [ ] animate damage (flash red)
- [ ] better ground sprites for clearer tile boundaries
