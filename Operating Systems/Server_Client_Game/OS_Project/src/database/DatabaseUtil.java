package database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import Dummy2.Server;
import app.Player1;

public class DatabaseUtil {

	private static Connection makeConnection() throws ClassNotFoundException, SQLException {
		// SQLite connection string
		Class.forName("org.sqlite.JDBC");
		String url = "jdbc:sqlite:" + System.getProperty("user.dir") + "\\database\\osproject.db";
		Connection conn = DriverManager.getConnection(url);
		return conn;
	}
	
	public static void createPlayerTable() throws ClassNotFoundException {

		// SQL statement for creating a new table
		String sql = "CREATE TABLE IF NOT EXISTS players (\n" + 
					 " ticket_temp INTEGER PRIMARY KEY AUTOINCREMENT,\n" + 
					 " nickname TEXT NOT NULL,\n" +
					 " ticket TEXT GENERATED ALWAYS AS (printf('%01d%s', ticket_temp, nickname)) STORED,\n" + 
					 " numberOfWins INTEGER NOT NULL\n" + ");";

		try (Statement statement = DatabaseUtil.makeConnection().createStatement()) {
			// create a new table
			statement.execute(sql);
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
	}
	
	public static void seedPlayerTable() throws ClassNotFoundException {
		String sql = "INSERT INTO players (nickname, numberOfWins)\n" +
					 "VALUES('jay', 11);";
		
		try (Statement statement = DatabaseUtil.makeConnection().createStatement()) {
			// populate the table
			statement.execute(sql);
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
	}
	
	public static void displayPlayersTable() throws ClassNotFoundException {
		
		String sql = "SELECT * FROM players;";
		
		try (Statement statement = DatabaseUtil.makeConnection().createStatement()) {	
			ResultSet resultSet = statement.executeQuery(sql);
			while (resultSet.next()) {
				int ticket_temp = resultSet.getInt(1);
				String nickname = resultSet.getString(2);
				String ticket = resultSet.getString(3);
				int numberWins = resultSet.getInt(4);

				System.out.println(ticket_temp + " " + nickname + " " + ticket + " " + numberWins);
			}
			
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
	}

	// checks if there exists a player record, and inserts if there is not
	public static Dummy2.Player searchTicket(String queryTicket) throws ClassNotFoundException {
		
		String sql = "SELECT * FROM players WHERE ticket LIKE " + "'"+queryTicket+"'";
		
		try (Statement statement = DatabaseUtil.makeConnection().createStatement()) {
			ResultSet resultSet = statement.executeQuery(sql);
			while (resultSet.next()) {
				int ticket_temp = resultSet.getInt(1);
				String nickname = resultSet.getString(2);
				String ticket = resultSet.getString(3);
				int numberWins = resultSet.getInt(4);

				Server.player.setNickname(nickname);
				Server.player.setNumberOfWins(numberWins);
				Server.player.setTicket(ticket);
				
				return Server.player;
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
		// insert player and then return it
		DatabaseUtil.insertPlayer(queryTicket);
		
		try (Statement statement = DatabaseUtil.makeConnection().createStatement()) {
			sql = "SELECT * FROM players ORDER BY ticket_temp DESC LIMIT 1;";
			ResultSet resultSet = statement.executeQuery(sql);
			while (resultSet.next()) {
				int ticket_temp = resultSet.getInt(1);
				String nickname = resultSet.getString(2);
				String ticket = resultSet.getString(3);
				int numberWins = resultSet.getInt(4);

				Server.player.setNickname(nickname);
				Server.player.setNumberOfWins(numberWins);
				Server.player.setTicket(ticket);
				
				return Server.player;
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
		return null;
	}
	
	public static void insertPlayer(String queryTicket) throws ClassNotFoundException {
		String sql = "INSERT INTO players (nickname, numberOfWins)\n" +
				 "VALUES('"+ queryTicket +"', 0);";
	
		try (Statement statement = DatabaseUtil.makeConnection().createStatement()) {
			statement.execute(sql);
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
		
	}
	
	public static ArrayList<Player1> getTopFivePlayers() throws ClassNotFoundException {
		String sql = "SELECT * FROM players ORDER BY numberOfWins DESC LIMIT 5;";
		ArrayList<Player1> leaderboard = new ArrayList<>();
		
		try (Statement statement = DatabaseUtil.makeConnection().createStatement()) {	
			ResultSet resultSet = statement.executeQuery(sql);
			while (resultSet.next()) {
				int ticket_temp = resultSet.getInt(1);
				String nickname = resultSet.getString(2);
				String ticket = resultSet.getString(3);
				int numberWins = resultSet.getInt(4);

				Player1 player = new Player1(nickname, numberWins, ticket, numberWins);
				leaderboard.add(player);
			}
			
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
		return leaderboard;
	}
	
	public static int incrementPlayerNumberOfWins(String ticket) throws ClassNotFoundException {
		String sql = "UPDATE players\n"
				+ "SET numberOfWins = numberOfWins + 1\n"
				+ "WHERE players.ticket ='" + ticket + "';";
	
		try (Statement statement = DatabaseUtil.makeConnection().createStatement()) {
			return statement.executeUpdate(sql);
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
		return 0;
	}
	

}
