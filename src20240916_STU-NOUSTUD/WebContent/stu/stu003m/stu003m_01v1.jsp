<%@ page import="com.nou.aut.AUTICFM, com.acer.util.*" %>
<%@ page import="com.nou.UtilityX" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../include/pages/checkUser.jsp"%>
<%@ include file="../../include/pages/query.jsp"%>
<%@ include file="../../include/pages/query1_1_0_2.jsp" %>
<%	
	String id_type = (String)session.getAttribute("ID_TYPE");	
	String isCenter ="N";
	if (!id_type.equals("1")) {
		System.out.println("id_type="+id_type);
		if(!id_type.equals("4")){
			isCenter ="Y";		
		}		
		/*
		out.println("<script>");
		out.println("alert('無權限進入此系統');");
		out.println("window.location='../../home/home00/main.htm';");		
		out.println("</script>");
		*/
	}
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>data</title>
<script language="javascript">
<!--
	/** 初始設定頁面資訊 */
	var	printPage		=	"/stu/stu003m/_01p1";	//列印頁面
	var	editMode		=	"ADD";				//編輯模式, ADD - 新增, MOD - 修改
	
	var	listShow		=	true;				//是否一進入顯示資料
	
	var	controlPage		=	"_01c2";	//控制頁面
	var	checkObj		=	new checkObj();			//核選元件
	var	queryObj		=	new queryObj();			//查詢元件
	
	var	noPermissAry		=	new Array();			//沒有權限的陣列
	
	/** 網頁初始化 */
	function page_init()
	{
		//page_init_start();
		
		editMode	=	"NONE";
		/** 權限檢核 */
		securityCheck();
	
		/** === 初始欄位設定 === */
		/** 初始上層帶來的 Key 資料 */
		iniMasterKeyColumn();
	
		/** 初始編輯欄位 */
		Form.iniFormSet('EDIT', 'IDNO', 'R', 1, 'S', 10, 'M',  10, 'A');
		Form.iniFormSet('EDIT', 'BIRTHDATE', 'R', 1, 'S', 8, 'N1', 'M',  8, 'A', 'DT');
		Form.iniFormSet('EDIT', 'NAME', 'R', 1, 'S', 10, 'M',  10, 'FS');
		Form.iniFormSet('EDIT', 'ENG_NAME', 'R', 1, 'S', 20, 'SE', 'M',  20, 'A');
		Form.iniFormSet('EDIT', 'ALIAS', 'R', 1, 'S', 20, 'M',  20, 'A');
		Form.iniFormSet('EDIT', 'SEX', 'M',  10, 'A', 'D', 1);
		Form.iniFormSet('EDIT', 'SELF_IDENTITY_SEX', 'M',  10, 'A');
		Form.iniFormSet('EDIT', 'CRRSADDR_ZIP', 'S', 5, 'N', 'M',  5, 'A');
		Form.iniFormSet('EDIT', 'CRRSADDR', 'S', 50, 'M',  50, 'A','FS');
		// Form.iniFormSet('EDIT', 'AREACODE_OFFICE', 'S', 3, 'N', 'M',  3, 'A');
		// Form.iniFormSet('EDIT', 'TEL_OFFICE', 'S', 12, 'N', 'M',  12, 'A');
		// Form.iniFormSet('EDIT', 'TEL_OFFICE_EXT', 'S', 5, 'N', 'M',  5, 'A');
		// Form.iniFormSet('EDIT', 'AREACODE_HOME', 'S', 3, 'N', 'M',  3, 'A');
		// Form.iniFormSet('EDIT', 'TEL_HOME', 'S', 12, 'N', 'M',  12, 'A');
		Form.iniFormSet('EDIT', 'AREACODE_OFFICE', 'S', 3, 'SE', 'M',  3, 'A');
		Form.iniFormSet('EDIT', 'TEL_OFFICE', 'S', 12, 'SE', 'M',  12, 'A');
		Form.iniFormSet('EDIT', 'TEL_OFFICE_EXT', 'S', 5, 'SE', 'M',  5, 'A');
		Form.iniFormSet('EDIT', 'AREACODE_HOME', 'S', 3, 'SE', 'M',  3, 'A');
		Form.iniFormSet('EDIT', 'TEL_HOME', 'S', 12, 'SE', 'M',  12, 'A');
		Form.iniFormSet('EDIT', 'MOBILE', 'S', 15, 'N', 'M',  15, 'A');	
		Form.iniFormSet('EDIT', 'NOU_EMAIL', 'S', 30);
		Form.iniFormSet('EDIT', 'EMAIL', 'S', 30,'M',  60, 'A');
		Form.iniFormSet('EDIT', 'EMRGNCY_NAME', 'S', 6, 'M',  6);
		Form.iniFormSet('EDIT', 'EMRGNCY_TEL', 'S', 17, 'SE', 'M',  17, 'A');
		Form.iniFormSet('EDIT', 'EMRGNCY_RELATION', 'S', 4, 'M',  2);
	
		//loadind_.showLoadingBar (15, "初始欄位完成");
		/** ================ */
	
		/** === 設定檢核條件 === */
		/** 查詢欄位 */
	
		/** 編輯欄位 */
		Form.iniFormSet('EDIT', 'CRRSADDR_ZIP', 'AA', 'chkForm', '郵遞區號');
		Form.iniFormSet('EDIT', 'CRRSADDR', 'AA', 'chkForm', '通訊地址');
		Form.iniFormSet('EDIT', 'AREACODE_HOME', 'AA', 'chkForm', '聯絡電話(宅)');
		Form.iniFormSet('EDIT', 'TEL_HOME', 'AA', 'chkForm', '聯絡電話(宅)');
		Form.iniFormSet('EDIT', 'MOBILE', 'AA', 'chkForm', '行動電話');
		Form.iniFormSet('EDIT', 'EMAIL', 'AA', 'chkForm', '個人電子信箱');
		Form.iniFormSet('EDIT', 'EMRGNCY_NAME', 'AA', 'chkForm', '緊急聯絡人');
		Form.iniFormSet('EDIT', 'EMRGNCY_TEL', 'AA', 'chkForm', '緊急聯絡人電話');
		Form.iniFormSet('EDIT', 'EMRGNCY_RELATION', 'AA', 'chkForm', '緊急聯絡人關係');
	
		doEdit("USER_ID|");
	}
	
	
	
	/** 新增功能時呼叫 */
	function doAdd()
	{
		doEdit("USER_ID|");
		return;
		doAdd_start();
	
		/** 清除唯讀項目(KEY)*/
		Form.iniFormSet('EDIT', 'IDNO', 'R', 0);
		Form.iniFormSet('EDIT', 'NAME', 'R', 0);
	
		/** 初始上層帶來的 Key 資料 */
		iniMasterKeyColumn();
	
		/** 設定 Focus */
		Form.iniFormSet('EDIT', 'IDNO', 'FC');
	
		/** 初始化 Form 顏色 */
		Form.iniFormColor();
	
		/** 停止處理 */
		queryObj.endProcess ("新增狀態完成");
	}
	
	/** 修改功能時呼叫 */
	function doModify()
	{
		/** 設定修改模式 */
		editMode		=	"UPD";
		EditStatus.innerHTML	=	"修改";
	
		/** 清除唯讀項目(KEY)*/
		Form.iniFormSet('EDIT', 'IDNO', 'R', 1);
		Form.iniFormSet('EDIT', 'NAME', 'R', 1);
	
		/** 初始化 Form 顏色 */
		Form.iniFormColor();
	
		/** 設定 Focus */
		Form.iniFormSet('EDIT', 'BIRTHDATE', 'FC');
	}
	
	/** 存檔功能時呼叫 */
	function doSave()
	{
		doSave_start();
	
		/** 判斷新增無權限不處理 */
		if (editMode == "NONE")
			return;
	
		/** 資料檢核及設定, 當有錯誤處理方式為 Form.errAppend(Message) 累計錯誤訊息 */
		//if (Form.getInput("QUERY", "SYS_CD") == "")
		//	Form.errAppend("系統編號不可空白!!");
		var email = Form.getInput("EDIT","EMAIL");
		if (email != "" && !checkMail(email)) {
			Form.errAppend("個人電子信箱所填資料文字或格式不正確，請再確認!!");
		}
		
		
		if($("input:checkbox:checked").val() == "0" || $("input:checkbox:checked").length == 0) {
			Form.errAppend("請確認資料是否正確，若完成修改或確認無誤，請於「確認資料正確」欄位勾選〝是〞，並進行存檔！<br><font color='green'><b>※重要提醒：為使您可收到校務或教學相關訊息，請再次確認您的「個人電子信箱」是否正確無誤。</b></font>");			
		}
	
		doSave_end()
	}
	
	/** ============================= 欲修正程式放置區 ======================================= */
	/** 設定功能權限 */
	function securityCheck()
	{
		try
		{
			/** 查詢 */
			if (!<%=AUTICFM.securityCheck (session, "QRY")%>)
			{
				noPermissAry[noPermissAry.length]	=	"QRY";
				try{Form.iniFormSet("QUERY", "QUERY_BTN", "D", 1);}catch(ex){}
			}
			/** 新增 */
			if (!<%=AUTICFM.securityCheck (session, "ADD")%>)
			{
				noPermissAry[noPermissAry.length]	=	"ADD";
				editMode	=	"NONE";
				try{Form.iniFormSet("EDIT", "ADD_BTN", "D", 1);}catch(ex){}
			}
			/** 修改 */
			if (!<%=AUTICFM.securityCheck (session, "UPD")%>)
			{
				noPermissAry[noPermissAry.length]	=	"UPD";
			}
			/** 新增及修改 */
			if (!chkSecure("ADD") && !chkSecure("UPD"))
			{
				try{Form.iniFormSet("EDIT", "SAVE_BTN", "D", 0);}catch(ex){}
			}
			/** 刪除 */
			if (!<%=AUTICFM.securityCheck (session, "DEL")%>)
			{
				noPermissAry[noPermissAry.length]	=	"DEL";
				try{Form.iniFormSet("RESULT", "DEL_BTN", "D", 1);}catch(ex){}
			}
			/** 匯出 */
			if (!<%=AUTICFM.securityCheck (session, "EXP")%>)
			{
				noPermissAry[noPermissAry.length]	=	"EXP";
				try{Form.iniFormSet("RESULT", "EXPORT_BTN", "D", 1);}catch(ex){}
				try{Form.iniFormSet("QUERY", "EXPORT_ALL_BTN", "D", 1);}catch(ex){}
			}
			/** 列印 */
			if (!<%=AUTICFM.securityCheck (session, "PRT")%>)
			{
				noPermissAry[noPermissAry.length]	=	"PRT";
				try{Form.iniFormSet("RESULT", "PRT_BTN", "D", 1);}catch(ex){}
				try{Form.iniFormSet("QUERY", "PRT_ALL_BTN", "D", 1);}catch(ex){}
			}
		}
		catch (ex)
		{
		}
	}
	
	/** 檢查權限 - 有權限/無權限(true/false) */
	function chkSecure(secureType)
	{
		if (noPermissAry.toString().indexOf(secureType) != -1)
			return false;
		else
			return true
	}
	
	/** ====================================================================================== */	
	
	function setADDR() {
		if (Form.getInput("EDIT","CRRSADDR") != "") return;
		var zip_city = Form.getInput("EDIT","ZIP_CITY");
		var zip_town = Form.getInput("EDIT","ZIP_TOWN");
		Form.setInput("EDIT","CRRSADDR",zip_city+zip_town);
	}
	
	function checkMail( str ) {
		//var mailform = /^[_a-z0-9A-Z\.]+@([_a-z0-9A-Z]+\.)+[a-z0-9A-Z]{2,3}$/;
		var mailform = /^[-_a-z0-9A-Z\.]+@([-_a-z0-9A-Z]+\.)+[a-z0-9A-Z]{2,3}$/;
		//var mailform = /^.+@.+\..+?/;
		return  mailform.test( str );			
	}
	/** 存檔功能時呼叫結束 */
	function doSave_end()
	{
		/** 檢核設定欄位*/
		Form.startChkForm("EDIT");
	
		/** 減核錯誤處理 */
		if (!queryObj.valideMessage (Form))
			return;
	
		/** = 送出表單 = */
		/** 設定狀態 */
		var	actionMode	=	"";
		if (editMode == "ADD")
			actionMode	=	"ADD_MODE";
		else
			actionMode	=	"EDIT_MODE";
	
		var	callBack	=	function (ajaxData)
		{
			if (ajaxData == null)
				return;
	
			/** 停止處理 */
			Message.hideProcess();
	
			if (editMode == "ADD"){			
				Message.openSuccess("A01");
			}else{			
				alert("資料修改成功!");
				Message.openSuccess("A02");
				//by poto 2008/03/03
				if(Form.getInput("EDIT","LINK")=='CCS003M'||Form.getInput("EDIT","LINK")=='CCS010M'||Form.getInput("EDIT","LINK")=='CCS011M'||Form.getInput("EDIT","LINK")=='CCS012M'){		
					window.close();
				}
			}	
				
			/** 設定為新增模式 */
			doAdd();
			
			//v0.0.2
			/** 重設 Grid 2006/11/16 nono add, 2007/01/07 調整判斷方式 */
			/*
			if (chkHasQuery())
			{
				iniGrid();
			}
			*/
		}
		sendFormData("EDIT", controlPage, actionMode, callBack);
	}	
	
	/** 查詢清除 */
	function doReset()
	{
		doEdit("USER_ID|");
		return;
	}
