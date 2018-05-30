<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
    <script src="http://how2j.cn/study/js/jquery/2.0.0/jquery.min.js"></script>
    <link href="http://how2j.cn/study/css/bootstrap/3.3.6/bootstrap.min.css" rel="stylesheet">
    <script src="http://how2j.cn/study/js/bootstrap/3.3.6/bootstrap.min.js"></script>
<html>
<head>
    <title>仿WebQQ聊天</title>
    <link rel="stylesheet" type="text/css" href="webstyle.css">
</head>
<body>

        <div class="text" style="text-align: center">
            <h1 style="font-size: 40px;color:red">
                 Welcome
            </h1>
        </div>
        <form class="form-inline" style="text-align: center" >
            <div class="input-group">
                <span class="input-group-addon" >请输入您的用户名：</span>
                <input type="text" class="form-control" size="10" id = "sockname">
            </div>
        </form>
        <br/>
        <div style="text-align: center">
            <button  class = "btn btn-success" onclick="openSocket()">确定并开启连接</button>
        </div>
        <hr/>
        <div style="text-align: center">
            <button class = "btn btn-warning" onclick="closeWebSocket() " >关闭WebSocket连接</button>
        </div>
        <hr/>
        <div id="message" class="container"></div>
        <br>
        <div>
            <button type="button" class = "btn btn-default btn-sm">
                <span class="glyphicon glypicon-picure"></span>图片
            </button>
        </div>
        <div style="text-align: center">
            <input id="text" type="text" size="88"/>
            <button  class = "btn btn-success" onclick="send()">发送</button>
        </div>
        <br/>
</body>

<script type="text/javascript">
    var websocket = null;
    //判断当前浏览器是否支持WebSocket
    function openSocket() {
        try{
            if ('WebSocket' in window) {
                websocket = new WebSocket("ws://localhost:8080/websocket");
            }

            else {
                alert('当前浏览器 Not support websocket');
            }

        }catch (e) {
            return;
        }
        //连接成功建立的回调方法
        websocket.onopen = function () {
            var item;
                item="欢迎 "+document.getElementById('sockname').value + "，"+ " WebSocket 连接成功。";
                setMessageInnerHTML(item,"ok");
        }
        //连接发生错误的回调方法
        websocket.onerror = function () {

            setMessageInnerHTML("WebSocket连接发生错误+","error");
        };



        //接收到消息的回调方法
        websocket.onmessage = function (event) {
            setMessageInnerHTML(event.data);
        }


    }



    //连接关闭的回调方法
    websocket.onclose = function () {
        setMessageInnerHTML("WebSocket连接关闭","ok");
    }

    //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
    window.onbeforeunload = function () {
        closeWebSocket();
    }

    //将消息显示在网页上
    function setMessageInnerHTML(innerHTML,type) {
        if (type == "ok") innerHTML = "<span style='color: green;'>" + innerHTML + "</span>";
        if (type == "error") innerHTML = "<span style='color: red;'>" + innerHTML + "</span>";
        document.getElementById('message').innerHTML += innerHTML + '<br/>';
    }

    //关闭WebSocket连接
    function closeWebSocket() {
        websocket.close();
    }
    //发送消息
    function send() {
        var message = document.getElementById('text').value;
        var user = document.getElementById('sockname').value;
        websocket.send( "<span style='color: blue;font-size:12px '>" + user + "</span>" );
        websocket.send("\n"+"&nbsp;&nbsp;"+message);
        document.getElementById("text").value = "";
    }
</script>
</html>