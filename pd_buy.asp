<!--#include file="common.asp"-->
<%
pd_id=request.querystring("id")
pd_num=request.cookies("pd_buy")("P" & pd_id)
if not isnumeric(pd_num) then pd_num=0
response.cookies("pd_buy")("P" & pd_id)=pd_num+1
response.cookies("pd_buy").expires=date()+7
err_alert "OK!"
'response.redirect "pd_shop.asp"
%>
