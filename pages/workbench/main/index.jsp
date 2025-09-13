<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%
    // 获取项目根目录路径
    String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
  %>
  <!--让路径基于根目录访问-->
  <base href="<%=basePath%>">
  <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
  <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
  <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
</head>
<body>
<img src="image/33.webp" style="position: relative;top: -10px; left: -10px; width: 100%"/>
</body>
</html>
