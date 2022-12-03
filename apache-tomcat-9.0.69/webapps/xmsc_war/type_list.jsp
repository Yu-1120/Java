<!-- Created by IntelliJ IDEA.-->
<!--  User: Retain-->
<!--  Date: 2021/1/14-->
<!--  Time: 10:53-->
<!--  To change this template use File | Settings | File Templates.-->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Layui</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="layui/css/layui.css"  media="all">
</head>
<body>
<p style="margin: 50px 0 -42px 48px;color: #8D8D8D">首页 / 全部类别</p>
<br>
<div class="layui-btn-group demoTable" style="margin: 57px 0 11px 48px">
    <button class="layui-btn" data-type="getCheckData" style="margin: 0 0 0 -99px">删除选中行数据</button>
</div>


<table id="tblTypeInfo" lay-filter="typeInfo" ></table>
<form lay-filter="typeModify" id="popUpModify" class="layui-form"  style="position: fixed;margin-left: 50px;margin-top: -70px;display: none">

    <div class="layui-form-item" style="margin: 150px auto;width: 500px;height: auto;">
        <label class="layui-form-label">类型编号</label>
        <div class="layui-input-block" style="margin-bottom: 20px;">
            <input type="text" id="typeId" name="typeId" readonly="readonly" required  lay-verify="required"  autocomplete="off" class="layui-input">
        </div>
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
                <button id="submitBtn" class="layui-btn" lay-submit lay-filter="modifySubmit" >立即提交</button>
                <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </div>
</form>
<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="detail">查看</a>
    <a class="layui-btn layui-btn-xs" lay-event="edit"  >编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>.
<script src="./js/jquery-3.4.1.min.js"></script>
<script src="layui/layui.js" charset="utf-8"></script>

<script>

    //分页数据
    layui.use('table', function(){
        var table = layui.table;

        //第一个实例
        table.render({
            elem: '#tblTypeInfo'
            ,height: 400
            ,url: '/xmsc/type?methodType=getAllTypes' //数据接口
            ,page: true //开启分页
            ,cols: [[ //表头
                {type: 'checkbox', fixed: 'left',align: 'center'},
                {field: 'id', title: 'ID', width:'10%', sort: true, fixed: 'left'}
                ,{field: 'name', title: '类型名称',align: 'center', width:'20%'}
                ,{field: 'description',align: 'center', title: '类型描述', width:'50%', sort: true},
                {fixed: 'right',title:'操作', width: '20%', align:'center', toolbar: '#barDemo'}
            ]]
        });

    });
    layui.use('table', function(){
        var table = layui.table;
        //监听工具条
        table.on('tool(typeInfo)', function(obj){
            var data = obj.data;
            if(obj.event === 'detail'){
                layer.msg('ID：'+ data.id +'<br>'+'类型名称：'+data.name+'<br>'+'类型描述：'+data.description);
            } else if(obj.event === 'del'){
                layer.confirm('确认删除类型： '+data.name+' 吗？', function(index){
                    $.ajax({
                        type: 'get',
                        url: '/xmsc/type?methodType=delTypeById',
                        dataType:'html',
                        data:{
                            id:data.id
                        },
                        contentType:'application/json',
                        success:function (data) {
                            if (data==1){
                                layer.msg("删除成功！");
                                obj.del();
                            }else {
                                layer.msg("删除失败！请检查操作是否正确")
                            }
                        },
                        error:function () {
                            layer.msg("删除失败！")
                        }
                    });
                    layer.close(index);
                });
            } else if(obj.event === 'edit'){
                layer.open({
                    //layer提供了5种层类型。可传入的值有：0（信息框，默认）1（页面层）2（iframe层）3（加载层）4（tips层）
                    type: 1,
                    title: "修改类型信息",
                    area: ['600px', '500px'],
                    content: $("#popUpModify")//引用的弹出层的页面层的方式加载修改界面表单
            });
                //获取类别信息
                loadData(data)
            }
        });
        function loadData(data){
            layui.use('form', function(){
                let form = layui.form;
                $.ajax({
                    url:'/xmsc/type?methodType=getTypeById',
                    type:'get',
                    dataType: 'json',
                    data:{
                        id:data.id
                    },
                    contentType:'application/json',
                    success:function (msg) {

                        form.val("typeModify", {
                            "typeId": msg.id
                            ,"name": msg.name
                            ,"desc":msg.description,

                        });

                    }
                });
            })
        }
        //更新提交
        layui.use('form', function(){
            let form = layui.form;
            //监听提交
            form.on('submit(modifySubmit)', function (data) {
                let load = layer.load(2);
                $.ajax({
                    url: '/xmsc/type?methodType=updateTypeById',
                    type: 'get',
                    dataType: 'html',
                    data: data.field,
                    contentType: 'application/json',
                    success: function (msg) {
                        if (msg == 1) {
                            layer.close(load);
                            layer.msg("修改成功", {icon: 6});
                            layer.closeAll('page');
                            setInterval(function () {
                                location.reload();
                            },2000)
                        } else {
                            layer.alert("修改失败", {icon: 5});
                        }
                    }
                })
                return false;
            })
        });
        var $ = layui.$, active = {
            getCheckData: function(){ //获取选中数据
                var checkStatus = table.checkStatus('idTest')
                    ,data = checkStatus.data;
                layer.alert(JSON.stringify(data));
            }
            ,getCheckLength: function(){ //获取选中数目
                var checkStatus = table.checkStatus('idTest')
                    ,data = checkStatus.data;
                layer.msg('选中了：'+ data.length + ' 个');
            }
        };

    });
</script>

</body>
</html>
