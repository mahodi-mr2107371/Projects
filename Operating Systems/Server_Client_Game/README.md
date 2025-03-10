# OS_Project_Phase2 Report
## Team
- Basil Saeed bm2108258@student.qu.edu.qa
- Mohammad Hassam Tahir Khaili mk2010329@student.qu.edu.qa
- Muhammad Khan mk2104088@student.qu.edu.qa
- Zane Doe zd0000004@student.qu.edu.qa

## Challenges
1. First we had trouble on planning the architecture of the project, meaning what classes we would have, and how the client would interact with the server, so we made a sequence diagram for that, and that cleared things up.
2. Regarding the architecture, at first we thought that the Server would have multiple threads of Games running, and we coded half way with this logics, but that was not the case, and we realized that a Game was a shared buffer and the threads to be created were for each Client/Player, and those would write to the shared buffer (Game).
3. We had issues debugging the program, since there is no sequential execution, and more than one thread made it difficult to pinpoint where exactly there was a mistake in the Server/Game logic.
4. Connecting the chat sockets to the main game.
## Issues
1. Issue #1 with details
2. Issue #2 with details
3. ...
## Contributions
### Basil Saeed:
- coded all of the database persistence of the player, its ticket and numberOfWins using JDBC for SQLite.
- coded and debugged the parse methods of the Player.java with teammate.
### Mahodi Hasan Sabab
Game Class: Game Class logic Implementations and major and minor issues debugging.
•	Multi-round Logic implementation and troubleshooting
•	Game Rules and Troubleshooting
Player Class: Fixed Errors and planned and implemented the logic for player to work with game.
Overall Project Management.

### Mohammad Hassam Tahir Khaili:
- created player, game, client, and player classes.
- made communication between server and the client possible
- initiaaly added game logic (all game rules and handling of messaages when the game starts) 
### Muhammad Khan:
- created the chat class where a person sends a message and is recieved by each person
- also updating people who currently in lobby that a new person has joined / been eliminated
- merged it with the main code.
