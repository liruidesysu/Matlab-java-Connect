package Client;

import java.util.HashMap;
import java.util.Map;


public class ClassToPosMap {
	private Map<String, Point> classToPosMap = new HashMap<String, Point>();
	
	public ClassToPosMap() {
		classToPosMap.put("1", new Point(10, 30));
		classToPosMap.put("2", new Point(20, 30));
		classToPosMap.put("3", new Point(30, 30));
		classToPosMap.put("4", new Point(40, 30));
		classToPosMap.put("5", new Point(50, 30));
	}
	
	public Map<String, Point> getClassToPosMap() {
		return classToPosMap;
	}
}
