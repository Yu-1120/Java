<%--Created by IntelliJ IDEA.--%>
<%--User: Retain--%>
<%--Date: 2021/1/15--%>
<%--Time: 10:25--%>
<%--To change this template use File | Settings | File Templates.--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
    <meta charset="utf-8">
    <title>发布商品</title>
    <script src="./js/jquery-3.4.1.min.js"></script>
    <link rel="stylesheet" href="layui/css/layui.css"  media="all">
    <link rel="stylesheet" href="./layui/css/modules/layer/default/layer.css">
</head>
<body>
<p style="margin: 50px 0 -42px 48px;color: #8D8D8D">首页 / 添加商品</p>
<br>

<form id="addForm" action="${pageContext.request.contextPath}/goods?methodType=addGoods" class="layui-form" style="margin: -90px auto" method="post" enctype="multipart/form-data">

    <div class="layui-form-item" style="margin: 150px auto;width: 500px;height: auto;">
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
                <select id="type" name="type" lay-filter="aihao">
                </select>
            </div>
        </div>
<%--        图片上传--%>
            <label class="layui-form-label">商品图片</label>
        <input type="text" id="imgUrl" name="imgUrl" style="display: none">
        <div class="layui-upload" style="margin-bottom: 20px">
            <button type="button" class="layui-btn layui-btn-normal" id="selectImg">选择图片</button>
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
                <button id="submitBtn" class="layui-btn" lay-submit lay-filter="goodsAddBtn">立即提交</button>
                <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </div>
</form>

<script src="./layui/layui.js" charset="utf-8"></script>
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


    //下拉框赋值
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

    //提交按钮
    layui.use('form', function(){
        var form = layui.form;
        //监听提交
        form.on('submit(goodsAddBtn)', function(data){
            // layer.msg("添加")
            let loadIndex = layer.load(2);
            $.ajax({
                type:'get',
                url:"/xmsc/goods?methodType=addGoods",
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
