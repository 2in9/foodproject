package project.co.kr;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class SelectDao {
	
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private DataSource ds = null;
	
	public SelectDao() {
		
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
	
public boolean idCheck(String id){
	
		ResultSet rs = null;
		int ckId = 0;
		
		String sql = "SELECT id FROM member WHERE id=?";
		
		try {
			getConnectpool();
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				ckId+=1;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if(rs != null) {rs.close();}
				if(pstmt != null) {pstmt.close();}
				if(conn != null) {conn.close();}
			} catch (Exception e2) {
				// TODO: handle exception
			}
		}
		
		if(ckId>0) {
			return false;
		} else {
			return true;
		}
	}
	
	public ArrayList<DistrictDto> setGugunDto(String dosi){
		
		ArrayList<DistrictDto> dtos = new ArrayList<DistrictDto>();
		DistrictDto dto = null;
		ResultSet rs = null;
		
		String sql = "SELECT DISTINCT gugun FROM district WHERE dosi=?";
		
		try {
			getConnectpool();
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dosi);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				dto = new DistrictDto();
				dto.setGugun(rs.getString("gugun"));
				dtos.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if(rs != null) {rs.close();}
				if(pstmt != null) {pstmt.close();}
				if(conn != null) {conn.close();}
			} catch (Exception e2) {
				// TODO: handle exception
			}
		}		
		
		return dtos;
	}
	
	public ArrayList<DistrictDto> setDosiDto(String area){
		
		ArrayList<DistrictDto> dtos = new ArrayList<DistrictDto>();
		DistrictDto dto = null;
		ResultSet rs = null;
		
		String sql = "SELECT DISTINCT dosi FROM district WHERE area=?";
		
		try {
			getConnectpool();
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, area);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				dto = new DistrictDto();
				dto.setDosi(rs.getString("dosi"));
				dtos.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if(rs != null) {rs.close();}
				if(pstmt != null) {pstmt.close();}
				if(conn != null) {conn.close();}
			} catch (Exception e2) {
				// TODO: handle exception
			}
		}		
		
		return dtos;
	}

	public ArrayList<DistrictDto> setAreaDto(){
		
		ArrayList<DistrictDto> dtos = new ArrayList<DistrictDto>();
		DistrictDto dto = null;
		ResultSet rs = null;
		
		String sql = "SELECT DISTINCT area FROM district";
		
		try {
			getConnectpool();
			
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				dto = new DistrictDto();
				dto.setArea(rs.getString("area"));
				dtos.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if(rs != null) {rs.close();}
				if(pstmt != null) {pstmt.close();}
				if(conn != null) {conn.close();}
			} catch (Exception e2) {
				// TODO: handle exception
			}
		}		
		
		return dtos;
	}
	
	public ArrayList<RestaurantDto> getCategoryDto() {		// 음식 분류
			
			ArrayList<RestaurantDto> dtos = new ArrayList<RestaurantDto>();
			RestaurantDto dto = null;
			ResultSet rs = null;
			
			String sql = "SELECT DISTINCT middleCategory FROM restaurantdata where middleCategory!='유흥주점' order by middlecategory desc";
			
			try {
				getConnectpool();
				
				pstmt = conn.prepareStatement(sql);
				//pstmt.setString(1, id);
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					dto = new RestaurantDto();
					dto.setMiddleCategory(rs.getString("middleCategory"));
					dtos.add(dto);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				try {
					if(rs != null) {rs.close();}
					if(pstmt != null) {pstmt.close();}
					if(conn != null) {conn.close();}
				} catch (Exception e2) {
					// TODO: handle exception
				}
			}
			return dtos;
	}
	
	public ArrayList<RestaurantDto> setCoordDto(String Category, String Dosi, String Gugun, String Keyword) {		// 마킹 좌표
		
		ArrayList<RestaurantDto> dtos = new ArrayList<RestaurantDto>();
		RestaurantDto dto = null;
		ResultSet rs = null;
		
		String sql = "SELECT @r := @r+1 num, headName, GroundNumAddr, WGS84X_Coord, WGS84Y_Coord from restaurantdata, (SELECT @r := 0) tmp WHERE middleCategory=? and GroundNumAddr LIKE ? and headName LIKE ?";
		
		
		try {
			
			getConnectpool();
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, Category);
			pstmt.setString(2, '%'+Dosi+'%'+Gugun+'%');
			pstmt.setString(3, '%'+Keyword+'%');
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				dto = new RestaurantDto();
				dto.setNum(rs.getString("num"));
				dto.setHeadName(rs.getString("headName"));
//				dto.setBranchName(rs.getString("branchName"));
//				dto.setMiddleCategory(rs.getString("middleCategory"));
//				dto.setSmallCategory(rs.getString("smallCategory"));
				dto.setGroundNumAddr(rs.getString("GroundNumAddr"));
//				dto.setRoadNumAddr(rs.getString("RoadNumAddr"));
//				dto.setPostNum(rs.getString("PostNum"));
				dto.setWGS84X_Coord(rs.getString("WGS84X_Coord"));
				dto.setWGS84Y_Coord(rs.getString("WGS84Y_Coord"));
//				dto.setUTM_KX_Coord(rs.getString("UTM_KX_Coord"));
//				dto.setUTM_KY_Coord(rs.getString("UTM_KY_Coord"));
				dtos.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if(rs != null) {rs.close();}
				if(pstmt != null) {pstmt.close();}
				if(conn != null) {conn.close();}
			} catch (Exception e2) {
				// TODO: handle exception
			}
		}
		return dtos;
	}
	
	public ArrayList<RestaurantDto> setCoordDto(String Dosi, String Gugun, String Keyword) {		// 마킹 좌표
		
		ArrayList<RestaurantDto> dtos = new ArrayList<RestaurantDto>();
		RestaurantDto dto = null;
		ResultSet rs = null;
		
		String sql = "SELECT headName, GroundNumAddr, WGS84X_Coord, WGS84Y_Coord from restaurantdata WHERE GroundNumAddr LIKE ? and headName LIKE ?";
		
		try {
			
			getConnectpool();
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, '%'+Dosi+'%'+Gugun+'%');
			pstmt.setString(2, '%'+Keyword+'%');
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				dto = new RestaurantDto();
//				dto.setNum(rs.getString("num"));
				dto.setHeadName(rs.getString("headName"));
//				dto.setBranchName(rs.getString("branchName"));
//				dto.setMiddleCategory(rs.getString("middleCategory"));
//				dto.setSmallCategory(rs.getString("smallCategory"));
				dto.setGroundNumAddr(rs.getString("GroundNumAddr"));
//				dto.setRoadNumAddr(rs.getString("RoadNumAddr"));
//				dto.setPostNum(rs.getString("PostNum"));
				dto.setWGS84X_Coord(rs.getString("WGS84X_Coord"));
				dto.setWGS84Y_Coord(rs.getString("WGS84Y_Coord"));
//				dto.setUTM_KX_Coord(rs.getString("UTM_KX_Coord"));
//				dto.setUTM_KY_Coord(rs.getString("UTM_KY_Coord"));
				dtos.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if(rs != null) {rs.close();}
				if(pstmt != null) {pstmt.close();}
				if(conn != null) {conn.close();}
			} catch (Exception e2) {
				// TODO: handle exception
			}
		}
		return dtos;
	}
}
