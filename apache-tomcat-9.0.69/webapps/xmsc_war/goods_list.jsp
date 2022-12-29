
<!--  Created by IntelliJ IDEA.-->
<!--  User: Retain-->
<!--  Date: 2021/1/15-->
<!--  Time: 14:10-->
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
<div style="margin-bottom: 5px;">
</div>

<p style="margin: 50px 0 -42px 48px;color: #8D8D8D">首页 / 全部商品</p>
<br>
<div class="layui-btn-group demoTable" style="margin: 57px 0 11px 48px">
    <button class="layui-btn" data-type="getCheckData" style="margin: 0 0 0 -99px">删除选中行数据</button>
</div>
<form class="layui-form">
<div class="layui-form-item" style="width: 500px;margin-left: 10px">
    <label class="layui-form-label">选择类别</label>
    <div class="layui-input-block">
        <select id="getByType" name="getByType" lay-filter="types">
            <option value="-1" selected>全部</option>
        </select>
    </div>
</div>
</form>
<table id="tblGoodsInfo" lay-filter="goodInfo" ></table>
<form lay-filter="goodsModify" id="popUpModify" class="layui-form"  enctype="multipart/form-data" style="margin-left: -6px;margin-top: -121px;display: none">

    <div class="layui-form-item" style="margin: 150px auto;width: 500px;height: auto;">
        <img src="" id="preImgUrl" width="150" height="150" style="margin-left: 184px"><br>
        <label class="layui-form-label">商品ID</label>
        <div class="layui-input-block" style="margin-bottom: 20px;">
            <input type="text" id="goodsId" name="goodsId" required readonly="readonly" lay-verify="required" placeholder="请输入商品名称" autocomplete="off" class="layui-input">
        </div>
        <label class="layui-form-label">商品名称</label>
        <div class="layui-input-block" style="margin-bottom: 20px;">
            <input type="text" id="goodsName" name="goodsName" required  lay-verify="required" placeholder="请输入商品名称" autocomplete="off" class="layui-input">
        </div>
        <label class="layui-form-label">商品价格</label>
        <div class="layui-input-block" style="margin-bottom: 20px;">
            <input type="text" id="goodsPrice" name="goodsPrice" required  lay-verify="required" placeholder="请输入商品价格" autocomplete="off" class="layui-input">
        </div>
        <label class="layui-form-label">商品库存</label>
        <div class="layui-input-block" style="margin-bottom: 20px;">
            <input type="number" id="goodsNum" name="goodsNum" required  lay-verify="required" placeholder="请输入商品库存" autocomplete="off" class="layui-input">
        </div>
        <label class="layui-form-label">商品描述</label>
        <div class="layui-input-block" style="margin-bottom: 20px;">
            <textarea name="goodsDesc" id="goodsDesc" placeholder="请输入商品描述" class="layui-textarea"></textarea>
        </div>
        <%--        商品类别下拉框--%>
        <div class="layui-form-item">
            <label class="layui-form-label">商品类别</label>
            <div class="layui-input-block">
                <select id="type" name="type" lay-filter="modifyTypes">

                </select>
            </div>
        </div>
        <%--        图片上传--%>
        <label class="layui-form-label">商品图片</label>
        <input type="text" id="imgUrl" name="imgUrl" style="display: none">
        <div class="layui-upload">
            <button type="button" class="layui-btn layui-btn-normal" id="selectImg">更换图片</button>
            <button type="button" class="layui-btn" id="uploadImg">开始上传</button>
        </div>
        <div>
            <label class="layui-form-label">商品详情</label>
            <div class="layui-input-block" style="margin-bottom: 20px;">
                <textarea name="goodsDetail" id="goodsDetail" required placeholder="请输入商品详情" class="layui-textarea"></textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button id="submitBtn" class="layui-btn" lay-submit lay-filter="modifySubmit">立即提交</button>
                <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </div>
</form>
<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="detail" href="detail.jsp" target="_self">查看</a>
    <a class="layui-btn layui-btn-xs" lay-event="edit"  >编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>
<script src="./js/jquery-3.4.1.min.js"></script>
<script src="layui/layui.js" charset="utf-8"></script>

