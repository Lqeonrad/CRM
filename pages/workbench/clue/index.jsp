<%--
  Created by IntelliJ IDEA.
  User: Leon
  Date: 2025/7/13
  Time: 10:31
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <meta charset="UTF-8">
  <%
    // 获取项目根目录路径
    String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
  %>
  <base href="<%=basePath%>">
  <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
  <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

  <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
  <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
  <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
  <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

  <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
  <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
  <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

  <!--//保存part-->
  <script type="text/javascript">
    $(function () {
      $("#saveClueBtn").click(function () {
        var clue = {
          fullname: $("#create-surname").val(),
          appellation: $("#create-call").val(),
          owner: $("#create-clueOwner").val(),
          company: $("#create-company").val(),
          job: $("#create-job").val(),
          email: $("#create-email").val(),
          phone: $("#create-phone").val(),
          website: $("#create-website").val(),
          mphone: $("#create-mphone").val(),
          state: $("#create-status").val(),
          source: $("#create-source").val(),
          description: $("#create-describe").val(),
          contactSummary: $("#create-contactSummary").val(),
          nextContactTime: $("#create-nextContactTime").val(),
          address: $("#create-address").val()
        };

        $.ajax({
          url: "workbench/clue/saveCreateClue.do",
          type: "post",
          data: clue,
          dataType: "json",
          success: function (data) {
            if (data.code === "1") {
              alert("创建成功！");
              $("#createClueModal").modal("hide");
              window.location.reload(); // 可选：刷新页面重新获取线索数据
            } else {
              alert(data.message);
            }
          },
          error: function () {
            alert("创建失败，请稍后重试！");
          }
        });
      });
      <!--删除-->
      $("#deleteClueBtn").click(function () {
        var checkedIds = $("input[type='checkbox']:checked");
        if (checkedIds.size() === 0) {
          alert("请选择要删除的线索！");
          return;
        }

        if (window.confirm("确定删除所选线索吗？")) {
          var ids = "";
          $.each(checkedIds, function () {
            ids += "id=" + this.value + "&";
          });
          ids = ids.slice(0, -1); // 去掉末尾的"&"

          $.ajax({
            url: "workbench/clue/deleteClueByIds.do",
            type: "post",
            data: ids,
            dataType: "json",
            success: function (data) {
              if (data.code === "1") {
                location.reload(); // 成功后刷新页面或调用重新查询函数
              } else {
                alert(data.message);
              }
            }
          });
        }
      });

      <!--修改-->
      $("[data-target='#editClueModal']").click(function () {
        var checkedBox = $("input[type='checkbox']:checked");
        if (checkedBox.length !== 1) {
          alert("请选择一条线索进行修改！");
          return;
        }

        var id = checkedBox.val();

        $.ajax({
          url: "workbench/clue/queryClueById.do",
          type: "get",
          data: { id: id },
          dataType: "json",
          success: function (clue) {
            // 把线索数据回显到编辑模态框中
            $("#edit-clueOwner").val(clue.owner);
            $("#edit-company").val(clue.company);
            $("#edit-call").val(clue.appellation);
            $("#edit-surname").val(clue.fullname);
            $("#edit-job").val(clue.job);
            $("#edit-email").val(clue.email);
            $("#edit-phone").val(clue.phone);
            $("#edit-website").val(clue.website);
            $("#edit-mphone").val(clue.mphone);
            $("#edit-status").val(clue.state);
            $("#edit-source").val(clue.source);
            $("#edit-describe").val(clue.description);
            $("#edit-contactSummary").val(clue.contactSummary);
            $("#edit-nextContactTime").val(clue.nextContactTime);
            $("#edit-address").val(clue.address);

            // 👇 将id作为隐藏字段或全局变量记录（可选）
            $("#editClueModal").data("cid", clue.id);

            // 打开模态框（其实你已经绑定了 data-toggle，但这里是保险）
            $("#editClueModal").modal("show");
          },
          error: function () {
            alert("查询线索失败！");
          }
        });
      });

<!--更新-->
      $("#updateClueBtn").click(function () {
        var clue = {
          id: $("#editClueModal").data("cid"), // 从模态框存储中取出 id
          fullname: $("#edit-surname").val(),
          appellation: $("#edit-call").val(),
          owner: $("#edit-clueOwner").val(),
          company: $("#edit-company").val(),
          job: $("#edit-job").val(),
          email: $("#edit-email").val(),
          phone: $("#edit-phone").val(),
          website: $("#edit-website").val(),
          mphone: $("#edit-mphone").val(),
          state: $("#edit-status").val(),
          source: $("#edit-source").val(),
          description: $("#edit-describe").val(),
          contactSummary: $("#edit-contactSummary").val(),
          nextContactTime: $("#edit-nextContactTime").val(),
          address: $("#edit-address").val()
        };

        $.ajax({
          url: "workbench/clue/saveEditClue.do",
          type: "post",
          data: clue,
          dataType: "json",
          success: function (data) {
            if (data.code === "1") {
              alert("修改成功！");
              $("#editClueModal").modal("hide");
              window.location.reload(); // 或重新加载线索列表
            } else {
              alert(data.message);
            }
          },
          error: function () {
            alert("修改失败，请稍后重试！");
          }
        });
      });

<!--分页查询-->
      // 分页查询函数
      function queryClueByConditionForPage(pageNo, pageSize) {
        var fullname = $("#query-fullname").val();
        var company = $("#query-company").val();
        var phone = $("#query-phone").val();
        var source = $("#query-source").val();
        var owner = $("#query-owner").val();
        var mphone = $("#query-myphone").val();
        var state = $("#query-state").val();

        $.ajax({
          url: 'workbench/clue/queryClueByConditionForPage.do',
          type: 'post',
          dataType: 'json',
          data: {
            fullname: fullname,
            company: company,
            phone: phone,
            source: source,
            owner: owner,
            mphone: mphone,
            state: state,
            pageNo: pageNo,
            pageSize: pageSize
          },
          success: function (data) {
            let htmlStr = "";
            $.each(data.clueList, function (index, c) {
              htmlStr += "<tr>";
              htmlStr += "<td><input type='checkbox' value='" + c.id + "'/></td>";
              htmlStr += "<td><a style='cursor:pointer;text-decoration:none;' href='workbench/clue/detail.do?id=" + c.id + "'>";
              htmlStr += c.fullname + c.appellation + "</a></td>";
              htmlStr += "<td>" + c.company + "</td>";
              htmlStr += "<td>" + c.phone + "</td>";
              htmlStr += "<td>" + c.mphone + "</td>";
              htmlStr += "<td>" + c.source + "</td>";
              htmlStr += "<td>" + c.state + "</td>";
              htmlStr += "</tr>";
            });
            $("#tBody").html(htmlStr);

            // 初始化分页插件
            var totalPages = Math.ceil(data.totalRows / pageSize);
            $("#demo_page1").bs_pagination('destroy');  // 先销毁旧的分页
            $("#demo_page1").bs_pagination({
              currentPage: pageNo,
              rowsPerPage: pageSize,
              totalRows: data.totalRows,
              totalPages: totalPages,
              visiblePageLinks: 5,
              showGoToPage: true,
              showRowsInfo: true,
              onChangePage: function (event, pageObj) {
                queryClueByConditionForPage(pageObj.currentPage, pageObj.rowsPerPage);
              }
            });
          }
        });
      }

      // 查询按钮点击事件
      $("#queryClueBtn").click(function () {
        queryClueByConditionForPage(1, 10);
      });

      // 页面默认加载第一页数据
      queryClueByConditionForPage(1, 10);


    });
  </script>
