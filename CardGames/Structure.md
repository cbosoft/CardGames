#  Structure

## Card object and simple container structure
```
 CardPosition: base locator for cards, which manages location and
   |           moving of a card
   |
   +- Card: card object which manages location (via parent) and
   |        sprite, animation of card
   |
   +- Stack: pile of cards acting as a container of cards. Manages
       |     flipping of cards as well as positioning. Base class.
       |
       +- VisibleStack: Stack laid out such that all card values
       |                are visible.
       |
       +- TopStack: Only top card visible. Used for the "complete"
       |            pile e.g. in Solitaire.
       |
       +- DeckStack: top $n cards visible to the right, with $m
                     visible on top the main stack to the left.
```


## Deck

Cards are drawn from a Deck, at random.

## Table

Game layout is managed by a table

```
CardTable: Manage location of stacks, card generation through decks,
  |        and gameplay.
  |
  +- SolitaireTable: Manage a DeckStack, 4xTopStacks, and 7xVisibleStacks
  |
  +- Other games...?
```

