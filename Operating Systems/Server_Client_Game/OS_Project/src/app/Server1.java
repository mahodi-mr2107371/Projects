package app;

import java.net.*;
import java.io.*;
import java.util.*;

public class Server1 {
	
	private static ArrayList<Game1> listOfGames; //array list to store games
	private static ArrayList<Player1> listOfLoggedInPlayers; //array list to store Players
	
	public static void main(String args[]) {
		try {

			@SuppressWarnings("resource")

			ServerSocket server = new ServerSocket(13337);
			System.out.println("Server Started");
			System.out.println("Server waiting for client on port " +
					server.getLocalPort());
			
			
			setListOfGames(new ArrayList<>()); //Initializing list of games array list
			setListOfLoggedInPlayers(new ArrayList<>()); //Initializing list of Players array list
			
			Game1 g1 = new Game1();
			Game1 g2 = new Game1();
			Game1 g3 = new Game1();
			
			g1.setGameId("game1");
			g2.setGameId("game2");
			g3.setGameId("game3");
			
			
			listOfGames.add(g1);
			listOfGames.add(g2);
			listOfGames.add(g3);
			

			for(;;) {
				// Get the next TCP Client
				Socket nextClient = server.accept();
				// Display connection details
				System.out.println("Receiving Request From " +
						nextClient.getInetAddress() + ":" +
						nextClient.getPort());
				Server1.initialService(nextClient);
				ServerUtil.nextClient=nextClient;
				//				output.println();

			}
		} catch(IOException ioe){
			System.out.println("Error" + ioe);
		}
	}

	public static ArrayList<Game1> getListOfGames() {
		return listOfGames;
	}

	public static void setListOfGames(ArrayList<Game1> listOfGames) {
		Server1.listOfGames = listOfGames;
	}
	
	 
	public static ArrayList<Player1> getListOfLoggedInPlayers() {
		return listOfLoggedInPlayers;
	}

	public static void setListOfLoggedInPlayers(ArrayList<Player1> listOfLoggedInPlayers) {
		Server1.listOfLoggedInPlayers = listOfLoggedInPlayers;
	}

	private static void initialService(Socket nextClient) {
		new Thread(new Runnable() {
			PrintWriter output;
			BufferedReader fromClient;
			@Override
			public void run() {

				try {
				
					output = new PrintWriter(nextClient.getOutputStream(), true);
					output.println("Identify Yourself: ");
					// reading ticket/name from client
				  
					fromClient=new BufferedReader(new InputStreamReader(nextClient.getInputStream()));
					
					// parsing the input in ServerUtil
					Player1 player = (Player1) ServerUtil.parseClient(fromClient.readLine());
					listOfLoggedInPlayers.add(player);
					
					String welcomeMessage ="Welcome "+player.getNickname()+" Your ticket is " +player.getTicket();

					output.println(welcomeMessage);
					output.println("Leaderboard:");
					output.println(ServerUtil.getLeaderBoard());
					output.println("Games available:");
					output.println(listOfGames.toString());
					output.println("All Players:");
					output.println(listOfLoggedInPlayers.toString());
					output.println("Join any game: ");
//					output.close();
					
//					System.out.println(fromClient.readLine());
			
					ServerUtil.parseClient(fromClient.readLine());
				//	Game game = new Game();
					//game.listOfCurrentPlayers.add(player);
//				
				  //  Game game1 = new Game(nextClient);
				//    game1.run();
					
				} catch (IOException | ClassNotFoundException e) {
					e.printStackTrace();
				} 

			}

		}).start();
	}


}