<script>

    //验证价格
    $('#goodsPrice').focusout(function() {
        var priceReg = /(^[1-9]\d*(\.\d{1,2})?$)|(^0(\.\d{1,2})?$)/;
        var price=$("#goodsPrice").val();
        if (!priceReg.test(price)){
            layer.alert("请输入正确的商品价格",{icon:5})
            return false;
        }
    });

    //将id变成内容，应用template模板
    function getTypeName(typeId){
        var tid = typeId;
        var title;
        $.ajax({
            url:'/xmsc/type?methodType=getTypeById',
            dataType:'json',
            data:{
                id:tid
            },
            contentType:'application/json',
            async: false,//同步
            success:function(data){
                $.each(data,function () {
                    console.log(data)
                    if(data.id==tid){
                        title=data.name;
                    }
                });
            }
        });
        return title;
    };
    //分页数据
    layui.use('table', function(){
        var table = layui.table;

        table.render({
            elem: '#tblGoodsInfo'
            ,height: 400
            ,url: '/xmsc/goods?methodType=getAllGoods' //数据接口
            ,page: true //开启分页
            ,cols: [[ //表头
                {type: 'checkbox', fixed: 'left',align: 'center'},
                {field: 'goodsImg', title: '商品图片', width:'100',height:50, fixed: 'left',templet:'<div><img src="{{ d.goodsImg }}" style="width: 30px; height: 30px;"></div>'},
                {field: 'goodsId', title: 'ID', width:100, sort: true},
                {field: 'goodsName', title: '商品名称',align: 'center', width:100},
                {field: 'typeId',align: 'center', title: '商品类型', width:100,templet: '<div>{{getTypeName(d.typeId)}}</div>'},
                {field: 'goodsPrice',align: 'center', title: '商品价格', width:100, sort: true},
                {field: 'goodsNum',align: 'center', title: '商品库存', width:100, sort: true},
                {field: 'goodsDesc',align: 'center', title: '商品描述', width:200, sort: true},
                {field: 'goodsDetail',align: 'center', title: '商品详情', width:300},
                {fixed: 'right',title:'操作', width: 200, align:'center', toolbar: '#barDemo'}
            ]],

        });

    });


    //操作监控
    layui.use('table', function(){
        var table = layui.table;
        //监听工具条
        table.on('tool(goodInfo)', function(obj){
            var data = obj.data;
            if(obj.event === 'detail'){
                sessionStorage.setItem('id',data.goodsId);
            } else if(obj.event === 'del'){
                layer.confirm('确认删除商品： '+data.goodsName+' 吗？', function(index){
                    $.ajax({
                        type: 'get',
                        url: '/xmsc/goods?methodType=delGoodsById',
                        dataType:'html',
                        data:{
                            goodsId:data.goodsId
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
    });

    function loadData(data){
            layui.use('form', function(){
                let form = layui.form;
                $.ajax({
                    url:'/xmsc/goods?methodType=getGoodsById',
                    type:'get',
                    dataType: 'json',
                    data:{
                        goodsId:data.goodsId
                    },
                    contentType:'application/json',
                    success:function (msg) {

                        $("#type option[value='"+msg.typeId+"']").attr("selected","selected");
                        document.getElementById('preImgUrl').setAttribute('src',msg.goodsImg);
                        $('#imgUrl').val(msg.goodsImg);
                        form.val("goodsModify", {
                            "goodsId": msg.goodsId
                            ,"goodsName": msg.goodsName
                            ,"goodsPrice":msg.goodsPrice
                            ,"goodsNum":msg.goodsNum
                            ,"goodsDesc":msg.goodsDesc
                            ,"goodsDetail":msg.goodsDetail
                            ,"typeId":msg.typeId,
                            "goodsImg":msg.goodsImg
                        });

                    }
                });
            })
        }
    //修改页面下拉框赋值
    layui.use('form', function(){
        let form = layui.form;
        $.ajax({
            url:'/xmsc/type?methodType=getAllTypes&page=1&limit=999999',
            type:'get',
            dataType: 'json',
            data:{},
            contentType:'application/json',
            success:function (msg) {
                let value=msg.data
                for (let s in value){
                    $('#type').append('<option value="'+value[s].id+'">'+value[s].name+'</option>')
                    $('#getByType').append('<option value="'+value[s].id+'">'+value[s].name+'</option>')
                }
                form.render('select')
            }
        });
    })
    //图片上传
    //选完文件后不自动上传
    layui.use('upload', function() {
        var file = document.getElementById('selectImg');
        var form = new FormData();
        form.append('goodsImg',file);
        var $ = layui.jquery
            , upload = layui.upload;
        upload.render({
            elem: '#selectImg'
            , url: '/xmsc/upload'
            , auto: false
            , bindAction: '#uploadImg'
            ,data:form,
            field:'goodsImg',
            accept:'images',
            done: function (res) {
                $('#imgUrl').val(res.src);
                layer.msg('上传成功');
                console.log(res)
            }
        });
    })


    //更新提交
    layui.use('form', function(){
        let form = layui.form;
        //监听提交
        form.on('submit(modifySubmit)', function (data) {
            let load = layer.load(2);
            $.ajax({
                url: '/xmsc/goods?methodType=updateGoodsById',
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
                        // layer.closeAll();//关闭所有的弹出层
                    } else {
                        layer.alert("修改失败", {icon: 5});
                    }
                }
            })
            return false
        })
    });

    //根据类别查询
    layui.use(['layer', 'jquery', 'form'], function () {
        var layer = layui.layer,
            form = layui.form;
        form.on('select(types)', function(data){
            if (data.value=='-1'){
                window.location.href='goods_list.jsp'
            }
           getByTypes(data.value,data.text);
        });

    });
    //分页数据
    function getByTypes(id,value) {
        layui.use('table', function(){
            var table = layui.table;

            table.render({
                elem: '#tblGoodsInfo'
                ,height: 400
                ,url: '/xmsc/goods?methodType=getGoodsByType&typeId='+id //数据接口
                ,page: true //开启分页
                ,cols: [[ //表头
                    {type: 'checkbox', fixed: 'left',align: 'center'},
                    {field: 'goodsImg', title: '商品图片', width:'100',height:50, fixed: 'left',templet:'<div><img src="{{ d.goodsImg }}" style="width: 30px; height: 30px;"></div>'},
                    {field: 'goodsId', title: 'ID', width:100, sort: true},
                    {field: 'goodsName', title: '商品名称',align: 'center', width:100},
                    {field: 'typeId', align: 'center', title: '商品类型', width:100,templet: '<div>{{getTypeName(d.typeId)}}</div>'},
                    {field: 'goodsPrice',align: 'center', title: '商品价格', width:100, sort: true},
                    {field: 'goodsNum',align: 'center', title: '商品库存', width:100, sort: true},
                    {field: 'goodsDesc',align: 'center', title: '商品描述', width:200, sort: true},
                    {field: 'goodsDetail',align: 'center', title: '商品详情', width:300},
                    {fixed: 'right',title:'操作', width: 200, align:'center', toolbar: '#barDemo'}
                ]],

            });

        });
    }

</script>

</body>
</html>
