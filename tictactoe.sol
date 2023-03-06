pragma solidity ^0.8.0;

contract TicTacToe {
    address public player1;
    address public player2;
    uint8 public currentPlayer;
    uint8 public moves;
    bool public gameEnded;
    uint8[9] public board;
    mapping (address => bool) public hasJoined;

    event GameStarted(address player1, address player2);
    event MovePlayed(address player, uint8 position);
    event GameOver(address winner);

    constructor() {
        currentPlayer = 1;
        moves = 0;
        gameEnded = false;
    }

    function joinGame() public {
        require(!hasJoined[msg.sender], "You have already joined the game.");
        require(player1 == address(0) || player2 == address(0), "The game is already full.");

        if (player1 == address(0)) {
            player1 = msg.sender;
            hasJoined[player1] = true;
        } else {
            player2 = msg.sender;
            hasJoined[player2] = true;
            emit GameStarted(player1, player2);
        }
    }

    function playMove(uint8 position) public {
        require(!gameEnded, "The game has already ended.");
        require(hasJoined[msg.sender], "You are not a player in this game.");
        require(currentPlayer == 1 && msg.sender == player1 || currentPlayer == 2 && msg.sender == player2, "It's not your turn.");
        require(board[position] == 0, "That position is already taken.");

        board[position] = currentPlayer;
        moves++;
        emit MovePlayed(msg.sender, position);

        if (checkForWinner()) {
            emit GameOver(msg.sender);
            gameEnded = true;
        } else if (moves == 9) {
            emit GameOver(address(0));
            gameEnded = true;
        } else {
            currentPlayer = currentPlayer == 1 ? 2 : 1;
        }
    }

    function checkForWinner() internal view returns (bool) {
        uint8[3][3] memory rows = [            [board[0], board[1], board[2]],
            [board[3], board[4], board[5]],
            [board[6], board[7], board[8]]
        ];

        for (uint8 i = 0; i < 3; i++) {
            if (rows[i][0] != 0 && rows[i][0] == rows[i][1] && rows[i][1] == rows[i][2]) {
                return true;
            }
            if (rows[0][i] != 0 && rows[0][i] == rows[1][i] && rows[1][i] == rows[2][i]) {
                return true;
            }
        }
        if (rows[0][0] != 0 && rows[0][0] == rows[1][1] && rows[1][1] == rows[2][2]) {
            return true;
        }
        if (rows[0][2] != 0 && rows[0][2] == rows[1][1] && rows[1][1] == rows[2][0]) {
            return true;
        }
        return false;
    }
}
