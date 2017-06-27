package Client;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;

public class ClientListenThread extends Thread {
	Socket hostSocket;
	
	public ClientListenThread(Socket _hostSocket) {
		hostSocket = _hostSocket;
	}
	
	public void run() {
		String serverMsg = "";
		try {
			BufferedReader inFromServer = new BufferedReader(new InputStreamReader(hostSocket.getInputStream()));
			serverMsg = inFromServer.readLine();
			
			System.out.println("Receive msg from server: " + serverMsg);
		}
		catch (IOException e) {
			e.printStackTrace();
			System.out.println("Socket Closed.");
		}
		
		try {
			MatlabClient.setClassTag(serverMsg);
		} catch (Exception e) {
			e.printStackTrace();
		}
//		System.out.println("ClientListenThread ended.");
	}
}
