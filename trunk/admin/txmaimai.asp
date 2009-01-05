<!--#include file="../common.asp"-->
<%

call check_admin()
	txmaimai_open=db_getvalue("setup_name='txmaimai_open'","sys_setup","setup_value")
	shop_logo=db_getvalue("setup_name='shop_logo'","sys_setup","setup_value")
	shop_desc=db_getvalue("setup_name='shop_desc'","sys_setup","setup_value")
	shop_product=db_getvalue("setup_name='shop_product'","sys_setup","setup_value")
	product_num=db_getvalue("setup_name='product_num'","sys_setup","setup_value")
	shop_carry=db_getvalue("setup_name='shop_carry'","sys_setup","setup_value")
	shop_freight=db_getvalue("setup_name='shop_freight'","sys_setup","setup_value")
	shop_QQ=db_getvalue("setup_name='shop_QQ'","sys_setup","setup_value")
	
	if ufomail_request("Form","action")<>"" then
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","txmaimai_open") & "|+|txmaimai_open","setup_name='txmaimai_open'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","shop_logo") & "|+|shop_logo","setup_name='shop_logo'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","shop_desc") & "|+|shop_desc","setup_name='shop_desc'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","shop_product") & "|+|shop_product","setup_name='shop_product'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","product_num") & "|+|product_num","setup_name='product_num'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","shop_carry") & "|+|shop_carry","setup_name='shop_carry'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","shop_freight") & "|+|shop_freight","setup_name='shop_freight'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","shop_QQ") & "|+|shop_QQ","setup_name='shop_QQ'")
		response.Redirect "txmaimai.asp"
	end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>天下买卖网店联盟</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>

<div class="page-title">天下买卖网店联盟介绍</div>
<div class="help-info"> 天下买卖网是一个专门为在淘宝，拍拍，易趣等C2C开网店的用户提供货源服务的专业网站。在成立不长的时间内已吸引了数以千记的用户注册。这些用户有些是兼职者，有些是学生，有些是专业卖家。天下买卖提供了一个供没有货源，没有资金的创业者提供一个创业机会，让他们通能代销天下卖网内的商品获得可观的经济收益。天下买卖网提供着极为着专业的网上开店的各项技术支持，让各个网店用户不断提升自己的销售业绩。<br>
  同时，天下买卖为网店用户提供货源的同时，也积极和上游生产厂家建立货源合作<a href="count"></a>，为生产厂商提供一个非常有效的产品推广平台。我们的网店会员通过自己在淘宝，拍拍的销售会为厂家的产品吸引更多的眼球，这是无论任何广告都无法达到的效果。同时我们的网店会员同时也成为了生产厂商无须付每月工资的“业务员”。<br>
</div>
<div class="page-title">如何加入天下买卖网店联盟</div>
<div class="help-info"> <br>
  1、 点击这里注册成为天下买卖网的“供应商会员”<br>
  2、在下面设置你在天下买卖网中的商家信息；<br>
  3、设置商品买卖的类型。</div>
<div class="page-title">商家信息设置及商品设置</div>
<div class="oper-content"><form name="form1" method="post" action="">
是否加入天下买卖网网店联盟：<select name="txmaimai_open" id="txmaimai_open" onChange="javascript:if(this.options[this.selectedIndex].value==0)shop_setup.style.display='none';else shop_setup.style.display='';">
        <option value="0" <%if txmaimai_open="0" then response.write " selected='selected'"%>>不加入</option>
        <option value="1" <%if txmaimai_open="1" then response.write " selected='selected'"%>>加入</option>
      </select><br>
	  <div id="shop_setup" <%if txmaimai_open="0" then response.write " style='display:none;'"%>> 
<hr size="1"/>
      店铺标志 ： 
      <input name="shop_logo" type="text" id="shop_logo" value="<%=shop_logo%>">
      (图片链接)<br>
      商家介绍：<br>
      <textarea name="shop_desc" cols="50" rows="9" id="shop_desc"><%=shop_desc%></textarea>
      <br>
      商家退荐的五款主打商品，录入商品的链接：<br>
      1、 <%shop_product=split(shop_product & ",,,,,",",")%>
      <input name="shop_product" type="text" id="shop_product" value="<%=trim(shop_product(0))%>">
      <br>
      2、
      <input name="shop_product" type="text" id="shop_product" value="<%=trim(shop_product(1))%>">
      <br>
      3、
      <input name="shop_product" type="text" id="shop_product" value="<%=trim(shop_product(2))%>">
      <br>
      4、
      <input name="shop_product" type="text" id="shop_product" value="<%=trim(shop_product(3))%>">
      <br>
      5、
      <input name="shop_product" type="text" id="shop_product" value="<%=trim(shop_product(3))%>">
      <br>
      起批数量：
      <input name="product_num" type="text" id="product_num" value="<%=product_num%>">
      <br>
      代发货：
      <input name="shop_carry" type="text" id="shop_carry" value="<%=shop_carry%>">
      <br>
      运费政策： 
      <input name="shop_freight" type="text" id="shop_freight" value="<%=shop_freight%>">
      <br>
      店铺客服：
      <input name="shop_QQ" type="text" id="shop_QQ" value="<%=shop_QQ%>">
      （QQ号码）<br>
<hr size="1"/>
</div>
<input type="submit" name="action" value="保存设置">
</form></div>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br></body>
</html>
