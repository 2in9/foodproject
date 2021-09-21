package project.co.kr;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Calendar;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import org.json.JSONArray;
import org.json.JSONObject;

public class InsertDao {

	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private DataSource ds = null;
	
	public InsertDao() {
		
	}
	
	private void getConnectpool() {
		try {
			Context context = new InitialContext();
			ds = (DataSource)context.lookup("java:comp/env/jdbc/mariadb");
			conn = ds.getConnection();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	public void InsertMember(String name, String id, String pw, String addr, String year, String month, String day, String gender) throws IOException{
		
		String sql = "insert into member (name, id, pw, addr, birthday, age, gender) values (?,?,?,?,?,?,?)";
		
		try {
			
			getConnectpool();
			
			Calendar cal = Calendar.getInstance();
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, name);
			pstmt.setString(2, id);
			pstmt.setString(3, pw);
			pstmt.setString(4, addr);
			pstmt.setString(5, year+"-"+month+"-"+day);
			pstmt.setInt(6, cal.get(Calendar.YEAR)-Integer.parseInt(year)+1);
			pstmt.setString(7, gender);
			
			pstmt.executeUpdate();

			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if(pstmt != null) {pstmt.close();}
				if(conn != null) {conn.close();}
			} catch (Exception e2) {
				// TODO: handle exception
			}
			
		}
		
	}
	
	public void InsertRestaurant() throws IOException{
		
		String line = null;
		String[] line_s = null;
		
		String sql = "insert into restaurant values (?,?,?,?,?,?,?,?,?,?,?,?)";
		
		try {
			
			getConnectpool();
			
			BufferedReader br = new BufferedReader(new FileReader("D:/jsp/eclipse-ee/workspace/foodproject1/WebContent/data/gv_food.txt"));
			
			while (true) {
				
				line = br.readLine();
				
				if (line == null) {
					break;
				}
				
				line_s = line.split("nnn");
				
				System.out.println(line);
				
				pstmt = conn.prepareStatement(sql);
				for (int i = 0; i <= 11; i++) {
					pstmt.setString(i+1, line_s[i]);
				}
				pstmt.executeUpdate();
			}

			br.close();
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if(pstmt != null) {pstmt.close();}
				if(conn != null) {conn.close();}
			} catch (Exception e2) {
				// TODO: handle exception
			}
			
		}
		
	}
	
	public void InsertDistrict() throws IOException{
		
		String insert = "insert into gugun (area, dosi, gugun) values (?,?,?)";
		String select = "select * from dosi";
		String line = null;
		ResultSet rs = null;
		
		try {
			
			getConnectpool();
			
			BufferedReader br = new BufferedReader(new FileReader("D:/jsp/eclipse-ee/workspace/foodproject1/WebContent/json/abc.json"));
			String result = br.readLine();
			
			while(true) {
				
				line = br.readLine();
				
				if (line == null) {
					break;
				}
				result += line;
			}			
			
			JSONObject obj = new JSONObject(result);
			
			pstmt = conn.prepareStatement(select);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				String a = rs.getString("area");
				String b = rs.getString("dosi");
				
				JSONObject oobj = new JSONObject(obj.get(a).toString());
				JSONArray array = new JSONArray(oobj.get(b).toString());
				
				for(int i=0; i<array.length(); i++) {
					pstmt = conn.prepareStatement(insert);
					
					pstmt.setString(1, a);
					pstmt.setString(2, b);
					pstmt.setString(3, array.getString(i));
					
					pstmt.executeUpdate();
					System.out.println(array.getString(i)+", ");
				}
			}
//			System.out.println(obj);
//			System.out.println(obj.get("수도권"));
//			System.out.println(oobj.get("서울특별시"));
//			System.out.println(array.getString(0));
//			System.out.println(result);
			
			br.close();
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if(pstmt != null) {pstmt.close();}
				if(conn != null) {conn.close();}
			} catch (Exception e2) {
				// TODO: handle exception
			}
			
		}
		
	}
}
