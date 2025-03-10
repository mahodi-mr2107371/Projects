package Dummy2;


import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import java.util.concurrent.Semaphore;
import java.util.stream.Collectors;

import database.DatabaseUtil;


public class Game {
	
	 private static int idCounter = 1;
	 	private Semaphore sem;
	    private int id;
	    private List<Player> listofCurrentPlayers;
	    private List<Player> roundLosers;
	    private List<Player> players;
	    private List<Player> winners;
	    private List<Player> listOfDeadPlayers;
	    private int roundNumber;
	    public  List<Integer> listOfCurrentGuesses ;
	    
	    private static final int MAX_PLAYERS = 6;
	    private Semaphore semaphore;

	    public Game() {
//	    	sem = new Semaphore(1);
	        id = idCounter++;
			listofCurrentPlayers = new ArrayList<>();
			listOfCurrentGuesses = new ArrayList<>();
			roundLosers = new ArrayList<>();
			winners = new ArrayList<>();
		    listOfDeadPlayers = new ArrayList<>();
	        roundNumber = 0;
	        
	        semaphore = new Semaphore(MAX_PLAYERS);
	    }
	    
	    public boolean tryJoinGame() {
	    	System.out.println("acquiring semaphore");
	    	return this.semaphore.tryAcquire();
	    }
	    
	    public void leaveGame() {
	    	this.semaphore.release();
	    }

	    public int getId() {
	        return id;
	    }
	    
	    
	    @Override
		public String toString() {
			return "Game [id=" + id + "]";
		}

		public synchronized void addPlayer(Player player) {
	        listofCurrentPlayers.add(player);
	    }

	    public synchronized void removePlayer(Player player) {
	        listofCurrentPlayers.remove(player);
	    }
	    
	    public synchronized void addGuess(int guess) {
	        listOfCurrentGuesses.add(guess);
	    }
	    
	    public synchronized void start() throws IOException, InterruptedException {
//	    	sem.acquire();
	    	 roundNumber++;
	    	 players = new ArrayList<>(this.listofCurrentPlayers);
	    	 for (Player player :players) {
	             PrintWriter output = new PrintWriter(player.getSocket().getOutputStream(), true);
	             output.println("Round "+roundNumber+". Guess a number between 0 and 100: ");
	         }
	    	
	    	
	    }
	    public synchronized void getAverage(int guess, Player player) throws IOException, ClassNotFoundException {
	    	
	    	 addGuess(guess);
	         if (listOfCurrentGuesses.size() == players.size()) {
	             calculateWinners();
	             listOfCurrentGuesses.clear();
	         }
		}
	    
	    private void sendRoundResults() throws IOException {
	        // Construct and send round results to all players
	        String roundResults = "game round " + roundNumber + " ";
	        // Add player nicknames
	        roundResults += listofCurrentPlayers.stream()
	                                            .map(Player::getNickname)
	                                            .collect(Collectors.joining(",")) + " ";
	        // Add guesses
	        roundResults += listofCurrentPlayers.stream()
	                                            .map(p -> Integer.toString(p.getGuess()))
	                                            .collect(Collectors.joining(",")) + " ";
	        //Add points
	        roundResults += listofCurrentPlayers.stream()
                    .map(p -> Integer.toString(p.getGamePoints()))
                    .collect(Collectors.joining(",")) + " ";
	        
	        // Add win/lose status
	        roundResults += listofCurrentPlayers.stream()
	                                            .map(p -> p.getRoundStatus().toLowerCase())
	                                            .collect(Collectors.joining(","));
	        
	        //sending the output to all players in the game
	        for (Player player : listofCurrentPlayers) {
	            PrintWriter output = new PrintWriter(player.getSocket().getOutputStream(), true);
	            output.println(roundResults+", Enter Ready to start the next round: ");
	        }
	        
	    }
		
