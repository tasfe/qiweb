<%
dim adm_qq,qq,N,myqq
'《网站QQ在线咨询插件》
'作者：西门飘雪（参考腾讯技术文档编写）
'ＱＱ：646852364
'演示：http://www.szok.org
'转载请完整保留此说明文档
QQ=split(adm_qq,",")
for N=0 to UBound(QQ)
MyQQ=MyQQ+QQ(N)+":"
next
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="plug-in/qq/qq.css" type="text/css">
</head>

<script>
var online= new Array();
if (!document.layers)
document.write('<div id="divStayTopLeft" style="position:absolute">')
</script>
<layer id="divStayTopLeft">

<table border="0" width="110" cellspacing="0" cellpadding="0">
<tr><td width="110"><img border="0" src="plug-in/qq/kefu_up.gif"></td></tr>
<script src="http://webpresence.qq.com/getonline?Type=1&<%=Myqq%>"></script>

<% for N=0 to UBound(QQ) %>

<tr><td valign=middle  background=plug-in/qq/kefu_middle.gif style="padding:2px 2px 2px 6px;">
<script>
if (online[<%=n%>]==0)
document.write("&nbsp;&nbsp;<img src=plug-in/qq/QQoffline.gif border=0 align=middle><a class='qqb' target=blank href='http://wpa.qq.com/msgrd?V=1&Uin=<%=QQ(n)%>&Site=在线咨询&Menu=no' title='客服不在线，请留言'><%=QQ(n)%></a>");
else
document.write("&nbsp;&nbsp;<img src=plug-in/qq/QQonline.gif border=0 align=middle><a class='qqa' target=blank href='http://wpa.qq.com/msgrd?V=1&Uin=<%=QQ(n)%>&Site=在线咨询&Menu=no' title='在线即时交谈'><%=QQ(n)%></a>");
</script >
</td></tr>
<%next%>
<tr><td width="110"><img border=0 src=plug-in/qq/kefu_down.gif></td></tr>
</table>
</layer>
<script type="text/javascript">
var verticalpos="frombottom"
if (!document.layers)
document.write('</div>')
function JSFX_FloatTopDiv()
{
//默认情况显示在屏幕左侧，若要显示在右侧，修改下面的3
	var startX =3,
	startY = 250;
	var ns = (navigator.appName.indexOf("Netscape") != -1);
	var d = document;
	function ml(id)
	{
		var el=d.getElementById?d.getElementById(id):d.all?d.all[id]:d.layers[id];
		if(d.layers)el.style=el;
		el.sP=function(x,y){this.style.left=x;this.style.top=y;};
		el.x = startX;
		if (verticalpos=="fromtop")
		el.y = startY;
		else{
		el.y = ns ? pageYOffset + innerHeight : document.body.scrollTop + document.body.clientHeight;
		el.y -= startY;
		}
		return el;
	}
	window.stayTopLeft=function()
	{
		if (verticalpos=="fromtop"){
		var pY = ns ? pageYOffset : document.body.scrollTop;
		ftlObj.y += (pY + startY - ftlObj.y)/8;
		}
		else{
		var pY = ns ? pageYOffset + innerHeight : document.body.scrollTop + document.body.clientHeight;
		ftlObj.y += (pY - startY - ftlObj.y)/8;
		}
		ftlObj.sP(ftlObj.x, ftlObj.y);
		setTimeout("stayTopLeft()", 10);
	}
	ftlObj = ml("divStayTopLeft");
	stayTopLeft();
}
JSFX_FloatTopDiv();
</script>
</html>