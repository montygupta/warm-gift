<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>

<%
    BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
%>
<script src="js/jquery-1.11.0.min.js"></script>	

<html>
    <head>
		  <meta charset="utf-8">
		  <title>Demo: Upload Video</title>
		  <link rel="stylesheet" href="style.css">
    </head>
    <body>
        <form action="<%= blobstoreService.createUploadUrl("/upload") %>" method="post" enctype="multipart/form-data">
		  <div id="video-container">
		    <video id="camera-stream" width="500" autoplay></video>
		  </div>
		  <script src="script.js"></script>
            <input type="text" name="foo">
            <input type="file" name="myFile">
            <input type="submit" value="Submit">
        </form>
    </body>
</html>