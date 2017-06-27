package Client;

public class Main {
	public static void main(String argus[]) throws Exception {
		
		MatlabClient matlabClient = new MatlabClient("172.19.129.208", 6677);
		
		String[] imagePath = {"5", "2", "4"};
		matlabClient.shopSignClassification(imagePath);
		
		Point[] shopPos = matlabClient.getShopPosition();
		for (int i = 0; i < shopPos.length; i++) {
			System.out.println("ShopPos" + i + " : (" + shopPos[i].x + ", " + shopPos[i].y + ")");
		}
	}
}