	    public void calculateWinners() throws IOException, ClassNotFoundException {
	    	
	    	double sum = listOfCurrentGuesses.stream().reduce(0, (acc, curr) -> acc + curr);
			double average=  sum/listOfCurrentGuesses.size();
			double target = (2.0 / 3.0) * average;
	        double minDifference = Double.MAX_VALUE;
	        
	        for (Player player :players) {
	        	player.setRoundStatus("lose");
	        	player.setReady(false);
	        }
	       
	      //last round Logic
	        if(players.size()==2) {
	        	  for (Iterator<Player> iterator = players.iterator(); iterator.hasNext();) {
	                  Player player = iterator.next();
	                  if (player.getGuess() == 0) {
	                	  player.setRoundStatus("lose");
	                      iterator.remove();
	                      listOfDeadPlayers.add(player);
	                      winners.add(players.get(0));
	                      return;
	        		}
	        	}
	        }
	        
	        //game logic
	        for(Player plr:listofCurrentPlayers) {
	        	for (Player player : players) {
		            if(player.getTicket().equals(plr.getTicket())) {
		            	if(player.getGuess()>=0 && player.getGuess()<=100) {
			            	double difference = Math.abs(target - player.getGuess());
			                if (difference < minDifference) {
			                    minDifference = difference;
			                    for(Player winner:winners) {
			                    	listofCurrentPlayers.get(listofCurrentPlayers.indexOf(winner)).setRoundStatus("lose");
			                    	players.add(winner);
			                    }
			                    winners.clear();
			                    listofCurrentPlayers.get(listofCurrentPlayers.indexOf(player)).setRoundStatus("win");
			                    winners.add(player);
			                    players.remove(player);
			                } else if (difference == minDifference) {
			                	listofCurrentPlayers.get(listofCurrentPlayers.indexOf(player)).setRoundStatus("win");
			                    winners.add(player);
			                    players.remove(player);
			                }
			            }
		            }
		            break;
		        }
	        }
	        //cheating logic
	        if(players.size()==0) {
	        	for(Player winner:winners) {
	        		winner.setRoundStatus("lose");;
	        		players.add(winner);
	        	}
	        	winners.clear();
	        }
	        decrementPoint(players);
	        if(players.size()!=1) {
	        	for(Player plr:listofCurrentPlayers) {
	        		for (Player player : players) {
			            if(player.getTicket().equals(plr.getTicket())) {
			            	if(player.getGamePoints()==0) {
				            	listOfDeadPlayers.add(player);
				            	players.remove(player);
				            }
			            	break;
			            }
			        }
	        	}
	        }
	        else if(players.size()==1) {
	        	if(players.get(0).getGamePoints()==0) {
	        		listOfDeadPlayers.add(players.get(0));
	        		players.clear();
	        	}
	        }
	        //adding the winners back
	        for(Player winner:winners) {
    			listofCurrentPlayers.get(listofCurrentPlayers.indexOf(winner)).setRoundStatus("win");
            	players.add(winner);
            }
	        
	        //last player left logic
	        if(players.size()==1) {
	        	DatabaseUtil.incrementPlayerNumberOfWins(players.get(0).getTicket());
//	        	listofCurrentPlayers.clear();
	        	PrintWriter output;
	        	for(Player plr:listofCurrentPlayers) {
	        		output = new PrintWriter(plr.getSocket().getOutputStream(),true);
	        		output.println("Game Ended, Winner is :"+players.get(0).getNickname()+" Pick a game: "+Server.getGames());
	        	}
	        	players.clear();
	        	winners.clear();
//	        	sem.release();
	        	return;
	        }
	        winners.clear();
	        sendRoundResults();
	    }
	    
      //decrements player points
    	public void decrementPoint(List<Player> player) {
    		for(Player p : player) {
    			p.setGamePoints(p.getGamePoints()-1);
//    			p.setRoundStatus("lose");
    		}
    	}
    	
		public List<Player> getListofCurrentPlayers() {
			return listofCurrentPlayers;
		}

		public void setListofCurrentPlayers(List<Player> listofCurrentPlayers) {
			this.listofCurrentPlayers = listofCurrentPlayers;
		}

		public int getRoundNumber() {
			return roundNumber;
		}

		public void setRoundNumber(int roundNumber) {
			this.roundNumber = roundNumber;
		}

		public void setId(int id) {
			this.id = id;
		}

		public List<Player> getPlayers() {
			return players;
		}

		public void setPlayers(List<Player> players) {
			this.players = players;
		}

		public List<Player> getRoundLosers() {
			return roundLosers;
		}

		public void setRoundLosers(List<Player> roundLosers) {
			this.roundLosers = roundLosers;
		}

			

	    // Other game methods...

}
