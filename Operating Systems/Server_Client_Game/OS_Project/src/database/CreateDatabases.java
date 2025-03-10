package database;

public class CreateDatabases {

	public static void main(String[] args) throws ClassNotFoundException {
		
		DatabaseUtil.createPlayerTable();
//		DatabaseUtil.seedPlayerTable();
		DatabaseUtil.displayPlayersTable();
		String tokenArr = "215jay";
//		System.out.println(DatabaseUtil.searchTicket(tokenArr));
		System.out.println( DatabaseUtil.getTopFivePlayers() );
//		System.out.println("updating wins of 215jay");
//		System.out.println(DatabaseUtil.incrementPlayerNumberOfWins("215jay"));
		DatabaseUtil.displayPlayersTable();
	}

}
