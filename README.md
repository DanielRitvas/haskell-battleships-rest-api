# Haskell Functional Programming course work. 
Yesod REST API for battleship game scenario.
- Stores game state
- Supports attacker and defender role
- data transactions are handled using bencode format.

The application takes care of encoding and decoding of bencode
using custom parser implementation. 

To run the app:
`stack run fp-first`

If you want to try it out locally, you can launch two instance of the app. One as a game server (which will also serve as a defender aka player B) and another one as a client (Attacker aka Player A).


More about the task:
https://git.mif.vu.lt/vipo/fp-2019
Bencode without arrays.
Tetris.