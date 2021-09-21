package website.co.kr;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Calendar;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

import project.co.kr.DistrictDto;
import project.co.kr.InsertDao;
import project.co.kr.RestaurantDto;
import project.co.kr.SelectDao;

@WebServlet("*.do")
public class Main extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public Main() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		
		PrintWriter out = response.getWriter();
		
		RequestDispatcher dis = null ; 
		String uri = request.getRequestURI();
		String path = request.getContextPath();
//		HttpSession session = request.getSession();
		InsertDao inDao = new InsertDao();
		SelectDao selDao = new SelectDao();
		uri = uri.replace(path, "");
		String pageName = null;
		
//		System.out.println(uri);
		
		if(uri.equals("/main.do")) {
			ArrayList<RestaurantDto> Categorylist = selDao.getCategoryDto();
			ArrayList<DistrictDto> Arealist = selDao.setAreaDto();
			request.setAttribute("Categorylist", Categorylist);
			request.setAttribute("Arealist", Arealist);
			
			pageName = "./index.jsp";
		}
		
		else if(uri.equals("/login.do")) {
			
			pageName = "./login.jsp";
		}
		
		else if(uri.equals("/getGugun.do")) {
			
			String dosi = request.getParameter("dosi");
			ArrayList<DistrictDto> Gugunlist = selDao.setGugunDto(dosi);
			JSONArray guguns = new JSONArray();
			
			for(int i=0; i<Gugunlist.size(); i++) {
				DistrictDto gugun = Gugunlist.get(i);
				guguns.put(gugun.getGugun());
			}
			
			out.print(guguns.toString());
			
			return;
		}
		
		else if(uri.equals("/getDosi.do")) {
			
			String area = request.getParameter("area");
			ArrayList<DistrictDto> Dosilist = selDao.setDosiDto(area);
			JSONArray dosis = new JSONArray();
			
			for(int i=0; i<Dosilist.size(); i++) {
				DistrictDto dosi = Dosilist.get(i);
				dosis.put(dosi.getDosi());
			}
			
			out.print(dosis.toString());
			
			return;
		}
		
		else if(uri.equals("/CoordData.do")) {
			String Category = request.getParameter("Category");
			String Dosi = request.getParameter("Dosi");
			String Gugun = request.getParameter("Gugun");
			String Keyword = request.getParameter("Keyword");
			
			ArrayList<RestaurantDto> CoordData = null;
			
			if(Category!=null) {
				CoordData = selDao.setCoordDto(Category, Dosi, Gugun, Keyword);
			} else {
				CoordData = selDao.setCoordDto(Dosi, Gugun, Keyword);
			}
			JSONArray Coord = null;
			JSONObject CoordOBJ = null;
			JSONArray Coords = new JSONArray();
			JSONObject CoordsOBJ = new JSONObject();
			
			for (int i = 0; i < CoordData.size() ; i++) {
				RestaurantDto r = CoordData.get(i);
				CoordOBJ = new JSONObject();
				Coord = new JSONArray();
				
				CoordOBJ.put("content", "<div>"+r.getHeadName()+"</div>");
				CoordOBJ.put("name", r.getHeadName());
				CoordOBJ.put("addr", r.getGroundNumAddr());
				
				Coord.put(r.getWGS84Y_Coord());
				Coord.put(r.getWGS84X_Coord());
				CoordOBJ.put("latlng", Coord);
				
				Coords.put(CoordOBJ);
			}
			CoordsOBJ.put("positions", Coords);
			out.println(CoordsOBJ.toString());
			
			return;
		}
		
		else if(uri.equals("/idCheck.do")) {
			
			String id = request.getParameter("id");
			System.out.println(id);
			out.print(selDao.idCheck(id));
			
			System.out.println(id);
			
			return;
		}
		
		else if(uri.equals("/login_naver.do")) {
			String clientId = "lZ_q_G3VUDdUaqqUW5y4";//애플리케이션 클라이언트 아이디값";
		    String clientSecret = "FQCxQ1jjW7";//애플리케이션 클라이언트 시크릿값";
		    String code = request.getParameter("code");
		    String state = request.getParameter("state");
		    String redirectURI = URLEncoder.encode("http://175.200.235.98:7777", "UTF-8");
		    String apiURL;
		    apiURL = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code&";
		    apiURL += "client_id=" + clientId;
		    apiURL += "&client_secret=" + clientSecret;
		    apiURL += "&redirect_uri=" + redirectURI;
		    apiURL += "&code=" + code;
		    apiURL += "&state=" + state;
		    String access_token = "";
		    String refresh_token = "";
		    System.out.println("apiURL="+apiURL);
		    try {
		      URL url = new URL(apiURL);
		      HttpURLConnection con = (HttpURLConnection)url.openConnection();
		      con.setRequestMethod("GET");
		      int responseCode = con.getResponseCode();
		      BufferedReader br;
		      System.out.print("responseCode="+responseCode);
		      if(responseCode==200) { // 정상 호출
		        br = new BufferedReader(new InputStreamReader(con.getInputStream()));
		      } else {  // 에러 발생
		        br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
		      }
		      String inputLine;
		      StringBuffer res = new StringBuffer();
		      while ((inputLine = br.readLine()) != null) {
		        res.append(inputLine);
		      }
		      br.close();
		      if(responseCode==200) {
//		    	  out.println(res.toString());
		    	  System.out.println(res.toString());
		    	  JSONObject jsonObj = new JSONObject(res.toString());
		    	  
		    	  access_token = (String)jsonObj.get("access_token");
		    	  refresh_token = (String)jsonObj.get("refresh_token");
		      }
		    } catch (Exception e) {
		      System.out.println(e);
		    }
			
			return;
		}
		
		else if(uri.equals("/signin_ok.do")) {
			
			String name = request.getParameter("name");
			String id = request.getParameter("id");
			String pw = request.getParameter("pw");
			String addr = request.getParameter("addr");
			String year = request.getParameter("year");
			String month = request.getParameter("month");
			String day = request.getParameter("day");
			String gender = request.getParameter("gender");
			
			if(gender=="m") {
				gender="남";
			}else {
				gender="여";
			}
			
			inDao.InsertMember(name, id, pw, addr, year, month, day, gender);
			
			pageName = "./signin_ok.jsp";
		}
		
		dis = request.getRequestDispatcher(pageName);
		dis.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