</head>
<body>

<!-- 创建线索的模态窗口 -->
<div class="modal fade" id="createClueModal" role="dialog">
  <div class="modal-dialog" role="document" style="width: 90%;">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">
          <span aria-hidden="true">×</span>
        </button>
        <h4 class="modal-title" id="myModalLabel">创建线索</h4>
      </div>
      <div class="modal-body">
        <form class="form-horizontal" role="form">

          <div class="form-group">
            <label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
            <div class="col-sm-10" style="width: 300px;">
              <select class="form-control" id="create-clueOwner">
                <c:forEach var="u" items="${userList}">
                  <option value="${u.id}">${u.name}</option>
                </c:forEach>
              </select>
            </div>
            <label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="create-company">
            </div>
          </div>

          <div class="form-group">
            <label for="create-call" class="col-sm-2 control-label">称呼</label>
            <div class="col-sm-10" style="width: 300px;">
              <select class="form-control" id="create-call">
                <option></option>
                <option>先生</option>
                <option>夫人</option>
                <option>女士</option>
                <option>博士</option>
                <option>教授</option>
              </select>
            </div>
            <label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="create-surname">
            </div>
          </div>

          <div class="form-group">
            <label for="create-job" class="col-sm-2 control-label">职位</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="create-job">
            </div>
            <label for="create-email" class="col-sm-2 control-label">邮箱</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="create-email">
            </div>
          </div>

          <div class="form-group">
            <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="create-phone">
            </div>
            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="create-website">
            </div>
          </div>

          <div class="form-group">
            <label for="create-mphone" class="col-sm-2 control-label">手机</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="create-mphone">
            </div>
            <label for="create-status" class="col-sm-2 control-label">线索状态</label>
            <div class="col-sm-10" style="width: 300px;">
              <select class="form-control" id="create-status">
                <option></option>
                <option>试图联系</option>
                <option>将来联系</option>
                <option>已联系</option>
                <option>虚假线索</option>
                <option>丢失线索</option>
                <option>未联系</option>
                <option>需要条件</option>
              </select>
            </div>
          </div>

          <div class="form-group">
            <label for="create-source" class="col-sm-2 control-label">线索来源</label>
            <div class="col-sm-10" style="width: 300px;">
              <select class="form-control" id="create-source">
                <option></option>
                <option>广告</option>
                <option>推销电话</option>
                <option>员工介绍</option>
                <option>外部介绍</option>
                <option>在线商场</option>
                <option>合作伙伴</option>
                <option>公开媒介</option>
                <option>销售邮件</option>
                <option>合作伙伴研讨会</option>
                <option>内部研讨会</option>
                <option>交易会</option>
                <option>web下载</option>
                <option>web调研</option>
                <option>聊天</option>
              </select>
            </div>
          </div>


          <div class="form-group">
            <label for="create-describe" class="col-sm-2 control-label">线索描述</label>
            <div class="col-sm-10" style="width: 81%;">
              <textarea class="form-control" rows="3" id="create-describe"></textarea>
            </div>
          </div>

          <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

          <div style="position: relative;top: 15px;">
            <div class="form-group">
              <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
              <div class="col-sm-10" style="width: 81%;">
                <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
              </div>
            </div>
            <div class="form-group">
              <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
              <div class="col-sm-10" style="width: 300px;">
                <input type="text" class="form-control" id="create-nextContactTime">
              </div>
            </div>
          </div>

          <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

          <div style="position: relative;top: 20px;">
            <div class="form-group">
              <label for="create-address" class="col-sm-2 control-label">详细地址</label>
              <div class="col-sm-10" style="width: 81%;">
                <textarea class="form-control" rows="1" id="create-address"></textarea>
              </div>
            </div>
          </div>
        </form>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary" id="saveClueBtn">保存</button>
      </div>
    </div>
  </div>
