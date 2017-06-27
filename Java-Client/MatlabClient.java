package Client;

import java.io.PrintWriter;
import java.net.Socket;

public class MatlabClient {
	static String hostIP;
	static int port;
	static String[] imagePaths;
	static String[] classlist = {"", "", ""};
	
	private ClassToPosMap classToPosMap;
	
	public MatlabClient(String _hostIP, int _port) {
		hostIP = _hostIP;
		port = _port;
		classToPosMap = new ClassToPosMap();
	}

	/**
	 * 店铺分类入口
	 * @param _imagePaths  图片路径
	 */
	public void shopSignClassification(String[] _imagePaths) throws Exception {
		imagePaths = _imagePaths;
		interactWithMatlabServer(imagePaths[0]);
	}
	
	/**
	 * 单个socket连接Matlab服务器，进行分类
	 * @param imagePath  单张图像路径
	 */
	private static void interactWithMatlabServer(String imagePath) throws Exception {
		Socket clientSocket = new Socket(hostIP, port);
		
		//连接后，给服务器发送数据
		PrintWriter outToServer = new PrintWriter(clientSocket.getOutputStream(), true);
		outToServer.println(imagePath);
		
		//从服务器读入线程
		ClientListenThread clientListenThread = new ClientListenThread(clientSocket);
		clientListenThread.start();
		
	}
	
	/**
	 * 子线程获得分类后，传回主线程
	 * @param serverMsg
	 */
	public static void setClassTag(String classTag) throws Exception {
		for (int i = 0; i < classlist.length; i++) {
			if (classlist[i] == "") {
				classlist[i] = classTag;
				if (i + 1 < imagePaths.length)
					interactWithMatlabServer(imagePaths[i + 1]);
				
				break;
			}
		}
		
//		System.out.println("Main Thread Print!");
	}
	
	/**
	 * 通过类别以及映射表返回3个商铺的地理位置
	 */
	public Point[] getShopPosition() throws InterruptedException {
		while (classlist[2] == "") {
			Thread.sleep(300);
		}
		
		Point[] shopPosSet = new Point[3];
		for (int i = 0; i < 3; i++) {
			shopPosSet[i] = classToPosMap.getClassToPosMap().get(classlist[i]);
			classlist[i] = "";
		}
		return shopPosSet;
	}
}
