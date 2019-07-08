# Manual testing

#### What I check before I say it is "tested"

1. Rebuild the image and spin up an instance
2. Set up an up-to-date Anki and AnkiDroid instance
3. Create two deck of cards in Anki desktop
   * 5-5 cards each
   * The first deck has cards with pictures, the second one does
4. Synchronize



Then I test whether any of these steps done on any (droid or desktop) instance breaks the synchronization:

1. Review some cards
2. Add new cards
3. Edit one card
4. Remove one card
5. Create a filtered deck
6. Checking media
7. Checking database
8. Remove a deck



If no error occurs during the above practices then I update the tested version informations in [README.md](README.md)

