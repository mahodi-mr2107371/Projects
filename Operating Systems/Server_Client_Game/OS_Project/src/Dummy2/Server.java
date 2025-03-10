package Dummy2;

import java.io.*;
import java.net.*;
import java.util.*;

public class Server {
	
	private static final int PORT = 13337;
    public static List<Player> players = new ArrayList<>();
    private static List<Game> games = new ArrayList<>();
    private static int ticketCounter = 1;
    public static  Player player;
    public static void main(String[] args) {
        try (ServerSocket serverSocket = new ServerSocket(PORT)) {
            System.out.println("Server started. Listening on port " + PORT);
            Game game1 = new Game();
            Game game2 = new Game();
            Game game3 = new Game();
            
            //adding games to the list
            addGame(game1);
            
            addGame(game2);
            addGame(game3);
            while (true) {
               Socket clientSocket = serverSocket.accept();
               player = new Player(clientSocket);
            
               players.add(player);
                
               new Thread(player).start();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    
//    public static synchronized int generateTicket() {
//        return ticketCounter++;
//    }

    public static synchronized void removePlayer(Player player) {
        players.remove(player);
    }

    public static synchronized List<Game> getGames() {
        return games;
    }

    public static synchronized void addGame(Game game) {
        games.add(game);
    }

    public static synchronized void removeGame(Game game) {
        games.remove(game);
    }
    
    public static synchronized void broadcast(String message) {
        for (Player player : players) {
            player.sendMessage(message);
        }
    }
    
//    public static synchronized void startGame(Game game, Player host) {
//        if (game.getHost() == host) {
//            game.start();
//        } else {
//            host.sendMessage("You are not the host of this game.");
//        }
//    }

}
