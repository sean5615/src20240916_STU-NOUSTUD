package com.acer.service.stu;

import java.io.PrintWriter;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Hashtable;

import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspWriter;

import org.springframework.stereotype.Service;

import com.acer.ajax.DataToJson;
import com.acer.ajax.LoadingStatus;
import com.acer.apps.Page;
import com.acer.db.DBAccess;
import com.acer.db.DBManager;
import com.acer.db.query.DBResult;
import com.acer.service.others.ServiceBase;
import com.acer.util.DateUtil;
import com.acer.util.Utility;
import com.nou.aut.AUTCONNECT;
import com.nou.stu.dao.STUT002DAO;
import com.nou.stu.dao.STUT002GATEWAY;

@Service
public class STU003MService extends ServiceBase {
	/** 處理查詢 Grid 資料 */
	public void doQuery(PrintWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
	{
		Connection	conn	=	null;
		DBResult	rs	=	null;

		try
		{
			conn	=	dbManager.getConnection(AUTCONNECT.mapConnect("STU", session));

			int		pageNo		=	Integer.parseInt(Utility.checkNull(requestMap.get("pageNo"), "1"));
			int		pageSize	=	Integer.parseInt(Utility.checkNull(requestMap.get("pageSize"), "10"));
			StringBuffer	sql		=	new StringBuffer();

	        STUT002GATEWAY SS = new STUT002GATEWAY(dbManager,conn);
	        rs = SS.getStut003Query(requestMap);
			out.println(DataToJson.rsToJson (Page.getTotalRowCount(), rs));
		}
		catch (Exception ex)
		{
			throw ex;
		}
		finally
		{
			if (rs != null)
				rs.close();
			if (conn != null)
				conn.close();

			rs	=	null;
			conn	=	null;
		}
	}

	/** 修改帶出資料 */
	public void doQueryEdit(PrintWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
	{
		Connection	conn	=	null;
		DBResult	rs	=	null;
		
		//String stno = (String)session.getAttribute("USER_ID");
		//String idno = (String)session.getAttribute("USER_IDNO");
		//String name = (String)session.getAttribute("USER_NAME");
		
		//中心登入駐記
		String	isCenter	=	Utility.checkNull(requestMap.get("isCenter"), "");
		
		String	stno	=	"";
		String	idno	=	"";
		String	name	=	"";
		System.out.println("isCenter="+isCenter);
		//為中心登入
		if ("Y".equals(isCenter))
		{
			stno	=	Utility.checkNull(requestMap.get("STNO"), "");
			idno	=	Utility.checkNull(requestMap.get("IDNO"), "");
			name	=	Utility.checkNull(requestMap.get("NAME"), "");
		}
		//為學生登入
		else
		{
			stno	=	(String)session.getAttribute("USER_ID");
			idno	=	(String)session.getAttribute("USER_IDNO");
			name	=	(String)session.getAttribute("USER_NAME");
		}
		
		
		System.out.println("stno="+stno);
		
		try
		{
			conn	=	dbManager.getConnection(AUTCONNECT.mapConnect("STU", session));
	        STUT002GATEWAY SS = new STUT002GATEWAY(dbManager,conn);
	        rs = SS.getStut003QueryEdit(idno,name,stno);
			out.println(DataToJson.rsToJson (rs));
		}
		catch (Exception ex)
		{
			throw ex;
		}
		finally
		{
			if (conn != null)
				conn.close();
			if (rs != null)
				rs.close();

			rs	=	null;
			conn	=	null;
		}
	}

	/** 修改存檔 */
	public void doModify(PrintWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
	{
		Connection	conn	=	null;
		DBResult rs = null;
		try
		{
			conn	=	dbManager.getConnection(AUTCONNECT.mapConnect("STU", session));
			rs = dbManager.getResultSet(conn);


			/** 修改條件 */
			String	condition	=	" IDNO	=	'" + Utility.dbStr(requestMap.get("IDNO"))+ "' AND " +							
							"ROWSTAMP	=	'" + Utility.dbStr(requestMap.get("ROWSTAMP")) + "'  ";


			/** 處理修改動作 */
			DBAccess	dba	=	dbManager.getDBAccess(conn);
			//rs.open();
			STUT002DAO s2= new STUT002DAO(dbManager,conn);
			s2.setWhere(condition);
			rs =s2.query();
			try {
				//rs.executeQuery("SELECT * FROM STUT002 WHERE " + condition);
				if (rs.next()) {
					dba.setTableName("STUU002");
					for (int i=1;i<=rs.getColumnCount();i++) {
						dba.setColumn(rs.getColumnName(i),rs.getString(i));
					}					
					dba.insert();
				}
			} finally {
				if (rs != null) rs.close();
			}

			/** Set Table */
			dba.setTableName("STUT002");

			/** Set Column */
			//dba.setColumn("IDNO",			Utility.dbStr(requestMap.get("IDNO")));
			//dba.setColumn("BIRTHDATE",		Utility.dbStr(requestMap.get("BIRTHDATE")));
			//dba.setColumn("NAME",			Utility.dbStr(requestMap.get("NAME")));
			//dba.setColumn("ENG_NAME",		Utility.dbStr(requestMap.get("ENG_NAME")));
			//dba.setColumn("ALIAS",			Utility.dbStr(requestMap.get("ALIAS")));
			dba.setColumn("SELF_IDENTITY_SEX",		Utility.dbStr(requestMap.get("SELF_IDENTITY_SEX")));
			dba.setColumn("CRRSADDR_ZIP",		Utility.dbStr(requestMap.get("CRRSADDR_ZIP")));
			dba.setColumn("CRRSADDR",		Utility.dbStr(requestMap.get("CRRSADDR")));
			dba.setColumn("AREACODE_OFFICE",		Utility.dbStr(requestMap.get("AREACODE_OFFICE")));
			dba.setColumn("TEL_OFFICE",		Utility.dbStr(requestMap.get("TEL_OFFICE")));
			dba.setColumn("TEL_OFFICE_EXT",		Utility.dbStr(requestMap.get("TEL_OFFICE_EXT")));
			dba.setColumn("AREACODE_HOME",		Utility.dbStr(requestMap.get("AREACODE_HOME")));
			dba.setColumn("TEL_HOME",		Utility.dbStr(requestMap.get("TEL_HOME")));
			dba.setColumn("MOBILE",			Utility.dbStr(requestMap.get("MOBILE")));
			//dba.setColumn("MARRIAGE",		Utility.dbStr(requestMap.get("MARRIAGE")));
			dba.setColumn("EMAIL",			Utility.dbStr(requestMap.get("EMAIL")));
			dba.setColumn("EMRGNCY_NAME",		Utility.dbStr(requestMap.get("EMRGNCY_NAME")));
			dba.setColumn("EMRGNCY_TEL",		Utility.dbStr(requestMap.get("EMRGNCY_TEL")));
			dba.setColumn("EMRGNCY_RELATION",	Utility.dbStr(requestMap.get("EMRGNCY_RELATION")));
			dba.setColumn("UPD_RMK","STU002M_,異動學生基本資料");
			dba.setColumn("UPD_DATE",	DateUtil.getNowDate());
			dba.setColumn("UPD_TIME",	DateUtil.getNowTimeS());
			dba.setColumn("UPD_USER_ID",	(String)session.getAttribute("USER_ID"));
			dba.setColumn("ROWSTAMP",	DateUtil.getNowTimeMs());
			

			/** Start Update */
			int	updateCount	=	dba.update(condition);
			
			
			/** Set Table */
			dba.setTableName("STUT003");

			/** Set Column */
			dba.setColumn("UPD_RMK","STU003M_,異動學生基本資料");
			dba.setColumn("UPD_DATE",	DateUtil.getNowDate());
			dba.setColumn("UPD_TIME",	DateUtil.getNowTimeS());
			dba.setColumn("UPD_USER_ID",	(String)session.getAttribute("USER_ID"));
			dba.setColumn("ROWSTAMP",	DateUtil.getNowTimeMs());
			
			dba.setColumn("stu003m_date", DateUtil.getNowDate());
			dba.setColumn("stu003m_chk", "Y");

			/** Start Update */
			int	updateCount003	=	dba.update(condition);

			/** Commit Transaction */
			dbManager.commit();

			/* === LoadingBar === */
			LoadingStatus.setStatus(session.getId(), 60, "(S)STUT002、STUT003 資料儲存完畢", LoadingStatus.success);

			if (updateCount == 0)
				out.println(DataToJson.faileJson("此筆資料已被異動過, <br>請重新查詢修改!!"));
			else
				out.println(DataToJson.successJson());
		}
		catch (Exception ex)
		{
			/* === LoadingBar === */
			LoadingStatus.setStatus(session.getId(), 60, "(S)STUT002、STUT003 資料儲存失敗", LoadingStatus.success);

			/** Rollback Transaction */
			dbManager.rollback();

			throw ex;
		}
		finally
		{
			if (conn != null)
				conn.close();
			conn	=	null;
		}
	}
}
