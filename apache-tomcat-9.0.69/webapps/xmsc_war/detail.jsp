<%--
  Created by IntelliJ IDEA.
  User: Retain
  Date: 2021/1/16
  Time: 19:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title></title>
    <link rel="stylesheet" href="layui/css/layui.css"  media="all">
    <style type="text/css">
        .detail{
            float: left;
            width: 450px;
            height:450px;
        }
        .layui-text h3{
            color: #009688;
        }

    </style>
</head>
<body>
<a href="goods_list.jsp" class="layui-btn layui-btn-primary layui-btn-sm" style="float: left;margin: 50px 0 0 100px"><i class="layui-icon"></i></a>
<div class="detail" style="margin: 50px 0 0 110px;">
    <img id="goodsImg" src="" width="100%" height="100%"/>
</div>
<div class="detail" style="margin: 100px 0 0 50px;">
    <ul class="layui-timeline">
        <li class="layui-timeline-item">
            <i class="layui-icon layui-timeline-axis"></i>
            <div class="layui-timeline-content layui-text">
                <h3 class="layui-timeline-title">商品Id</h3>
                <p id="goodsId"></p>
            </div>
        </li>
        <li class="layui-timeline-item">
            <i class="layui-icon layui-timeline-axis"></i>
            <div class="layui-timeline-content layui-text">
                <h3 class="layui-timeline-title">商品名称</h3>
                <p id="goodsName"></p>
            </div>
        </li>
        <li class="layui-timeline-item">
            <i class="layui-icon layui-timeline-axis"></i>
            <div class="layui-timeline-content layui-text">
                <h3 class="layui-timeline-title">商品类别</h3>
                <p id="type"></p>
            </div>
        </li>
        <li class="layui-timeline-item">
            <i class="layui-icon layui-timeline-axis"></i>
            <div class="layui-timeline-content layui-text">
                <h3 class="layui-timeline-title">商品价格</h3>
                <p id="goodsPrice" style="color: red"></p>
            </div>
        </li>
        <li class="layui-timeline-item">
            <i class="layui-icon layui-timeline-axis"></i>
            <div class="layui-timeline-content layui-text">
                <h3 class="layui-timeline-title">商品库存</h3>
                <p id="goodsNum"></p>
            </div>
        </li>

        <li class="layui-timeline-item">
            <i class="layui-icon layui-timeline-axis"></i>
            <div class="layui-timeline-content layui-text">
                <h3 class="layui-timeline-title">商品描述</h3>
                <p id="goodsDesc"></p>
            </div>
        </li>
        <li class="layui-timeline-item">
            <i class="layui-icon layui-timeline-axis"></i>
            <div class="layui-timeline-content layui-text">
                <h3 class="layui-timeline-title">商品详情</h3>
                <p id="goodsDetail"></p>
            </div>
        </li>

    </ul>
</div>

<script src="./js/jquery-3.4.1.min.js"></script>
<script src="layui/layui.js" charset="utf-8"></script>

<script>
    function loadInfo(id,info) {
        document.getElementById(id).innerText=info
    }
    //获取id
    let id = sessionStorage.getItem('id');
    $.ajax({
        url:'/xmsc/goods?methodType=getGoodsById',
        type:'get',
        dataType: 'json',
        data:{
            goodsId:id
        },
        contentType:'application/json',
        success:function (msg) {
            document.getElementById('goodsImg').setAttribute('src',msg.goodsImg);
            loadInfo('goodsId',msg.goodsId)
            loadInfo('goodsName',msg.goodsName)
            loadInfo('goodsPrice',msg.goodsPrice)
            loadInfo('goodsNum',msg.goodsNum)
            loadInfo('goodsDesc',msg.goodsDesc)
            loadInfo('goodsDetail',msg.goodsDetail)
            getType(msg.typeId)
        }
    });
    function getType(id) {
        $.ajax({
            url:'/xmsc/type?methodType=getTypeById',
            dataType:'json',
            data:{
                id:id
            },
            contentType:'application/json',
            async: false,//同步
            success:function(data){
                loadInfo('type',data.name)

            }
        });
    }

</script>
</body>
</html>