-->
</script>
</head>

<body>
<span id="lblFunc" class="title"></span>
<jsp:include page="../../include/pages/title.jsp" />

	<form id="EDIT" name="EDIT" method="POST">
		<input type=hidden name="control_type">
	    <input type=hidden name="ROWSTAMP">
		
		<input type=hidden name="USER_ID">
		<input type=hidden name="LINK">
		
		<input type=hidden name="STNO">
		<input type=hidden name="isCenter" value="<%=isCenter%>">
		
		<div class="title">【編輯畫面】- <span id='EditStatus'>新增</span></div>

		<div align='center'>
			<%
				//showMsg((String) request.getAttribute("message"), out);
			%>
		</div>		
		<!----------------------單筆資料開始------------------------------------------------------>
		<table class="box1" cellSpacing="0" cellPadding="0" border="0" width="100%">
			<tr>
				<td>
					<table class="box2" cellSpacing="0" cellPadding="5" width="100%" border="0">
					<tr>
						<td align='right' class='dataHeader'>身分證字號：</td>
						<td class='dataColor00'><input type=text name='IDNO'></td>
						<td align='right' class='dataHeader'>出生日期：</td>
						<td class='dataColor00'><input type=text name='BIRTHDATE'></td>
					</tr>
					<tr>
						<td align='right' class='dataHeader'>姓名：</td>
						<td class='dataColor00'><input type=text name='NAME'></td>
						<td align='right' class='dataHeader'>英文姓名：</td>
						<td class='dataColor00'><input type=text name='ENG_NAME'></td>
					</tr>
					<tr>
						<td align='right' class='dataHeader'>別名：</td>
						<td class='dataColor00'><input type=text name='ALIAS'></td>
						<td align='right' class='dataHeader'>性別：</td>
						<td class='dataColor00'>法定性別<font color=red>＊</font>：
							<select name='SEX'>
								<option value=''>請選擇</option>
								<option value='1'>男</option>
								<option value='2'>女</option>
								</select><br>
							自我認同性別：
							<select name='SELF_IDENTITY_SEX'>
								<option value=''>請選擇</option>
								<option value='1'>男</option>
								<option value='2'>女</option>
								<option value='3'>非二元</option>
							</select>
						</td>
					<tr>
						<td align='right' class='dataHeader'>通訊地址<font color='red'>＊</font>：</td>
						<td class='dataColor00' colspan="3">郵遞區號(<input type=text Column='ZIP' name='CRRSADDR_ZIP' onblur='Form.blurData("SYST006_01_BLUR", "ZIP", this.value , ["ZIP_CITY","ZIP_TOWN"],[_i("EDIT", "ZIP_CITY"),_i("EDIT", "ZIP_TOWN")], true);'>)
						<img src='/images/select.gif' alt='開窗選取' style='cursor:hand' onkeypress='Form.openPhraseWindow("SYST006_01_WINDOW", "","", "郵遞區號,縣市,鄉鎮區", [_i("EDIT", "CRRSADDR_ZIP")]);' onclick='Form.openPhraseWindow("SYST006_01_WINDOW", "","", "郵遞區號,縣市,鄉鎮區", [_i("EDIT", "CRRSADDR_ZIP"),_i("EDIT", "ZIP_CITY"),_i("EDIT", "ZIP_TOWN")]);'>							
						<input type=text name='CRRSADDR'>	
						<input type=hidden Column='ZIP_CITY' name='ZIP_CITY'>
						<input type=hidden Column='ZIP_TOWN' name='ZIP_TOWN' onpropertychange=setADDR()>			
						</td>
						
						
					</tr>
					<tr>						
						<td align='right' class='dataHeader'>聯絡電話(公)：</td>
						<td class='dataColor00'>(<input type=text name='AREACODE_OFFICE'>)<input type=text name='TEL_OFFICE'>分機<input type=text name='TEL_OFFICE_EXT'> ex:(02)12345678</td>
						<td align='right' class='dataHeader'>聯絡電話(宅)<font color='red'>＊</font>：</td>
						<td class='dataColor00'>(<input type=text name='AREACODE_HOME'>)<input type=text name='TEL_HOME'> ex:(02)12345678</td>
					</tr>
					<tr>
						<td align='right' class='dataHeader'>行動電話<font color='red'>＊</font>：</td>
						<td class='dataColor00'><input type=text name='MOBILE'> ex:0932123456</td>
						<!--
						<td align='right' class='dataHeader'>婚姻狀況：</td>
						<td class='dataColor00'>
							<select name='MARRIAGE' disabled>
								<script>Form.getSelectFromPhrase("SYST001_01_SELECT","KIND","MARRIAGE");</script>
							</select>
						</td>-->
						<td align='right' class='dataHeader'>空大電子信箱：</td>
						<td class='dataColor00'>
							<input type=text name='NOU_EMAIL' readonly>
						</td>
					</tr>
					<tr>
						<td align='right' class='dataHeader'>個人電子信箱<font color='red'>＊</font>：</td>
						<td class='dataColor00'><input type=text name='EMAIL'><br>如果沒有個人電子信箱，請填寫「0@0.0」</td>
						<td align='right' class='dataHeader'>緊急聯絡人<font color='red'>＊</font>：</td>
						<td class='dataColor00'><input type=text name='EMRGNCY_NAME'></td>
					</tr>
					<tr>
						<td align='right' class='dataHeader' nowrap>緊急聯絡人電話<font color='red'>＊</font>：</td>
						<td class='dataColor00'><input type=text name='EMRGNCY_TEL'></td>
						<td align='right' class='dataHeader' nowrap>緊急聯絡人關係<font color='red'>＊</font>：</td>
						<td colspan='1' class='dataColor00'><input type=text name='EMRGNCY_RELATION'></td>
					</tr>
					<tr>
						<td align='right' class='dataHeader' nowrap>確認資料正確<font color='red'>＊</font>：</td>
						<td class='dataColor00' colspan="3">
							<label class='checkGroup'><input type="checkbox" name="check" value="1">是</label>
							<label class='checkGroup'><input type="checkbox" name="check" value="0">否</label>
							<font color='red'><b>※重要提醒：為使您可收到校務或教學相關訊息，請再次確認您的「個人電子信箱」是否正確無誤。</b></font>
						</td>
					</tr>
					</table>
					</span>
				</td>					
       		</tr>
						
			<tr>
				<td >
					<table cellSpacing="1" cellPadding="2" align="center" border="0" width="100%" >
						<tr>
							<td height="35" >								
								<%=ButtonUtil.GetButton("javascript:void(0);", "doSave();", "存  檔", false, false, false, "SAVE_BTN") %>
								<%=ButtonUtil.GetButton("javascript:void(0);", "doReset();", "清  除", false, false, false, "") %>										
							</td>							
						</tr>
					</table>
				</td>
			</tr>					
		</table>
		<!----------------------單筆資料結束------------------------------------------------------>
		<!----------------------工具列開始------------------------------------------------------>

		<!----------------------工具列結束------------------------------------------------------>		
	</form>
</body>
</html>
<script>
    document.write ("<font color=\"white\">" + document.lastModified + "</font>");
    window.addEventListener("load", page_init);
    
    $('.checkGroup input').click(function(){
  	   if($(this).prop('checked')){
	  	   $('.checkGroup input').prop('checked',false);
	  	   $(this).prop('checked',true);
  	   }
 	});
    
</script>