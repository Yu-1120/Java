<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>登录</title>
    <link rel="stylesheet" href="css/login.css" />
    <script src="./js/jquery-3.4.1.min.js"></script>
    <link rel="stylesheet" href="./layui/css/layui.css">
    <style type="text/css">
        .adminInput{
            width: 200px;
            height: 40px;
            font-size: 15px;
            border-radius: 0.5em;

        }
        .codeInput{
            border-left: none;
            margin-left: -2px;
            width: 80px;
            height: 38px;
            font-size: 15px;
            border-radius: 0 0.5em 0.5em 0;
            /*验证码样式*/
            font-family: "gill sans mt condensed", serif;
            font-style: italic;
            font-weight: bold;
            /*border: 0;*/
            letter-spacing: 2px;
            cursor: pointer;
        }
    </style>
</head>
<body>
<div class="wrap">
    <img src="img/login_bg2.jpg" class="imgStyle">
    <div class="loginForm">
        <form>
            <div class="logoHead">
                <img src="img/logo_small.png" />
                <h2>小米商城后台管理系统</h2>
            </div>
            <div class="usernameWrapDiv">
                <div class="usernameLabel">
                    <label>用户名:</label>
                </div>
                <div class="usernameDiv">
                    <i class="layui-icon layui-icon-username adminIcon"></i>
                    <input id="account" class="layui-input adminInput" type="text" name="account" placeholder="输入用户名" >
                </div>
            </div>
            <div class="usernameWrapDiv">
                <div class="usernameLabel">
                    <label>密码:</label>
                </div>
                <div class="passwordDiv">
                    <i class="layui-icon layui-icon-password adminIcon"></i>
                    <input id="pwd" class="layui-input adminInput" type="password" name="pwd" placeholder="输入密码">
                </div>
            </div>
            <div class="usernameWrapDiv">
                <div class="usernameLabel">
                    <label>验证码:</label>
                </div>
                <div class="cardDiv">
                    <input id="loginCard" class="layui-input cardInput" type="text" name="checkCode" placeholder="输入验证码">
                </div>
                <div class="codeDiv">
                    <input id="loginCode" class="layui-input codeInput"  type="button">
                </div>
            </div>
            <div class="usernameWrapDiv">
                <div class="submitLabel">
                    <label>忘记密码？<a href="#" id="loginRegister">点击找回</a></label>
                </div>
                <div class="submitDiv">
                    <input id="loginBtn" type="button" class="layui-btn layui-btn-warm layui-btn-radius" value="登录" style="width: 97px;background-color: #ff6700"></input>
                </div>

            </div>
        </form>
    </div>
</div>
<script src="./layui/layui.js" type="text/javascript"></script>
<script>
    layui.use(['layer'],function () {
        let layer = layui.layer;
    })
    $(function () {
        // 页面初始化生成验证码
        window.onload = createCode('#loginCode');
        // 验证码切换
        $('#loginCode').click(function () {
            createCode('#loginCode');
        });
        // 登陆事件
        $('#loginBtn').click(function () {
            login();
        });
    });
    // 生成验证码
    function createCode(codeID) {
        let code = "";
        // 验证码长度
        let codeLength = 4;
        // 验证码dom元素
        let checkCode = $(codeID);
        // 验证码随机数
        let random = [0,1,2,3,4,5,6,7,8,9,'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R',
            'S','T','U','V','W','X','Y','Z'];
        for (let i = 0;i < codeLength; i++){
            // 随机数索引
            let index = Math.floor(Math.random()*36);
            code += random[index];
        }
        // 将生成的随机验证码赋值
        checkCode.val(code);
    }
    // 校验验证码、用户名、密码
    function validateCode(inputID,codeID) {
        let inputCode = $(inputID).val().toUpperCase();
        let cardCode = $(codeID).val();
        let account = $('#account').val();
        let pwd = $('#pwd').val();
        if ($.trim(account) == '' || $.trim(account).length<=0){
            layer.alert("用户名不能为空");
            return false;
        }
        if ($.trim(pwd) == '' || $.trim(pwd).length<=0){
            layer.alert("密码不能为空");
            return false;
        }
        if (inputCode.length<=0){
            layer.alert("验证码不能为空");
            return false;
        }
        if (inputCode != cardCode){
            layer.alert("请输入正确验证码");
            return false;
        }
        return true;
    }
    // 登录
    function login() {
        if (!validateCode('#loginCard','#loginCode')){
        }else {
            let account = $('#account').val();
            let pwd = $('#pwd').val();

            let loginLoadIndex = layer.load(5);
            $('#loginBtn').val("正在登录...");
            $.ajax({
                type:'get',
                url:"/xmsc/login",
                dataType:'html',
                data: {
                  "account":account,
                  "pwd":pwd
                },
                contentType:'application/json',
                success:function (data) {
                    layer.close(loginLoadIndex);
                    // let jsonData = JSON.parse(data);
                    if (data==1){
                        window.location.href = 'main.html';
                    }else {
                        layer.alert("用户名或密码错误，请重新输入")
                        $('#loginBtn').val("登录");
                    }
                },
                error:function () {
                }
            });
        }

    }

</script>

</body>
</html>