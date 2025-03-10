package dummy;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.Random;

public class Service extends Thread{
	
	Socket nextClient;
	PrintWriter to_client;
	BufferedReader from_client;
	int countTrials=0;
	long currentTime = System.currentTimeMillis();
	long newTime, diff;
	
	public Service(Socket nextClient) {
		super();
		this.nextClient = nextClient;
	}
	
	public void run() {
		try {
			to_client = new PrintWriter(nextClient.getOutputStream(), true);
			from_client = new BufferedReader(new InputStreamReader(nextClient.getInputStream()));
			
			while(true) {
				if(diff > 60000) {
					to_client.println("You are done, n.o of correct trials = "+countTrials);
					to_client.println("Done");
					break;
				}
				Random rand = new Random();
				int numb1 = rand.nextInt(10)+1;
				int numb2 = rand.nextInt(10)+1;
				int numb3 = rand.nextInt(10)+1;
				
				int serverSum = numb1 + numb2 + numb3;
				to_client.println("Game is starting!");
				to_client.println("Enter the Sum of 3 numbers: "+numb1+" "+numb2+" "+numb3);
				
				from_client.readLine();
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
	}

}
