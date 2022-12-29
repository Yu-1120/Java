<!--  Created by IntelliJ IDEA.-->
<!--  User: Retain-->
<!--  Date: 2021/1/14-->
<!--  Time: 10:53-->
<!--  To change this template use File | Settings | File Templates.-->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <meta charset="utf-8">
    <title></title>
    <script src="./js/jquery-3.4.1.min.js"></script>
    <link rel="stylesheet" href="./layui/css/layui.css">
</head>
<body>

<p style="margin: 50px 0 -42px 48px;color: #8D8D8D">首页 / 添加类型</p>
<br>

<form id="addForm" class="layui-form" action="">

    <div class="layui-form-item" style="margin: 150px auto;width: 500px;height: auto;">
        <label class="layui-form-label">类别名称</label>
        <div class="layui-input-block" style="margin-bottom: 20px;">
            <input type="text" id="name" name="name" required  lay-verify="required" placeholder="请输入类别名称" autocomplete="off" class="layui-input">
        </div>
        <div class="layui-form-item layui-form-text">
            <label class="layui-form-label">类型描述</label>
            <div class="layui-input-block">
                <textarea name="desc" id="desc" placeholder="请输入类型描述" class="layui-textarea"></textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button id="submitBtn" class="layui-btn" lay-submit lay-filter="typeAddForm">立即提交</button>
                <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </div>
</form>
<script src="./layui/layui.js"></script>

<script>
    layui.use('form', function(){
        var form = layui.form;

        //监听提交
        form.on('submit(typeAddForm)', function(data){
            // layer.msg("添加")
            let loadIndex = layer.load(2);
            $.ajax({
                type:'get',
                url:"/xmsc/type?methodType=addType",
                dataType:'html',
                data: data.field,
                contentType:'application/json',
                success:function (data) {
                    layer.close(loadIndex);
                    if (data==1){
                        layer.msg("添加成功！",{icon: 6});
                    }else {
                        layer.msg("添加失败！请检查输入是否正确",{icon: 5})
                    }
                },
                error:function () {
                    layer.msg("添加失败！",{icon: 5})
                }
            });
            return false;
        });
    });
</script>
</body>
</html>

