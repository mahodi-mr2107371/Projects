package app;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.ArrayList;
//import java.util.Date;
//import java.util.Optional;
import java.util.Random;
import java.util.concurrent.Semaphore;

public class Game1 implements Runnable {
	int roundNumber;
	public  ArrayList<Integer> listOfCurrentGuesses = new ArrayList<>();
	public ArrayList<Player1> listOfCurrentPlayers = new ArrayList<>();

	private String gameName;

	public ArrayList<Player1> listOfDeadPlayers = new ArrayList<>();
	private String gameId;
	private boolean isStarted = false;
	Socket nextClient;
	PrintWriter to_client;
	BufferedReader from_client;
	int countTrials=0;
	long currentTime = System.currentTimeMillis();
	long newTime, diff;
	String roundEndResults;
	
//	private final int maxNumOfPlayers=6;
//	private final Semaphore semaphore;
	
	public Game1() {
			//	super();
			roundNumber=0;
		}
	
	
	public Game1(Socket nextClient) {
	//	super();
		this.nextClient = nextClient;
		// semaphore = new Semaphore(maxNumOfPlayers);
	}
	
	
	// all game rules will be coded here
	@Override
	public void run() {
		//if(preGameLogicCheck()) {
			try {
				to_client = new PrintWriter(nextClient.getOutputStream(), true);
				from_client = new BufferedReader(new InputStreamReader(nextClient.getInputStream()));
				
				while(true) {
					if(diff > 5000) {
						to_client.println("You are done, n.o of correct trials = "+countTrials);
						to_client.println("Done");
						break;
					}
					Random rand = new Random();
					int numb1 = rand.nextInt(10)+1;
					int numb2 = rand.nextInt(10)+1;
					int numb3 = rand.nextInt(10)+1;
					
					int serverSum = numb1 + numb2 + numb3;
					
					to_client.println("Enter the Sum of 3 numbers: "+numb1+" "+numb2+" "+numb3 + ": ");
					
					String userSum = from_client.readLine();
					
					int userSumInt = Integer.parseInt(userSum);
					
					newTime = System.currentTimeMillis();
					
					diff = newTime - currentTime;
					
					if(serverSum == userSumInt && diff<60000) {
						countTrials++;
					}
				}
			}catch(IOException e){
				
				e.printStackTrace();			
			}
			finally{
				try {
					if(nextClient!=null) {
						nextClient.close();
					}
					if(to_client!=null) {
						to_client.close();
					}
					if(from_client!=null) {
						from_client.close();
					}
				}catch(IOException e) {
					e.printStackTrace();
				}
			}
	//	}
		
	}
	
	
	//returns the average
	public double getAverage() {
		double sum = listOfCurrentGuesses.stream().reduce(0, (acc , curr)-> acc +=curr);
		return sum/listOfCurrentGuesses.size();
	}
	
	
	//decides winner or the game
	public void roundWinnerLogic() {
		
		//Round End Report Work
		roundEndResults="game round: "+roundNumber+" ";
		for(int i=0;i<listOfCurrentPlayers.size();i++) {
			if(i!=listOfCurrentPlayers.size()-1) {
				roundEndResults.concat(listOfCurrentPlayers.get(i).getNickname()+", ");
			}
			else {
				roundEndResults.concat(listOfCurrentPlayers.get(i).getNickname()+" ");
			}
		}
		
		
		double target = (2.0 / 3.0) * getAverage();
        double minDifference = Double.MAX_VALUE;
        ArrayList<Player1> winners = new ArrayList<>();
        
        //last round Logic
        if(listOfCurrentPlayers.size()==2) {
        	for(Player1 player:listOfCurrentPlayers) {
        		if(player.getGuess()==0) {
        			listOfCurrentPlayers.remove(player);
        			listOfDeadPlayers.add(player);
        			winners.add(listOfCurrentPlayers.get(0));
        			return;
        		}
        	}
        }
        
        //game logic
        for (Player1 player : listOfCurrentPlayers) {
            if(player.getGuess()>=0 && player.getGuess()<=100) {
            	double difference = Math.abs(target - player.getGuess());
                if (difference < minDifference) {
                    minDifference = difference;
                    winners.clear();
                    winners.add(player);
                    listOfCurrentPlayers.remove(player);
                } else if (difference == minDifference) {
                    winners.add(player);
                    listOfCurrentPlayers.remove(player);
                }
            }
        }
        
        decrementPoint(listOfCurrentPlayers);
        for (Player1 player : listOfCurrentPlayers) {
            if(player.getGamePoints()==0) {
            	listOfCurrentPlayers.remove(player);
            	listOfDeadPlayers.add(player);
            }
        }
        
        for (Player1 p : winners) {
        	p.setNumberOfWins(p.getNumberOfWins()+1);
        	listOfCurrentPlayers.add(p);
        }
        
        
        //Round End Report Work 2
      	for(int i=0;i<listOfCurrentPlayers.size();i++) {
      		if(i!=listOfCurrentPlayers.size()-1) {
      			roundEndResults.concat(listOfCurrentPlayers.get(i).getGuess()+", ");
      		}
      		else {
      			roundEndResults.concat(listOfCurrentPlayers.get(i).getGuess()+" ");
      		}
      	}
        
        //Round End Report Work 3
      	for(int i=0;i<listOfCurrentPlayers.size();i++) {
      		if(i!=listOfCurrentPlayers.size()-1) {
      			roundEndResults.concat(listOfCurrentPlayers.get(i).getGamePoints()+", ");
      		}
      		else {
      			roundEndResults.concat(listOfCurrentPlayers.get(i).getGamePoints()+" ");
      		}
      	}
      	
        //Round End Report Work 3
      	for(int i=0;i<listOfCurrentPlayers.size();i++) {
      		if(i!=listOfCurrentPlayers.size()-1) {
      			roundEndResults.concat(listOfCurrentPlayers.get(i).getRoundStatus()+", ");
      		}
      		else {
      			roundEndResults.concat(listOfCurrentPlayers.get(i).getRoundStatus());
      		}
      	}
      	if(!listOfDeadPlayers.isEmpty()) {
      		roundEndResults.concat(" Eliminated Player(s): ");
      		for(int i=0;i<listOfDeadPlayers.size();i++) {
          		if(i!=listOfDeadPlayers.size()-1) {
          			roundEndResults.concat(listOfDeadPlayers.get(i).getNickname()+", ");
          		}
          		else {
          			roundEndResults.concat(listOfDeadPlayers.get(i).getNickname());
          		}
          	}
      	}

      	System.out.println(roundEndResults);
      	
	}
	
	
	//decrements player points
	public void decrementPoint(ArrayList<Player1> player) {
		for(Player1 p : player) {
			p.setGamePoints(p.getGamePoints()-1);
		}
	}
	
	
	//preGameLogic
	public boolean preGameLogicCheck() {
		
		//there should be atleast 2 players in game
		if(listOfCurrentPlayers.size()<2) { 
			return false;
		}
		
		
		//point setting to 5
		for(Player1 player:listOfCurrentPlayers) {
			player.setGamePoints(5);
		}
		
		
		//all players should be ready
		for(Player1 player:listOfCurrentPlayers) {
			if(!player.isReady()) {
				return false;
			}
		}
		
		return true;
	}
	
	
	//getters and setters for GameID
	public String getGameId() {
		return gameId;
	}
	public void setGameId(String gameId) {
		this.gameId = gameId;
	}
	
	
	@Override
	public String toString() {
		return "Game=" + gameId + ", Game Name=" + gameName ;
	}
	
	
	//getters and setters for isStarted
	public boolean isStarted() {
		return isStarted;
	}
	public void setStarted(boolean isStarted) {
		this.isStarted = isStarted;
	}
//	
//	public boolean tryJoin(Socket nextClient) {
//		boolean allow = semaphore.tryAcquire();
//		if (allow)
//			listOfCurrentPlayers.add(nextClient);
//	}
	
}
