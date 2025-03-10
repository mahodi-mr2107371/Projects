

package app;

public class Player1 {

	private String nickname;
	private int numberOfWins;
	private String ticket;
	private int gamePoints;
	private int guess;
	private boolean ready;
	private String roundStatus;


	public Player1(String nickname, int numberOfWins, String ticket) {
		this.nickname = nickname;
		this.numberOfWins = numberOfWins;
		this.ticket = ticket;
		this.gamePoints = 0;
		this.ready=false;
	}
	
	public Player1(String nickname, int numberOfWins, String ticket, int gamePoints) {
		this.nickname = nickname;
		this.numberOfWins = numberOfWins;
		this.ticket = ticket;
		this.gamePoints = gamePoints;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public int getNumberOfWins() {
		return numberOfWins;
	}

	public void setNumberOfWins(int numberOfWins) {
		this.numberOfWins = numberOfWins;
	}

	public String getTicket() {
		return ticket;
	}

	public void setTicket(String ticket) {
		this.ticket = ticket;
	}

	public int getGamePoints() {
		return gamePoints;
	}

	public void setGamePoints(int gamePoints) {
		this.gamePoints = gamePoints;
	}
	

	public int getGuess() {
		return guess;
	}

	public void setGuess(int guess) {
		this.guess = guess;
	}
	public String getRoundStatus() {
		return roundStatus;
	}

	public void setRoundStatus(String roundStatus) {
		this.roundStatus = roundStatus;
	}

	@Override
	public String toString() {
		return "Player [Name= " + nickname + ", ticket= " + ticket +"]";
		
	}
	
	public String printPlayer() {
		return "Player [Name= " + nickname + ", Wins= " + numberOfWins +"]";
	}

	public boolean isReady() {
		return ready;
	}

	public void setReady(boolean ready) {
		this.ready = ready;
	}
	


}