</div>

<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
  <div class="modal-dialog" role="document" style="width: 90%;">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">
          <span aria-hidden="true">×</span>
        </button>
        <h4 class="modal-title">修改线索</h4>
      </div>
      <div class="modal-body">
        <form class="form-horizontal" role="form">

          <div class="form-group">
            <label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
            <div class="col-sm-10" style="width: 300px;">
              <select class="form-control" id="edit-clueOwner">
                <c:forEach var="u" items="${userList}">
                  <option value="${u.id}">${u.name}</option>
                </c:forEach>
              </select>
            </div>
            <label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="edit-company" value="">
            </div>
          </div>

          <div class="form-group">
            <label for="edit-call" class="col-sm-2 control-label">称呼</label>
            <div class="col-sm-10" style="width: 300px;">
              <select class="form-control" id="edit-call">
                <option></option>
                <option selected>先生</option>
                <option>夫人</option>
                <option>女士</option>
                <option>博士</option>
                <option>教授</option>
              </select>
            </div>
            <label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="edit-surname" value="李四">
            </div>
          </div>

          <div class="form-group">
            <label for="edit-job" class="col-sm-2 control-label">职位</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="edit-job" value="CTO">
            </div>
            <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
            </div>
          </div>

          <div class="form-group">
            <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="edit-phone" value="010-84846003">
            </div>
            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
            </div>
          </div>

          <div class="form-group">
            <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="edit-mphone" value="12345678901">
            </div>
            <label for="edit-status" class="col-sm-2 control-label">线索状态</label>
            <div class="col-sm-10" style="width: 300px;">
              <select class="form-control" id="edit-status">
                <option></option>
                <option>试图联系</option>
                <option>将来联系</option>
                <option selected>已联系</option>
                <option>虚假线索</option>
                <option>丢失线索</option>
                <option>未联系</option>
                <option>需要条件</option>
              </select>
            </div>
          </div>

          <div class="form-group">
            <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
            <div class="col-sm-10" style="width: 300px;">
              <select class="form-control" id="edit-source">
                <option></option>
                <option selected>广告</option>
                <option>推销电话</option>
                <option>员工介绍</option>
                <option>外部介绍</option>
                <option>在线商场</option>
                <option>合作伙伴</option>
                <option>公开媒介</option>
                <option>销售邮件</option>
                <option>合作伙伴研讨会</option>
                <option>内部研讨会</option>
                <option>交易会</option>
                <option>web下载</option>
                <option>web调研</option>
                <option>聊天</option>
              </select>
            </div>
          </div>

          <div class="form-group">
            <label for="edit-describe" class="col-sm-2 control-label">描述</label>
            <div class="col-sm-10" style="width: 81%;">
              <textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
            </div>
          </div>

          <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

          <div style="position: relative;top: 15px;">
            <div class="form-group">
              <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
              <div class="col-sm-10" style="width: 81%;">
                <textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
              </div>
            </div>
            <div class="form-group">
              <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
              <div class="col-sm-10" style="width: 300px;">
                <input type="text" class="form-control" id="edit-nextContactTime" value="2025-05-01">
              </div>
            </div>
          </div>

          <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

          <div style="position: relative;top: 20px;">
            <div class="form-group">
              <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
              <div class="col-sm-10" style="width: 81%;">
                <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
              </div>
            </div>
          </div>
        </form>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <!--修改按键-->
        <button type="button" class="btn btn-primary" id="updateClueBtn">更新</button>

      </div>
    </div>
  </div>
</div>




<div>
  <div style="position: relative; left: 10px; top: -10px;">
    <div class="page-header">
      <h3>线索列表</h3>
    </div>
  </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

  <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

    <div class="btn-toolbar" role="toolbar" style="height: 80px;">
      <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

        <div class="form-group">
          <div class="input-group">
            <div class="input-group-addon">名称</div>
            <input class="form-control" type="text" id="query-fullname">
          </div>
        </div>

        <div class="form-group">
          <div class="input-group">
            <div class="input-group-addon">公司</div>
            <input class="form-control" type="text" id="query-company">
          </div>
        </div>

        <div class="form-group">
          <div class="input-group">
            <div class="input-group-addon">公司座机</div>
            <input class="form-control" type="text" id="query-phone">
          </div>
        </div>

        <div class="form-group">
          <div class="input-group">
            <div class="input-group-addon">线索来源</div>
            <select class="form-control" id="query-source">
              <option></option>
              <option>广告</option>
              <option>推销电话</option>
              <option>员工介绍</option>
              <option>外部介绍</option>
              <option>在线商场</option>
              <option>合作伙伴</option>
              <option>公开媒介</option>
              <option>销售邮件</option>
              <option>合作伙伴研讨会</option>
              <option>内部研讨会</option>
              <option>交易会</option>
              <option>web下载</option>
              <option>web调研</option>
              <option>聊天</option>
            </select>
          </div>
        </div>

     <!--   <div class="form-group">
          <div class="input-group">
            <div class="input-group-addon">所有者</div>
            <input class="form-control" type="text" id="query-owner">
          </div>
        </div>



        <div class="form-group">
          <div class="input-group">
            <div class="input-group-addon">手机</div>
            <input class="form-control" type="text" id="query-myphone">
          </div>
        </div>

        <div class="form-group">
          <div class="input-group">
            <div class="input-group-addon">线索状态</div>
            <select class="form-control" id="query-state">
              <option></option>
              <option>试图联系</option>
              <option>将来联系</option>
              <option>已联系</option>
              <option>虚假线索</option>
              <option>丢失线索</option>
              <option>未联系</option>
              <option>需要条件</option>
            </select>
          </div>
        </div>  -->

        <!-- 给按钮添加 id，防止默认提交 -->
        <button type="button" id="queryClueBtn" class="btn btn-default">查询</button>

      </form>
    </div>
    <div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
      <div class="btn-group" style="position: relative; top: 18%;">
        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createClueModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
        <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editClueModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
        <button type="button" class="btn btn-danger" id="deleteClueBtn">
          <span class="glyphicon glyphicon-minus"></span> 删除
        </button>
      </div>


    </div>
    <div style="position: relative;top: 50px;">
      <table class="table table-hover">
        <thead>
        <tr style="color: #B3B3B3;">
          <td><input type="checkbox" /></td>
          <td>名称</td>
          <td>公司</td>
          <td>公司座机</td>
          <td>手机</td>
          <td>线索来源</td>
          <!--<td>所有者</td>-->
          <td>线索状态</td>
        </tr>
        </thead>
        <tbody id="tBody"></tbody>

      </table>
      <div id="demo_page1"></div>
    </div>

  </div>

</div>
</body>
</html>